<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int feeId = Integer.parseInt(request.getParameter("feeId"));
    ArrayList<McaProrate> mps = McaProrateMgr.getInstance().retrieveListX("mcaFeeId=" + feeId, "order by id desc", 
    _ws2.getBunitSpace("bunitId"));    
    String membrIds = new RangeMaker().makeRange(mps, "getMembrId");
    Map<Integer, McaStudent> msMap = new SortingMap(McaStudentMgr.getInstance().retrieveList(
        "membrId in (" + membrIds + ")","")).doSortSingleton("getMembrId");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    // get billrecord Id for bill link
    ArrayList<McaRecordInfo> mrs = McaRecordInfoMgr.getInstance().retrieveList("mcaFeeId=" + feeId + 
        " and mca_fee.status!=-1", "");
    String billRecordIds = new RangeMaker().makeRange(mrs, "getBillRecordId");
    BillRecordInfo br = BillRecordInfoMgr.getInstance().findX("billrecord.id in (" + billRecordIds + ")",
        _ws2.getBunitSpace("bill.bunitId"));
    // #############
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function clear_status()
{
    statuswin.hide();
}

function do_save(f)
{
    var mpId = f.mpId.value;
    var date = f.prorateDate.value;
    var url = "mca_update_prorate.jsp?id=" + mpId + "&d=" + encodeURI(date) + "&r="+(new Date()).getTime();
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
</script>
<center>
<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td width=30%>
                    Name
                </td>
                <td width=50%>
                    Pro-rate date
                </td>
                <td width=20%>
                </td>
            </tr>
<%
    for (int i=0; i<mps.size(); i++) {
        McaProrate mp = mps.get(i);
        McaStudent ms = msMap.get(mp.getMembrId());  
%>
            <form>
            <input type=hidden name="mpId" value="<%=mp.getId()%>">
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    <%=ms.getFullName()%>
                    <a target=_blank href="bill_detail.jsp?sid=<%=ms.getMembrId()%>&rid=<%=br.getId()%>&poId=-1&backurl=mca_fee_list.jsp"><img src="img/billlink.png" height=14 border=0></a>&nbsp;&nbsp;
                </td>
                <td nowrap>
                    <input type=text size=8 name="prorateDate" value="<%=sdf.format(mp.getProrateDate())%>">
                </td>
                <td nowrap>
                    <input type=button value="Save" onclick="do_save(this.form)">
                </td>
            </tr>
            </form>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>
</center>        
</blockquote>

