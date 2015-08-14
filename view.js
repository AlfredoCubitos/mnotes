var win;

function openNote(id)
{
	  
	  
//	  console.log(this.buttonLabel.text )
	  var component = Qt.createComponent("Window.qml");
        if (component.status === Component.Ready)
		{
            var	win = component.createObject(notesApp,{"noteId":id});
					
		}else{
			console.log(component.errorString())
		}
		
		
		win.show();
		
}

function addToList(id, titel)
{
    notesModel.append({"nId": id, "titel": titel})
}

function updateList(id, titel)
{
    notesModel.set(id, {"titel": titel})
}
function removeFromList(idx)
{
     notesModel.remove(index);
}
