<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,601))
    {
        response.sendRedirect("authIndex.jsp?code=601");
    }
%>
<%@ include file="leftMenu4.jsp"%>
<%


	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
%>
<head>
 
	<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
	<script language="JavaScript" src="js/in.js"></script>
	<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
	<script type="text/javascript" src="js/ajax.js"></script>
	<script type="text/javascript" src="js/ajax-tooltip.js"></script>
 
	
	<script type="text/javascript" src="js/xmlhttprequest.js"></script>
	<script type="text/javascript" src="js/check.js"></script>

</head>

<body>


<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/highlight-active-input.js.js"></script>

<div class=es02>
<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增學生-參觀模式</b>
<br>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
 


<form action="addVisit2.jsp" method=post name="xs" id="xs" onsubmit="return(checkX())">

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">
				<font color=red>*</font>學生姓名</td>
		<td class=es02>
 
				<table border=0>
		 		<tr>
		 			<td>
						<input type=text name="studentName" size=10 onchange="javascript:showname(this.value)">
 
					</td>
					<tD>
						<div id="showName"></div>
					</td>
					<td>
						<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=1',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
					</td>
				</tr>
			</table>				
	</td>
</tr>	

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">English Name</td>
	<td>

		&nbsp;<input type=text name="studentNickname" size=10>
	</tr>
 
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
		身份證字號
	</td>
	<td class=es02>
		
		<table border=0 class=es02>
			<tr>
				<td>
					<input type=text size=10 name="studentIDNumber" onkeyup="javascript:showIdLength(this.value)">
				</td>
				<td nowrap>
					<div id="showIdLength"></div>
				</td>
				<tD>											
					<div id="showId"></div>
				</td>
				<td>
					<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=2',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
				</tD>
			</tr>
		</table>
	</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
        性別
	</td>
	<td class=es02>
		<input type=radio size=20 name="studentSex" value="1" checked>男
 		<input type=radio size=20 name="studentSex" value="2" >女
 	</td>
 </tr> 
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
            生日</td>
	<td>
        <input type=checkbox name="tags" value="1" onClick="checkBirth()">
		<input  type=text size=10 name="studentBirth" value="<%=JsfTool.showDate(new Date())%>" disabled> 
<%
          EsystemMgr em=EsystemMgr.getInstance();
          Esystem e=(Esystem)em.find(1);
          if(e.getEsystemDateType()==0)
          {
%>
		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=3',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
<%          }else{  %>
		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=18',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>


<%      }   %>
	</td>
	</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
		父親<br> 
		<input type=radio name="emailDefault" value="1" checked>(預設聯絡人)
	</td>
	<td class=es02> 
		<table border=0 class=es02>
			<tr>
				<td>
				<div id="needName1"></div>  						
				</td>
			<tD>	
				姓名:&nbsp;&nbsp;&nbsp;<input  type=text name="studentFather" size=6>

				手機1: <input type=text name="studentFatherMobile" size=10>
				<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
		</td>
		</tr>
	
        <tr>
        <td></td>
        <td>
            Email: <input type=text name="studentFatherEmail" size=30 onblur="emailCheck(this)">
        </tD>
        </tr>
        </table>
        </td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">
				</div>母親<br>
				<input type=radio name="emailDefault" value="2">(預設聯絡人)
			</td>
		<td class=es02>
			<table border=0 class=es02>
			<tr>
				<td>
					<div id="needName2"></div>
				</td>
				<td>		
					姓名:&nbsp;&nbsp;&nbsp;<input type=text name="studentMother" size=6>
    
    				手機1: <input type=text name="studentMotherMobile" size=10 onkeyup="up3tab(this,10,'studentMotherMobile2')">		
					<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
		</td>
		</tr>
		<tr>
			<td></td>
			<td>
				Email: <input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentMotherEmail" size=30 onblur="emailCheck(this)">	
			</td>
		</tr>		
		</table>
		
		</td></tr>
		
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
		其他聯絡人<br>
		<input type=radio name="emailDefault" value="0">(預設聯絡人)
	</td>
	<td class=es02>
	
		<table border=0 class=es02>
			<tr>
				<td>
					<div id="needName3"></div>
				</td>
				<td>	
					姓名:<input  type=text name="rName" size=15>
			 關係 :
			<%
			Relation[] ra=ja.getAllRelation(_ws.getStudentBunitSpace("bunitId"));
			if(ra==null)
			{
				out.println("<font size=2 color=red><b>尚未加入關係</b></font>");
			}
			else
			{
		%>
				
				<select name="rRelation" size=1 onKeyDown="if(event.keyCode==13) event.keyCode=9;">	
		<%	
				for(int i=0;i<ra.length;i++)
				{
		%>
				<option value="<%=ra[i].getId()%>"><%=ra[i].getRelationName()%></option>
			
		<%
				}	
				out.println("</select>");
			}
			%>	
			<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
	</td>
	</tr>
	<tr>
		<td>
			<div id="needPhone3"></div>
		</td>
		<td>	
			手機1: <input   type=text name="rMobile" size=10>
			
			電話1:<input  type=text name="rPhone" size=10>	
		</td>
	</tr>

	</table>
	
	</td>
