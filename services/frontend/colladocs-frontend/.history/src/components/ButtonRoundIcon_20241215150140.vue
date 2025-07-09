<template lang="">
    <div class="rounded-full">
        <v-icon :name="icon"/>
        {{title}}
    </div>
</template>
<script>
export default {
    
}
</script>
<style lang="">


const props = defineprops({
    icon: string,
    title: string 
})
</style>