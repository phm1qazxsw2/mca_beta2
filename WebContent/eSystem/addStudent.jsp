<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%> 
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


<%!
    public String getCheckboxes(Vector<Tag> tv, Map<Integer/*tagId*/, Vector<TagMembr>> tm) {
        if (tv==null)
            return "";
        String ret = "";
        for (int i=0; i<tv.size(); i++) {
            ret += "<input type=checkbox id='tagId_"+tv.get(i).getId()+"' name='tagId' value='"+tv.get(i).getId()+"'";
            if (tm!=null && tm.get(tv.get(i).getId())!=null)
                ret += "checked";
            ret += ">" + tv.get(i).getName() + "　<span id='addc_"+tv.get(i).getId()+"'></span><br>\n";
        }
        return ret;
    }
%>
<%
	JsfAdmin ja=JsfAdmin.getInstance();
	Classes[] cl=ja.getAllActiveClasses();
	Degree[] degree=ja.getAllActiveDegree(_ws.getStudentBunitSpace("bunitId")); 
	
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
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;<%=(pZ2.getCustomerType()==0)?"新增學生 - 就讀學生模式":"新增客戶"%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote> 


<form action="addStudent2.jsp" method=post name="xs" id="xs" <%=(pZ2.getCustomerType()==0)?"onsubmit=\"return(checkX())\"":""%>>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">
				<font color=red>*</font><%=(pZ2.getCustomerType()==0)?"學生姓名":"客戶名稱"%></td>
		<td class=es02> 
				<table border=0 cellpadding="0" cellspacing="0">
		 		<tr>
		 			<td>
						<input type=text name="studentName" size=15 onchange="javascript:showname(this.value)"> 
					</td>
					<tD>
						<div id="showName"></div>
					</td>
            <%
            if(pZ2.getCustomerType()==0){
            %>
					<td>
						<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=1',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
					</td>
		<%
            }
        %>	
        	</tr>
			</table>				
	    </td>
    </tr>	
    <tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">
                <%=(pZ2.getCustomerType()==0)?"學號":"客戶編號"%>
        </td>
		<td class=es02>
            <input type=text name="studentNumber" size=15>

            簡稱: <input type=text name="studentShortName" size=15>
	    </td>
    </tr>	
    <tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">English Name</td>
	<td>
		<input type=text name="studentNickname" size=15>
	</tr>
 
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
        <%=(pZ2.getCustomerType()==0)?"身份證字號":"統一編號"%>
	</td>
	<td class=es02>
		
		<table border=0 class=es02 cellpadding="0" cellspacing="0">
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
            <%
            if(pZ2.getCustomerType()==0){
            %>
				<td>
					<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=2',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
				</tD>
            <%  }   %>
			</tr>
		</table>
	</td>
</tr>
<%
if(pZ2.getCustomerType()==0){
%>
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
        血型  	
    </td>
	<td class=es02>
        <input type=text name="bloodType" value="" size=5>
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

<%          }   %>
	</td>
	</tr>
<%
    }else{
%>
        <input type=hidden name="bloodType" value="">            
        <input type=hidden name="tags" value="1">
        <input type=hidden name="studentSex" value="1">
        <input type=hidden name="studentBirth" value="2008/01/01">
<%
    }
%>
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">
		<%=(pZ2.getCustomerType()==0)?"父親":"負責人"%><br> 
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
				教育程度:
		<%
		if(degree==null)
		{
		%>
			請先設定教育程度
		<%
		}else{
		%>
			<select name=studentFatherDegree size=1>
			<%
				for(int j=0;j<degree.length;j++)
				{
			%>
				<option value="<%=degree[j].getId()%>"><%=degree[j].getDegreeName()%>
			<%
				}
			%>
			</select>
		<%
		}

        if(pZ2.getCustomerType()==0){
        %>

		職業: <input type=text name="studentFathJob" size=10>
		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>

        <%  }else{  %>
            <input type=hidden name="studentFathJob" value="">
        <%  }   %>
		</td>
		</tr>
		
		<tr>
			<td>
				<div id="needPhone1"></div>
			</td><td>	
				手機1: <input type=text name="studentFatherMobile" size=10>
				手機2: <input type=text name="studentFatherMobile2" size=10>
			</tD>
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
				</div><%=(pZ2.getCustomerType()==0)?"母親":"聯絡人"%><br>
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
		
				教育程度: 
				<%
				if(degree==null)
				{
				%>
					請先設定教育程度
				<%
				}else{
				%>
					<select name=studentMothDegree size=1>
					<%
						for(int j=0;j<degree.length;j++)
						{
					%>
						<option value="<%=degree[j].getId()%>"><%=degree[j].getDegreeName()%>
					<%
						}
					%>
					</select>
				<%
				}

                if(pZ2.getCustomerType()==0){
				%>		
				職業: <input  type=text name="studentMothJob" size=10>						
				<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
                <%  }else{  %>
                    <input type=hidden name="studentMothJob" value="">
                <%  }   %>

		</td>
		</tr>
		<tr>
			<tD>
				<div id="needPhone2"></div>
			</td>
			<td>	
				手機1: <input type=text name="studentMotherMobile" size=10 onkeyup="up3tab(this,10,'studentMotherMobile2')">
				手機2: <input type=text name="studentMotherMobile2" size=10 onkeyup="up3tab(this,10,'motheSkype')">
			</tD>
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

	    <%
        if(pZ2.getCustomerType()==0){
        %>
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

        <%
        }else{
        %>
            <input type=hidden name="rRelation" value="0">
        <%  }   %>
	</td>
	</tr>
	<tr>
		<td>
			<div id="needPhone3"></div>
		</td>
		<td>	
			手機1: <input   type=text name="rMobile" size=10>
			
			電話1:<input  type=text name="rPhone" size=10>	
			電話2:<input type=text name="rPhone2" size=10>
		</td>
	</tr>
	<tr>
		<td></td>
		<td>		
			備註:<textarea  name="rPs" rows=3 cols=30></textarea>
		</tD>
	</tr>
	</table>
	
	</td>
