import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from 'https://esm.sh/stripe@14.21.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.7'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') ?? '', {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req: Request) => {
  // 1. Обработка CORS (Preflight request)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 2. Инициализация Supabase клиента с токеном пользователя
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // 3. Получаем данные пользователя (проверка авторизации)
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      throw new Error('Пользователь не авторизован')
    }

    // 4. Парсим входящие данные
    const { priceId, successUrl, cancelUrl } = await req.json()
    
    if (!priceId) {
      throw new Error('Price ID обязателен для создания сессии')
    }

    console.log(`🛠 Создание сессии для пользователя: ${user.id} (${user.email})`);

    // 5. Создаем сессию Stripe Checkout
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [{ 
        price: priceId, 
        quantity: 1 
      }],
      mode: 'subscription',
      
      // КРИТИЧЕСКИЙ ПАРАМЕТР: Передаем ID пользователя напрямую
      client_reference_id: user.id,
      
      // Используем email из Supabase Auth для предзаполнения в Stripe
      customer_email: user.email,
      
      // Валидация Success URL
      success_url: successUrl?.startsWith('http') 
        ? successUrl 
        : 'https://app.dokki.org/payment-success',
        
      // Валидация Cancel URL
      cancel_url: cancelUrl?.startsWith('http') 
        ? cancelUrl 
        : 'https://app.dokki.org/payment-cancel',
      
      // Дублируем в метаданные для подстраховки
      metadata: { 
        user_id: user.id 
      },
    })

    console.log(`✅ Сессия успешно создана: ${session.id}`);

    // 6. Возвращаем URL сессии фронтенду
    return new Response(JSON.stringify({ url: session.url }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })

  } catch (error: any) {
    console.error('❌ Ошибка в Edge Function:', error.message);
    
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})