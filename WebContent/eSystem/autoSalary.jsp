<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<link rel="stylesheet" href="style.css" type="text/css">
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
%> 
<br>
<br>


<b>&nbsp;&nbsp;&nbsp;編輯薪資-<img src="pic/auto.gif" border=0>自動產生</b>
<blockquote>
	<form action="autoSalary.jsp" method="post">

	<table width="" border=0>
		<tr class=es02>
		<td valign=top>產生月份</td>
		<td valign=top>
			<select name="year" size=1 onchange="this.form.submit();">
					<option value="2006" <%=(syear==null && newdate[0].equals("2006"))?"selected":""%> <%=(syear !=null &&syear.equals("2006"))?"selected":""%>>2006</option>
					<option value="2007" <%=(syear==null && newdate[0].equals("2007"))?"selected":""%> <%=(syear !=null &&syear.equals("2007"))?"selected":""%>>2007</option>
					<option value="2008" <%=(syear==null && newdate[0].equals("2008"))?"selected":""%> <%=(syear !=null &&syear.equals("2008"))?"selected":""%>>2008</option>
					<option value="2009" <%=(syear==null && newdate[0].equals("2009"))?"selected":""%> <%=(syear !=null &&syear.equals("2009"))?"selected":""%>>2009</option>
					<option value="2010" <%=(syear==null && newdate[0].equals("2010"))?"selected":""%> <%=(syear !=null &&syear.equals("2010"))?"selected":""%>>2010</option>
				</select>	
			-
			<select name="month" size=1 onchange="this.form.submit();">
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
		<td>
				<input type=submit value="搜尋">
				</form>
			</td>
		</tr>
	</table>	
</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
	if(syear==null)
	{ 
		syear =newdate[0];
		smonth =newdate[1];
	}
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Date runDate=sdf.parse(syear+"-"+smonth); 

	boolean SalaryStatus= JsfPay.SALARYStatus(runDate);

	if(!SalaryStatus)
	{ 
		out.println("<blockquote><br><font color=red><img src=\"pic/warning.gif\" border=0>本月已結算,不得新增或修改!</font></blockquote>");
 
		return;				
	}

%>
   
