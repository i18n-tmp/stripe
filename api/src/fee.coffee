#!/usr/bin/env coffee

> ./STRIPE.coffee:

# 假设你已经获取到了SetupIntent的ID
setupIntentId = 'your_setup_intent_id'

# 获取SetupIntent
setupIntent = await stripe.setupIntents.retrieve(setupIntentId)

# 获取PaymentMethod的ID
paymentMethodId = setupIntent.payment_method

# 获取Customer的ID
customerId = 'your_customer_id'

# 将PaymentMethod附加到Customer
paymentMethodAttached = await stripe.paymentMethods.attach(paymentMethodId, {customer: customerId})

# 创建一个PaymentIntent来收取费用
paymentIntent = await stripe.paymentIntents.create({
 amount: 2000,
 currency: 'eur'
 customer: customerId,
 payment_method: paymentMethodId
 off_session: true
 confirm: true
})
