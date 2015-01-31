<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
 
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%@ include file="jumpTop.jsp"%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
	if (checkflag == "false") {
		for (i = 0; i < field.length; i++) 
		{
			field[i].checked = true;
		}
		checkflag = "true";
		
		return "Uncheck All"; 
	}else {
		for (i = 0; i < field.length; i++) 
		{
			field[i].checked = false; 
		}
		checkflag = "false";
		return "Check All"; 
	}
}
//  End -->
</script>


<%
    PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem ps=(PaySystem)em.find(1);

	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd"); 
	JsfAdmin ja=JsfAdmin.getInstance();

	String typeS=request.getParameter("x");
	String classIdS= request.getParameter("y");
	String groupS= request.getParameter("z");

%>

<br>
<form action="addGroupMessage2.jsp" method="post"> 
<b><img src="pic/mobile2.gif" border=0>發送簡訊-群組</b>

<center>
<table>
		<td class=es02> 
			群組
			<select name="type" size=1 onChange="getMessageList(this.form.type.value,this.form.classId.value,1)">	
				<option value=0 <%=(typeS !=null && typeS.equals("0")?"selected":"")%>>全部</option>
				<option value=1 <%=(typeS !=null && typeS.equals("1")?"selected":"")%>>行政</option>
				<option value=2 <%=(typeS !=null && typeS.equals("2")?"selected":"")%>>老師</option>
				<option value=3 <%=(typeS !=null && typeS.equals("3")?"selected":"")%>>學生</option>
			</select>
			</select>	
			班級
			<select name="classId" size=1 onChange="getMessageList(this.form.type.value,this.form.classId.value,1)">
			
				<option value="999" <%=(classIdS !=null && groupS!=null && groupS.equals("1") &&classIdS.equals("999")?"selected":"")%>>全部</option>
			<%
			Classes[] cl=ja.getAllClasses2();
			
			if(cl !=null)
			{ 
			
				for(int k=0;cl!=null&&k<cl.length;k++)
				{
				%>	
				<option value="<%=cl[k].getId()%>" <%=(classIdS !=null && classIdS.equals(String.valueOf(cl[k].getId()))?"selected":"")%>>
				<%
					out.println(cl[k].getClassesName());
				%>
				</option>
				
			<%
				}
			} 
			%>	
				<option value="0" <%=(classIdS !=null && classIdS.equals("0"))?"selected":""%>>未定</option>
			
            </select> 
            or 才藝班 
			<% 
				Talent[] tal=ja.getActiveTalent();
			%>
			<select name="talentId" size=1 onChange="getMessageList(this.form.type.value,this.form.talentId.value,2)">
				<option>請選擇</option>
				<%
				for(int k=0;tal!=null&&k<tal.length;k++) 
				{ 
				%> 
				<option value="<%=tal[k].getId()%>" <%=(groupS!=null &&classIdS !=null && classIdS.equals(String.valueOf(tal[k].getId()))&& groupS.equals("2"))?"selected":""%>><%=tal[k].getTalentName()%></option>
				<%
				}
				%>
				
			</select>
		</td>
	</tr>
  </table> 
  </center>
   <br>
  <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
  <br>
    <div class=es02>
    &nbsp;&nbsp;&nbsp;&nbsp;<font color=red>*</font>目前學生發送對象設定為: 
    <%
        if(ps.getPaySystemMessageTo()==0)
        {
    %>
            <font color=blue>預設聯絡人</font>
    <%
        }else{
    %>
            <font color=blue>父母皆發送</font>
    <%
        }
    %>
    </div>  
<centeR>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	 	<tr bgcolor=#ffffff align=left valign=middle>
			<td bgcolor=#f0f0f0 class=es02 width=60>
				目前群組
			</td>
			<td class=es02>
	  			<div id="showGroup"></div> 
	  			
			</td>
	</tr>


 	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 width=60>名單
 			<br>
			<input type="checkbox" onClick="this.value=check(this.form.mobiles)">全選
		</td>
		<td class=es02> 
		
					
			<div id="realtime" name="realtime">
			<% 
			JsfPay jp=JsfPay.getInstance();

			if(typeS!=null && typeS.trim().length()>=1)
			{ 
				try{ 
					out.println(jp.getMessageList(Integer.parseInt(typeS),Integer.parseInt(classIdS),Integer.parseInt(groupS)));
				}catch(Exception ex){}
			}
			%>
			</div>
		</td>
	</tr>
	<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
				<td>簡訊內容</td>
				<td bgcolor=#ffffff>
					<textarea rows=5 cols=20 name="content"></textarea>
					<br>
	  				<font color=red>*</font>不得超過70個中文字
				</tD>
			</tr>
			<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
				<td colspan=2>
					 <center>
 						<input type=submit value="送出" onClick="retunr(confirm('確認送出?'))">
					</centeR>	
				</td>
			</tr>	
			</table>
		</td>
	</tr>
</table>

</form> 

</center>
