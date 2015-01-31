<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
 
<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}
//  End -->
</script> 

<script> 
	function goX()
	{ 
		window.location.reload();
	}
</script>
<%
    if(!AuthAdmin.authPage(ud2,3))
    {
        response.sendRedirect("authIndex.jsp?page=5&info=1");
    }


	DecimalFormat mnf = new DecimalFormat("###,###,##0"); 


	String syear=request.getParameter("year");
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	
	SalaryTypeMgr stm=SalaryTypeMgr.getInstance();
	String smonth=request.getParameter("month");
	String seleString="";
	
	if(smonth !=null)
		seleString=smonth;
	
	String mo=request.getParameter("mo");
	
	String[] newdate=jt.getSalaryDate();
	
		
	SalaryAdmin sa=SalaryAdmin.getInstance();
	
	Date xa=new Date();

	
	Position[] po=ja.getAllPosition();
	Classes[] cl=ja.getAllActiveClasses();
	
	if(po==null)
	{
		out.println("<br><br><blockquote>尚未設定職位</blockquote>");
%>
		<%@ include file="bottom.jsp"%>
<%		
		return;
	}
%>
 
 
<br>
<b>&nbsp;&nbsp;依名單編輯薪資-個人</b>

<form action="addSalaryByPerson.jsp" method="post">

<table width="55%" border=0 cellpadding=4 cellspacing=1>
	<tr class=es02>
	<td valign=top>月份</td>
	<td valign=top>
		<select name="year" size=1>
				<option value="2006" <%=(syear==null && newdate[0].equals("2006"))?"selected":""%> <%=(syear !=null &&syear.equals("2006"))?"selected":""%>>2006</option>
				<option value="2007" <%=(syear==null && newdate[0].equals("2007"))?"selected":""%> <%=(syear !=null &&syear.equals("2007"))?"selected":""%>>2007</option>
				<option value="2008" <%=(syear==null && newdate[0].equals("2008"))?"selected":""%> <%=(syear !=null &&syear.equals("2008"))?"selected":""%>>2008</option>
				<option value="2009" <%=(syear==null && newdate[0].equals("2009"))?"selected":""%> <%=(syear !=null &&syear.equals("2009"))?"selected":""%>>2009</option>
				<option value="2010" <%=(syear==null && newdate[0].equals("2010"))?"selected":""%> <%=(syear !=null &&syear.equals("2010"))?"selected":""%>>2010</option>
			</select>	
		-
		<select name="month" size=1>
		<%
		for(int i=0;i<12;i++)
		{
			String sValue="";
			if(i<=8)
				sValue="0"+String.valueOf(i+1);
			else
				sValue=String.valueOf(i+1);
				
		%>
		<option value="<%=sValue%>"  <%=(seleString.length()<=0 &&sValue.equals(newdate[1]))?"selected":""%> <%=(seleString.length()>0 && sValue.equals(seleString))?"selected":""%>><%=i+1%></option>
		<%
		}
		%>
		</select>
	
	
	
	</td>
	<td  valign=top> 
	職稱:
	</td>
	<td valign=top>
<%

	String poIdS=request.getParameter("poId");
	String claIdS=request.getParameter("classId");
%>
	<select name=poId size=1>
	<option value=999 <%=(poIdS !=null && poIdS.equals("999"))?"selected":""%>>全部</option>
<%		
	for(int i=0;i<po.length;i++)
	{
%>
	<option value=<%=po[i].getId()%> <%=(poIdS !=null && poIdS.equals(String.valueOf(po[i].getId())))?"selected":""%>><%=po[i].getPositionName()%></option>
<%
	}
%>
		<option value=0 <%=(poIdS !=null && poIdS.equals("0"))?"selected":""%>>未定</option>
	</select>	

	</td>
	<td valign=top>
	班級:
	</td>
	<td>
	
	<select name="classId" size=1>
	<option value="999" <%=(claIdS !=null && claIdS.equals("999"))?"selected":""%>>全部</option>
	<option value="0" <%=(claIdS !=null && claIdS.equals("0"))?"selected":""%>>跨班</option>
<%
  	for(int i=0;cl!=null&&i<cl.length;i++)
  	{
%>
	  	<option value=<%=cl[i].getId()%> <%=(claIdS !=null && claIdS.equals(String.valueOf(cl[i].getId())))?"selected":""%>><%=cl[i].getClassesName()%></option>
<%
	}
%>
	</select>
	
		<input type=submit value="搜尋">
	</td>
	</form>
	</tr>
	</table>	

