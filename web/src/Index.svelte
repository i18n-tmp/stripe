<template lang="pug">
Scorll
  <svelte:component this="{M}" {...A}/>
</template>

<script lang="coffee">
> ./Stripe.svelte
  @~3/scroll:Scorll
  @~3/wait:Wait

M = Wait
A = {}

onMount =>
  p = location.pathname.slice(1)
  {
    default:M
  } = await if p then import(
    "./url/#{p}.svelte"
  ) else await import(
    "./Stripe.svelte"
  )
  return
# > @~3/wait:WAIT
#
# M = WAIT

</script>

<style lang="stylus">
:global(body>.scroll)
  background #fff
  height 100%
  justify-content center
  position absolute
  width 100%
</style>
