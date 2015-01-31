<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    String z=request.getParameter("z");

	int teacherHealthType=0;
    try { teacherHealthType=Integer.parseInt(request.getParameter("teacherHealthType")); } catch (Exception e) {}

	int teacherHealthMoney=0;
    try { teacherHealthMoney=Integer.parseInt(request.getParameter("teacherHealthMoney")); } catch (Exception e) {}

	int teacherHealthPeople=0;
    try { teacherHealthPeople=Integer.parseInt(request.getParameter("teacherHealthPeople")); } catch (Exception e) {}


    JsfTool jt=JsfTool.getInstance();

    out.println("自付費用為: <font color=blue>"+jt.calculateHealthFee(1,teacherHealthMoney,teacherHealthPeople)+"</font> 元");

%>