<%
	if(ud2.getUserRole()>2) 
	{  
%>	
		<br>
				<br>
				<font color=red>權限不足!</font>
 				<br>
				<br>
				由於本薪資含有非鐘點費的薪資,必須以<font color=blue>經營者</font>或<font color=blue>會計人員</font>的身份來編輯.
				
				<%@ include file="bottom.jsp"%>
<%
			return;
	}
%>


<%
if(poIdS==null)
{ 
	syear =newdate[0];
	smonth =newdate[1];
	poIdS ="999"; 
	claIdS="999";	
}
int poId=Integer.parseInt(poIdS);
int claId=Integer.parseInt(claIdS);


SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
Date runDate=sdf.parse(syear+"-"+smonth);

boolean SalaryStatus= JsfPay.SALARYStatus(runDate);


Teacher[] tea=sa.getTeacherByPositionClasses(poId,claId);

if(tea ==null)
 
{ 
	out.println("沒有名單<br>");
 
	return;
} 
 

out.println("<blockquote>");
for(int i=0;i<tea.length;i++)
{
%>
	<a href="addSalaryByPerson.jsp?year=<%=syear%>&month=<%=smonth%>&poId=<%=poId%>&classId=<%=claId%>&teaId=<%=tea[i].getId()%>"><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></a> | 
<%  
 
	int j=i+1;
	if(j>4 && j%10==0)
		out.println("<br>");
} 

out.println("</blockquote>");
%>	
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
	String teaIdS=request.getParameter("teaId");
	
	if(teaIdS ==null)
 
	{ 
		out.println("<br><blockquote><font color=blue>請點選上方的老師名單</font></blockquote><br>");
%>
		<%@ include file="bottom.jsp"%>
<%			
		return;
	} 

	int teaId=Integer.parseInt(teaIdS);
 
	
	TeacherMgr tm=TeacherMgr.getInstance();
 
  	Teacher t=(Teacher)tm.find(teaId);
 
  	 
  	if(t==null) 
	{
		out.println("<br><blockquote><font color=blue>沒有此老師</font></blockquote><br>");
 
%>
		<%@ include file="bottom.jsp"%>
<%		
		return;
	}
 
	
	SalaryTicket st=sa.getSalaryTicketByDateAndTeaId(runDate,t.getId());	
	Vector feeType1=new Vector();	
	Vector feeType2=new Vector(); 
	Vector feeType3=new Vector();
 
	Hashtable ha=new Hashtable();	
	
	
	if(st !=null)
	{ 
		SalaryFee[] sfs=sa.getSalaryFeeBySanumber(st.getSalaryTicketSanumberId());
		
		if(sfs !=null)
 
		{ 
			for(int j=0;j<sfs.length;j++)	
			{
				switch(sfs[j].getSalaryFeeType())
				{
					case 1:
						feeType1.add((SalaryFee)sfs[j]);
						break;							
					case 2:
						feeType2.add((SalaryFee)sfs[j]);
						break; 
					case 3:
						feeType3.add((SalaryFee)sfs[j]);
						break; 
					case 4:
						feeType1.add((SalaryFee)sfs[j]);
						break;									
					case 5:
						feeType1.add((SalaryFee)sfs[j]);
						break;									
						
				}
				ha.put((String)String.valueOf(sfs[j].getSalaryFeeTypeId()),(String)"1");		
			}		
		} 
	}
 %>



<blockquote>
	<b><%=syear%>-<%=smonth%> <font color=blue><%=t.getTeacherFirstName()%><%=t.getTeacherLastName()%></font> <img src="pic/fix.gif" border=0>個人修改</b>
	<%
		if(st !=null) 
		{ 
	%>			
		| <a href="salaryTicketDetailX.jsp?stNumber=<%=st.getSalaryTicketSanumberId()%>">薪資明細</a>	
	<%
		}
	%>
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td></td><td width=180><b>應領所得/鐘點費</b></td><tD width=180><b>代扣</b></td><td width=180><b>應扣薪資</b></tD>
			<td width=100><b>薪資合計</b></td> 
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
			<td><font color=blue>已加入項目</font></tD>
			<td  bgcolor=#ffffff class=es02 valign=top>
