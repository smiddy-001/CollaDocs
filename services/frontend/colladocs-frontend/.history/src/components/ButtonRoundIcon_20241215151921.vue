import ButtonRoundIcon from 'ButtonRoundIcon';
<template lang="">
    <div class="rounded-full flex flex-row items-center">
        <v-icon :name="icon"/>
        {{title}}
    </div>
</template>
<script>
export default {
    
}
const props = defineprops({
    icon: string,
    title: string 
})
</script>
<style lang="">

</style>