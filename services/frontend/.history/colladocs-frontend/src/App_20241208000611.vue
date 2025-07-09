<script setup lang="ts">
</script>

<template>
  <header>
    <div class="wrapper">
      <nav class="w-full flex justify-center">
        <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/login">login</RouterLink>
      </nav>
    </div>
  </header>
  <RouterView />
</template>