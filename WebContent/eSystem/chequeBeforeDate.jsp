<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    
    SimpleDateFormat sdfcheque = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnfcheque = new DecimalFormat("###,###,##0");
    int totalchque = (int)0;

    ArrayList<Cheque> cheques = ChequeMgr.getInstance().retrieveListX("recordTime >'" + 
        sdf.format(beforeDate)+"'", "order by cashDate asc", _ws.getBunitSpace("bunitId"));
    Map<Integer/*type*/, Vector<Cheque>> chequeMap = new SortingMap(cheques).doSort("getType");

    //##1
    Map<Integer/*chequeId*/, Vector<BillPaidInfo>> paidMap = null;
    if (cheques.size()>0) {
        String chequeIds = new RangeMaker().makeRange(cheques, "getId");
        ArrayList<BillPaidInfo> paids = BillPaidInfoMgr.getInstance().
            retrieveList("billpay.chequeId in (" + chequeIds + ")", "");
        paidMap = new SortingMap(paids).doSort("getChequeId");
    }
    //###

    Vector<Cheque> checks = chequeMap.get(new Integer(Cheque.TYPE_INCOME_TUITION));

    long nowtime=new Date().getTime();
    int runCheck=0;
    boolean haveshow=false;
    for (int i=0; checks!=null && i<checks.size(); i++) {
        Cheque ch = checks.get(i);
        long casttime=ch.getCashDate().getTime();  

            runCheck++;
            if(!haveshow){   
%>
                <div class=es02>
                <b><img src="pic/cheque.png" border=0 width=16>&nbsp;支票管理</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('chequeDiv');return false"><%=checks.size()%> 筆</a>
</div>
                <div id=chequeDiv style="display:none" class=es02>
                <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                         <td align=middle width=100>兌現日期</td>
                         <td>ID</td>
                         <td align=middle>支票號碼</td>
                         <td align=middle>支票內容</td>
                         <td align=middle>金額</td>
                         <td></td>
                      </tr>
<%          
            haveshow=true;
            }   %>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02>
            <%
                if(casttime<nowtime){
            %> 
                <img src="pic/star2.png" border=0>
            <%  }else{  %>
                &nbsp;&nbsp;&nbsp;
            <%  }   %>  
                  <%=sdfcheque.format(ch.getCashDate())%>
            </td>
            <td class=es02><%=ch.getId()%></td>
            <td class=es02><%=ch.getChequeId()%></td>
            <td class=es02><%=getDescription(ch, paidMap)%></td>
            

            <td class=es02 align=right bgcolor=<%=(ch.getCashed()==null)?"#4A7DBD":"#F77510"%>>
                <font color=#ffffff><%=mnf.format(ch.getInAmount())%></font></td>

            <td class=es02 align=middle>
                <%
                if(ch.getCashed()==null){
                %>
                <a href="javascript:openwindow_phm('cheque_realize.jsp?id=<%=ch.getId()%>','支票兌現',500,400,true)">兌現</a>
                <%  }else{  %>
                
                已兌現
                <%  }   %>
            </td>
        </tr>
<%
    }

    if(haveshow){
%>
        </table>
        </td>
        </tr>
        </table>
        </div>
        <br>
<%  }   %>

<%!
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM");
    String getDescription(Cheque ch, Map<Integer, Vector<BillPaidInfo>> paidMap)
    {
        String desc = ch.getTitle();
        if (desc==null)
            desc = "";
        Vector<BillPaidInfo> pv = paidMap.get(new Integer(ch.getId()));
        if (pv!=null) {
            for (int i=0; i<pv.size(); i++) {
                BillPaidInfo bp = pv.get(i);
                if (desc.length()>0) desc += "<br>";
                if (bp.getBillMonth()!=null)
                    desc += "　　銷 " + sdf2.format(bp.getBillMonth()) + "月 " + bp.getBillPrettyName() + bp.getPaidAmount();
            }
        }
        return desc;
    }

%>



