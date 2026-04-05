import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from 'https://esm.sh/stripe@14.21.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.4'

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
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      throw new Error('Missing Authorization header')
    }

    // 2. Инициализация Admin-клиента
    // Мы используем SERVICE_ROLE_KEY, чтобы вручную проверить токен пользователя.
    // Это обходит проблемы с несовпадением ключей шифрования (ECC/HS256).
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 3. Извлекаем чистый токен из заголовка
    const token = authHeader.replace('Bearer ', '')

    // 4. Вручную верифицируем пользователя через Admin API
    const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(token)
    
    if (authError || !user) {
      console.error('Auth verification failed:', authError?.message)
      throw new Error('401: Unauthorized - Не удалось верифицировать токен пользователя')
    }

    // 5. Парсим тело запроса
    const { priceId, successUrl, cancelUrl } = await req.json()
    
    if (!priceId) {
      throw new Error('Price ID обязателен')
    }

    console.log(`🛠 Создание сессии для пользователя: ${user.id} (${user.email})`)

    // 6. Создаем сессию Stripe Checkout
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      mode: 'subscription',
      client_reference_id: user.id,
      customer_email: user.email,
      success_url: successUrl,
      cancel_url: cancelUrl,
      metadata: {
        user_id: user.id,
      },
    })

    console.log(`✅ Сессия успешно создана: ${session.id}`)

    return new Response(JSON.stringify({ url: session.url }), {
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json',
      },
      status: 200,
    })

  } catch (error: any) {
    console.error('❌ Ошибка в Edge Function:', error.message)
    
    return new Response(JSON.stringify({ error: error.message }), {
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json',
      },
      status: 400,
    })
  }
})