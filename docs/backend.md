3 services

## Frontend
do this bit last

## Database
- USER(<u style="color: olive">userId</u>, username, email, password, joinDate, lastLoginDate, <span style="color: lightBlue">userSettings</span>)
- SETTINGS(<u style="color: lightBlue">settingsId</u>, permissions, userColorScheme,  | ...  )
- ARTICLE(<u style="color: pink">articleId</u>, Title, keywords, <span style="color: olive">owner</span>, articleVisibility, currentVersionPointer)
- ARTICLE_VERSION(<u>versionId</u>, articleId, editTime, authorId, parentVersionId, changes)
- ARTICLE_HISTORY(<span style="color: pink">article</span>, edit_time, versionId)
- ARTICLE_EDITOR(<span style="color: olive">userId</span>)

**VIEWS**
- <span style="color:green">viewerView</span>
- <span style="color:orange">editorView</span>, contains <span style="color:green">viewerView</span> permissions
- <span style="color:red">ownerView</span>, contains <span style="color:orange">editorView</span> + <span style="color:green">viewerView</span> permissions

## Article Maker API 

all calls to the api require an access key

| REST   | Call                    | Parameters                                                                                                                            | Security Context                             | Example | Description                                                                                                                                                               |
|--------|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PUSH   | article                 | <span style="color:olive">userId</span>, **json**                                            | <span style="color:green">viewerView</span>  | ...     | creates a new article with some default values or custom ones specified in the **json**                                                                                   |
| PUSH   | user                    | **json**                                                                                                                              | <span style="color:green">viewerView</span>  | ...     | creates a new user and returns some info about the newly created user **json**                                                                                            |
| GET    | articleAuthor           | <span style="color:pink">articleId</span>                                                                                             | <span style="color:green">viewerView</span>  | ...     | gets the article author username and email                                                                                                                                |
| GET    | articleFromKeyword      | some string                                                                                                                           | <span style="color:green">viewerView</span>  | ...     | gets the title and id of the articles with a matching keyword from some **json** keyword list                                                                             |
| GET    | articleFromTitle        | some string                                                                                                                           | <span style="color:green">viewerView</span>  | ...     | gets the title and id of the articles with a matching title                                                                                                               |
| GET    | articlesInvolvingAuthor | <span style="color:olive">userId</span>                                                                                               | <span style="color:green">viewerView</span>  | ...     | a list of articles the specific user has been involved with                                                                                                               |
| GET    | viewArticle             | <span style="color:pink">articleId</span>                                                                                             | <span style="color:green">viewerView</span>  | ...     | gets the article for reading                                                                                                                                              |
| DELETE | user                    | <span style="color:olive">userId</span>                                                                                               | <span style="color:green">viewerView</span>  | ...     | removes the user and the articles they own, unless they specified editors, in which case the editor becomes the new owner and the user we delete is removed from the file |
| PUT    | articleContent          | <span style="color:olive">userId</span>, <span style="color:red">userView</span>, <span style="color:pink">articleId</span>, **json** | <span style="color:orange">editorView</span> | ...     | modify the article content, and map it to the article history / version                                                                                                   |
| PUT    | articleRevert          | <span style="color:pink">articleId</span>, ArticleVersionId | <span style="color:orange">editorView</span> | ...     | revert the article content, by copying the info in the article history table, and adding a new row, with the same info as the reverted change just incase the user reverts the revertion                                                                                                   |
| PUT    | articleInfo             | <span style="color:olive">userId</span>, <span style="color:pink">articleId</span>, **json** | <span style="color:red">ownerView</span>     | ...     | modify the article visibility / transfer ownership / title / metadata                                                                                                     |
| DELETE | article                 | <span style="color:olive">userId</span>, <span style="color:pink">articleId</span>                                                    | <span style="color:red">ownerView</span>     | ...     | removes all info relating to he article                                                                                                                                   |


## Example json for some example page

```json
{
    "title": "intro to DSA"
    "keywords": {
        [
            "intro to DSA",
            "Data Structures",
            "Algorithms"
        ]
    },
    "authors": {
        [
            "Riley Smith",
            "John Doe"
        ]
    },
    "last-edit-date": "01-07-2004",  // the last edit in dd-mm-yyy
    "body": {
        [
            {  // first block in the website
                "type": "mdx"  // of mdx, md, html, image, or code
                "content": "# title\nhello world\n\n<button url="helloworld.com">"
            },
            {  // second block in the website
                "type": "code"  // of mdx, md, html, image, or code
                "code": {
                    "py": {  // same as the file extension if you were to use the language
                        "content": "import os\n\n\ndef main():\n  print("Hello World!")\n\nmain()",
                        "functions": {
                            [
                                {
                                    "title": main
                                    "start_position": (4:1), // line:column
                                    "end_position": (5:26),
                                    "docstring": "this function does  | ... ",
                                    "params": [...],
                                    "returns": "None"
                                }
                            ]
                        }
                    }
                }
            },
        ]
    }
}
```


## Example json for an edit to a page

```json
{
    [
        // OPERATION(some json finder stuff, line to start, line to end)
        "INSERT(body[2], code, py, content, 4)": "None",
         | ... 
    ]
}
```