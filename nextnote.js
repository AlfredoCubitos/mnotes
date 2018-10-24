var json;


function getList()
{
    notesApp.request = "liste";
    netWork.getMnotes("/index.php/apps/notes/api/v0.2/notes");
}

function getNote(id)
{
    console.log("getNote "+id)
    notesApp.request = "note";
    netWork.getMnotes("/index.php/apps/notes/api/v0.2/notes/"+id)
}

function newNote(content)
{
    notesApp.request = "new";
    var data = JSON.stringify({"content":content});
    var url = "/index.php/apps/notes/api/v0.2/notes" ;
    netWork.newMnote(url,data);
}

function updateNote(id, cat, fav, content)
{
    notesApp.request = "update";
    if(!cat)
        cat = null

   // var data ={"id": id, "category":cat,"favorite":fav,"modified":Date.now(),"content":content};

    var data =JSON.stringify({"id": id, "content":content});
//    console.log("Content: "+data)
    var url = "/index.php/apps/notes/api/v0.2/notes/" +id;

    netWork.updateMnote(url, data);

}

function delNote(id)
{
    notesApp.request = "delete";
    var url = "/index.php/apps/notes/api/v0.2/notes/" +id;
    netWork.delMnote(url);

}

function parseJson(result)
{
     console.log("parseJson: "+ result)
    if (result.length > 0)
    {
        json = JSON.parse(result);
    }else{
        errorDlg.informativeText = "No data available! \nCheck your Server if notes is active."
        errorDlg.open()
    }
    notesBusy.visible = false;

    switch (notesApp.request)
    {
    case "liste":
        makeList();
        break;
    case "note":
        parseNote();
        break;
    case "new":
        parseNewNote();
        break;
    default:
        break;
    }

}

function makeList()
{
    for (var i in json)
    {
      //  console.log(json[i].id)
        notesModel.append({"nId": json[i].id,"titel": json[i].title,})
        if(json[i].category)
                notesModel.setProperty(notesModel.count-1,"buttonLabel.category",json[i].category)
        notesModel.setProperty(notesModel.count-1,"buttonLabel.favorite",json[i].favorite)
       // console.log(notesModel.count)

    }
}


function parseNewNote()
{
   listHeader.id = json.id;
   listHeader.title = json.title;
}

function parseNote()
{
    noteTxt.text = json.content;
    notesApp.noteTitel = json.title;
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

      // stack.push({item:note});
      nextStack.push(note);

}






