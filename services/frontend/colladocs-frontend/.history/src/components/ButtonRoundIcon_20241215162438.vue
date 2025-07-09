<!-- ButtonRoundIcon -->
<template lang="">
    <div class="rounded-full flex flex-row items-center">
        <v-icon :name="icon"/>
        {{title}}
    </div>
</template>
<script setup>
import { BiFileEarmarkArrowDown, BiFileEarmarkRichtext, BiPersonPlusFill } from "oh-vue-icons/icons";
addIcons(BiFileEarmarkArrowDown, BiFileEarmarkRichtext, BiPersonPlusFill);


defineprops({
    icon: string,
    title: string 
})
</script>