 function LTrim( value ) {
     	var re = /\s*((\S+\s*)*)/;
     	return value.replace(re, "$1");
 }
   
 // Removes ending whitespaces
 function RTrim( value ) {
  	var re = /((\s*\S+)*)\s*/;
  	return value.replace(re, "$1");	
 }
 // Removes leading and ending whitespaces
 function trim( value ) {
  	return LTrim(RTrim(value)); 	
 }

function myEncodeURI(uri)
{
    var r = encodeURI(uri);
    return r.replace('&','%26');
}