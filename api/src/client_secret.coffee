#!/usr/bin/env coffee

> stripe:Stripe

STRIPE = Stripe(
  "sk_test_51OOdeZBS6OLyeF2Qg9JIegNWvAQmpatGqyJV4ZFGlO2Pui1gvrSoWM2lmmYWyUwULsvF3pY4ZDSkJ4P3t2Kq0chM00s25ov6rF",
)


r = await STRIPE.customers.create({
  email: "jenny@us.example.com"
})
console.log r
# paymentIntent = await stripe.paymentIntents.create({
#   amount: 123,
#   currency: "usd",
#   # In the latest version of the API, specifying the `automatic_payment_methods` parameter is optional because Stripe enables its functionality by default.
#   automatic_payment_methods: {
#     enabled: true,
#   },
# })
#
# console.log(paymentIntent)
# console.log("client_secret", paymentIntent.client_secret)

###
接下来，你可以创建一个产品和一个基于用量的价格。在这个例子中，我们创建一个名为“基于用量的计费”的产品，然后创建一个每月10美元的价格：

stripe.products.create({
 name: 'Usage Based Billing',
 type: 'service',
})
.then((product) => {
 return stripe.prices.create({
   unit_amount: 1000,
   currency: 'usd',
   recurring: { interval: 'month' },
   usage_type: 'metered',
   product: product.id,
 });
})
.then((price) => {
 console.log(`Price ${price.id} created.`);
})
.catch((error) => {
 console.error(`Error creating price: ${error}`);
});
2

在这段代码中，我们首先创建了一个产品，然后使用这个产品的ID来创建一个价格。这个价格被设置为每月10美元，并且它的用量类型被设置为"metered"，这意味着我们可以记录客户的用量并根据他们的用量来计费。

最后，我们打印出创建的价格ID，以便我们可以在之后的订阅或者购买中使用这个价格。
###


