<script setup lang="ts">
</script>

<template>
  <header>
    <div class="wrapper">
      <nav class="w-full flex flex-col">
        <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/login">login</RouterLink>
      </nav>
    </div>
  </header>
  <RouterView />
</template>