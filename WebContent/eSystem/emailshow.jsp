<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%

	ReportAdmin ra=ReportAdmin.getInstance();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");

	String nowString=sdf.format(new Date());
	
	Date runDate=sdf.parse(nowString);

	out.println(ra.getCostpayUpdate(runDate));

%>


