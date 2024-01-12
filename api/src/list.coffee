#!/usr/bin/env coffee

> ./STRIPE.coffee

n = 0
customer = 'cus_PLt83YjoBXFS3p'
opt = {
  limit: 10
  customer
}



loop
  {
    has_more
    data:li
  } = await STRIPE.setupIntents.list(opt)

  console.log has_more, li
  for i from li
    console.log ++n, i
    console.log i.status, i.customer, new Date(i.created * 1000).toISOString()
    if i.status == 'succeeded'
      console.log await STRIPE.paymentMethods.retrieve(i.payment_method)

  if not has_more
    break
  opt.starting_after = li.pop().id

process.exit()

