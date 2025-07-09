<!-- ButtonRoundIcon -->

<script setup>
import { addIcons } from "oh-vue-icons";
import { BiFileEarmarkArrowDown, BiFileEarmarkRichtext, BiPersonPlusFill } from "oh-vue-icons/icons";

addIcons(BiFileEarmarkArrowDown, BiFileEarmarkRichtext, BiPersonPlusFill);

defineProps({
    icon: String,
    title: String,
});
</script>

<template lang="">
    <div class="rounded-full flex flex-row items-center border">
        <v-icon :name="icon"/>
        {{title}}
    </div>
</template>