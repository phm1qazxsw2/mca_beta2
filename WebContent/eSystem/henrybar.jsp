<%@ page language="java" contentType="text/html;charset=UTF-8"%><%

/*
	int feeInt[]={200000,210000,310000,400000,111001,22222,222222,321321};
	int salaryInt[]={150000,20000,300000,2000,22,222,32132,32132};
	String feeString[]={"平平安安","幸福快樂","親親愛愛","又又寶貝","sss","222","32323","32132"};

*/
%>

<script src="AppletFiles/jpapplet.js" language="javascript" type="text/javascript"></script>
<script language="javascript" type="text/javascript">jpwriteapplet('<applet code="VbarchartApplet.class" archive="Vbarchart.jar" codebase="AppletFiles/" width="650" height="440">')</script>

<!-- Start Up Parameters -->
<param name="LOADINGMESSAGE" value="Creating Chart - Please Wait.">
<param name="STEXTCOLOR"     value="0,0,100">
<param name="STARTUPCOLOR"   value="255,255,255">
<!-- Character Encoding -->
<param name="charset"   value="8859_1">
<!-- Chart Switches -->
<param name="3D"           value="true">
<param name="grid"         value="true">
<param name="axis"         value="true">
<param name="ylabels"      value="true">
<param name="outline"      value="true">
<param name="legend"       value="true">
<param name="autoscale"    value="false">
<param name="gradientfill" value="true">
<!-- Chart Characteristics -->
<param name="nCols"            value="<%=feeInt.length%>">
<param name="nRows"            value="7">
<param name="ndecplaces"       value="0">
<param name="nSeries"          value="3">
<param name="chartScale"       value="100000">
<param name="chartStartY"      value="0">
<param name="labelOrientation" value="0">
<param name="labelsY"          value="390">
<param name="labelsY_offset"   value="15">
<param name="bar_spacing"      value="20">
<param name="barwidth"         value="10">
<param name="depth3D"          value="15">
<param name="linkcursor"       value="hand">
<param name="BackgroundColor"  value="White">
<param name="barOutlineColor"  value="black">
<!-- Grid properties -->
<param name="gridxpos"    value="70">
<param name="gridypos"    value="375">
<param name="vSpace"      value="30">
<param name="gridStyle"   value="2">
<param name="gridColor"   value="50,50,50">
<param name="axisColor"   value="0,0,255">
<param name="floorColor"  value="50,50,50">
<param name="gridbgcolor" value="#CCCCFF">
<param name="gridbgimage" value=" ">
<!-- Label and pop-up value properties -->
<param name="xlabel_font"  value="'',N,12">
<param name="ylabel_font"  value="'',I,10">
<param name="popupfont"    value="'',N,10">
<param name="labelColor"   value="75,75,125">
<param name="popupbgcolor" value="255,255,200">
<param name="popup_pre"    value="$">
<param name="popup_post"   value=" ">
<param name="ylabel_pre"   value="$">
<param name="ylabel_post"  value=" ">
<param name="thousandseparator"  value=",">
<!-- Bar Labels -->
<%
	for(int i=0;i<feeString.length;i++)
	{
%>
<param name="label<%=i+1%>"  value="<%=feeString[i]%>">
<%
	}
%>
<!-- Legend Information -->
<param name="legendfont"       value="'',N,12">
<param name="legendposition"   value="500,10">

<param name="legendtitle"      value="學費收入與薪資">
<param name="LegendBackground" value="240,240,240">
<param name="LegendBorder"     value="125,125,125">
<param name="LegendtextColor"  value="50,50,50">
<!-- Titles - Main, x and y --> <!--     text|xpos,ypos|Font|Color -->
<param name="title" value="金額|50,25|'',BI,18|130,130,180">
<param name="xtitle" value="班級|200,435|'',B,16|130,130,180">
<param name="ytitle" value="金額|5,200|'',B,16|130,130,180">
<!-- Series Data --> <!--      series color|2nd scale|legend label|Link URL|Target Frame -->
<param name="series1" value="100,199,100|left|學費收入">
<param name="series2" value="255,60,60|left|薪資支出">
<param name="series3" value="100,100,255|left|餘額">
<!-- Target Lines --> <!--      Color|style|value|label|font --> <!-- <PARAM name="target1" value="#990000|4|28000|Break Even|Arial,N,10">  -->
<!-- <PARAM name="target2" value="#007700|1|55000|Target|Arial,N,10"> --> <!-- Free Form Text --> <!--     text|xpos,ypos|Font|Color -->
<!-- <param name="text1" value="Note :|125,60|Arial,N,12|0,0,175">  -->


<!-- Bar Data --> <!--                               value,URL,Target Frame -->
<%
	for(int i=0;i<feeInt.length;i++)
	{
%>

<param name="data<%=i+1%>series1"  value="<%=feeInt[i]%>">
<param name="data<%=i+1%>series2"  value="<%=salaryInt[i]%>">
<param name="data<%=i+1%>series3"  value="<%=Integer.parseInt(feeInt[i])-Integer.parseInt(salaryInt[i])%>">
<%
	}
%>

<h2>Your browser is NOT Java enabled !</h2>
For instructions on how to add Java to your browser <a href="http://www.jpowered.com/graph_chart_collection/javaenabled.htm">click here</a>
</applet>
</div>
