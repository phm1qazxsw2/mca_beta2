
<%
	
	//response.setContentType("application/xml");

	String str ="<?xml version=\"1.0\" encoding=\"Big5\" ?><library>";
	str +="<book sales=\"Y\">";
	str +="<code>F6476</code>";
	str +="<title>ASP.NET 2.0網頁製作徹底研究</title>";
	str +="<author>陳會安</author>";
	str +="<price>660</price>";
	str +="</book>";
	str +="</library>";
	out.println(str);	
%>	