// Utility file for string formatting and path checks
const isHome = (context: any): boolean => context.$route.path === "/home";
const isLogin = (context: any): boolean => context.$route.path === "/login";
const isBrowse = (context: any): boolean => context.$route.path === "/browse";
const isDoc = (context: any): boolean => context.$route.path.startsWith("/doc");

// Converts a hash-separated string into a formatted string
// Example: "test#document" => "Test Document"
const hashToFormatted = (text: string): string => {
    return text
        .split("#")
        .map((word, index) => 
            index === 0 ? capitalize(word) : capitalizeFirstLetter(word)
        )
        .join(" ");
};

// Capitalizes the first letter of a string
const capitalize = (word: string): string => {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
};

// Capitalizes the first letter of a word after a hash
const capitalizeFirstLetter = (word: string): string => {
    return word.charAt(0).toUpperCase() + word.slice(1);
};

// Retrieves the document name from the route path
const getDocName = (context: any): string | null => {
    if (!isDoc(context)) return null;
    const docNameRaw = context.$route.path.split("/")[2]; // Extracts the raw name
    return hashToFormatted(docNameRaw); // Formats the name
};

// Checks if the current path is equal to a given path
const getPathEqual = (context: any, path: string): boolean => {
    return context.$route.path === path;
};

// Checks if the current path starts with a given string
const getPathStarts = (context: any, path: string): boolean => {
    return context.$route.path.startsWith(path);
};

export {
    isHome,
    isLogin,
    isBrowse,
    isDoc,
    getDocName,
    getPathEqual,
    getPathStarts,
};
