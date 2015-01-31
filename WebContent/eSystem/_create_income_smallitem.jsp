<%@ page language="java" import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%><%
IncomeSmallItem[] si = null;
int sid = -1;
try
{
    JsfAdmin ja = JsfAdmin.getInstance();
    si = ja.getActiveIncomeSmallItemByBID(1);
    String name = request.getParameter("n");
    
    IncomeSmallItem s = new IncomeSmallItem();
    s.setIncomeSmallItemName(name);   
    s.setIncomeSmallItemActive(1); 
    s.setIncomeSmallItemIncomeBigItemId(1);
    IncomeSmallItemMgr sim = IncomeSmallItemMgr.getInstance();
    sid = sim.createWithIdReturned(s);

    si = ja.getActiveIncomeSmallItemByBID(1);
}
catch (Exception e)
{
}
%>
<select name=smallitem onchange="change_smallitem(this)">
    <option value="-1">---請選擇---</option>
<%
    for (int i=0; si!=null && i<si.length; i++)
        out.println("    <option value='"+si[i].getId()+"' "+((sid==si[i].getId())?"selected":"")+">"+si[i].getIncomeSmallItemName()+"</option>");
%>
    <option value="0">--產生新的會計科目--</option>
</select>
