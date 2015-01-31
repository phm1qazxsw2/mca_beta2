<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,303))
    {
        response.sendRedirect("authIndex.jsp?code=303");
    }
%>
<%@ include file="leftMenu5.jsp"%>
<%
    // 1. 那所有的帳單記錄出來
    BillRecordInfoMgr bmgr = BillRecordInfoMgr.getInstance();
    ArrayList<BillRecordInfo> allrecords = bmgr.retrieveListX("billType="+Bill.TYPE_SALARY + 
        " and privLevel>=" + ud2.getUserRole(), "order by month desc", _ws.getBunitSpace("bill.bunitId"));
    
    // 2. 按月份來排
    Map<Date, Vector<BillRecordInfo>> monthMap = new SortingMap(allrecords).doSort("getMonth");

    Set<Date> keys = monthMap.keySet();
    Iterator<Date> monthiter = keys.iterator(); // this has months that has billrecords

    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");

    String monstr = request.getParameter("month");
    if (monstr==null)
        monstr = "";
%>
<br>
<form action="salaryrecord_chart.jsp">
    <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/re1.png" border=0>&nbsp;<b>薪資報表中心</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  查詢月份
    <select name="month" onchange="this.form.submit()">
    <option value="">--- 請選擇查詢月份 ---
    <%
        while (monthiter.hasNext()) {
            Date d = monthiter.next();
            out.println("<option value='"+sdf2.format(d)+"' "+((monstr.equals(sdf2.format(d)))?"selected":"")+">" + sdf1.format(d) + "</option>");
        }
    %>
    </select>
</form>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<%
    if (monstr.length()==0) {
        return;
    }

    ArrayList<BillRecordInfo> targetRecords = bmgr.retrieveListX("month='" + monstr + 
        "' and billType="+Bill.TYPE_SALARY + " and privLevel>=" + ud2.getUserRole(), "", _ws.getBunitSpace("bunitId"));
     
    EzCountingService ezsvc = EzCountingService.getInstance();

    // all members that has 帳單 in this records
    ArrayList<Membr> membrs = new ArrayList<Membr>();

    // membrId
    Map<Integer, Vector<MembrInfoBillRecord>> billMap = 
            new LinkedHashMap<Integer, Vector<MembrInfoBillRecord>>();
    // ticketId
    Map<String, Vector<ChargeItemMembr>> feeMap =
            new LinkedHashMap<String, Vector<ChargeItemMembr>>();
    // chargeItemId
    Map<String, Vector<DiscountInfo>> discountMap = 
            new LinkedHashMap<String, Vector<DiscountInfo>>();

    ezsvc.getNumbers(targetRecords, membrs, billMap, feeMap, discountMap);

    // 會計科目的東東
    Object[] objs = IncomeSmallItemMgr.getInstance().retrieve("","");
    Map<Integer, IncomeSmallItem> smallitemMap = new HashMap<Integer, IncomeSmallItem>();
    for (int i=0; objs!=null && i<objs.length; i++)
        smallitemMap.put(new Integer(((IncomeSmallItem)objs[i]).getId()), (IncomeSmallItem)objs[i]);

    int type=-1;
    String typeS=request.getParameter("type");
    if(typeS != null)
        type=Integer.parseInt(typeS);
    Date nowDate=sdf2.parse(monstr);
    String nowMonth=sdf1.format(nowDate);

%>