</tr>		
<tr bgcolor=#ffffff align=left valign=middle class=es02><td class=es02 bgcolor="#f0f0f0">家中電話</td><td>
<input type=hidden name=phoneDefault value="1">
電話1: <input  type=text name="studentPhone" size=10><br>

</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle class=es02>
	<td class=es02 bgcolor="#f0f0f0">地址</td>
	<td>
		郵遞區號: <input  type=text name="studentZipCode" size=5>
		住址: 
				<SELECT name="address_county1"  onchange="changearea('1')" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
	                <OPTION value="0">請選擇</OPTION>
	            		<SCRIPT type="text/javascript" language="JavaScript" src="js/changearea1_1.js"> </SCRIPT>
	            </SELECT> 
				<SELECT name="address_area1" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
					<OPTION value="0">請選擇</OPTION>
					<SCRIPT type="text/javascript" language="JavaScript" src="js/changearea1_2.js"> </SCRIPT>
				</SELECT>
		
		    <input type=text name="studentAddress" size=30>
	</td>
</tr>



	<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">入學狀態</td>
			<td class=es02>
 
				<table border=0 class=es02>
					<tr> 
						<td bgcolor=f0f0f0>
							<font color=blue>潛在學生:</font>
							<input type=radio name="studentStatus" value=1 checked>參觀登記/上網登入
							<input type=radio name="studentStatus" value=2>報名/等待入學
						</tD>
						<td>
						<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=5',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>
					</tr>
				</table>
			</td>
    </tr>

	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">備註</td>
		<td>
			<textarea name=studentPs rows=6 cols=50></textarea>
		</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td colspan=2>					
		
			<input type="hidden" name="studentBank1" value="">
			<input type="hidden" name="studentAccountNumber1" value="">
			<input type="hidden" name="studentBank2" value="">
			<input type="hidden" name="studentAccountNumber2" value="">
			<center><input type=submit value="新增"></center>
		</td>
	</tr>
	</table>	

	</td>
	</tr>
	</table>
		
	</form>
	
	<div class=es02><font color=red>*</font> 為必填資訊.</div>

</blockquote>

<script type="text/javascript">
	
	  var nowId=1;
	   function goAlert(defaultId)
	   {
	   	var xId=eval(defaultId);
	   	
	   	if(xId==1)
	   	{
	   		nowId=1;
	   		document.getElementById("needName1").innerHTML="<font color=red>*</font>";
	   		document.getElementById("needPhone1").innerHTML="<font color=red>*</font>";
	   		
	   		document.getElementById("needName2").innerHTML="";
	   		document.getElementById("needPhone2").innerHTML="";
	   		document.getElementById("needName3").innerHTML="";
	   		document.getElementById("needPhone3").innerHTML=""
	   		
	   	}else if(xId==2){
	   		
	   		nowId=2;
	   		document.getElementById("needName2").innerHTML="<font color=red>*</font>";
	   		document.getElementById("needPhone2").innerHTML="<font color=red>*</font>";
	   	
	   		document.getElementById("needName1").innerHTML="";
	   		document.getElementById("needPhone1").innerHTML=""
	   		document.getElementById("needName3").innerHTML="";
	   		document.getElementById("needPhone3").innerHTML=""
	   		
	   	}else if(xId==3){
	   		
	   		nowId=3;
	   	
	   		document.getElementById("needName3").innerHTML="<font color=red>*</font>";
	   		document.getElementById("needPhone3").innerHTML="<font color=red>*</font>"
	   	
	   		document.getElementById("needName1").innerHTML="";
	   		document.getElementById("needPhone1").innerHTML=""
	   		document.getElementById("needName2").innerHTML="";
	   		document.getElementById("needPhone2").innerHTML=""
	   	}
	   }
	   	
	   function checkX()
	   {
   	 	  	if(document.xs.studentName.value.length ==0)
			{
				alert('請填入"姓名"');

				document.xs.studentName.focus();	
				return false;
			}			
			return true;
	} 	

	function showIdLength(xValue)
	{
		document.xs.studentIDNumber.value=document.xs.studentIDNumber.value.toUpperCase();

		
		if(xValue.length>10)
		{
			document.getElementById("showIdLength").innerHTML="目前已輸入: "+(xValue.length)+" 位 <font color=red>,已超過正常10碼.</font>";
		}else{

			document.getElementById("showIdLength").innerHTML="目前已輸入: "+(xValue.length)+" 位";
		}

		if(xValue.length >=9)
		{	
			showid(xValue);
		}

	}  
	document.xs.studentName.focus();


    function checkBirth(){
        
        if(document.xs.tags.value==1){
            
            document.xs.tags.value=0;
            document.xs.studentBirth.disabled=false;

        }else{

            document.xs.tags.value=1;
            document.xs.studentBirth.disabled=true;

        }
    }
</script>


</body>

<%@ include file="bottom.jsp"%>	