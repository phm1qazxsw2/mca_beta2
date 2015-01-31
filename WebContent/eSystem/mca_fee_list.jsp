<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    ArrayList<McaFee> fees = McaFeeMgr.getInstance().retrieveList("status=" + McaFee.STATUS_ACTIVE,"");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    Map<Integer, ArrayList<McaRecordInfo>> feerecordMap = new SortingMap(McaRecordInfoMgr.getInstance().
        retrieveList("status!=-1", "order by mca_fee.id asc")).doSortA("getMcaFeeId");
    ArrayList<McaProrate> prorates = McaProrateMgr.getInstance().retrieveListX("", "", _ws.getBunitSpace("bunitId"));
    Map<Integer, ArrayList<McaProrate>> prorateMap = new SortingMap(prorates).doSortA("getMcaFeeId");
%>
<script>
function do_printform(feeId)
{
    openwindow_phm2('mca_print_regform.jsp?id='+feeId, 'Print Registration Form', 200, 200, 'printwin');
}

function create_fee()
{
    // openwindow_phm2('mca_fee_create.jsp', '產生新的收費', 400, 300, 'feewin');
    location.href = "mca_fee_copy.jsp";
}
</script>
<br>
 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;Fee Schedules</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>

<table width="500" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0 align=center>
                <td>No.</td>
                <td>Month</td>
                <td>Title</td>
                <td nowrap>Pro-rate</td>
                <td></td>
                <td></td>
            </tr>
<%
    for (int i=0; i<fees.size(); i++) {
        McaFee fee = fees.get(i);
        ArrayList<McaRecordInfo> records = feerecordMap.get(fee.getId());
        int total = 0;
        if (records!=null && records.size()>0) {
            String billRecordIds = new RangeMaker().makeRange(records, "getBillRecordId");
            total = MembrInfoBillRecordMgr.getInstance().numOfRowsX("billRecordId in (" + billRecordIds + ")", 
                _ws.getBunitSpace("bill.bunitId"));
        }
%>    
            <tr class=es02 bgcolor=white align=center>
                <td>
                   <%=(i+1)%>
                </td>
                <td nowrap>
                   &nbsp;&nbsp;<%=(fee.getMonth()!=null)?sdf.format(fee.getMonth()):""%>&nbsp;&nbsp;
                </td>
                <td align=left nowrap>
                   &nbsp;&nbsp;
                   <% if (total>0) { %>
                        <a href="mca_billsoverview.jsp?id=<%=fee.getId()%>"><%=fee.getTitle()%> (<%=total%> bills)</a>
 
                   <% if (fee.getFeeType()==McaFee.REGISTRATION_ONLY) { %>
                        (<a href="javascript:do_printform(<%=fee.getId()%>)">Reg.forms</a>)&nbsp;
                    <% } %>

                   <% } else { %>
                        <%=fee.getTitle()%>
                   <% } %>
                   &nbsp;&nbsp;
                </td>
                <td nowrap>
                <%
                    ArrayList<McaProrate> pr = prorateMap.get(fee.getId());
                    if (pr!=null && pr.size()>0) {
                        out.println("&nbsp;&nbsp;<a href=\"javascript:openwindow_phm2('mca_show_prorate.jsp?feeId="+fee.getId()+"','Pro-rate records',500,500,'prowin');\">" + pr.size() + "</a>&nbsp;&nbsp;");
                    }
                %>
                </td>
                <td nowrap>
                    <a href="javascript:openwindow_phm2('mca_dp_list.jsp?feeId=<%=fee.getId()%>','Deferred Plan List',500,500,'dpwin')">D.Plan</a>
                </td>
                <td nowrap align=left>
<% if (ud2.getUserRole()<=3) { %>
                   &nbsp;&nbsp;<a href="mca_fee.jsp?id=<%=fee.getId()%>">Edit</a> |
                   <a href="mca_fee_copy.jsp?id=<%=fee.getId()%>">Copy</a> |
                   <a href="javascript:openwindow_phm2('mca_fee_dodelete.jsp?id=<%=fee.getId()%>','delete fee',200,200,'feewin')">Delete</a>&nbsp;
<% } else { %>
                   &nbsp;&nbsp;<a href="mca_fee.jsp?id=<%=fee.getId()%>">Detail</a> &nbsp;
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
<br>
<% if (ud2.getUserRole()<=3) { %>
<div class=es02><a href="javascript:create_fee()">Create New Fee Schedule</a></div>
<% } %>
</blockquote>

<%@ include file="bottom.jsp"%>	
