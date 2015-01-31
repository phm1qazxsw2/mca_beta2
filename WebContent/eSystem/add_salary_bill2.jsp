<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("n");
    if (name==null)
        throw new Exception("name is null");

    ArrayList<Bill> bills = BillMgr.getInstance().retrieveListX("status=1 and billType=" +
        Bill.TYPE_SALARY, "", _ws2.getBunitSpace("bunitId"));

    Iterator<Bill> iter = bills.iterator();
    while (iter.hasNext())
    {
        Bill b2 = iter.next();
        
        if(b2.getName().equals(name))
        {
%>
<blockquote>
<div class=es02>
<font color=red>Error:</font>薪資類型的名稱重複,請設定未使用過的名稱.
<br><br>
    <a href="list_salary_bills.jsp">回薪資列表</a>
</div>
</blockquote>
        
<%
            return;
        }    
    }

    BillMgr bmgr = BillMgr.getInstance();
    int priv = Integer.parseInt(request.getParameter("priv"));
    Bill b = new Bill();
    b.setName(name);
    b.setPrettyName(name);
    b.setStatus(Bill.STATUS_ACTIVE);
    b.setBillType(Bill.TYPE_SALARY);
    b.setPrivLevel(priv);
    b.setBunitId(_ws2.getSessionBunitId());
    bmgr.create(b);
%>
<blockquote>
<div class=es02>
新增成功！
<br><br>
<a href="salaryrecord_add.jsp?billId=<%=b.getId()%>"> 設定<%=name%>薪資 </a> | 
    <a href="list_salary_bills.jsp">回薪資列表</a>
</div>
</blockquote>

