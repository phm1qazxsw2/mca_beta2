
<br> 
<div align=left><b>&nbsp;&nbsp;&nbsp;基本資料
</b></div> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>幼生姓名</td>
		<td bgcolor=ffffff><input class="textInput" type=text size=20 name="studentName" value="<%=stu.getStudentName()%>" size=6></td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>English Name</td>
		<td bgcolor=ffffff><input name="studentNickname" value="<%=stu.getStudentNickname()%>" size=20></td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>性別</td>
		<td bgcolor=ffffff>
			<input type=radio size=20 name="studentSex" value="1" <%=(stu.getStudentSex()==1)?"checked":""%>>男
 			<input type=radio size=20 name="studentSex" value="2" <%=(stu.getStudentSex()==2)?"checked":""%>>女
 		</td>
 	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>出生年月</td>
		<td bgcolor=ffffff>
			<input name="studentBirth" value="<%=jt.ChangeDateToString(stu.getStudentBirth())%>" size=10> 
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>同胞人數</td>
		<td bgcolor=ffffff>
			兄<input  class="textInput" type=text size=5 name="studentBrother" size=6 value="<%=stu.getStudentBrother()%>">人,
			姐<input  class="textInput" type=text size=5 name="studentBigSister" size=6 value="<%=stu.getStudentBigSister()%>">人,
			弟<input  class="textInput" type=text size=5 name="studentYoungBrother" size=6 value="<%=stu.getStudentYoungBrother()%>">人,
			妹<input  class="textInput" type=text size=5 name="studentYoungSister" size=6 value="<%=stu.getStudentYoungSister()%>">人

		</td>
	</tr> 
	<tr bgcolor=#f0f0f0 class=es02><td>父親</td>
		<td bgcolor=ffffff>
			姓名:<input  class="textInput" type=text name="studentFather" value="<%=stu.getStudentFather()%>" size=6>
			職業<input  class="textInput" type=text name="studentFathJob" value="<%=stu.getStudentFathJob()%>" size=6>
			教育程度
			<%
			if(degree==null)
			{
			%>
				請先設定教育程度
			<%
			}
			else
			{
			%>
				<select name=studentFatherDegree size=1>
				<%
					for(int j=0;j<degree.length;j++)
					{
				%>
					<option value="<%=degree[j].getId()%>" <%=(degree[j].getId()==stu.getStudebtFatherDegree())?"selected":""%>><%=degree[j].getDegreeName()%>
				<%
					}
				%>
				</select>
			<%
			}
			%>		
			<br>
			<input type=radio name=emailDefault value="1" <%=(stu.getStudentEmailDefault()==1)?"checked":""%>>(預設)
			email <input  class="textInput" type=text name="studentFatherEmail" value="<%=stu.getStudentFatherEmail()%>" size=30 onblur="emailCheck(this)">
			<br>
			<input type=radio name=mobileDefault value="1" <%=(stu.getStudentMobileDefault()==1)?"checked":""%>>(預設)
			手機1<input  class="textInput" type=text name="studentFatherMobile" value="<%=stu.getStudentFatherMobile()%>" size=10>
			<input type=radio name=mobileDefault value="2" <%=(stu.getStudentMobileDefault()==2)?"checked":""%>>(預設)
			手機2<input  class="textInput" type=text name="studentFatherMobile2" value="<%=stu.getStudentFatherMobile2()%>" size=10>
			<br>
			<input type=radio name=skypeDefault value="1" <%=(stu.getStudentSkypeDefault()==1)?"checked":""%>>(預設)
			Skype ID <input type=text  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" name="fatherSkype" value="<%=stu.getStudentFatherSkype()%>" size=15>
		</td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>母親</td>
			<td bgcolor=ffffff>
				姓名:<input  class="textInput" type=text name="studentMother" value="<%=stu.getStudentMother()%>" size=6>
				職業<input  class="textInput" type=text name="studentMothJob" value="<%=stu.getStudentMothJob()%>" size=6>
				教育程度
				<%
				if(degree==null)
				{
				%>
					請先設定教育程度
				<%
				}
				else
				{
				%>
					<select name=studentMothDegree size=1>
					<%
						for(int j=0;j<degree.length;j++)
						{
					%>
						<option value="<%=degree[j].getId()%>"  <%=(degree[j].getId()==stu.getStudentMothDegree())?"selected":""%>><%=degree[j].getDegreeName()%>
					<%
						}
					%>
					</select>
				<%
				}
				%>		
				<br>
				<input type=radio name=emailDefault value="2" <%=(stu.getStudentEmailDefault()==2)?"checked":""%>>(預設)
				email <input  class="textInput" type=text name="studentMotherEmail" value="<%=stu.getStudentFatherEmail()%>" size=30 onblur="emailCheck(this)">	
				<br>
				<input type=radio name=mobileDefault value="3" <%=(stu.getStudentMobileDefault()==3)?"checked":""%>>(預設)
				手機1 <input  class="textInput" type=text name="studentMotherMobile" value="<%=stu.getStudentMotherMobile()%>" size=10>
				<input type=radio name=mobileDefault value="4" <%=(stu.getStudentMobileDefault()==4)?"checked":""%>>(預設)
				手機2 <input  class="textInput" type=text name="studentMotherMobile2"  value="<%=stu.getStudentMotherMobile2()%>" size=10>
				<br>
				<input type=radio name=skypeDefault value="2" <%=(stu.getStudentSkypeDefault()==2)?"checked":""%>>(預設)
				Skype ID <input type=text  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" name="motherSkype" value="<%=stu.getStudentMotherSkype()%>" size=15>
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<tD>家中電話</td>
		<td bgcolor=ffffff>
			<input type=radio name=phoneDefault value="1" <%=(stu.getStudentPhoneDefault()==1)?"checked":""%>>(預設)
			家中電話1<input type=text name="studentPhone" size=10 value="<%=stu.getStudentPhone()%>"><br>
			<input type=radio name=phoneDefault value="2" <%=(stu.getStudentPhoneDefault()==2)?"checked":""%>>(預設)
			家中電話2<input type=text name="studentPhone2" size=10 value="<%=stu.getStudentPhone2()%>"><br>
			<input type=radio name=phoneDefault value="3" <%=(stu.getStudentPhoneDefault()==3)?"checked":""%>>(預設)
			家中電話3<input type=text name="studentPhone3" size=10 value="<%=stu.getStudentPhone3()%>">
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>地址</td>
		<td bgcolor=ffffff>
        郵遞區號:<input type=text name="studentZipCode" size=5 value="<%=stu.getStudentZipCode()%>"><a href="http://www.post.gov.tw/post/internet/f_searchzone/index.jsp?ID=190102" target="_blank"><font size=2>查詢</font></a> 
		住址: 	
		<input type=text name="studentAddress" size=40 value="<%=stu.getStudentAddress()%>">
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>接送方式</td>
		<td bgcolor=ffffff>
			<input type="radio" name="studentGohome" value="1" <%=(stu.getStudentGohome()==1)?"checked":""%>>自接送
			<input type="radio" name="studentGohome" value="2" <%=(stu.getStudentGohome()==2)?"checked":""%>>乘坐娃娃車
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02><tD>是否曾經上學</td>
	<td bgcolor=ffffff>
		<input type="radio" name="studentSchool" value="0" <%=(stu.getStudentSchool()==0)?"checked":""%>>否
		<input type="radio" name="studentSchool" value="1" <%=(stu.getStudentSchool()==1)?"checked":""%>>是
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>幼兒特殊狀況</td>
		<td bgcolor=ffffff>
			<textarea  class="textInput" name=studentSpecial rows=10 cols=40><%=stu.getStudentSpecial()%></textarea>
		</td>
	</tr> 
	<tr><td colspan=2><center><input type=submit onClick="checkYear2(); return(confirm('確認修改此筆資料?'))" value="修改"></center></td></tr>
	</table>
</td>
</tr>
</table>
</center>

<br>
<br>