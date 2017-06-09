$(document).ready(function() {
    var pods =[
        {
            podVersion: "2.2.13",
            xcodeVersion: "8.0+",
            swiftVersion: "3.0.1",
            location: false,
            changes: [
                "Nuevo rediseño visual"
            ]
        },
        {
            podVersion: "2.0.3.2",
            xcodeVersion: "8.0",
            swiftVersion: "2.3",
            location: false,
            changes: [
                "Compatible con Xcode 7",
                "Sin dependecias de Google Analitics"
            ]
        },
        {
            podVersion: "workshop",
            xcodeVersion: "7.0",
            swiftVersion: "2.0",
            location: "workshop/",
            changes: [
                "Version Beta"
            ]
        }
    ]
    var hash = window.location.hash 
    var id = findWithAttr(pods, "podVersion", hash.substring(hash.lastIndexOf('#')+1))
    if (window.location.hash == ""){
        id = 0
    } 
    if (id != -1){
        setPod(id)
    }
    $('#version').html(loadVersions());
    $('#version li').click( function(){
        setPod($(this).attr('id'))
    });


    function setPod(id){
        $('.podVersion').html(pods[id].podVersion);
    	$('#versionXcode').text(pods[id].xcodeVersion);
    	$('#versionSwift').text(pods[id].swiftVersion);
    	$('#changes').html(listChanges(id));
    	$("#dropdownTitle").text("Pod " + pods[id].podVersion);   
    }
    function listChanges(id){

        var length = pods[id].changes.length
        var html = ""
        while (length>0){
            html += "<li>"+ pods[id].changes[length-1]+ "</li>"
            length --
        }
        return html
    }
    function loadVersions(){
        var url = window.location.pathname;
        var filename = url.substring(url.lastIndexOf('/')+1);
        var html = ""
        var upperRoute = ""
        if (pods[id].location == false){
            upperRoute = ""
        } else {
            upperRoute = "../"
        }
        for (var i = 0; i < pods.length; i++) {
            if (pods[i].location != false){
                upperRoute += pods[i].location;
            }

            html += "<li id =\"" + i + "\"><a href=\"" + upperRoute+filename + "#" + pods[i].podVersion + "\" > Pod " + pods[i].podVersion + "</a></li>"
        }
        return html
    }
    function findWithAttr(array, attr, value) {
    for(var i = 0; i < array.length; i += 1) {
        if(array[i][attr] === value) {
            return i;
        }
    }
    return -1;
}

});
