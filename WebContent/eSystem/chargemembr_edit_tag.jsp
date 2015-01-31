<div class=es02>
<img src="img/flag2.png" border=0>&nbsp;<b>已加入的收費對象: (<%=chargedmembrs.size()%>筆) </b> 

<script>
function open_editor(tid) {
    openwindow_phm2('tag_editor.jsp?tid='+tid+"&from=0&cid=<%=bcitem.getId()%>",'標籤名單編輯',800,600,'tageditorwin');
}
</script>

<% if (chargedmembrs.size()>0) { %>
<a href="<%=(pageType==0)?"editChargeItemDiscount":"editChargeItemDiscountExpress"%>.jsp?cid=<%=bcitem.getId()%>"><img src="pic/last.gif" border=0>&nbsp; 整批編輯折扣</a>    
<% } %>
</div>
    
<br>
<form name="f2" action="chargeitem_batchremove.jsp" method="post">
<input type=hidden name="cid" value="<%=bcitem.getId()%>">
<input type=hidden name="backurl" value="<%=backurl%>">

<table class=es02 width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<% 
    for (int k=0; k<tags.size(); k++) {
        Tag tag = tags.get(k); 
        ArrayList<TagMembr> tms = TagMembrMgr.getInstance().retrieveList("tagId=" + tag.getId(), "order by bindTime desc");
%> 
    <tr align=left valign=top>
      <td colspan=2 height=30 valign=bottom>
          》<b><%=tag.getName()%></b> 　<a href="javascript:open_editor(<%=tag.getId()%>)">編輯名單</a>
          　<a href="javascript:open_editor(<%=tag.getId()%>)">移除連結</a>
      </td>
    </tr>
    <tr align=left valign=top>
      <td bgcolor="white" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
      <td bgcolor="#e9e3de" style="border:1px solid black">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
<%
        //### 拿所有這個 chargeitemId 的 feedetail 出來，等下若是要有 feedetail 編輯過的人就不能在這改數字
        Map<String, Vector<FeeDetail>> fdetailMap = new SortingMap(FeeDetailMgr.getInstance().
            retrieveList("chargeItemId=" + bcitem.getId(),"")).doSort("getChargeKey");
        //###############

        int i=0, j=0;
        int mo=4;
        if (connecting_product)
            mo=3;
        Iterator<TagMembr> iter = tms.iterator();
        while (iter.hasNext())
        {
            ChargeItemMembr c = chargemembrMap.get(iter.next().getMembrId());
            if (c==null)
                continue;
            if ((i%mo)==0)
            {        
                j++;
                if((j%2)==1)
                    out.println("<tr class=es02 bgcolor=#f2f2f2>");
                else
                    out.println("<tr class=es02 bgcolor=#ffffff>");
            }
            out.println("<td nowrap>");
            boolean editable = false;
            if (c.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                out.println("<img src='pic/lockfinish2.png' align=top width=15 height=15 alt='已付'>");
            else if (c.getPrintDate()>0)
                out.println("<img src='pic/lockno2.png' align=top width=15 height=15 alt='已鎖'>");
            else {
                //out.println("<input type=checkbox name='target' value='"+c.getMembrId()+"'>");
                if (fdetailMap.get(c.getMembrId()+"#"+c.getChargeItemId())==null)
                    editable = true; // 有 feedetail, 在此不可直接改數字
            }
                
            out.println("<a href='bill_detail.jsp?rid=" + c.getBillRecordId()+"&sid="+c.getMembrId()+"&backurl="+java.net.URLEncoder.encode(backurl)+"' onmouseover=\"ajax_showTooltip('peek_bill.jsp?rid="+c.getBillRecordId()+"&sid="+c.getMembrId()+"',this);return false\" onmouseout=\"ajax_hideTooltip()\">" + c.getMembrName() + "</a>");
    %> 
          &nbsp;&nbsp;
          <% if (editable) { %>
          <input type=text size=4 name="_<%=c.getChargeKey()%>" value="<%=c.getMyAmount()%>" class=ei onblur="update_change(<%=i%>,'<%=c.getChargeKey()%>',<%=c.getMyAmount()%>,this)"> 元 
               <% if (connecting_product) { %>
          <input type=text size=1 name="@<%=c.getChargeKey()%>" value="<%=c.getPitemNum()%>" class=ei onkeyup="update_price('<%=c.getChargeKey()%>',<%=bcitem.getDefaultAmount()%>,this)"> 個
               <% } %>
          <% } else { %>
          <%=mnf.format(c.getMyAmount())%>
          <% }  
            out.println("</td>");
            if ((i%mo)==(mo-1))
                out.println("</tr>");
            i ++;
        }
        if (i%mo!=0) {
            while ((i%mo)!=0) {
                out.println("<td></td>");
                i++;
            }
            out.println("</tr>");
        }

        out.println("</table>");
    }   %>

    </td>
  </tr>
<%
    if (chargedmembrs.size()>0) {
%>
  <tr>
    <td colspan=2 bgcolor=ffffff align=middle>
        <input type="button" value="儲存金額<%=(connecting_product)?"與數量":""%>" onclick="doSave();">
    </td>
  </tr>    
  <tr>
    <td colspan=2 bgcolor=ffffff align=right class=es02>
        說明: <img src="pic/lockno2.png" border=0> 帳單為鎖定狀態,需解除才能修改;
        <img src="pic/lockfinish2.png" border=0> 帳單已繳費,不能修改.
    </td>
  </tr>        

<%
    }
%>

</table>

</form>
