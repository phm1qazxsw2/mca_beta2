<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,200))
    {
        response.sendRedirect("authIndex.jsp?code=200");
    }

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    Calendar c = Calendar.getInstance();
    c.add(Calendar.DATE, 7);
    Date end = c.getTime();
    try { end = sdf.parse(request.getParameter("end")); } catch (Exception e) {}
    int paidstatus = 0;
    try { paidstatus = Integer.parseInt(request.getParameter("paidstatus")); } catch (Exception e) {}
    c.setTime(end);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();
    c.add(Calendar.DATE, -22);
    Date start = c.getTime();
    int type=-1;
    try { type=Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
    try { start = sdf.parse(request.getParameter("start")); } catch (Exception e) {}

    int userId=-1;
    try { userId=Integer.parseInt(request.getParameter("userId")); } catch (Exception e) {}

    int verifystatus=-1;
    try { verifystatus=Integer.parseInt(request.getParameter("verifystatus")); } catch (Exception e) {}

    String query = "recordTime<'" + sdf.format(nextEndDay) + 
        "' and recordTime>='" + sdf.format(start) + "'";

    if (paidstatus==1) // 未付清
        query += " and paidstatus!=2";
    else if (paidstatus==2) // 付清
        query += " and paidstatus=2";

    if (type>=0)
        query += " and type=" + type;

    if(userId !=-1)
        query+=" and userId="+userId;

    if(verifystatus !=-1)
        query+=" and verifystatus="+verifystatus;

    String ac = request.getParameter("ac");
    if (ac!=null)
        query += " and acctCode like '"+ ac +"%'";

    VitemMgr vimgr = VitemMgr.getInstance();
    ArrayList<Vitem> vitems = vimgr.retrieveList(query, "order by recordTime asc");
    String backurl = "spending_list.jsp?" + request.getQueryString();
    VoucherMgr vchrmgr = VoucherMgr.getInstance();

    /*
        when list vitems, if vitem has voucherId then we need to do special handling
        1. use its voucher contents to draw
        2. later if encounter vitem using the same voucher, ignore it        
    */
    Map<Integer/*voucherId*/, Vector<Vitem>> voucherMap = null;
    Map<Integer/*voucherId*/, Vector<Voucher>> voucherMap2 = null;
    HashMap<Integer/*voucherId*/, String> _done = new HashMap<Integer/*voucherId*/, String>();
    if (vitems.size()>0) {
        String voucherIds = new RangeMaker().makeRange(vitems, "getVoucherId");
        if (voucherIds!=null && voucherIds.length()>0) {
            ArrayList<Vitem> vchr_items = 
                vimgr.retrieveList("voucherId in (" + voucherIds + ")", "order by recordTime asc");
            voucherMap = new SortingMap(vchr_items).doSort("getVoucherId");
            ArrayList<Voucher> vouchers = 
                vchrmgr.retrieveList("id in (" + voucherIds + ")", "");
            voucherMap2 = new SortingMap(vouchers).doSort("getId");
        }
    }

    Object[] users = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users, new ArrayList<User>(), "getId");

    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    String title = (type==-1)?"收支":(type==0)?"支":"收";
%>
<script src="js/formcheck.js"></script>
<script>
function doSubmit(f)
{
    if (!checkDate(f.start.value,'/')) {
        alert("請輸入正確的開始日期");
        f.start.focus();
        return false;
    }
    if (!checkDate(f.end.value,'/')) {
        alert("請輸入正確的結束日期");
        f.end.focus();
        return false;
    }
    return true;
}
function do_merge()
{
    var e = document.f2.id;
    var ret = '';
    if (typeof e=='undefined') {
        alert("沒有選擇項目");
        return false;
    }
    else if (typeof e.length=='undefined') {
        if (e.checked) {
            ret = e.value;
        }
    }
    else {
        for (var i=0; i<e.length; i++) {
            if (e[i].checked) {
                if (ret.length>0) ret += ",";
                    ret += e[i].value;
            }
        }
    }
    if (ret.length==0) {
        alert("沒有選擇項目");
        return false;
    }
    // openwindow_phm('spending_pay.jsp?vid=' + encodeURI(ret),'合倂',500,400,true);
    return true;
}
</script>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;雜費收支總覽</b>

</div>
<br>
<center>
<div class=es02>
形式:
<b>
<%
    switch(type){

        case -1:
            out.println("全部");
            break;
        case 0:
            out.println("支出");
            break;
        case 1:
            out.println("收入");
            break;
    }
%>
</b>
&nbsp;&nbsp;開始日期: <b><%=sdf.format(start)%></b>
&nbsp;&nbsp;結束日期:<b><%=sdf.format(end)%></b>
登入人:
<b>
<%
    if(userId==-1){
        out.println("全部");
    }else{

        UserMgr umm=UserMgr.getInstance();
        User u=(User)umm.find(userId);
        if(u !=null)
            out.println(u.getUserFullname());
    }
%>
</b>
付款狀態:
<b>
<%
    switch(paidstatus){
        
        case 0:
            out.println("全部");
            break;
        case 1:
            out.println("未結清");
            break;
        case 2:
            out.println("已結清");
            break;
    

    }
