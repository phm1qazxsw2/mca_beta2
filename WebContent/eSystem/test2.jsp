<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>

<%
    int type=1;
    String typeS=request.getParameter("type");
    if(typeS !=null)
        type=Integer.parseInt(typeS);

    int scriptType=0;
%>
<script>

  function up3tab(s_obj,len,next_obj){
    var tmp_obj;

    if(s_obj.value.length==4 || s_obj.value.length==7)
    {
        getCodeinfo(s_obj.value);
    }else if(s_obj.value.length >4){
        var xinfo=s_obj.value.substring(0,4);
        getCodeinfo(xinfo);
    }else{
        document.getElementById("showCode").innerHTML="";
    }

    if((s_obj.value.length >= len) && next_obj && (tmp_obj = eval("document.xs." + next_obj))) return tmp_obj.focus();
  }

    function getCodeinfo(accountCode)
    {

        var codeType=<%=scriptType%>;
        SDIV = document.getElementById("showCode");

        var url ="_getAccountingCode.jsp?code="+accountCode+"&type="+codeType+"&ran="+(new Date()).getTime();
        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    SDIV.innerHTML = req.responseText;
                }
            }
        };
        req.open('GET', url);
        req.send(null);
    }

    function goChange(smallItem){
        
        document.xs.bigCode.value=document.xs.bigCode.value.substring(0,4)+smallItem;

        
    }

</script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<br>
<br>
<br>

<center>
<table>
    <tr>
        <form name="xs" id="xs">
        <td>
            會計科目
        </td>
        <td>
            <input type=text name="bigCode" value="" size=6 maxlength=7  onkeyup="up3tab(this,7,'next')">
            <div id="showCode"></div>
        </td>
        <td>
            <a href="javascript:openwindow_phm('searchAccntCode.jsp?type=<%=scriptType%>','尋找會計科目',300,600,true);">尋找</a>
        </td>
    </tr>
    <tr>
        <td>next</td>
        <tD colspan=2>
            <input type=text name="next">
        </td>
    </tr>
    </table>
    </center>
        </form>

<%
    String code=request.getParameter("code");
    if(code !=null)
    {
%>
<script>
    
    document.xs.bigCode.value=<%=code%>;
    getCodeinfo(<%=code%>);

</script>
<%
    }
%>