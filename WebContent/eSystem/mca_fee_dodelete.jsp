<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function showMsg(msg)
{
    document.getElementById("msg").innerHTML = msg;
}

function do_delete_check(id)
{
    if (!confirm('Are you sure to delete?')) {
        parent.feewin.hide();
        return;
    }
    var url = "mca_fee_delete_check.jsp?id=" + id;

    showMsg("Please wait");

    var req = new XMLHttpRequest();
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0) {
                    alert(req.responseText.substring(t+2));
                }
                else {
                    var r = req.responseText;
                    if (r.indexOf("yes")>=0 && !confirm('There are manully added/modified charges, delete it anyway?'))
                        return;
                    do_delete(id);
                }
            }
            else if (req.readyState == 4 && req.status == 404) {
                alert("檔案不存在");
                return;
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function do_delete(id)
{
    
    var url = "mca_fee_delete.jsp?id=" + id;

    var req = new XMLHttpRequest();
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0) {
                    alert(req.responseText.substring(t+2));
                }
                else {
                    showMsg("delete success!");
                    parent.do_reload = true;
                }
            }
            else if (req.readyState == 4 && req.status == 404) {
                alert("檔案不存在");
                return;
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function dodelete() {
    do_delete_check(<%=request.getParameter("id")%>);
}

</script>

<body onload="dodelete()">
<blockquote>
<div id="msg"></div>
</blockquote>