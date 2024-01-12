#!/usr/bin/env coffee
> @3-/uws/localhost.js:uws
  @3-/uws/Err.js > NOT_FOUND
  @3-/uridir
  ./STRIPE.js
  path > dirname join

ROOT = dirname uridir import.meta

METHOD = {
  get:
    setup:=>
      # stripe.customers.update 可以更新邮件 , 记得在hook修改邮件事件, 不应该每次都创建用户, 应该先从数据库中读取用户
      customer = await STRIPE.customers.create({
        email: 'test@example.com'
        # 'jennyrosen@example.com'
        # preferred_locales: []
      })
      # https://stripe.com/docs/payments/payment-element/migration?integration-path=future#recurring-add-payment-methods
      o = await STRIPE.setupIntents.create {
        customer: customer.id
      }
      console.log 'client_secret', o.client_secret
      return o.client_secret
}

APP = (res)->
  head = new Map @head
  origin = head.get('origin')
  if origin
    res.writeHeader(
      'Access-Control-Allow-Origin'
      '*'
    )
  m = METHOD[@method]
  if m
    f = m[@path]
    if f
      return f()
  NOT_FOUND

uws(
  APP
  ROOT
)

