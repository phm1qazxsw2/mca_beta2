<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>

<!--############# -->
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />
<script type="text/javascript" src="openWindow.js"></script> 
<script src="js/show_voucher.js"></script>
<!--############# -->

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script src="js/formcheck.js"></script>
<script>
function add_vchr()
{
    openwindow_phm2('vchr_add.jsp','新增傳票',800,600,'addvchrwin');
}
function edit_vchr(id)
{
    openwindow_phm2('vchr_edit.jsp?id='+id,'修改傳票',800,600,'addvchrwin');
}

function copy_vchr(id)
{
    openwindow_phm2('vchr_copy.jsp?id='+id,'複製傳票',800,600,'addvchrwin');
}

function delete_vchr(id)
{
    if (!confirm("確定刪除？"))
        return;

    var url = "vchr/vchr_delete.jsp?id=" + id + "&r="+(new Date()).getTime();
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
                    alert("刪除成功!");
                    location.reload();
                }                        
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("刪除時發生錯誤,資料沒有寫入");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);    
}
</script>
<br>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;傳 票 登 入</b>
</div>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<%
    if(checkAuth(ud2,authHa,201)){
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:add_vchr();"><img src="pic/costtype3add.png" border=0>&nbsp;新增傳票</a>
</div>
<br>
<%  }   
%>
<%
    int start = 0;
    try { start = Integer.parseInt(request.getParameter("s")); } catch (Exception e) {}
    VchrHolderTypeMgr vmgr = VchrHolderTypeMgr.getInstance();
    String q = "srcType=" + VchrThread.SRC_TYPE_MANUAL;
    int total = vmgr.numOfRows(q);
    int len = 20;

    ArrayList<VchrHolderType> vchrs = vmgr.retrieveListX(q, "order by vchr_holder.id desc limit "
        +start+","+len, _ws.getBunitSpace("vchr_holder.buId"));
    if (vchrs.size()==0) {
        return;
    }
    String vchrIds = new RangeMaker().makeRange(vchrs, "getId");
    ArrayList<VchrItem> vchritems = VchrItemMgr.getInstance().retrieveList("vchrId in (" + vchrIds + ")", "");
    Map<Integer, ArrayList<VchrItem>> vchritemMap = new SortingMap(vchritems).doSortA("getVchrId");

%>
<link href="ft02.css" rel=stylesheet type=text/css>

<table border=0 class=es02>

<tr align=middle bgcolor='#f0f0f0'>
   <td width=30 align=right>No.</td><td nowrap width=50>部門</td><td colspan=2 nowrap>會計科目</td><td nowrap align=middle>摘&nbsp;&nbsp;要</td><td>借</td><td>貸</td>
</tr>
<%
    for (int i=0; i<vchrs.size(); i++) {
        VchrHolder v = vchrs.get(i);
        out.println("<tr><td></td><td colspan=6 height=10><hr style=\"color:#f0f0f0;height:1px\" width='100%'></td></tr>");
        out.println("<tr><td align=right>v"+v.getId()+"&nbsp;</td><td colspan=6><a href=\"javascript:edit_vchr("+v.getId()+")\">" + v.getSerial() + "</a>&nbsp;&nbsp; ");
        if (ud2.getId()==v.getUserId()) {
            out.println("<a href=\"javascript:edit_vchr("+v.getId()+")\">編輯</a> &nbsp;&nbsp; <a href=\"javascript:delete_vchr("+v.getId()+")\">刪除</a> &nbsp;&nbsp; <a href=\"javascript:copy_vchr("+v.getId()+")\">複製</a>");
        }
        else {
            out.println("<span class=es02>created by: "+EzCountingService.getUserName(v.getUserId())+"</span>");
        }
        out.println("</td></tr>");
        ArrayList<VchrItem> items = vchritemMap.get(v.getId());
        VchrInfo vinfo = new VchrInfo(items,0);
        for (int j=0; j<items.size(); j++) {
            VchrItem vi = items.get(j);
            out.print("<tr align=left valign=top><td></td>");
            out.print("<td nowrap>&nbsp;" + vinfo.getBunitName(vi) + "&nbsp;&nbsp;&nbsp;</td>");
            out.print("<td nowrap>" + vinfo.formatAcode(vi) + "</td>");
            out.print("<td nowrap>&nbsp;&nbsp;" + vinfo.getAcodeName(vi) + "</td>");
            out.print("<td width=250>&nbsp;&nbsp;" + vinfo.getNote(vi) + "&nbsp;&nbsp;</td>");
            out.print("<td align=right nowrap>&nbsp;" + vinfo.formatDebit(vi) + "&nbsp;&nbsp;</td>");
            out.print("<td align=right nowrap>&nbsp;" + vinfo.formatCredit(vi) + "&nbsp;&nbsp;</td>");
            out.println("</tr>");
        }
    }
%>
</table>

<%@ include file="bottom.jsp"%>