%>
</b>
覆核:
<b>
<%
    switch(verifystatus){
        
        case -1:
            out.println("全部");
            break;
        case 0:
            out.println("尚未");
            break;
        case 1:
            out.println("警示");
            break;
        case 90:
            out.println("OK");
            break;    
    }
%>
</b>
</center>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<center>
<form>
<input type="button" value="列印本頁" onClick="window.print()" />
</form>
</center>
<%
    if(vitems==null || vitems.size()==0){
%>
        
        <center>
        <div class=es02>
            <font color=blue>本次搜尋沒有相關資料.</font>
        </div>
        </center>
        
        <%@ include file="bottom.jsp"%>
<%
        return;
    }
%>
<center>
<div class=es02 align=right>
    本次搜尋合計:<font color=blue><%=vitems.size()%></font> 筆&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
	<table width="95%" border=1 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap>傳票編號</td>
		<td align=middle nowrap>日期</td>
        <td align=middle colspan=2 width=160 nowrap>摘要</td>
        <td align=middle width=50 nowrap>登入人</td>
        <td align=middle width=45 nowrap>應付<br>金額</td>
        <td align=middle width=45 nowrap>應收<br>金額</td>
        <td align=middle nowrap>收付<br>金額</td>
        <td align=middle nowrap>覆核</td>
	</tr>
<%
    int costTotal=0;
    int incomeTotal=0;
    int paytotal=0;

    Iterator<Vitem> iter = vitems.iterator();
    while (iter.hasNext()) {
        Vitem vi = iter.next();
        boolean isPacked = false;
        if (vi.getVoucherId()>0) {
            isPacked = true;
            vi = getMergedInfo(vi, voucherMap, voucherMap2, _done, userMap, backurl,ud2,authHa);
            if (vi==null) // already done before, skip
                continue;
        }
        if (paidstatus==2 && vi.getPaidstatus()!=Vitem.STATUS_FULLY_PAID)
            continue;
        String identifier = ((isPacked)?"V":"I") + vi.getId();

        if(vi.getType()==Vitem.TYPE_SPENDING){

            costTotal+=vi.getTotal();
            paytotal-=vi.getRealized();
        }else{
            incomeTotal+=vi.getTotal();
            paytotal+=vi.getRealized();            
        }
        if(!isPacked){
%>
<tr bgcolor=#ffffff valign=middle>
        <td class=es02  bgcolor=#ffffff valign=top>&nbsp;
        </td>
        <td class=es02 valign=top align=middle><%=sdf2.format(vi.getRecordTime())%></td>
        <td class=es02 valign=top colspan=2>
            <%
                // Vitem.TYPE_SPENDING, Vitem.TYPE_INCOME
                if(vi.getType()==Vitem.TYPE_SPENDING){
            %>
        &nbsp;<font color=blue><%=identifier%></font>
            <%  }else{  %>
        &nbsp;<font color=red><%=identifier%></font>
            <%  }   %>
            &nbsp;<%=vi.getTitle()%>
        </td>	
        <td class=es02 align=middle valign=top><%=getUserName(vi.getUserId(), userMap)%>
        </td>
<%
        if(vi.getType()==Vitem.TYPE_SPENDING){
%>  
            <td align=right class=es02 valign=middle><%=mnf.format(vi.getTotal())%></td>  
            <td align=right class=es02 valign=middle>&nbsp;</td>  
<%      }else{  %>
            <td align=right class=es02 valign=middle>&nbsp;</td>  
            <td align=right class=es02 valign=middle><%=mnf.format(vi.getTotal())%></td>  
<%      }   %>
<%
        if(vi.getPaidstatus()==Vitem.STATUS_FULLY_PAID)
        {
%>
            <td bgcolor=#ffffff align=right class=es02 valign=middle>
<%      }else{  %>
            <td bgcolor=#ffffff align=right class=es02 valign=middle>
<%      }   %>

<%
        if(vi.getType()==Vitem.TYPE_SPENDING &&vi.getRealized() >0){
%>
            (<%=mnf.format(vi.getRealized())%>)
<%      }else{  %>
            <%=mnf.format(vi.getRealized())%>
<%      }   %>
        </td>  

<%
        if(vi.getVerifystatus()==Vitem.VERIFY_NO){
%>  
    <td class=es02 align=middle valign=top nowrap>
          尚未覆核<br>

<%
        }else if(vi.getVerifystatus()==Vitem.VERIFY_YES){
%>
        <td class=es02 align=middle valign=top>
          <font color=blue>OK</font><br>
          

<%      }else if(vi.getVerifystatus()==Vitem.VERIFY_WARN){  %>
        <td class=es02 align=middle valign=top nowrap>
            警示
           
            <%
            }
            %>
        </td>

    </tr>

<%      }else{  %>
        
         <%=vi.getTitle()%>
<%
        }
    }
