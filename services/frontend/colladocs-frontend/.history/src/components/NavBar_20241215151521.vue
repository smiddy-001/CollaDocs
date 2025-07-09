<template>
    <nav class="w-screen, h-10 flex flex-rows items-center justify-between">
        <div id="logo-and-system-toolbar">
            <div id="colladocs-logo" class="h-8 w-8 rounded-xl bg-slate-800"></div>
            <v-icon name="bi-music-player" />
        </div>
        <div id="user-toolbar-and-profile" class="flex flex-row justify-end items-center">
            <ButtonRoundIcon icon="BiFileEarmarkArrowDown" title="Export"/>
            <ButtonRoundIcon icon="BiFileEarmarkRichtext" title="Publish"/>
            <ButtonRoundIcon icon="BiPersonPlusFill" title="Add Collaborators"/>
            <div id="profile"></div>
            <v-icon name="BiPersonCircle"/>
        </div>
    </nav>
</template>

<script>
import { ButtonRoundIcon } from "ButtonRoundIcon";
import { BiPersonCircle } from "oh-vue-icons/icons";

const props = defineprops({
    title: string,
    userProfilePicture: string,
})
</script>
