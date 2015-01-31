<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<% 

/*
	String titleName="龔麾測試"; 
	String itemName="項目";
	String preUnit="$";
	String[] item ={"aaa","中文額給很成勒","ccc","ddd","eee","工","sa","sa","adee"};
	int[] itemNum={324,4324,432,76,453,120,21,32,43};
	String[] itemUrl ={"aaa.jsp","bb.jsp","ccc","ddd","eee","工","","",""};
*/
	
%>


<script src="AppletFiles/jpapplet.js" language="javascript" type="text/javascript"></script>
<script language="javascript" type="text/javascript">jpwriteapplet('<applet code="PiechartApplet.class" archive="Piechart.jar" codebase="AppletFiles/" width="550" height="440">')</script>
<!-- Start Up Parameters -->
<PARAM name="LOADINGMESSAGE" value="Creating Chart - Please Wait.">
<PARAM name="STEXTCOLOR"     value="#000060">
<PARAM name="STARTUPCOLOR"   value="#FFFFFF">
<!-- Chart Switches -->
<PARAM name="3D"                 value="true">
<PARAM name="Slabels"            value="true">
<PARAM name="displayPercentages" value="true">
<PARAM name="legend"             value="true">
<PARAM name="labellines"         value="true">
<!-- Chart Characteristics -->
<PARAM name="nPies"      value="3">
<PARAM name="ndecplaces" value="0">
<PARAM name="3Dangle" value="50">
<PARAM name="depth3D" value="25">
<!-- Link Cursor --> <!--  valid values are - crosshair, default, hand, move, text or wait -->
<PARAM name="linkCursor" value="hand">
<!-- Pop-Up segment Value Pre & Post Symbols -->
<PARAM name="valuepresym"  value="<%=preUnit%>">
<!-- thousand separater -->
<PARAM name="thousandseparator" value=",">
<!-- Additional font information -->
<PARAM name="popupfont"  value="Arial,B,10">
<PARAM name="slabelfont" value="Arial,N,10">
<!-- Additional color information -->
<PARAM name="bgcolor"      value="#FFFFFF">
<PARAM name="labelcolor"   value="#323232">
<PARAM name="popupbgcolor" value="#A0A0CC">
<!-- Title --> <!-- title   text|xpos,ypos|Font|Color Defintion"> -->
<PARAM name="title" value="Sales by Region|5,10|Arial,B,12|#888888">
<!-- Legend Information -->
<PARAM name="legendfont"       value="'',N,12">
<PARAM name="legendposition"   value="400,0">
<PARAM name="legendtitle"      value="<%=itemName%>">
<PARAM name="LegendBackground" value="#FFFFFF">
<PARAM name="LegendBorder"     value="#DDDDDD">
<PARAM name="LegendtextColor"  value="#202020">
<!-- Free Form Text --> <!--  textn         text,xpos,ypos,font-type,font-style,font-size,Rcolor,Gcolor,Bcolor"> -->
<!--
<PARAM name="text1"  value="Product X|20,45|Arial,B,10|#000090">
<PARAM name="text2"  value="Product Y|250,20|Arial,B,10|#000090">
-->
<PARAM name="text1"  value="<%=titleName%>|270,240|'','',16|#000090">
<!-- Pie Data --> <!--  PieN   x,y,size,number of segments, separation --> 

<PARAM name="Pie1" value="70,80,200,6,0">

<!-- Segment Data --> <!-- segmentN       series color|legend label|URL|Target Frame --> 

<% 
	for(int itemI=0;itemI<item.length;itemI++)
  	{
 %> 
		<PARAM name="segment<%=itemI+1%>" value="<%=segmentStyle[itemI]%>|<%=item[itemI]%>">
<%
	}
%>

<!-- Pie Data --> <!--                value,URL,Target Frame -->
<% 
	for(int itemI=0;itemI<item.length;itemI++)
  	{
 %> 
<PARAM name="data<%=itemI+1%>series1" value="<%=itemNum[itemI]%>,<%=itemUrl[itemI]%>">
<%
	}
%>

</applet>
</div>




</body>
</html>
