<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function updateMonthGrid(monstr, divname, f, data)
{
    var SDIV = document.getElementById(divname);
    if (monstr.length==0)
        return;

    var url ="schedule_monthgrid.jsp?month=" + monstr + "&r=" + new Date().getTime();
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
                if (f!=null && data!=null)
                    setupWeekday(f, data);
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function setupNormalWeekday(f)
{
    var elements = f.form.elements;
    for (var i=0; i<elements.length; i++)
    {
        var e = elements[i];
        if (e.name=='day') {
            var tokens = e.value.split("@");
            var dayofmonth = tokens[0];
            var dayofweek = tokens[1];
            if (dayofweek==1 || dayofweek==7) {
                e.checked = false;
                continue;
            }
            e.checked = f.checked;
        }
    }
}

function setEnabled(f, enable)
{
    var elements = f.elements;
    for (var i=0; i<elements.length; i++)
    {
        var e = elements[i];
        if (e.name=='day') {
            e.checked = enable;
        }
    }
}

function setupWeekday(f, data)
{
    var a = new Array;
    var elements = f.elements;
    for (var i=0; i<elements.length; i++)
    {
        var e = elements[i];
        if (e.name=='day') {
            var tokens = e.value.split("@");
            var dayofmonth = tokens[0];
            a[dayofmonth] = e;
        }
    }
    var tokens = data.split(",");
    for (var i=0; i<tokens.length; i++) {
        var e = a[tokens[i]];
        if (e!=null)
            e.checked = true;
    }
}
</script>