<%
				if(feeType1.size()==0)
 
				{ 
					out.println("尚未加入");			
				}else
{ 
%>				
					<table width=175>	
						<tr bgcolor="f0f0f0" class=es02>
							<td>名稱</td><td>金額</td>
<td></td>
						</tr>
					<%
						for(int k=0;k<feeType1.size();k++)
 
						{ 
							SalaryFee  sf=(SalaryFee)feeType1.get(k); 
							SalaryType sts=(SalaryType)stm.find(sf.getSalaryFeeTypeId());

					%>		
						<tr class=es02> 
							<td><%=sts.getSalaryTypeName()%></td>
							<td align=right><%=mnf.format(sf.getSalaryFeeNumber())%></td>
							<td align=right>
 
							<%
								if(SalaryStatus)
								{
	 	 	 	
  							%>
								<a href="#" onClick="javascript:openwindow52a('<%=sf.getId()%>');return false">修改</a>
							<%
								}
							%>
							</td>
						</tr>
					<%
						}
					%>		

					</table>			
<%	
				
}
%>
			</td>
			<td  bgcolor=#ffffff class=es02  valign=top>
<%
				if(feeType2.size()==0)
 
				{ 
					out.println("尚未加入");			
				}else{ 
%>				
						<table width=175>	
						<tr bgcolor="f0f0f0" class=es02>
							<td>名稱</td><td>金額</td><td></td>
						</tr>

					<%
						for(int k=0;k<feeType2.size();k++)
						{ 
							SalaryFee  sf=(SalaryFee)feeType2.get(k); 
							SalaryType sts=(SalaryType)stm.find(sf.getSalaryFeeTypeId());

					%>		
						<tr class=es02>
 
							<td><%=sts.getSalaryTypeName()%></td>
							<td align=right><%=mnf.format(sf.getSalaryFeeNumber())%></td>
							<td align=right>
 
							<%
								if(SalaryStatus)
								{
	 	 	 	
  							%>
								<a href="#" onClick="javascript:openwindow52a('<%=sf.getId()%>');return false">修改</a>
							<%
								}
							%>
							</td>
						</tr>
					<%
						}
					%>		

					</table>			
				<%	
								
				}
				%>
			</td>
			<td  bgcolor=#ffffff class=es02 valign=top> 
			
	<%
				if(feeType3.size()==0)
				{ 
					out.println("尚未加入");			
				}else{ 
	%>				
					<table width=175>	
						<tr bgcolor="f0f0f0" class=es02>
							<td>名稱</td><td>金額</td><td></td>
						</tr>
					<%
						for(int k=0;k<feeType3.size();k++)
						{ 
							SalaryFee  sf=(SalaryFee)feeType3.get(k); 
							SalaryType sts=(SalaryType)stm.find(sf.getSalaryFeeTypeId());

					%>		
						<tr class=es02>
							<td><%=sts.getSalaryTypeName()%></td>
							<td><%=mnf.format(sf.getSalaryFeeNumber())%></td>
							<td>
 
							<%
								if(SalaryStatus)
								{
	 	 	 	
  							%>
								<a href="#" onClick="javascript:openwindow52a('<%=sf.getId()%>');return false">修改</a>
							<%
								}
							%>
							</td>
						</tr>
					<%
						}
					%>		

					</table>			
				<%	
				}
				%>
			</td>
 
			<td  bgcolor=#ffffff class=es02>
			</td>
		</tr>	
		<tr class=es02> 
			<td>合計</tD>
			<td align=right>
			<% 
					if(st ==null)
  					{
  						out.println("0");
  					}else{
 						out.println("<b>"+mnf.format(st.getSalaryTicketMoneyType1())+"</b>");
					}
				%>	
			</td>
			<td align=right>
			<% 
					if(st ==null)
  					{
  						out.println("0");
  					}else{
 						out.println("<b>"+mnf.format(st.getSalaryTicketMoneyType2())+"</b>");
					}
				%>	
			</td>
			<td align=right>
			<% 
					if(st ==null)
  					{
  						out.println("0");
  					}else{
 						out.println("<b>"+mnf.format(st.getSalaryTicketMoneyType3())+"</b>");
					}
				%>	
			
			</td>
 
			<td align=right> 
			<% 
					if(st ==null)
  					{
  						out.println("0");
  					}else{
 						out.println("<b>"+mnf.format(st.getSalaryTicketTotalMoney())+"</b>");
					}
				%>	
			</tD>
		</tr>	
		<tr bgcolor=#f0f0f0 class=es02>
			<td>尚未加入項目</tD>
			<td valign=top bgcolor=#ffffff class=es02>
 
				<%
					SalaryType[] isi=sa.getSalaryTypeByType(1);
					
					if(isi==null)
 
					{ 
						out.println("尚未加入項目");	
%>
						<br><br><blockquote><a href="addSalaryType1.jsp?type=1">新增項目</a></blockquote>
<%						
					}else{
%>
 

			<form action="addSalaryFeesWithPerson.jsp" method="post">
						<table class=es02 width=100%>
 
						<tr bgcolor="f0f0f0">
							<td>
								<input type="checkbox" onClick="this.value=check(this.form.type1)"><br><font color=blue>全選</font>
							</td>
<td>名稱</tD><td>金額</tD>
						</tr>
<%
 

						boolean showButton1=false;
						for(int k=0;k<isi.length;k++)
 
						{ 
 
							if(ha.get(String.valueOf(isi[k].getId()))!=null)	 
								 continue;
							
							boolean couldCheck=true;
							SalaryNumber sn=null;
							if(isi[k].getSalaryTypeFixNumber()==1)
							{
								sn=sa.getSalaryNumberByTeacherId(isi[k].getId(),teaId);
								
								if(sn ==null)	
									couldCheck=false;
									
							}		
							
							
						
%>
						<tr>
							<td> 
								<%
								if(couldCheck){
									showButton1 =true;
								%>
									<input type=checkbox name="type1" value=<%=isi[k].getId()%>>
								<%
									}
								%>	
							</td>
							<td><%=isi[k].getSalaryTypeName()%></tD>
							<td>
							<%
								if(isi[k].getSalaryTypeFixNumber()==1)
								{
	
									if(sn==null)
 
									{  
							%>		
										<a href="modifySalaryType1a.jsp?stId=<%=isi[k].getId()%>">尚未預設</a>
							<%
									} else{ 
										out.println(sn.getSalaryNumberMoneyNumber());		
%>
										<input type=hidden name="n<%=isi[k].getId()%>" value="<%=sn.getSalaryNumberMoneyNumber()%>" size=5>
<%
									}

								}else{
							%>
								<input type=text name="n<%=isi[k].getId()%>" value="0" size=5>
 
							<%		
								}		
							%>
							
							</tD>
						</tr>
<%						
						} 
 
 
						
						if(showButton1)
  						{
 %>
 
						<tr>
							<td colspan=3 align=center> 
 
							<%
								if(SalaryStatus)
								{
							%>
								<input type=hidden name="year" value="<%=syear%>">
								<input type=hidden name="month" value="<%=smonth%>">
								<input type=hidden name="teaId" value="<%=teaId%>">
 
								<input type=hidden name="poId" value="<%=poIdS%>">
								<input type=hidden name="classId" value="<%=claIdS%>">
								<input type=submit value="加入">
							<%
								}else{
									out.println("<font color=red><img src=\"pic/warning.gif\" border=0>本月已結算,不得修改</font>");
								}
							%>
							</td>
						</tr> 
			<%
						}
			%>
						</table>
 
					 </form>
<%
					} 
