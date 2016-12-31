

function getNotebooks(code){
    var method = "GET";
    var url = "https://www.onenote.com/api/v1.0/me/notes/notebooks"

   oneRequest(method,url,"pagesReceived",code)


}


function getPages(code){
    var method = "GET";
    var url = "https://www.onenote.com/api/v1.0/me/notes/pages"
    notesApp.token = code
    oneRequest(method,url,pagesReceived,code)
}

function pagesReceived(obj){

    for (var key in obj.value) {
         var jsonObject = obj.value[key];
       // console.log("oneNoteUrl: " + jsonObject["contentUrl"])

         notesModel.append({"nId": 0, "titel": jsonObject["title"],"oneNoteUrl": jsonObject["contentUrl"]});
    }
}

function getContent(url){
    var method = "GET";
    console.log("getContent: "+notesApp.token)
    var req = new XMLHttpRequest;
    req.open(method, url);
    if (notesApp.token !== undefined)
        req.setRequestHeader("Authorization", "Bearer " + notesApp.token);
    req.onreadystatechange = function() {
        var status = req.readyState;
        if (status === XMLHttpRequest.DONE) {
           // console.log(req.responseText)

              noteText.text = req.responseText

            /*if (wasLoading == true)
                wrapper.isLoaded()*/
        }
       // wasLoading = (status === XMLHttpRequest.LOADING);
    }
    req.send();
  //  oneRequest(method,url,contentReceived,notesApp.token)
}



function oneRequest(method,url,func,code) {
    var req = new XMLHttpRequest;
    req.open(method, url);
    if (code !== undefined)
        req.setRequestHeader("Authorization", "Bearer " + code);
    req.onreadystatechange = function() {
        var status = req.readyState;
        if (status === XMLHttpRequest.DONE) {
           // console.log(req.responseText)
            var objectArray = JSON.parse(req.responseText);
            if (objectArray.errors !== undefined)
                console.log("Error fetching data: " + objectArray.errors[0].message)
            else {
              //  if (typeof func === 'function')

                    func(objectArray);
            }
            /*if (wasLoading == true)
                wrapper.isLoaded()*/
        }
       // wasLoading = (status === XMLHttpRequest.LOADING);
    }
    req.send();
}

function showNote(id, tab)
{
    var component = Qt.createComponent("Note.qml");
      if (component.status === Component.Ready)
      {
         var note = component.createObject(notesApp,{"noteId":id,"noteTab":tab});

      }else{
          console.log(component.errorString())
      }

      isNote = true;

       oneNoteStack.push({item:note});


}

