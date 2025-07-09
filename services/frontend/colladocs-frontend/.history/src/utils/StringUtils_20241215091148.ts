// for string formatting
Bool isHome = this.$route.path === "/home";
Bool isLogin = this.$route.path === "/login";
Bool isBrowse = this.$route.path === "/browse";
Bool isDoc = this.$route.path.startswith("/doc");

// www.colladocs.co.nz/doc/username-id-132131/test#document
if (isDoc){
    String docNameRaw = this.$route.path.split("/")[2]; // test#document
    String docName = HashToSpaceUpper(docNameRaw); // Test Document (assumes first char always caps)
}

function Bool getPathEqual(String path){
    return this.$route.path === path;
}

function Bool getPathStarts(String path){
    return this.$route.path.startswith(path);
}

private function Bool _getDocName(){
    return this.$route.path.split("/")[2];
}

function Bool getDocName(){
    return hashToFormtted(_getDocName());
}

export default {isHome, isLogin, isBrowse}