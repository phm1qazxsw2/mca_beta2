<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
    }
%>
<%@ include file="leftMenu5.jsp"%>
<%
    //##v2

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int recordId = Integer.parseInt(request.getParameter("recordId"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillRecordInfo record = BillRecordInfoMgr.getInstance().findX(
        "billrecord.id="+recordId, _ws.getBunitSpace("bunitId"));

    if (record==null) {
        %><script>alert("資料不存在,可能已經被刪除了");history.go(-1)</script><%
        return;
    }

    Bill b = BillMgr.getInstance().find("id="+record.getBillId());
    ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("billId=" + b.getId(),"");
    Iterator<BillItem> iter = bitems.iterator();
    String backurl = "salaryrecord_edit.jsp?" + request.getQueryString();
        
    Map m = new HashMap();
    for (int i=0; iter.hasNext(); i++) {
        BillItem bi = iter.next();
        m.put(new Integer(bi.getId()), bi);
    }
    ArrayList<ChargeItem> citems = 
        ChargeItemMgr.getInstance().retrieveList("billRecordId=" + record.getId(), "");

    MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
    Object[] objs = sbrmgr.retrieve("billrecordId=" + record.getId(), "");
    int receivableNum = 0;
    int receivable = (int)0;
    int receivedNum = 0;
    int received = (int)0;
    if (objs!=null) {
        for (int j=0; j<objs.length; j++) {
            MembrBillRecord sbr = (MembrBillRecord) objs[j];
            receivableNum ++;
            receivable += sbr.getReceivable();
            if (sbr.getReceived()>=sbr.getReceivable()) {
                receivedNum ++;
                received += sbr.getReceived();
            }
        }
    }
%>
<br>
<div class=es02>
<img src="pic/fix.gif" border=0>&nbsp; 
<b><%=record.getName()%></b> - 整批編輯薪資
&nbsp;&nbsp;&nbsp;&nbsp;<a href="salaryoverview.jsp"><img src="pic/last2.png" border=0 width=12>&nbsp;回薪資總覽</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td align=middle valign=top width=150 class=es02>
        <br>
            
        <img src="pic/sbill3.gif" border=0>
        <br>
        <br>
        <div align=left>
        合計開單: <%=receivableNum%>     &nbsp;筆 <br>
        合計應付: <%=mnf.format(receivable)%> 元
        </div>
        <br>
        <input type=button value="已開薪資列表" onClick="javascript:window.location='searchsalaryrecord.jsp?brId=<%=recordId%>'">
    </td>
    <td width=600 valign=top class=es02>

        <b>薪資項目列表</b>
        <a href="javascript:openwindow_phm('salarybillitem_add.jsp?billId=<%=record.getBillId()%>','新增薪資項目',560,350,true);">
        <img src="pic/add.gif" border=0>&nbsp;新增薪資項目</a> | <a href="salaryrecord_frame.jsp?recordId=<%=recordId%>" target="_blank"><img src="pic/littleE.png" border=0>&nbsp;快速編輯</a>


        <br><br>

        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
                <td nowrap width=35%>薪資項目</td>
                <td nowrap width=1%>延續</td>
                <td nowrap width=25%>應付金額小計</td>
                <td nowrap width=25% align=center>薪資名單</td>
                <td nowrap width=15%></td>
            </tr>
        <%
            ChargeMgr cmgr = ChargeMgr.getInstance();
        
            Map<Integer, Vector<ChargeItem>> chiMap = new SortingMap(citems).doSort("getSmallItemId");
            Set chikey = chiMap.keySet();
            Iterator<Integer> chiiter = chikey.iterator();
            while (chiiter.hasNext()) {
                Integer ciId = chiiter.next();
                Vector<ChargeItem> chv = chiMap.get(ciId);
        %>
            <tr>
                <td colspan=5 class=es02 bgcolor=4A7DBD>
                    <font color=white><b>
                    <%
                        switch(ciId){
                            case 1:
                                out.println("+ 應付薪資");                            
                                break;
                            case 2:
                                out.println("- 代扣薪資");
                                break;
                            case 3:
                                out.println("- 應扣薪資");
                                break;        
                        }
                    %>
                    </b></font>
                </td>
            </tr>
        <%
                for(int k=0;chv !=null &&k<chv.size();k++)
                {
                    ChargeItem ci =(ChargeItem)chv.get(k);
                    int num = cmgr.numOfRows("chargeItemId=" + ci.getId());
                    if (num==0)
                        continue;
System.out.println("## ci=" + ci.getId() + " billitem id=" + ci.getBillItemId());
                    BillItem bi = (BillItem) m.remove(new Integer(ci.getBillItemId()));
                    if (bi==null) {
                        System.out.println("## chargeItemId=" + ci.getId());
                        //throw new Exception("BillItem is not supposed to be null");
                        continue;
                    }
                    int sub_total = ezsvc.calcAmountForChargeItem(ci);                 
        %>
            <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'">
                <td class=es02>
                    <table width=100% cellpadding="0" cellspacing="0">
                    <tr class=es02>
                        <td nowrap>
                            <img src="img/flag2.png" border=0>&nbsp;<%=bi.getName()%> 
                        </td>
                        <td width=40 nowrap>
                        (<a href="javascript:openwindow_phm('salarybillitem_edit.jsp?bid=<%=bi.getId()%>','編輯薪資項目',560,350,true);">修改</a>)
                        </td>
                    </tr>
                    </table>                  
                </td>
                <td align=center class=es02><%=bi.getCopyStatus()==BillItem.COPY_YES?"是":"否"%></td>
                <td class=es02 nowrap align=right> <%=(sub_total<0)?"("+Math.abs(sub_total)+")":mnf.format(sub_total)%> 元</td>
                <td class=es02 align=right>
                    <%=num%>筆
                    &nbsp;<img src="pic/fix.gif" border=0 width=12><a href="salarychargeitem_edit.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=<%=ci.getId()%>">編輯</a>
                </td>
                <td align=middle class=es02>

                </td>
            </tr>
        <%
                }
            }

            iter = bitems.iterator();
            while (iter.hasNext())
            {
                BillItem bi = iter.next();
                if (bi.getStatus()!=BillItem.STATUS_ACTIVE)
                    continue;
                if (m.get(new Integer(bi.getId()))!=null) {
                %>
            <tr bgcolor=#f0f0f0 class=es02 valign=center height=30>
                <td colspan=3>
                    <b>
                    <%
                    if (bi.getSmallItemId()==1) out.println("+ 應付薪資");
                    else if (bi.getSmallItemId()==2) out.println("- 代扣薪資");
                    else if (bi.getSmallItemId()==3) out.println("- 應扣薪資");
                    %>
                    </b>
                    <%=bi.getName()%>
                    (<a href="javascript:openwindow_phm('salarybillitem_edit.jsp?bid=<%=bi.getId()%>','編輯薪資項目',560,350,true);">修改</a>)

                </td>
                <td class=es02 align=right> 
                    &nbsp;<img src="pic/fix.gif" border=0 width=12>
                    <a href="salarychargeitem_edit.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=-1">編輯</a>
                </td>
                <td align=center><a href="billitem_remove.jsp?bid=<%=bi.getId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>" onclick="if (confirm('刪除不會影響以前開過的單子，確定刪除？')) return true; else return false;">刪除</a>&nbsp;&nbsp;
                </td>
            </tr>
        <%  
                }
            }
        %>
        </table>
        </td></tr></table>
    </td>
    </tr>
    </table>

    <br>
    <br>
    </td>
    </tr>
    </table>
    </center>



<!--- end 主內容 --->
<%@ include file="bottom.jsp"%>	