<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,200))
    {
        response.sendRedirect("authIndex.jsp?code=200");
    }
%>
<%@ include file="leftMenu2-new.jsp"%>
<%

    String para=request.getParameter("backurl");
    if(para ==null)
        para="spending_list.jsp";

    Voucher vchr = null;
    Vitem vitem = null;
    ArrayList<Vitem> vitems = null;
    String idstr = null;
    String ticketId="";

    boolean isV=false;
    try { 
        idstr = request.getParameter("id");
        if (idstr.charAt(0)=='V') {
            vchr = VoucherMgr.getInstance().find("id=" + idstr.substring(1)); 
            ticketId="傳票</b> &nbsp;&nbsp;傳票號碼:<b>"+vchr.getCostbookId()+"</b>";
            vitems = VitemMgr.getInstance().retrieveListX("voucherId=" + vchr.getId(), "", _ws.getBunitSpace("bunitId"));
            isV=true;
            if (vitems.size()==0) {
              %><script>alert("此傳票已沒有項目,返回前頁");location.href="<%=para%>";</script><%
                return;
            }
        }
        else {
            vitems = new ArrayList<Vitem>();
            vitem = VitemMgr.getInstance().findX("id=" + idstr.substring(1), _ws.getBunitSpace("bunitId"));
            if (vitem==null || vitem.getTotal()==0) {
               %><script>alert("找不到資料，可能已被刪除");location.href='<%=para%>';</script><%
                return;
            }
            vitems.add(vitem);
            ticketId="項目</b> &nbsp;&nbsp;項目編號:<b>"+idstr+"</b>";
        }
    } 
    catch (Exception e) 
    {%><script>alert("參數不正確,找不到id");history.go(-1);</script><%}

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    
    EzCountingService ezsvc = EzCountingService.getInstance();
    ArrayList<Costpay2> costpays = ezsvc.getVpaidForVitems(vitems);
    StringBuffer sb = new StringBuffer();

    int type=vitems.get(0).getType();
    String title = ((type==0)?"支出":(type==1)?"收入":"進貨") + "明細-";
    if (vitems.size()>0) {
        title += vitems.get(0).getTitle();
        if (title.length()>13)
            title = title.substring(0, 13) + "..";
        title += "等" + vitems.size() + "筆";
    }
    _ws.setBookmark(ud2, title);

    
    String balckurl="spending_voucher.jsp?id="+idstr+"&backurl="+para;
%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><%=idstr%>&nbsp;合倂支出明細 :</b>
&nbsp;&nbsp;&nbsp;
<%
    String vids = new RangeMaker().makeRange(vitems, "getId");
