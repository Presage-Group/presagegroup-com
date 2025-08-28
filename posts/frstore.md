@def title = "frstore: R interface to Google Firestore Database"
@def author = "Umair Durrani"
@def date = "2025-08-21"
@def tags = ["Analytics", "Google"]
@def short_text = ""
@def img = "/assets/images/frstore.png"

@def rss_pubdate = Date(2025, 08, 21)

\blogheader{}

Firestore is a Google Cloud NoSQL database that is used to power internal tooling and applications at Presage. Since there is no official support for interacting with Firestore in the R programming language, we developed the [`frstore`](https://github.com/Presage-Group/frstore) package that enables the Create, Read, Update, and Delete (CRUD) database operations on Firestore databases using R. This open-source package is available on GitHub.

[`frstore`](https://github.com/Presage-Group/frstore) provides these functions for the CRUD operations:

| Operation | Functions |
|-----------|-----------|
| Create    | `frstore_create_document` |
| Read      | `frstore_get`; `frstore_run_query` |
| Update    | `frstore_patch` |
| Delete    | `frstore_delete` |
