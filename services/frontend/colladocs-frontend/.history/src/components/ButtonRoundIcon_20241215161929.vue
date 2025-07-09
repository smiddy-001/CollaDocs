import ButtonRoundIcon from 'ButtonRoundIcon';
<template lang="">
    <div class="rounded-full flex flex-row items-center">
        <v-icon :name="icon"/>
        {{title}}
    </div>
</template>
<script setup>
defineprops({
    icon: string,
    title: string 
})
</script>
<style lang="">

</style>