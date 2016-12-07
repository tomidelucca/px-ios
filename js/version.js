$(document).ready(function() {
    $('#version li').click( function(){
    	if ($(this).attr('id') == "2.2.1"){
    		setPod220();
    	}
    	if ($(this).attr('id') == "2.0.3.2"){
			setPod2032();
    	}
    	if ($(this).attr('id') == "workshop"){
			setPodWorkshop();
    	}
    });
    if (window.location.hash == "#2.0.3.2"){
      	setPod2032();
    } else if (window.location.hash == "#workshop"){
      	setPodWorkshop();
    } else if (window.location.hash == "" || window.location.hash =="2.2.1"){
      	setPod220();
    }

    function setPod2032(){
    	$('#versionXcode').text("8.0");
    	$('#versionSwift').text("2.3");
    	$('#changes').html("<li>Compatible con Xcode 7</li><li>Sin dependecias de Google Analitics</li>");
    	
    	$("#dropdownTitle").text("Pod 2.0.3.2");
    }
    function setPod220(){
    	$('#versionXcode').text("8.0+");
    	$('#versionSwift').text("3.0.1");
    	$('#changes').html("<li>Nuevo rediseño visual</li>");

    	$("#dropdownTitle").text("Pod 2.2.1");
    }
    function setPodWorkshop(){
    	$('#versionXcode').text("7.0");
    	$('#versionSwift').text("2.0");
    	$('#changes').html("<li>Version Beta</li>");

    	$("#dropdownTitle").text("Pod Workshop");
    }

});
