<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=2;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    // 1. 那所有的帳單記錄出來
    BillRecordInfoMgr bmgr = BillRecordInfoMgr.getInstance();
    ArrayList<BillRecordInfo> allrecords = bmgr.retrieveListX("billType="+Bill.TYPE_BILLING, 
        "order by month desc", _ws.getBunitSpace("bill.bunitId"));
    
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
<form action="billrecord_chart.jsp">
    <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/re1.png" border=0>&nbsp;<b>收費報表中心</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  查詢月份
    <select name="month" onchange="this.form.submit()">
    <option value="">--- 請選擇查詢月份 ---
    <%
        boolean bnow=false;
        if (monstr.length()>0) {
            bnow=true;
        }
        while (monthiter.hasNext()) {
            Date d = monthiter.next();
            if(!bnow)
            {
                monstr=sdf2.format(d);
                bnow=true;
            }
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
%>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

    ArrayList<BillRecordInfo> targetRecords = 
        bmgr.retrieveListX("month='" + monstr + "' and billType="+Bill.TYPE_BILLING, "", _ws.getBunitSpace("bill.bunitId"));
     
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

    int ordr = -1;
    String ordrS=request.getParameter("ordr");
    
    if(ordrS !=null){
        try { ordr = Integer.parseInt(ordrS); } catch (Exception e) {}
    }else{
        TagTypeMgr ttmgr = TagTypeMgr.getInstance();
        Object[] objs2 = ttmgr.retrieveX("main='1'", "",_ws.getBunitSpace("bunitId"));
        if(objs2!=null){
            TagType tpa = (TagType) objs2[0];
            ordr=tpa.getId();
        }
    }
    Iterator<TagType> titer = TagTypeMgr.getInstance().retrieveListX("","",_ws.getBunitSpace("bunitId")).iterator();
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
            <a href="billrecord_chart.jsp?month=<%=monstr%>&type=-1">                
                <font color="<%=(type==-1)?"#ffffff":"5F5F5F"%>"><%=nowMonth%> 總覽</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==0){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==0)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="billrecord_chart.jsp?month=<%=monstr%>&type=0">                
                <font color="<%=(type==0)?"#ffffff":"5F5F5F"%>">帳單明細</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==2){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==2)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="billrecord_chart.jsp?month=<%=monstr%>&type=2">                
                <font color="<%=(type==2)?"#ffffff":"5F5F5F"%>">會計科目統計</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==1){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==1)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="billrecord_chart.jsp?month=<%=monstr%>&type=1">                
                <font color="<%=(type==1)?"#ffffff":"5F5F5F"%>">收費項目統計</font></a>
        </td>
    </tr>

    <tr>
        <%  if(type==3){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==3)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="billrecord_chart.jsp?month=<%=monstr%>&type=3">                
                <font color="<%=(type==3)?"#ffffff":"5F5F5F"%>">折扣項目統計</font></a>
        </td>
    </tr>
    <tr>
        <%  if(type==4){    %>
                <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
        <%  }else{  %>
                <td width=8 align=top height=25></td>
        <%  }   %>        
        <td bgcolor="<%=(type==4)?"#6B696B":""%>" colspan=2 align=left class=es02>
            <a href="billrecord_chart.jsp?month=<%=monstr%>&type=4">                
                <font color="<%=(type==4)?"#ffffff":"5F5F5F"%>">繳費統計</font></a>
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
                        <%  

                        switch(type){   
                                case 0:
                        %>
                        <table border=0>
                        <tr>
                            <td class=es02>
                             <font color=ffffff>&nbsp;&nbsp;&nbsp;查詢月份:<%=nowMonth%>&nbsp;                               <b>帳單明細</b></font>                               
                        </td>
                        <td>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=white>排序方式</font></td>
                        </td>
                        <td>                                            
                            <select name="ordr" onChange="window.location='billrecord_chart.jsp?month=<%=monstr%>&type=0&ordr='+this.value">
                                <option value=-1>無</option>
                            <%  while (titer.hasNext()) { 
                                    TagType tp = titer.next(); %>
                                <option value=<%=tp.getId()%> <%=(tp.getId()==ordr)?"selected":""%>><%=tp.getName()%></option>
                            <%  }  %>
                            </select>            
                        </td>
                    </tr>
                    </table>
                    </div>
                        <br>
                        <input type="button" value="列印本頁&nbsp" onClick="javascript:window.print();">
                        <input type="button" value="下載 excel 報表" onClick="window.location='searchbillrecord.jsp?month=<%=nowMonth%>&tag=-1&pstat=-1'">
                       
                        <%          break;
                                case -1:
                        %>
                             <font color=ffffff>&nbsp;&nbsp;&nbsp;查詢月份:<%=nowMonth%>&nbsp;                               
                        <font color=ffffff>總覽</font>               
                    </div>
                        <br>
                        <input type="button" value="列印<%=nowMonth%>總覽" onClick="javascript:window.print();">
                                

                        <%          
                                    break;
                                default:
                        %>
                                                             <font color=ffffff>&nbsp;&nbsp;&nbsp;查詢月份:<%=nowMonth%>&nbsp;      
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
                    <%@ include file="chart_report00.jsp"%>
            <%          break;
                    case 0:
            %>
                    <%@ include file="chart_report0.jsp"%>
            <%
                        break;
                    case 1:
            %>
                    <%@ include file="chart_report1.jsp"%>
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
                    <%@ include file="chart_report4.jsp"%>
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