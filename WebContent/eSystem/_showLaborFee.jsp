<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    String z=request.getParameter("z");

	int teacherLaborMoney=0;
    try { teacherLaborMoney=Integer.parseInt(request.getParameter("teacherLaborMoney")); } catch (Exception e) {}


    JsfTool jt=JsfTool.getInstance();

    int[] level=jt.getLaborLevel(teacherLaborMoney);
    
    int fee=jt.getLaborMonthFee(level);

    out.println("薪資等級為: <font color=blue>"+level[0]+"</font> 投保薪資為: <font color=blue>"+level[1]+"</font> 元<br>自付費用為: <font color=blue>"+fee+"</font> 元");

%>