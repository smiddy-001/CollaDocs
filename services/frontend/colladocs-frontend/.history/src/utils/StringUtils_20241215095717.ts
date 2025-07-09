// Utility file for string formatting and path checks

// Converts a hash-separated string into a formatted string
// Example: "test#document" => "Test Document"
function hashToFormatted(text: string): string {
    return text
        .split("#")
        .map((word, index) => 
            index === 0 ? capitalize(word) : capitalizeFirstLetter(word)
        )
        .join(" ");
}

// Capitalizes the first letter of a string
function capitalize(word: string): string {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
}

// Capitalizes the first letter of a word after a hash
function capitalizeFirstLetter(word: string): string {
    return word.charAt(0).toUpperCase() + word.slice(1);
}

// Retrieves the document name from the route path
function getDocName(): string | null {
    if (!this.$route.path.startsWith("/doc")) return null;
    const docNameRaw = this.$route.path.split("/")[2]; // Extracts the raw name
    return hashToFormatted(docNameRaw); // Formats the name
}

// Checks if the current path is equal to a given path
function getPathEqual(path: string): boolean {
    return this.$route.path === path;
}

// Checks if the current path starts with a given string
function getPathStarts(path: string): boolean {
    return this.$route.path.startsWith(path);
}

export default {
    getDocName,
    getPathEqual,
    getPathStarts,
};
