<script lang="coffee">
onMount =>
  m = {}
  for [k,v] from new URLSearchParams(location.search)
    m[k] = v
  redirect_status = 'redirect_status'
  if m[redirect_status] == 'succeeded'
    delete m[redirect_status]
    console.log m.setup_intent
    console.log m.setup_intent_client_secret
    return
  console.log m
  return
</script>

<template lang="pug">
</template>

<style lang="stylus"></style>

