<%@ page language="java" import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<%
    new VoucherService(0, _ws.getSessionBunitId()).setupAcodeCashAccounts();
    // ### 2009/2/4 added by peter, 學生帳戶不用傳回
    String q = "active="+Acode.ACTIVE_YES;
    q += " and not (main='" + VoucherService.STUDENT_ACCOUNT + "' and sub like '#%')";
    // ########
    ArrayList<Acode> acodes = AcodeMgr.getInstance().retrieveListX(q, "order by main, sub asc", _ws.getAcodeBunitSpace("bunitId"));
    AcodeInfo ainfo = new AcodeInfo(acodes);
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;會計科目維護</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 

<table>
<tr>
   <td valign=top width=40>
<!--
       <br>
       <input type=checkbox onclick="do_search();"> 全部 <br>
       <input type=checkbox> 系統產生 <br>
       <input type=checkbox> 1 開頭 <br>
       <input type=checkbox> 2 開頭 <br>
       <input type=checkbox> 3 開頭 <br>
       <input type=checkbox> 4 開頭 <br>
       <input type=checkbox> 5 開頭 <br>
       <input type=checkbox> 6 開頭 <br>
       <input type=checkbox> 7 開頭 <br>
-->
   </td>
   <td valign=top id="content">       

<!-- ################### start of content ################### -->
  <a href="#" class=es02 onclick="addmain();return false;"><img src="pic/add.gif" border=0 width=15>&nbsp;新增主科目</a>
  <table width="500" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1 id="tbl">
            <tr class=es02 bgcolor=f0f0f0>
                <td width=1%>                    
                </td>
                <td>
                    科目
                </td>
                <td>
                    名稱
                </td>
                <td>                    
                </td>
                <td>                    
                </td>
                <td>                    
                </td>
            </tr>
<%
    for (int i=0; i<acodes.size(); i++) {
        Acode a = acodes.get(i); %>
            <tr class=es02 bgcolor="<%=(a.getType()!=Acode.TYPE_MANUAL)?"lightyellow":"#ffffff"%>">
                <td width=1% nowrap>
                    <%=(a.getRootId()==0)?"主":""%>
                </td>
                <td nowrap>
                    <%=(a.getRootId()==0)?"":"&nbsp;&nbsp;"%><%=ainfo.getMainSub(a)%>
                </td>
                <td id="a<%=i%>" nowrap>
                    <%=(a.getRootId()==0)?"":"&nbsp;&nbsp;"%><%=ainfo.getName(a)%>
                </td>
                <td nowrap>
                    <%=(a.getType()!=Acode.TYPE_MANUAL)?"系統":""%>
                </td>
                <td nowrap>
                <%
                    if (a.getType()==Acode.TYPE_MANUAL)
                        out.println("<a href=\"javascript:disable("+a.getId()+")\">刪除</a>");
                %>
                </td>
                <td align=right nowrap>
                <% if (a.getRootId()==0) { %>
                    <a href="javascript:addsub(<%=a.getId()%>)"><img src="pic/add.gif" border=0 width=10>&nbsp;新增子科目</a>
                <% } %>
                </td>
            </tr>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>
<!-- #################### end of content ################### -->
   </td>
</tr>
</table>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function disable(id) {
    if (!confirm("確定刪除？"))
        return;

    var url = "acode_disable.jsp?a=" + id + "&r="+(new Date()).getTime();
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else {
                    location.reload();
                }                        
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("查詢服務器時發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);    
}
</script>

<script>
var aid = new Array;
var atxt = new Array;
<% for (int i=0; i<acodes.size(); i++) { 
       if (acodes.get(i).getType()==Acode.TYPE_SYSTEM)
           continue; %>
aid[<%=i%>] = <%=acodes.get(i).getId()%>;
atxt[<%=i%>] = '<%=phm.util.TextUtil.escapeJSString(ainfo.getName(acodes.get(i)))%>';
var d = document.getElementById('a<%=i%>');
d.idx = <%=i%>;
d.onclick = function() {
    var pname = "";
    var sname = atxt[this.idx];
    var c = sname.indexOf("-");
    if (c>0) {
        pname = atxt[this.idx].substring(0, c);
        sname = atxt[this.idx].substring(c+1);
    }
    this.innerHTML = 
        pname + 
        ' <input type=text id="input'+this.idx+'" name="input'+this.idx+'" value="" size=15>' + 
        ' <a href="#" onclick="return false;">儲存</a> | <a href="#" onclick="return false;">取消</a>';
    var x = document.getElementById('input'+this.idx);
    x.container =this;
    x.idx = this.idx;
    x.orgname = sname;
    x.onblur = function() {
        var displaytxt = atxt[this.idx];
        if (this.value.length>0 && this.value!=this.orgname) {
            if (confirm("是否儲存修改？")) {
                displaytxt = "saving..";
                var newname = this.value;
                var acodeid = aid[this.idx];
                var curidx = this.idx;
                var curcontainer = this.container;
                
                var url = "acode_modify.jsp?a=" + acodeid + "&n=" + encodeURI(newname) + "&r="+(new Date()).getTime();
                var req = new XMLHttpRequest();

                if (req) 
                {
                    req.onreadystatechange = function() 
                    {
                        if (req.readyState == 4 && req.status == 200) 
                        {
                            var t = req.responseText.indexOf("@@");
                            if (t>0)
                                alert(req.responseText.substring(t+2));
                            else {
                                var result = req.responseText;
                                var tokens = result.split(":");
                                aid[curidx] = eval(tokens[0]);
                                atxt[curidx] = tokens[1];
                                curcontainer.innerHTML = atxt[curidx];
                            }                        
                        }
                        else if (req.readyState == 4 && req.status == 500) {
                            alert("查詢服務器時發生錯誤");
                            return;
                        }
                    }
                };
                req.open('GET', url);
                req.send(null);
            }
        }
        if (displaytxt.indexOf("-")>0)
            displaytxt = "&nbsp;&nbsp;" + displaytxt;
        this.container.innerHTML = displaytxt; // atxt[this.container.idx];
    }
    x.focus();
}
<% } %>
</script>

<script>
function addmain()
{
    openwindow_phm2('acode_add.jsp', '新增主科目', 400, 300, 'acodewin');  
}
function addsub(parentId)
{
    openwindow_phm2('acode_add_sub.jsp?a='+parentId, '新增子科目', 400, 300, 'acodewin');  
}
</script>