%>
    <tr class=es02>
        <td colspan=5 align=middle>本 次 搜 尋 小 計</td>
        <td align=right nowrap><b><%=mnf.format(costTotal)%></b></td>
        <td align=right nowrap><b><%=mnf.format(incomeTotal)%></b></td>
        <td align=right nowrap>
            <b><%
                if(paytotal <0)
                    out.println("(");
                out.println(mnf.format(Math.abs(paytotal)));
                if(paytotal <0)
                    out.println(")");
            %></b>

        </td>
        <td colspan=2 align=right>
            &nbsp;
        </td>
    </tr>
    </table> 
</center>
<br>


<%!

    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    static SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    public Vitem getMergedInfo(Vitem vi, 
            Map<Integer, Vector<Vitem>> voucherMap,
            Map<Integer, Vector<Voucher>> voucherMap2,
            Map<Integer/*voucherId*/, String> _done, 
            Map<Integer/*userId*/, Vector<User>> userMap, String backurl,User ud2,Hashtable authHa) throws Exception
    {
        Integer vchrId = new Integer(vi.getVoucherId());
        if (_done.get(vchrId)!=null)
            return null; // already done
        Vector<Vitem> v = voucherMap.get(vchrId);
        Vitem ret = new Vitem();
        StringBuffer sb = new StringBuffer();

        Voucher vr = voucherMap2.get(vchrId).get(0);

        sb.append("<tr bgcolor=#ffffff>");

        String costbook="";
        
        if(vr.getCostbookId() !=null)
            costbook=vr.getCostbookId();

        if(vi.getType()==Vitem.TYPE_SPENDING){

        sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/costticket.png\" width=16>&nbsp;<br><font color=blue>"+costbook+"</font></td>");

        }else{

        sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/incometicket.png\" width=16>&nbsp;<br><font color=red>"+costbook+"</font></td>");

        }

        StringBuffer sb2=new StringBuffer();
        
        boolean paid = true;
        int total = 0;
        int realized = 0;

        for (int i=0; i<v.size(); i++) {

            if(i==0)
            {
            sb.append("<td class=es02 align=middle>" + sdf2.format(v.get(i).getRecordTime()) + "</td><td class=es02 colspan=2>");

            if(vi.getType()==Vitem.TYPE_SPENDING){
                sb.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
            }else{
                sb.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
            }
            sb.append("</td><td  class=es02 align=middle width=80>"+getUserName(v.get(i).getUserId(), userMap)+"</td>");

            }else{

                sb2.append("<tr bgcolor=#ffffff>");

                sb2.append("<td class=es02 align=middle>" + sdf2.format(v.get(i).getRecordTime()) + "</td><td class=es02 colspan=2 nowrap>");

                if(vi.getType()==Vitem.TYPE_SPENDING){
                    sb2.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
                }else{
                    sb2.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
                }

                sb2.append("</td><td align=middle width=80 class=es02>"+getUserName(v.get(i).getUserId(), userMap)+"</td></tr>");

            }

            total += v.get(i).getTotal();
            realized += v.get(i).getRealized();

            if (v.get(i).getPaidstatus()!=Vitem.STATUS_FULLY_PAID)
                paid = false;
        }
        if(vi.getType()==Vitem.TYPE_SPENDING){
        
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right valign=middle>"+mnf.format(total)+"</td>");
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right>&nbsp;</td>");
        }else{
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right>&nbsp;</td>");
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right valign=middle>"+mnf.format(total)+"</td>");
        }
        if((total-realized)==0)
        {
            sb.append("<td class=es02 rowspan="+v.size()+" align=right bgcolor=#ffffff>");
        }else{
            sb.append("<td class=es02 rowspan="+v.size()+" align=right bgcolor=#ffffff>");
        }
        sb.append("<font color=white>");

        if(vi.getType()==Vitem.TYPE_SPENDING &&realized >0){
            sb.append("("+mnf.format(realized)+")");
        }else{
            sb.append(mnf.format(realized));
        }

        if(vi.getVerifystatus()==Vitem.VERIFY_NO){  
            
            sb.append("<td bgcolor=ffffff class=es02 align=middle valign=middle nowrap rowspan="+v.size()+">尚未覆核<br>");


        }else if(vi.getVerifystatus()==Vitem.VERIFY_YES){

            sb.append("<td class=es02  bgcolor=ffffff  align=middle valign=middle nowrap rowspan="+v.size()+">OK<br>");



        }else if(vi.getVerifystatus()==Vitem.VERIFY_WARN){

            sb.append("<td class=es02 align=middle valign=middle bgcolor=red nowrap rowspan="+v.size()+"><font color=white>警示</font><br>");
        } 

        sb.append("</td>");
       
        sb.append("</tr>");

        sb.append(sb2.toString());
        ret.setTitle(sb.toString());
        ret.setId(vchrId);
        ret.setRecordTime(v.get(0).getRecordTime());
        ret.setType(v.get(0).getType());
        ret.setTotal(total);
        ret.setRealized(realized);
        ret.setBunitId(vi.getBunitId());
        if (paid)
            ret.setPaidstatus(Vitem.STATUS_FULLY_PAID);
        _done.put(vchrId, "");
        // Vitem.TYPE_SPENDING, Vitem.TYPE_INCOME
        return ret;
    }

    public String getUserName(int uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(new Integer(uid));
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }
%>

