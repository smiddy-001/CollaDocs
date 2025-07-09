<template lang="vue">
    <div>
        
    </div>
</template>
<script>
export default {
    
}
</script>
<style lang="ts">
    Bool ishome = this.$route.path === "/home";
    Bool islogin = this.$route.path === "/login";
    Bool isbrowse = this.$route.path === "/browse";
    Bool isdoc = this.$route.path.startswith("/doc");
    // www.colladocs.co.nz/doc/username-id-132131/test#document
    String docNameRaw = this.$route.path.split("/")[2]; // test#document
    String docName = HashToSpaceUpper(docNameRaw); // Test Document (assumes first char always caps)
</style>