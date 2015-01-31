<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    String formatName(String n)
    {
        if (n==null || n.length()==0)
            return n;
        return n.substring(0,1).toUpperCase() + n.substring(1);
    }

    String formatAddr(McaStudent s) throws Exception {
        return McaService.formatAddr(s.getCountryID(), s.getCountyID(), s.getCityID(), s.getDistrictID(), 
            s.getChineseStreetAddress(), s.getPostalCode());
    }

    String formatBillingAddr(McaStudent s) throws Exception  {
        return McaService.formatAddr(s.getBillCountryID(), s.getBillCountyID(), s.getBillCityID(), s.getBillDistrictID(), 
            s.getBillChineseStreetAddress(), s.getBillPostalCode());
    }

    int getCampusProgId(Bunit bu)
    {
        if (bu.getLabel().equals("Taichung"))
            return McaService.PROG_TUITION_TAICHUNG;
        else if (bu.getLabel().equals("Bethany"))
            return McaService.PROG_TUITION_BETHANY;
        else if (bu.getLabel().equals("Kaohsiung"))
            return McaService.PROG_TUITION_KAOHSIUNG;
        else if (bu.getLabel().equals("Chiayi"))
            return McaService.PROG_TUITION_CHIAYI;
        return 0;
    }

    String drawNav(int from, int len, int total, int feeId)
    {
        int pages = (total/len) + (((total%len)==0)?0:1);
        if (pages<2)
            return "";
        StringBuffer sb = new StringBuffer();
        int cur = from/len;
        for (int i=0; i<pages; i++) {
            if (sb.length()>0) sb.append(" | ");
            if (i!=cur)
                sb.append("<a href=\"mca_student_list.jsp?s=" + (i*len) + "&l=" + len + "&fid=" + feeId + "\">" + (i+1) + "</a>");
            else
                sb.append((i+1));
        }
        sb.append("　　　　<a href=\"mca_student_list.jsp?s=0&l=100000&fid=" + feeId + "\">全部</a>");
        return "頁 " + sb.toString();
    }
%>
<%
    // #### 這一段找出該 bunit 該 fee 的 campus tag
    int feeId = Integer.parseInt(request.getParameter("fid"));
    McaFee fee = McaFeeMgr.getInstance().find("id=" + feeId);
    McaTagHelper th = new McaTagHelper(0);
    ArrayList<Tag> feetags = th.getFeeTags(fee);
    Map<String, Tag> tagprogbunitMap = new SortingMap(feetags).doSortSingleton("getBunitProgKey");
    int campus_progId = getCampusProgId(_ws2.getSessionBunit());
    Tag tag = tagprogbunitMap.get(_ws2.getSessionBunitId()+"#"+campus_progId);
    ArrayList<TagMembr> tms = TagMembrMgr.getInstance().retrieveList("tagId=" + tag.getId(), "");
    // #############################################

    String membrIds = new RangeMaker().makeRange(tms, "getMembrId");
    ArrayList<McaStudent> mcastudents = McaStudentMgr.getInstance().
        retrieveList("membrId in (" + membrIds + ")", "order by StudentSurname asc");

    int from = 0;
    try { from = Integer.parseInt(request.getParameter("s")); } catch (Exception e) {}
    int len = 50;
    try { len = Integer.parseInt(request.getParameter("l")); } catch (Exception e) {}

