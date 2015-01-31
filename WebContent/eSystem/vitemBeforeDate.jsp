<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%><%
 
 
	SimpleDateFormat sdfDateCost2=new SimpleDateFormat("yyyy/MM/dd");
	SimpleDateFormat sdfDateCost3=new SimpleDateFormat("MM/dd");
    int paidstatus = 0;
    int costTotalX=0;
    int incomeTotalX=0;
    int paytotalX=0;
    int typeNow=-1;

    String query = "recordTime >='" + sdfDateCost2.format(beforeDate)+ "'";
   


    VitemMgr vimgr = VitemMgr.getInstance();
    ArrayList<Vitem> vitems = vimgr.retrieveListX(query, "order by recordTime asc", _ws.getBunitSpace("bunitId"));

    Map<Integer/*voucherId*/, Vector<Vitem>> voucherMap = null;
    HashMap<Integer/*voucherId*/, String> _done = new HashMap<Integer/*voucherId*/, String>();
    if (vitems.size()>0) {
        String voucherIds = new RangeMaker().makeRange(vitems, "getVoucherId");
        if (voucherIds!=null && voucherIds.length()>0) {
            ArrayList<Vitem> vchr_items = 
                vimgr.retrieveList("voucherId in (" + voucherIds + ")", "order by recordTime asc");
            voucherMap = new SortingMap(vchr_items).doSort("getVoucherId");
        }
    }

    Object[] users = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users, new ArrayList<User>(), "getId");

    SimpleDateFormat sdf2x = new SimpleDateFormat("MM/dd");

    if(vitems!=null && vitems.size()>0){
%>
<div class=es02>
<b><img src="pic/incometicket.png" border=0 width=16>&nbsp;雜費收支</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('victemDiv');return false"><%=vitems.size()%> 筆</a>
</div>
<div id=victemDiv style="display:none" class=es02>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap>編號</td>
		<td align=middle nowrap>入帳日期</td>
        <td align=middle colspan=2 width=160 nowrap>明細</td>
        <td align=middle width=50 nowrap>登入人</td>
        <td align=middle width=45 nowrap>應付<br>金額</td>
        <td align=middle width=45 nowrap>應收<br>金額</td>
        <td align=middle width=45 nowrap>收付<br>金額</td>
        <td align=middle width=40></td>
	</tr>
<%
    int paytotal=0;

    Iterator<Vitem> iter = vitems.iterator();
    while (iter.hasNext()) {
        Vitem vi = iter.next();
        boolean isPacked = false;
        if (vi.getVoucherId()>0) {
            isPacked = true;
            vi = getMergedInfo(vi, voucherMap, _done, userMap, backurl);
            if (vi==null) // already done before, skip
                continue;
        }
        if (paidstatus==2 && vi.getPaidstatus()!=Vitem.STATUS_FULLY_PAID)
            continue;
        String identifier = ((isPacked)?"V":"I") + vi.getId();

        if(vi.getType()==Vitem.TYPE_SPENDING){

            costTotalX+=vi.getTotal();
            paytotalX-=vi.getRealized();
        }else{
            incomeTotalX+=vi.getTotal();
            paytotalX+=vi.getRealized();            
        }
        if(!isPacked){
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight<%=(vi.getType()==Vitem.TYPE_SPENDING)?"2":""%>'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02  bgcolor=#ffffff valign=top>

        </td>
        <td class=es02 valign=top><%=sdfDateCost3.format(vi.getRecordTime())%></td>
        <td class=es02 valign=top colspan=2 align=left>
<%
        if(vi.getType()==Vitem.TYPE_SPENDING){
%>  
        <font color=blue>&nbsp;<%=identifier%></font>
<%      }else{  %>
        <font color=red>&nbsp;<%=identifier%></font>
<%      }   %>


<%=vi.getTitle()%></td>	
        <td class=es02 align=middle valign=top><%=getUserName(vi.getUserId(), userMap)%>
        </td>
<%
        if(vi.getType()==Vitem.TYPE_SPENDING){
%>  
            <td align=right class=es02 valign=middle><%=mnf.format(vi.getTotal())%></td>  
            <td align=right class=es02 valign=middle></td>  

<%      }else{  %>
            <td align=right class=es02 valign=middle></td>  
            <td align=right class=es02 valign=middle><%=mnf.format(vi.getTotal())%></td>  
<%      }   %>
<%
        if(vi.getPaidstatus()==Vitem.STATUS_FULLY_PAID)
        {
%>
            <td bgcolor=#F77510 align=right class=es02 valign=middle>
<%      }else{  %>
            <td bgcolor=#4A7DBD align=right class=es02 valign=middle>
<%      }   %>
            <font color=white>
<%
        if(vi.getType()==Vitem.TYPE_SPENDING &&vi.getRealized() >0){
%>
            (<%=mnf.format(vi.getRealized())%>)
<%      }else{  %>
            <%=mnf.format(vi.getRealized())%>
<%      }   %>
        </font>
        </td>  
        <td class=es02 align=middle valign=top>
            <a href="spending_voucher.jsp?id=I<%=vi.getId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">詳細資料</a>
        </td>
    </tr>

<%      }else{  %>
        
         <%=vi.getTitle()%>
<%
        }
    }
%>
    <tr class=es02>
        <td colspan=5 align=middle>小 計</td>
        <td align=right nowrap><b><%=mnf.format(costTotalX)%></b></td>
        <td align=right nowrap><b><%=mnf.format(incomeTotalX)%></b></td>
        <td align=right nowrap>
            <b><%
                if(paytotal <0)
                    out.println("(");
                out.println(mnf.format(Math.abs(paytotal)));
                if(paytotal <0)
                    out.println(")");
            %></b>

        </td>
        <td colspan=4 align=right></td>
    </tr>
    </table> 
</td>
</tr>
</table>
</div>
<BR>
<%
    }