<blockquote>   
			<b>薪資月份:</b><%=sdf.format(runDate)%>
			<br>
			<br>			
			<b>將產生薪資項目</b>
			<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
			<tr align=left valign=top>
			<td bgcolor="#e9e3de">

			<table width="100%" border=0 cellpadding=4 cellspacing=1>
					<tr class=es02>
						<tD>應領所得</tD>
						<td>代扣</td>
						<td>應扣薪資</td>
					</tr>
					<tr bgcolor=#ffffff class=es02>
						<td valign=top>
						<%
							SalaryType[] isi=sa.getSalaryTypeByTypeFixNumber(1,1);
							
							if(isi==null)
							{ 
								out.println("沒有符合的項目");	
							}else{
						%>
  						<table class=es02 width=100%>
							<tr bgcolor="f0f0f0">
								<td>名稱</tD><td></tD>
							</tr>
							<%
								for(int j=0;j<isi.length;j++) 
								{ 
							%>
								<tr>
									<td><%=isi[j].getSalaryTypeName()%></tD>
									<td> 
										<a href="modifySalaryType1a.jsp?stId=<%=isi[j].getId()%>">編輯預設值</a>
									</tD>
							<%
								}
							%>
						</table>				
  						<%
  							}
  						%>

						</tD>
					  	<td valign=top>  
					  	<%
							isi=sa.getSalaryTypeByTypeFixNumber(2,1);
							
							if(isi==null)
							{ 
								out.println("沒有符合的項目");	
							}else{
						%>
  						<table class=es02 width=100%>
							<tr bgcolor="f0f0f0">
								<td>名稱</tD><td></tD>
							</tr>
							<%
								for(int j=0;j<isi.length;j++)
 
								{ 
							%>
								<tr>
									<td><%=isi[j].getSalaryTypeName()%></tD>
									<td> 
										<a href="modifySalaryType1a.jsp?stId=<%=isi[j].getId()%>">編輯預設值</a>
									</tD>
							<%
								}
							%>
						</table>				
  						<%
  							}
  						%>

					  	</tD>
					  	<td valign=top>
  
					  	<%
							isi=sa.getSalaryTypeByTypeFixNumber(3,1);
							
							if(isi==null)
							{ 
								out.println("沒有符合的項目");	
							}else{
						%>
  						<table class=es02 width=100%>
							<tr bgcolor="f0f0f0">
								<td>名稱</tD><td></tD>
							</tr>
							<%
								for(int j=0;j<isi.length;j++)
 
								{ 
							%>
								<tr>
									<td><%=isi[j].getSalaryTypeName()%></tD>
									<td> 
										<a href="modifySalaryType1a.jsp?stId=<%=isi[j].getId()%>">編輯預設值</a>
									</tD>
							<%
								}
							%>
						</table>				
  						<%
  							}
  						%>

					  	</tD>

					 </tr>
				</table> 	
				</td>
				</tr>
				</table>
			
			<br>
			<br>
			<b>薪資名單</b>
	<%
	int order=0;
	
	Teacher[] tea=ja.getActiveTeacher(0);

	if(tea ==null)
  	{
  		out.println("沒有資料");
 
  		return;
  	}

	Hashtable ha=new Hashtable();
 
	ClassesMgr cm=ClassesMgr.getInstance();
	Classes[] cl=ja.getAllClasses2(); 

	for(int i=0;i<tea.length;i++)
	{  
		int classId=tea[i].getTeacherClasses();
		Vector v=(Vector)
		ha.get((String)String.valueOf(classId));
		
		
		if(v==null)	
		{
			v=new Vector();
			v.add(tea[i]);
			ha.put(String.valueOf(classId),(Vector)v);
		} else{
			v.add(tea[i]);
 
			ha.put(String.valueOf(classId),(Vector)v);
		}
	} 
	
	%>		
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>班級</td><td>跨班</td>
			<% 
			if(cl !=null)
  			{
 				for(int k=0;k<cl.length;k++) 
				{ 
			%>
				<tD><%=cl[k].getClassesName()%></tD>
			<%
				} 
			}
			%>			
 		</tr>
		<tr  bgcolor=#ffffff class=es02>

			<td bgcolor=#f0f0f0>人數</td>
 			<td>
 				<%
 					int totalNum=0;
 					Vector v0=(Vector)ha.get("0"); 
 					if(v0==null)	
 					{
 						out.println("0");
 					}else{
 					  	out.println(v0.size());
 					} 
 				%>		
 			</td>
			<%
			if(cl !=null)
  			{
 				for(int k=0;k<cl.length;k++)
				{ 
			%>
				<tD>
				<%
					Vector v2=(Vector)ha.get(String.valueOf(cl[k].getId())); 
 					
 					if(v2==null)	
 					{
 						out.println("0");
 					}else{
 					  	out.println(v2.size());
 					} 
				%>
				</tD>
			<%
				}
			}
			%>	
		</tr> 
		<tr>
			<td bgcolor=f0f0f0  class=es02>名單</tD>
 			<td bgcolor=ffffff  class=es02 valign=top>
				<%
					if(v0!=null)
					{ 
						for(int k=0;k<v0.size();k++)	
						{ 
							totalNum++;
							Teacher tea2=(Teacher)v0.elementAt(k);
						%>
						<a href="#" onClick="javascript:openwindow16('<%=tea2.getId()%>');return false"><font color=blue><%=tea2.getTeacherFirstName()%><%=tea2.getTeacherLastName()%></font></a>,
			<%			
							int ki=k+1;
							if(ki>2 &&ki%3==0)
								 out.println("<br>");
						}				
					} 
				%> 			
 			</td>		
	<%
		for(int j=0;cl!=null && j<cl.length;j++)
		{  
			out.println("<td  bgcolor=ffffff class=es02  valign=top>");
		
 					Vector v1=(Vector)ha.get((String)String.valueOf(cl[j].getId())); 
 					
					if(v1!=null)
					{ 
						for(int k=0;k<v1.size();k++)	
						{ 
							totalNum++;
							Teacher tea2=(Teacher)v1.elementAt(k);
	%>		
							<a href="#" onClick="javascript:openwindow16('<%=tea2.getId()%>');return false"><font color=blue><%=tea2.getTeacherFirstName()%><%=tea2.getTeacherLastName()%></font></a>,
	<% 
							int ki=k+1;
							if(ki>3 &&ki%4==0)
								 out.println("<br>");

						}				
					}
			out.println("</td>"); 
		}
	%>		
		


 		</tr>

	
	
 	</table>
 		
 		</tD>
 		</tR>
 		</table>
		
		<center>
			<form action="autoSalary2.jsp"  method="post">	
				<input type=hidden name="year" value="<%=syear%>">
				<input type=hidden name="month" value="<%=smonth%>">
					<input type=submit value="自動產生" onClick="return(confirm('確認產生?'))">
			</form>		
		</centeR>
</blockquote>