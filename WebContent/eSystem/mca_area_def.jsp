<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/javascript;charset=UTF-8"%>
var countries = new Array;
var counties = new Array;
var cities = new Array;
var districts = new Array;
<%
	ArrayList<Area> areas = new AreaMgr(0).retrieveList("", "order by level asc, code asc");
	for (int i=0; i<areas.size(); i++) {
		Area a = areas.get(i);
		int lv = a.getLevel();
		String array_var = (lv==0)?"countries":(lv==1)?"counties":(lv==2)?"cities":"districts";
%>
<%=array_var%>[<%=array_var%>.length] = new area('<%=a.getCode()%>','<%=(a.getCName()!=null)?a.getCName():""%>', '<%=(a.getEName()!=null)?a.getEName():""%>', <%=lv%>, '<%=a.getParentCode()%>');
<%
	}
%>	