%>
<%!
    static SimpleDateFormat sdf = new SimpleDateFormat("MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    public Vitem getMergedInfo(Vitem vi, Map<Integer, Vector<Vitem>> voucherMap,
            Map<Integer/*voucherId*/, String> _done, 
            Map<Integer/*userId*/, Vector<User>> userMap, String backurl) throws Exception
    {
        Integer vchrId = new Integer(vi.getVoucherId());
        if (_done.get(vchrId)!=null)
            return null; // already done
        Vector<Vitem> v = voucherMap.get(vchrId);
        Vitem ret = new Vitem();
        StringBuffer sb = new StringBuffer();

        Voucher vr=VoucherMgr.getInstance().find("id="+vchrId);

        String costbook="";
        
        if(vr.getCostbookId() !=null)
            costbook=vr.getCostbookId();

        sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight");

        if(vi.getType()==Vitem.TYPE_SPENDING){
            sb.append("2");
        }

        sb.append("'\"  onmouseout=\"this.className='normal2'\" valign=middle>");

         if(vi.getType()==Vitem.TYPE_SPENDING){

                sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/costticket.png\" width=16>&nbsp;<br><font color=blue>"+costbook+"</font></td>");

                }else{

                sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/incometicket.png\" width=16>&nbsp;<br><font color=red>"+costbook+"</font></td>");

                }
/*
        if(vi.getType()==Vitem.TYPE_SPENDING){

        sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/costticket.png\" width=16>&nbsp;<b><font color=blue>V"+vchrId+"</font></b></td>");
        }else{
        sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/incometicket.png\" width=16>&nbsp;<b><font color=red>V"+vchrId+"</font></b></td>");
        }

*/

        StringBuffer sb2=new StringBuffer();
        
        boolean paid = true;
        int total = 0;
        int realized = 0;

        for (int i=0; i<v.size(); i++) {

            if(i==0)
            {
            sb.append("<td class=es02>" + sdf.format(v.get(i).getRecordTime()) + "</td><td colspan=2 class=es02>");

            if(vi.getType()==Vitem.TYPE_SPENDING){
                sb.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
            }else{
                sb.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
            }
            
            sb.append("<td  class=es02 align=middle width=80>"+getUserName(v.get(i).getUserId(), userMap)+"</td>");

            }else{

                sb2.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight");
                
                if(vi.getType()==Vitem.TYPE_SPENDING){
                    sb2.append("2");
                }

                sb2.append("'\"  onmouseout=\"this.className='normal2'\" valign=middle>");

                sb2.append("<td class=es02>" + sdf.format(v.get(i).getRecordTime()) + "</td><td colspan=2 class=es02>");

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
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right></td>");
        }else{
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right></td>");
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right valign=middle>"+mnf.format(total)+"</td>");

        }

        if((total-realized)==0)
        {
            sb.append("<td class=es02 rowspan="+v.size()+" align=right bgcolor=#F77510>");
        }else{
            sb.append("<td class=es02 rowspan="+v.size()+" align=right bgcolor=#4A7DBD>");
        }
        sb.append("<font color=white>");

        if(vi.getType()==Vitem.TYPE_SPENDING &&realized >0){
            sb.append("("+mnf.format(realized)+")");
        }else{
            sb.append(mnf.format(realized));
        }
        sb.append("<td class=es02 bgcolor=#ffffff rowspan="+v.size()+" align=middle nowrap><a href=\"spending_voucher.jsp?id=V"+vchrId+"&backurl="+java.net.URLEncoder.encode(backurl)+"\">詳細資料</a></td>");

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
	