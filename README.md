
## Shiny Firebase Data/Session Saving and Sharing

this is an example how to share shiny application data in a quick and intuitive way. 

Once the user clicks on "create link", the defined variables are send to firebase and a link is generated.

--------------

##### internal logic:

Adding data to DB

list --> serialize() --> base64_enc() --> toJSON --> FIREBASE 

```
addToDB <- function(...){
  PUT(paste0(dbURL,path,".json"), body = toJSON(base64_enc(serialize(list(...), NULL))))
}
```

Retrieving data from DB

Firebase --> fromJSON --> base64_dec --> unserialize() --> list2env (variables/data is set to local/global env)

```
fromDB <- function(..., path, url){
  entries <- list(...)
  dataJSON = GET(paste0(url,path,".json"), content_type_json())
  dataFrame = unserialize(base64_dec(unlist(content(dataJSON))))
  for (i in 1:length(entries)) {
    list2env(dataFrame[entries[[i]]], envir = .GlobalEnv)
  }
}
```

--------------

### Result

![alt tag](https://firebasestorage.googleapis.com/v0/b/rscriptmarket-66f49.appspot.com/o/statics%2Fgithub%2Fice_video_20170327-002614.gif?alt=media&token=19f6f9d0-fc14-4cb7-a6e8-88a3300efc99)

#### Next Steps:

 - Refactoring functions to get them more efficient/compact. 