%>
<a href="javascript:show_vitem_vouchers('<%=vids%>')"><img src="pic/costtype3.png" border=0>&nbsp;傳票內容</a>
 | <a href="<%=para%>"><img src="pic/last2.png" border=0>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<%
    CosttradeMgr cmm=CosttradeMgr.getInstance();
    JsfAdmin ja=JsfAdmin.getInstance();
    String backurl = request.getRequestURI() + "?" + request.getQueryString();
    int total = 0;
    int paid = 0;
    StringBuffer sbContent=new StringBuffer();
    Iterator<Vitem> iter = vitems.iterator();

    String bgcolornow="";
    if(type==1)
        bgcolornow="highlight";
    else
        bgcolornow="highlight2";
        
    while (iter.hasNext()) {
        Vitem vi = iter.next();
        total += vi.getTotal();
        paid += vi.getRealized();

        if (sb.length()>0) sb.append(",");
        sb.append(vi.getId());

        sbContent.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='"+bgcolornow+"'\" onmouseout=\"this.className='normal2'\" valign=middle>");

        sbContent.append("<td class=es02 valign=top>"+sdf.format(vi.getRecordTime())+"</td>");
        sbContent.append("<td class=es02 valign=top>");

        String bigCode="";
        String smallCode="";
        String code=vi.getAcctcode();
        if(code!=null && code.length() >=4)
        {
            VoucherService vsvc = new VoucherService(0, _ws.getSessionBunitId());
            Acode a = vsvc.getAcodeFromAcctcode(code);
            if (a==null) {
                sbContent.append("無此科目:<br>"+vi.getAcctcode());
            }
            else {
                AcodeInfo ai = AcodeInfo.getInstance(a);
                sbContent.append(ai.getMainSub(a,true) + "<br>" + ai.getName(a));
            }
        }else{
            sbContent.append("格式錯誤:<br>"+vi.getAcctcode());
        }

        sbContent.append("</td>");
        sbContent.append("<td class=es02 valign=top>");
        
        if(type==1)            
            sbContent.append("<font color=red> I"+vi.getId()+"</font><br>");
        else
            sbContent.append("<font color=blue> I"+vi.getId()+"</font><br>");
        sbContent.append(vi.getTitle()+"</td>");
        sbContent.append("<td align=middle  class=es02>");

        sbContent.append(ezsvc.getUserName(vi.getUserId()));

        sbContent.append("</td>");
        sbContent.append("<td align=right class=es02 valign=middle>"+mnf.format(vi.getTotal())+"</td>");
        sbContent.append("<td class=es02 align=middle valign=middle>");
        String tradeName="";
        if(vi.getCostTradeId() !=0)
        {
            Costtrade   ct=(Costtrade)cmm.find(vi.getCostTradeId()); 
            if(ct !=null){
                tradeName=ct.getCosttradeName(); 
                sbContent.append("<a href=\"#\" onClick=\"openwindow_phm('showContact.jsp?ctId="+ct.getId()+"','雜費收付款',600,460,true)\">"+tradeName+"</a>");
            }
        }
        sbContent.append("</td>");
        sbContent.append("<td class=es02 align=middle valign=middle>"+vi.getNote()+"</td>");

        
        sbContent.append("<td align=middle class=es02>");
        /*
       // if(vi.getUserId()==0 || vi.getUserId()==ud2.getId())
       // {
            if(vi.getVerifystatus()!=Vitem.VERIFY_YES){
        
            sbContent.append("<td align=middle class=es02>");
            sbContent.append("<a href=\"spending_modify.jsp?id="+vi.getId()+"&backurl="+java.net.URLEncoder.encode(balckurl)+"\">詳細<br>資料</a>");
            }else{
                sbContent.append("<td align=left class=es02 colspan=2>");
                sbContent.append("<font color=blue>O.K.</font><br>");
                sbContent.append(ezsvc.getUserName(vi.getVerifyUserId()));                    
            }
       // }else{
       //         sbContent.append("<td align=middle class=es02>");
       // }
        */
        sbContent.append("</td>");

        

        if(vi.getVerifystatus()==Vitem.VERIFY_NO){

            sbContent.append("<td class=es02 align=middle>");
            if (vchr!=null) {

                String onclickstr = 
                    " onclick=\"if (confirm('移除本項目後此合倂傳票會拆成兩個單獨項目，繼續？')) { return true; } else {return false;}\"";            
                sbContent.append("<a href=\"spending_detach.jsp?id="+vi.getId()+"&backurl="+java.net.URLEncoder.encode(backurl)+"\"");
                if (vitems.size()==2)
                    sbContent.append(onclickstr);
                sbContent.append(">移離<br>合倂</a>");
            }
        }else{
            
            if(vi.getVerifystatus()==Vitem.VERIFY_WARN)
            {
                sbContent.append("<td class=es02 align=left bgcolor=red>");
                sbContent.append("<font color=white>警示<br>");
                sbContent.append(ezsvc.getUserName(vi.getVerifyUserId())+"</font>");
            }
        }
            
        sbContent.append("</td>");
        sbContent.append("</tr>");
    }     
