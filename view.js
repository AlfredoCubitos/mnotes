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
function search()
{
    var lcount=0;

    var reg = new RegExp( searchBox.text,'gi')

    var lines = noteText.text.split("\n")

   // var lines = noteText.text
  //  lines.replace(reg, function(match, p1, p2, p3, offset, string){return("<div  background-color: #C0FFC0>"+p1+"</div>")})
    // noteText.text = lines

    for (var i in lines)
    {
        lcount += (lines[i].length === 0 ? 1 : lines[i].length)
      //  lcount += lines[i].length
        var found = reg.exec(lines[i])
        if (found)
        {
            var pos =  lcount - lines[i].length + (found.index === 0 ? 1: found.index)

            console.log("pos: " + pos+"->"+lines[i]+" - "+found[1]+ " :: " + lcount)
             searchBox.svalues.push( pos +3)
        }


      // console.log("#"+lcount+"::"+lines[i].length+": " +lines[i])
    }
    if (searchBox.svalues.length > 0)
    {
        console.log("found: " + lcount +" :: "+searchBox.svalues[0])
      //  noteText.cursorPosition = (searchBox.svalues[0]+2);
        noteText.select(searchBox.svalues[0],searchBox.svalues[0]+3)
        console.log("c start: "+searchBox.selectionStart)
    }
}