%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function do_change()
{
    var url = "mca_update_student.jsp?id="+this.id.substring(1) + "&n=" + encodeURI(this.name) + 
        "&v=" + encodeURI(this.value) + "&r="+(new Date()).getTime();
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
                    openwindow_inline("<div><br><br><center>saved..</center></div>", "Saved", 10, 10, "statuswin");
                    setTimeout("clear_status()", 500);
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

function update_addr(type, msId, new_addr)
{
    if (type==1) {
        d = document.getElementById("addr_" + msId);
        d.innerHTML = '<a href="javascript:edit_addr('+msId+',1)">' + new_addr + '</a>';
    }
    else if (type==2) {
        d = document.getElementById("billing_" + msId);
        d.innerHTML = '<a href="javascript:edit_addr('+msId+',2)">' + new_addr + '</a>';
    } 
    else { // type==3 ditto
        d = document.getElementById("billing_" + msId);
        d.innerHTML = '<a href="javascript:edit_addr('+msId+',2)"><img src="images/lockyes.gif" width=15 height=15 border=0></a>';
    }

}

var __lasthilight = null;
function hilight(msId, type)
{
    if (__lasthilight!=null)
        __lasthilight.style.border = "";
    if (type==1) {
        d = document.getElementById("addr_" + msId);
        d.style.border = "solid red 2px";
        __lasthilight = d;
    }
    else {
        d = document.getElementById("billing_" + msId);
        d.style.border = "solid red 2px";
        __lasthilight = d;
    }
}
function clearhilight()
{
    if (__lasthilight!=null)
        __lasthilight.style.border = "";
    __lasthilight = null;
}

function edit_addr(msId, type)
{
    var title = 'updating ' + ((type==1)?"home":"billing") + " address";
    hilight(msId, type);
    openwindow_phm2("mca_update_addr.jsp?mid=" + msId + "&type=" + type, title, 500, 400, 'addrwin');
}

function clear_status()
{
    statuswin.hide();
}

function init()
{
    var elements = document.f1.elements;
    for (var i=0; i<elements.length; i++) {
        if (elements[i].id==null || elements[i].id.charAt(0)!='s')
            continue;
        elements[i].onchange = do_change;
    }
}

</script>

<body onload="init()">
<form name="f1">
<div style="position:absolute;left:10px">
<%= drawNav(from, len, mcastudents.size(), feeId) %>
<table height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    No.
                </td>
                <td>
                    Firstname
                </td>
                <td>
                    Lastname
                </td>
                <td>
                    Coop#
                </td>
                <td>
                    TDisc
                </td>
                <td nowrap>
                    F. Firstname
                </td>
                <td nowrap>
                    F. Lastname
                </td>
                <td nowrap>
                    M. Firstname
                </td>
                <td nowrap>
                    M. Lastname
                </td>
                <td nowrap>
                    Home Address
                </td>
                <td nowrap>
                    Billing Address
                </td>
                <td>
                </td>
            </tr>
<%
    for (int i=from; i<mcastudents.size() && i<(from+len); i++) {
        McaStudent s = mcastudents.get(i);
        String addr = formatAddr(s);
        String billing = formatBillingAddr(s);
%>      
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    <a href="javascript:openwindow_phm2('modify_mca_student.jsp?studentId=<%=s.getStudId()%>','基本資料',700,700, 'mcastudentwin');"><%=(i+1)%></a>
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="StudentFirstName" size=7 value="<%=formatName(s.getStudentFirstName())%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="StudentSurname" size=7 value="<%=formatName(s.getStudentSurname())%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="CoopID" size=7 value="<%=s.getCoopID()%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="TDisc" size=7 value="<%=s.getTDisc()%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="FatherFirstName" size=7 value="<%=formatName(s.getFatherFirstName())%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="FatherSurname" size=7 value="<%=formatName(s.getFatherSurname())%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="MotherFirstName" size=7 value="<%=formatName(s.getMotherFirstName())%>">
                </td>
                <td>
                    <input type=text id="s<%=s.getId()%>" name="MotherSurname" size=7 value="<%=formatName(s.getMotherSurname())%>">
                </td>
                <td id="addr_<%=s.getId()%>">
                    <a href="javascript:edit_addr(<%=s.getId()%>,1)"><%=(addr.trim().length()>0)?addr:"<img src='images/lockyes.gif' width=15 height=15 border=0>"%></a>
                </td>
                <td id="billing_<%=s.getId()%>">
                    <a href="javascript:edit_addr(<%=s.getId()%>,2)"><%=(billing.trim().length()>0)?billing:"<img src='images/lockyes.gif' width=15 height=15 border=0>[same]"%></a>
                </td>
                <td>
                </td>
            </tr>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>
<%= drawNav(from, len, mcastudents.size(), feeId) %>
</div>
</form>

