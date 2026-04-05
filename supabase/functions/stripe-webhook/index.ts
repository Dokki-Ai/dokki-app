import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from 'https://esm.sh/stripe@14.21.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.4'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') ?? '', {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

serve(async (req: Request) => {
  try {
    // Читаем полное событие прямо из тела запроса
    const event = await req.json()
    console.log(`📦 Event received: ${event.type}`)

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // ОБРАБОТКА: Оплата завершена
    if (event.type === 'checkout.session.completed') {
      const session = event.data.object as any
      const userId = session.client_reference_id
      const subscriptionId = session.subscription

      if (!userId) {
        console.error('❌ Ошибка: client_reference_id отсутствует')
        // Возвращаем 200, чтобы Stripe не пытался переотправлять событие с ошибкой
        return new Response('ok', { status: 200 })
      }

      // Запрашиваем данные подписки у Stripe для получения даты окончания
      const subscription = await stripe.subscriptions.retrieve(subscriptionId)

      // 1. Активируем подписку
      const { error: subError } = await supabase.from('subscriptions').upsert({
        user_id: userId,
        stripe_customer_id: session.customer,
        stripe_subscription_id: subscriptionId,
        status: 'active',
        plan: 'monthly_50',
        current_period_end: new Date(subscription.current_period_end * 1000).toISOString(),
        updated_at: new Date().toISOString(),
      }, { onConflict: 'user_id' })

      if (subError) console.error('❌ Ошибка записи подписки:', subError)

      // 2. Активируем бизнес-запись
      const { error: bizError } = await supabase.from('businesses').upsert({
        user_id: userId,
        bot_id: 'admin_basic',
        status: 'active',
      }, { onConflict: 'user_id, bot_id' })

      if (bizError) console.error('❌ Ошибка активации бизнеса:', bizError)

      console.log(`✅ Подписка и бизнес активированы для юзера: ${userId}`)
    }

    // ОБРАБОТКА: Подписка удалена
    if (event.type === 'customer.subscription.deleted') {
      const subscription = event.data.object as any
      
      const { error } = await supabase
        .from('subscriptions')
        .update({ status: 'cancelled', updated_at: new Date().toISOString() })
        .eq('stripe_subscription_id', subscription.id)

      if (error) console.error('❌ Ошибка при отмене подписки:', error)
      
      console.log(`🚫 Подписка аннулирована: ${subscription.id}`)
    }

    return new Response(JSON.stringify({ received: true }), { 
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })

  } catch (err: any) {
    console.error(`❌ Webhook Error: ${err.message}`)
    return new Response(JSON.stringify({ error: err.message }), { 
      status: 400,
      headers: { 'Content-Type': 'application/json' }
    })
  }
})