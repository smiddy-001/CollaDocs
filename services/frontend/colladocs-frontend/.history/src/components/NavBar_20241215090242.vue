<template lang="html">
    <div>
        
    </div>
</template>
<script>
export default {
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