</tr>		
<tr bgcolor=#ffffff align=left valign=middle class=es02><td class=es02 bgcolor="#f0f0f0">
<%=(pZ2.getCustomerType()==0)?"家中電話":"公司電話"%></td><td>
<input type=hidden name="phoneDefault" value=1>
電話1: <input  type=text name="studentPhone" size=10>
&nbsp;&nbsp;&nbsp;電話2: <input type=text name="studentPhone2" size=10>
&nbsp;&nbsp;&nbsp;傳真: <input type=text name="studentPhone3" size=10><br>
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



	<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0"><%=(pZ2.getCustomerType()==0)?"入學狀態":"狀態設定"%></td>
			<td class=es02>
            <%
                if(pZ2.getCustomerType()==0){
			%>
            	<table border=0 class=es02>
					<tr> 
						<td bgcolor=f0f0f0>
							<font color=blue>潛在學生</font>
							<input type=radio name="studentStatus" value=1 >參觀登記/上網登入
							<input type=radio name="studentStatus" value=2>報名/等待入學
						</tD>
						<td>
						<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=5',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>
					</tr>
					<tr>
						<td bgcolor=f0f0f0><font color=blue>就&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;讀:</font>
							<input type=radio name="studentStatus" value=3>試讀
							<input type=radio name="studentStatus" value=4 checked>入學
						</td>
						<td>
								<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=6',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>
					</tr>
				</table>
            <%  }else{  %>
                <input type=radio name="studentStatus" value=1>潛在客戶
                <input type=radio name="studentStatus" value=4 checked>正式客戶
            <%  }   %>
			</td></tr>

  <%
        ArrayList<TagType> tagtypes = TagTypeMgr.getInstance().retrieveListX("", "", _ws.getStudentBunitSpace("bunitId"));
        TagHelper th = TagHelper.getInstance(pZ2, 0, _ws.getSessionStudentBunitId());
        ArrayList<Tag> tags = th.getTags(false, "", _ws.getStudentBunitSpace("bunitId"));
        // tagtype Id
        Map<Integer, Vector<Tag>> tagMap = new SortingMap(tags).doSort("getTypeId");
        Iterator<TagType> titer = tagtypes.iterator();


        while (titer.hasNext()) { 
            TagType tt = titer.next(); 
  %>

            <tr bgcolor=#ffffff align=left valign=middle>
            <td  bgcolor=#f0f0f0  class=es02><%=tt.getName()%></td>
            <td class=es02>    
            <%

                Vector<Tag> tv = tagMap.get(tt.getId());
                out.println(getCheckboxes(tv, null));
            %>
            </td>
            </tr>
      <%}%>
          
<tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>標籤-未定</td>
    <td class=es02>
        <% out.println(getCheckboxes(tagMap.get(0), null)); %>
    </td>
</tr>

		<input type="hidden" name="studentBank1" value="">
		<input type="hidden" name="studentAccountNumber1" value="">
		<input type="hidden" name="studentBank2" value="">
		<input type="hidden" name="studentAccountNumber2" value="">


	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">備註</td>
		<td>
			<textarea name=studentPs rows=6 cols=50></textarea>
		</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td colspan=2>
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

    function doclick () {
        var d = document.getElementById("addc_" + this.id);
        if (this.checked) {
            var c = b[this.id];
            if (c!=null && c.length>0) {
                d.innerHTML = '<input type=checkbox name="addc_'+this.id+'" value="1"> 加入 ' + c;
            }
        }
        else
            d.innerHTML = '';
    }

    var a = new Array;
    var b = new Array;
<%
    for (int i=0; i<tags.size(); i++) {
      %>a[<%=i%>] = <%=tags.get(i).getId()%>;
        b[<%=tags.get(i).getId()%>] = '<%=phm.util.TextUtil.escapeJSString(th.getBillChargeItemStringInChain(tags, tags.get(i)))%>';
      <%
    }
%>
    for (var i=0; i<a.length; i++) {
        var d = document.getElementById("tagId_" + a[i]);
        d.id = a[i];
        d.onclick = doclick;
    }
</script>


</body>

<%@ include file="bottom.jsp"%>	