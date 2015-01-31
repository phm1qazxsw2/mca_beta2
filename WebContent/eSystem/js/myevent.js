
function addevent(targetId, funcName, event)
{
	var d = document.getElementById(targetId);
	var str = '';
	if (d.addEventListener) {
		str = 'd.addEventListener(\'' + event + '\',' + funcName + ', false);';
	}
	else if (d.attachEvent) {
		str = "d.on" + event + " = " + funcName;
	}
	eval(str);
}