%>
<center>
<table class=es02 border=0 width=96%>
<tr class=es02 height=20>
        <td align=left valign=middle>
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr width=100%>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                    <td width=60%  bgcolor=#696a6e class=es02>
                        <font color=ffffff>
<%  if(isV){ %>
                        <img src="pic/<%=(type==1)?"incometype2.png":"costtype2.png"%>" border=0>
<%  }   %>
                        &nbsp;<b><%=(type==1)?"雜費收入":(type==0)?"雜費支出":"進貨成本"%><%=ticketId%>&nbsp;&nbsp;
                        </font>
                    </td>                        
                    <td width=40% align=right bgcolor=#696a6e class=es02>

                    </td>
                    <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                </tr>
            </table>
        </tD>
        </tr>
        <tr class=es02  height=10>
        <td align=left valign=middle>
        </tD>
        </tr>
        <tr>
            <td>
<center>
<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap width=80>入帳日期</td>
		<td align=middle nowrap width=80>會計科目</td>
        <td align=middle width=120>摘要</td>
        <td align=middle width=80>登入人</td>
        <td align=middle width=80 nowrap>帳面金額</td>
        <td align=middle width=80 nowrap>交易廠商</td>
        <td align=middle nowrap width=100>備註</td>
        <td align=middle width=30></td>
        <td align=middle width=30></td>
	</tr>
  
    <%=sbContent.toString()%>
	<tr class=es02>
        <td colspan=3 class=es02 align=middle>

        </td>
        <td colspan=2 align=right valign=bottom>
            帳面金額小計:&nbsp;&nbsp;&nbsp; <b><%=mnf.format(total)%></b>                
        </td>

        <%  if((total-paid)!=0){ %>
            <td bgcolor=#4A7DBD align=middle class=es02 valign=bottom colspan=2>

        <%  }else{  %>
            <td bgcolor=#F77510 align=middle class=es02 valign=bottom colspan=2>
        <%  }   %>
                <font color=#ffffff>
                <%=(type==1)?"已收小計:":"已付小計:"%>
                &nbsp;&nbsp;&nbsp;
                <font color=#ffffff>
                    <%=mnf.format(paid)%>
                </font>
        </td>
        <td colspan=4 class=es02>
                &nbsp;&nbsp;&nbsp;&nbsp;
<%
    if(checkAuth(ud2,authHa,202))
    {
%>
            <%  if((total-paid)!=0){ %>
                <%
                if(type==1){
                %>
                    <input type=button value="收款" onclick="javascript:do_pay()">
                <%  }else{  %>
                    <input type=button value="付款" onclick="javascript:do_pay()">
                <%  }   %>
            <%  }   %>
<%  }else{   %>
        權限不足,無法收付款
<%  }   %>
        </td>
    </tr>    
    </table> 

</td>
</tr>
</table>

    </td>
    </tr>
    </table>

<% if (costpays!=null && costpays.size()>0) { %>
<br>
<br>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>
<%
    if(type==1){
%>
        <img src="pic/incomeSpend.png" border=0>&nbsp;收款記錄:
<%  }else{  %>
        <img src="pic/costSpend.png" border=0>&nbsp;付款記錄:
<%  }   %>
</b>

&nbsp;&nbsp;<a href="print_mca_receipt.jsp?id=<%=vitem.getId()%>&r=<%=new Date().getTime()%>" target="_blank">列印收據</a><br>
</div>

    <%@ include file="spending_payinfo.jsp"%>

<% } %>

</center>

<script type="text/javascript" src="js/show_voucher.js"></script>
<script>
function do_pay()
{
    openwindow_phm('spending_pay.jsp?vid=<%=sb.toString()%>','雜費收付款',600,460,true);
}

function show_vitem_vouchers(vids)
{
    var url = "vchr/show_vitem_vchr.jsp?vids=" + encodeURI(vids);
    openwindow_phm2(url, "雜費相關傳票", 800, 400, 'vitemvchrwin');
}

</script>

<%@ include file="bottom.jsp"%>