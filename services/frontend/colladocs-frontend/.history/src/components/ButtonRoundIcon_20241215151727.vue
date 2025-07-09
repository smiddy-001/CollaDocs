import ButtonRoundIcon from 'ButtonRoundIcon';
<template lang="">
    <div class="rounded-full flex ">
        <v-icon :name="icon"/>
        {{title}}
    </div>
</template>
<script>
export default {
    ButtonRoundIcon
}
const props = defineprops({
    icon: string,
    title: string 
})
</script>
<style lang="">

</style>