%>
			</td>
			<td valign=top bgcolor=#ffffff class=es02>
 
				<%
					isi=sa.getSalaryTypeByType(2);
					
					if(isi==null)
					{ 
						out.println("尚未加入項目");	
%>
						<br><br><blockquote><a href="addSalaryType1.jsp?type=1">新增項目</a></blockquote>
<%						
					}else{
%>
 

			<form action="addSalaryFeesWithPerson.jsp" method="post">
					<table class=es02 width=100%>
						<tr bgcolor="f0f0f0">
							<td>
								<input type="checkbox" onClick="this.value=check(this.form.type1)"><br><font color=blue>全選</font>
							</td>
							<td>名稱</tD><td>金額</tD>
						</tr>

<%
						boolean showButton2=false;

						for(int k=0;k<isi.length;k++)
						{ 
 
							if(ha.get(String.valueOf(isi[k].getId()))!=null)	 
								 continue;
							
							boolean couldCheck=true;
							SalaryNumber sn=null;
							if(isi[k].getSalaryTypeFixNumber()==1)
							{
								sn=sa.getSalaryNumberByTeacherId(isi[k].getId(),teaId);
								
								if(sn ==null)	
									couldCheck=false;
									
							}		
							
							
						
%>
						<tr class=es02>
							<td> 
								<%
								if(couldCheck){
									showButton2 =true;
								%>
									<input type=checkbox name="type1" value=<%=isi[k].getId()%>>
								<%
									}
								%>	
							</td>
							<td><%=isi[k].getSalaryTypeName()%></tD>
							<td>
							<%
								if(isi[k].getSalaryTypeFixNumber()==1)
								{
	
									if(sn==null)
 
									{  
							%>		
										<a href="modifySalaryType1a.jsp?stId=<%=isi[k].getId()%>">尚未預設</a>
							<%
									} else{ 
										out.println(sn.getSalaryNumberMoneyNumber());		
%>
										<input type=hidden name="n<%=isi[k].getId()%>" value="<%=sn.getSalaryNumberMoneyNumber()%>" size=5>
<%
									}

								}else{
							%>
								<input type=text name="n<%=isi[k].getId()%>" value="0" size=5>
 
							<%		
								}		
							%>
							
							</tD>
						</tr>
<%						
						} 
 
						
						if(showButton2)
  						{
 				 
%>
 
						<tr>
							<td colspan=3 align=center> 
 
							<%
								if(SalaryStatus)
								{
							%>
 								<input type=hidden name="year" value="<%=syear%>">
								<input type=hidden name="month" value="<%=smonth%>">
								<input type=hidden name="teaId" value="<%=teaId%>">
 
								<input type=hidden name="poId" value="<%=poIdS%>">
								<input type=hidden name="classId" value="<%=claIdS%>">
 								<input type=submit value="加入">
 								
 							<%
								}else{
									out.println("<font color=red><img src=\"pic/warning.gif\" border=0>本月已結算,不得修改</font>");
								}
							%>

							</td>
						</tr>
					<%
						}
					%>						
						
						</table>
 
					 </form>
<%
					} 