<center>
<table cellpadding=0 cellspacing=0 border=0 width=788 height=700>
<tr>
    <td width=100 valign=top>
    <br><br>
    <!-- list of transactions -->
    <table border=0 cellpadding=0 cellspacing=0 width=100%>
    <tr>
        <%  if(type==-1){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==-1)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="salaryrecord_chart.jsp?month=<%=monstr%>&type=-1">                
                <font color="<%=(type==-1)?"#ffffff":"5F5F5F"%>"><%=nowMonth%>總覽</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==0){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==0)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="salaryrecord_chart.jsp?month=<%=monstr%>&type=0">                
                <font color="<%=(type==0)?"#ffffff":"5F5F5F"%>">薪資明細</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==1){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==1)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="salaryrecord_chart.jsp?month=<%=monstr%>&type=1">                
                <font color="<%=(type==1)?"#ffffff":"5F5F5F"%>">薪資項目統計</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==4){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==4)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="salaryrecord_chart.jsp?month=<%=monstr%>&type=4">                
                <font color="<%=(type==4)?"#ffffff":"5F5F5F"%>">付款統計</font></a>
        </td>
    </tr>
    </table>

    </td>
    <td valign=top>
        <table border=0 cellpadding=0 cellspacing=0 width=100% height=9>
        <tr width=100%>
            <td background="img/a3_11.gif" width=9 height=9></td>
            <td bgcolor="#6B696B"><img src="img/aspace.gif" border=0></td>
            <tD width=9 height=9 background="img/a3_12.gif"></td>
        </tr>
        <tr bgcolor="#6B696B">
            <td></td>
            <td>
            <table border=0 CELLSPACING=0 CELLPADDING=0 width=100%>
            <tr>
                <td valign=middle>
                  
                    <div class=es02>
                      
                        <font color=ffffff>&nbsp;&nbsp;&nbsp;查詢月份:<%=nowMonth%>&nbsp;&nbsp;&nbsp;&nbsp;                        </font>
                        <%  

                        switch(type){   
                                case 0:
                        %>
                        <font color=ffffff>薪資明細</font>               
                    </div>
                        <br>
                        <input type="button" value="&nbsp;友善列印本頁&nbsp;" onClick="javascript:window.print();">
                        <input type="button" value="下載 Excel 報表" onClick="window.location='salary_excel_billrecord.jsp?month=<%=monstr%>'">
                        

                        <%          break;
                                case -1:
                        %>
                        <font color=ffffff>薪資總覽</font>               
                    </div>
                        <br>
                        <input type="button" value="友善列印本頁" onClick="javascript:window.print();">
                                

                        <%          
                                    break;
                                case 4:
                        %>
                        <font color=ffffff>付款統計</font>               
                        </div>
                        <%
                                    break;
        
                                }   
                        %>
                    <br><br>
                </td>
            </tr>
            <tr bgcolor=ffffff width=100% height=600>
            <td width=100% valign=top>
            
                <br>
            <%
                DecimalFormat nf = new DecimalFormat("###,##0.00");
                DecimalFormat mnf = new DecimalFormat("###,###,##0");
                DecimalFormat mnf2 = new DecimalFormat("########0");            
                Iterator<Membr> miter = membrs.iterator();
                switch(type){
                    case -1:
            %>
                    <%@ include file="chart_report_salary00.jsp"%>
            <%          break;
                    case 0:
            %>
                    <%@ include file="chart_report0_salary.jsp"%>
            <%
                        break;
                    case 1:
            %>
                    <%@ include file="chart_report1_salary.jsp"%>
            <%
                        break;         
                    case 2:
            %>
                    <%@ include file="chart_report2.jsp"%>
            <%
                        break;         
                    case 3:
            %>
                    <%@ include file="chart_report3.jsp"%>
            <%
                        break;         
                    case 4:
            %>
                    <%@ include file="chart_report4_salary.jsp"%>
            <%
                    break;         


                }
            %>
            </td>
            </tr>
            </table>                       

            </td>
            <td></td>
        </tr>
        <tr width=100%>
            <td background="img/a3_21.gif" width=9 height=9></td>
            <td bgcolor="#6B696B"><img src="img/aspace.gif" border=0></td>
            <tD width=9 height=9 background="img/a3_22.gif"></td>
        </tr>
        </table>
            
            
    </td>
    </tr>
    </table>
    <br>
    <br>
<%@ include file="bottom.jsp"%>