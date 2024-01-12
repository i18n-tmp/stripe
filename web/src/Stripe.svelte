<script lang="coffee">
> @stripe/stripe-js/pure > loadStripe
  @3-/fetch/fTxt.js
  @~3/wait:Wait

+ I, form, el, err, stripe, type, pay

google_pay = 'google_pay'

get = new Proxy(
  {}
  get:(_, url)=>
    fTxt '//localhost:3000/'+url
)

# fields 领域
# 默认情况下，付款元素将收集完成付款所需的所有详细信息。
#
# 对于某些付款方式，这意味着付款元素将收集您可能已从用户那里收集的详细信息，例如姓名或电子邮件。如果是这种情况，您可以使用 fields 选项阻止付款元素收集这些数据。
#
# 如果您使用 fields 选项禁用特定字段的收集，则必须将相同的数据传递给 stripe.confirmPayment，否则付款将被拒绝。

KEY = 'pk_test_51OOdeZBS6OLyeF2Q2vJSNp2Sj38M7I648CqUliWXm9qu20z6BmzzM5DoDNn6JSLSlSoiivOsvbpIgfVOxWPc7iP000sxlGQ1SL'

errRender = (r)=>
  {error} = r
  if error
    err = error.message
    return
  return 1

onMount =>
  # https://stripe.com/docs/payments/payment-element/migration?integration-path=future

  email = '3ti.site@gmail.com'

  stripe = await loadStripe(KEY)
  # https://stripe.com/docs/js/elements_object/create_without_intent
  # locale https://stripe.com/docs/js/appendix/supported_locales , 切换语言的时候用 https://stripe.com/docs/js/elements_object/update
  # 如果未指定，则 usage 默认为 off_session。查看如何在您的服务器上创建 SetupIntent 并指定 usage：

  el = stripe.elements(
    {
      currency: 'eur'
      mode:'setup'
      # setupFutureUsage: 'off_session'
      appearance:
        labels: 'floating'
        rules:
          '.Label--floating':
            paddingBottom: '12px'
        variables:
          spacingUnit: '4px'
          colorBackground: '#fff'
          colorPrimary: '#333'
          borderRadius: 0
    }
  )

  pay = el.create(
    'payment'
    {
      defaultValues:
        billingDetails: {
          email
        }
      layout:
        type: 'accordion'
        visibleAccordionItemsCount:0
        radios: false
    }
  ).on(
    'change'
    (e)=>
      if errRender e
        { type } = e.value
        if type == google_pay
          submit()
      return
  )

  pay.mount(I)

  return

ING = 'ing'

submit = =>
  form.classList.add ING

  {href} = location

  try
    if errRender await el.submit()
      errRender await stripe.confirmSetup({
        elements: el
        clientSecret:await get.setup
        confirmParams: {
          return_url: href.slice(0,href.indexOf('/',8)+1)+'paySetup'
        }
      })
    else if type == google_pay
      pay.collapse()
      return
  finally
    form.classList.remove ING

  return

</script>

<template lang="pug">
form(@&form @submit|preventDefault=submit)
  i(@&I)
  +if el
    +if err
      b {err}
    button(type="submit") 绑定扣费方式
    +else
      Wait
</template>

<style lang="stylus">
i
  width 100%

b
  align-self flex-start
  color #f00
  display block
  font-size 16px
  font-weight bold
  margin-top 12px
  text-align left

form
  margin auto
  max-width 500px
  min-width 400px
  padding 16px

  button
    margin 20px auto
    width 100%
</style>

