<script setup lang="ts">
import NavBar from 'components/NavBar.vue'
</script>

<template>
  <header>
    <div class="wrapper">
      <NavBar/>
    </div>
  </header>
  <RouterView />
</template>