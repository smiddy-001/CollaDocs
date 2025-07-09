<template lang="vue">
    <div>
        <BrushIcon class="h-5 w-5 fill-blue-500"/>
    </div>
</template>

<script>
export default {
    import { BrushIcon } from '@remixicons/vue/fill'
    import { getIsHome,  getIsLogin, getIsBrowse, getIsDoc, getDocName } from '../utils/StringUtils'

    Bool isHome = this.$route.path === "/home";
    Bool isLogin = this.$route.path === "/login";
    Bool isBrowse = this.$route.path === "/browse";
    Bool isDoc = this.$route.path.startswith("/doc");
    
    // www.colladocs.co.nz/doc/username-id-132131/test#document
    if (isDoc){
        String docNameRaw = this.$route.path.split("/")[2]; // test#document
        String docName = HashToSpaceUpper(docNameRaw); // Test Document (assumes first char always caps)
    }
}
</script>

<style lang="css">
</style>