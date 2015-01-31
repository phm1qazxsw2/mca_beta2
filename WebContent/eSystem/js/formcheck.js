
function IsPositive(sText, isInt)
{
	if (!IsNumeric(sText))
		return false;
	eval("var tmp = (sText>0);");
	return tmp;
}

function IsNumeric(sText, isInt)
{
    var ValidChars = (isInt)?"0123456789":"0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;
}

function checkDate(d, sep) {
	separator = "-";
	if (arguments.length>1)
		separator = sep;
    var tokens = d.split(separator);
    if (tokens.length!=3)
        return false;
    for (var i=0; i<tokens.length; i++) {
        if (!IsNumeric(tokens[i])) {
            return false;
        }
    }    
    if (tokens[0].length!=4 || tokens[1].length!=2 || tokens[2].length!=2) {
        return false;
    }
    
    return true;
}
