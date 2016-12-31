function ownNote_Client(method)
{
    var request = new XMLHttpRequest();


    request.onreadystatechange = function(){
        if (request.readyState === 4 && request.status === 200) {
            var type = request.getResponseHeader("Content-Type");
           if (type.indexOf( "json"))
           {
                switch(method)
                {
                    case "list":
                        parseJson(JSON.parse(request.responseText));
                        break;
                    case "edit":
                        edit(request.responseText)
                        break;

                }


           }else{
               console.log("got no json data")
           }

        }else{
            console.log("State: "+ request.readyState)
        }
    }

    return request;
}

function getList(name,pw,url)
{
    var request = ownNote_Client("list");
    request.open("GET",url, true);
    request.setRequestHeader("Authorization",  "Basic " + Qt.btoa(name + ":" + pw))
    request.send();
    
}


function parseJson(json)
{
    for (var i in json)
    {
        //console.log(json[i].name)
        notesModel.append({"nId": json[i].toString().id,"titel": json[i].name,})

    }

}

function getNote(name,pw,url,note,group)
{
     var request = ownNote_Client("edit");
    var data =  JSON.stringify({"name":note,"group":group})
    console.log("Data: "+data)
    request.open("POST",url, true);
    request.setRequestHeader("Authorization",  "Basic " + Qt.btoa(name + ":" + pw))
    request.setRequestHeader("Content-type", "application/json");
    request.send(data);
}

function edit(txt)
{

    console.log("Text:" +  normalize(txt) )
    noteText.text = txt;
}

function normalize(str)
{
    return txt
}
