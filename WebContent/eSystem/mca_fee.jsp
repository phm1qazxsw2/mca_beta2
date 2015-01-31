<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("id"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
%>
<script>
function edit_tag()
{
    document.f2.submit();
}

function edit_billing()
{
    document.f3.submit();
}

function show_detail(tp)
{
    if (tp==1) {
        document.f4.tp.value = 1;
        document.f4.keys.value = create_list;
    }
    else if (tp==2) {
        document.f4.tp.value = 2;
        document.f4.keys.value = modified_list;
    }
    else if (tp==3) {
        document.f4.tp.value = 3;
        document.f4.keys.value = deleted_list;
    }
    document.f4.submit();
}

function do_save()
{
    if (!do_check()) 
        return;
    document.f1.do_action.value = "save";
    document.f1.submit();
}

function do_create(real)
{
    if (!do_check()) 
        return;
    openwindow_inline("<div id='mcafeewin'>This may take a while, please wait...</div>", 'test', 600, 500, 'feewin');

    var url = "mca_fee2.jsp";
    if (real)
        document.f1.do_action.value = 'create';
    else
        document.f1.do_action.value = 'dry';
    var elements = document.f1.elements;
    var post_params = '';
    for (var i=0; i<elements.length; i++) {
        if (elements[i].name=="feeType" && !elements[i].checked)
            continue;
        if (post_params.length>0)
            post_params += '&';
        post_params += (elements[i].name + "=" + encodeURI(elements[i].value));
    }

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
                    feewin.hide();
                    location.reload();
                }
                else {
                    var d = document.getElementById("mcafeewin");
                    d.style.overflow = "auto";
                    d.innerHTML = req.responseText;
                    var c1 = req.responseText.indexOf('<!--START');
                    var c2 = req.responseText.indexOf('END-->');
                    var scr = req.responseText.substring(c1 + 9, c2-1);
                    eval(scr);
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
    req.open('POST', url);
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("Content-length", post_params.length);
    req.setRequestHeader("Connection", "close");
    req.send(post_params);
}

function use_new(key, amt)
{
    if (!confirm("Use calculated amount to overwrite the manual change?"))
        return;

    var url = "mca_resolve_conflict.jsp?key=" + key + "&amt=" + amt + "&r=" + new Date().getTime();

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
                    var d = document.getElementById(key);
                    d.innerHTML = "";
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

function init()
{
    if (<%=ud2.getUserRole()>3%>) {
        var elements = document.f1.elements;
        for (var i=0; i<elements.length; i++) {
            if (elements[i].name=='b1' || elements[i].name=='b2')
                continue;
            elements[i].disabled = true;
        }
    }
}
</script>

<br>

<body onload="init()">
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;Modify Fee Schedule Settings</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<form name=f1 action="mca_fee2.jsp" onsubmit="return do_check(f)" method=post>
<input type=hidden name=do_action value="save">
<input type=hidden name=id value="<%=fee.getId()%>">

<% boolean create_new = false; %>
<%@ include file="mca_fee_content.jsp"%>

</form>
<form name=f2 target=_blank action="studentoverview.jsp">
<input type=hidden name="feeId" value="<%=fee.getId()%>">
</form>
<form name=f3 target=_blank action="mca_student_list.jsp">
<input type=hidden name="tp" value="1">
<input type=hidden name="fid" value="<%=fee.getId()%>">
</form>
<form name=f4 target=_blank action="mca_charge_detail.jsp" method=post>
<input type=hidden name="tp" value="1">
<input type=hidden name="keys">
</form>

</blockquote>

<%@ include file="bottom.jsp"%>	

<script>
    document.getElementById("buttons").innerHTML = 
        '<input name=noname type=button value="Save Only!" onclick="do_save()">' +　　
        '<input name=b1 type=button value="Dry Run" onclick="do_create(false)">' +
        '<input name=b2 type=button value="Generate" onclick="do_create(true)">';
</script>