%>
			
			
			
			</td>
			<td valign=top bgcolor=#ffffff class=es02>
			<%
					isi=sa.getSalaryTypeByType(3);
					
					if(isi==null)
					{ 
						out.println("尚未加入項目");	
%>
						<br><br><blockquote><a href="addSalaryType1.jsp?type=1">新增項目</a></blockquote>
<%						
					}else{
%>
			<form action="addSalaryFeesWithPerson.jsp" method="post">
						<table class=es02 width=100%>			
						<tr bgcolor="f0f0f0">
							<td>
								<input type="checkbox" onClick="this.value=check(this.form.type1)"><br><font color=blue>全選</font>
							</td>
							<td>名稱</tD><td>金額</tD>
						</tr>

<%
 

						boolean showButton3=false;						
						for(int k=0;k<isi.length;k++)
						{ 
 
							if(ha.get(String.valueOf(isi[k].getId()))!=null)	 
								 continue;
							
							boolean couldCheck=true;
							SalaryNumber sn=null;
							if(isi[k].getSalaryTypeFixNumber()==1)
							{
								sn=sa.getSalaryNumberByTeacherId(isi[k].getId(),teaId);
								
								if(sn ==null)	
									couldCheck=false;
									
							}		
							
							
						
%>
						<tr class=es02>
							<td> 
								<%
								if(couldCheck){
									showButton3 =true;
								%>
									<input type=checkbox name="type1" value=<%=isi[k].getId()%>>
								<%
									}
								%>	
							</td>
							<td><%=isi[k].getSalaryTypeName()%></tD>
							<td>
							<%
								if(isi[k].getSalaryTypeFixNumber()==1)
								{
	
									if(sn==null)
 
									{  
							%>		
										<a href="modifySalaryType1a.jsp?stId=<%=isi[k].getId()%>">尚未預設</a>
							<%
									} else{ 
										out.println(sn.getSalaryNumberMoneyNumber());		
%>
										<input type=hidden name="n<%=isi[k].getId()%>" value="<%=sn.getSalaryNumberMoneyNumber()%>" size=5>
<%
									}

								}else{
							%>
								<input type=text name="n<%=isi[k].getId()%>" value="0" size=5>
 
							<%		
								}		
							%>
							
							</tD>
						</tr>
<%						
						} 
  
   						if(showButton3)
   						{
%>
 
						<tr>
							<td colspan=3 align=center> 
 
 	 	 	 	 	 	 	<%
								if(SalaryStatus)
								{
							%>

								<input type=hidden name="year" value="<%=syear%>">
								<input type=hidden name="month" value="<%=smonth%>">
								<input type=hidden name="teaId" value="<%=teaId%>">
								<input type=hidden name="poId" value="<%=poIdS%>">
								<input type=hidden name="classId" value="<%=claIdS%>">
								<input type=submit value="加入">
 
							<%
								}else{
									out.println("<font color=red><img src=\"pic/warning.gif\" border=0>本月已結算,不得修改</font>");
								}
							%>

							</td>
						</tr>
 
						<% 
						}
						%>
						</table>
 
					 </form>
<%
					} 
%>
			
			</td> 
			<td bgcolor="ffffff"></tD>
		</tr>	
		</table>

		</td>
		</tr>
		</table>
		
		</blockquote>
		<br>
		<br>
    <%@ include file="bottom.jsp"%>

