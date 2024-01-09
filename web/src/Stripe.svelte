<script lang="coffee">
> @stripe/stripe-js/pure > loadStripe

KEY = 'pk_test_51OOdeZBS6OLyeF2Q2vJSNp2Sj38M7I648CqUliWXm9qu20z6BmzzM5DoDNn6JSLSlSoiivOsvbpIgfVOxWPc7iP000sxlGQ1SL'

'sk_test_51OOdeZBS6OLyeF2Qg9JIegNWvAQmpatGqyJV4ZFGlO2Pui1gvrSoWM2lmmYWyUwULsvF3pY4ZDSkJ4P3t2Kq0chM00s25ov6rF'

+ i

onMount =>
  stripe = await loadStripe(KEY)
  elements = stripe.elements({
    clientSecret:{

    }
    appearance:{

    }
  })
  paymentElement = elements.create('payment', options)
  paymentElement.mount(i)
  return
</script>

<template lang="pug">
i(@&i)
h1 test
</template>

<style lang="stylus"></style>

