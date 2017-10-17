var note;

function ownNote_Client(method,dataObj)
{
    var request = new XMLHttpRequest();

    var data = configData.readConfig("OwnCloud")
    var url = data["url"];

    request.onreadystatechange = function(){

        if (request.readyState == XMLHttpRequest.OPENED)
        {
            request.setRequestHeader("Authorization",  "Basic " + Qt.btoa(data["login"] + ":" + data["password"]))
        }

        if( request.readyState == XMLHttpRequest.DONE){
            var type = request.getResponseHeader("Content-Type");

            if (type.indexOf( "json"))
            {
                switch(method)
                {
                case "list":
                    parseJson(JSON.parse(request.responseText));
                    break;
                case "note":
                    parseNote(JSON.parse(request.responseText))
                    break;

                }


            }else{
                console.log("got no json data")
            }

        }
    }

    switch (method)
    {

        case "list":
            url = url + "/index.php/apps/notes/api/v0.2/notes";
            request.open("GET",url, true);
            break;
        case "note":
            console.log(dataObj["id"])
            url = url + "/index.php/apps/notes/api/v0.2/notes/" +dataObj["id"];
            request.open("GET",url, true);
            break;

    }

    request.send();


}



function getList()
{
    ownNote_Client("list");
}


function parseJson(json)
{
    for (var i in json)
    {
        console.log(json[i].id)
        notesModel.append({"nId": json[i].id,"titel": json[i].title,})

    }

}

function getNote(id)
{
     var data = {"id": id}
     var request = ownNote_Client("note",data);

}

function parseNote(json)
{
   noteTxt.text = json.content;
   notesApp.noteTitel = json.title;
}

function showNote(id, tab)
{
    var component = Qt.createComponent("Note.qml");
      if (component.status === Component.Ready)
      {
          note = component.createObject(notesApp,{"noteId":id,"noteTab":tab});

      }else{
          console.log(component.errorString())
      }

      isNote = true;

      // stack.push({item:note});
      nextStack.push(note);

}



