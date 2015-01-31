<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authindex.jsp?info=1&page=5");
    }

	String orderString=request.getParameter("order");
	String pageNum=request.getParameter("pageNum");
	
	int order=1;
	
	if(orderString !=null)
		order=Integer.parseInt(orderString);
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	Teacher[] tea=ja.getActiveTeacher(order);
	
	if(tea==null)
	{
		out.println("<br><br><blockquote>尚未設定老師資料</blockquote>");
%>
		<%@ include file="bottom.jsp"%>
<%		
		return;
	}
	
	int pageNumber=1;
	int teacherLength=tea.length;
%>
<script type="text/javascript" src="openWindow.js"></script> 
<script>
	
	function goReload(){
	
		window.location.reload();
	}

</script>

<br>
<b>&nbsp;&nbsp;&nbsp;薪資資料設定</b>
<br>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
 <br>
	
<center>
<%
	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
	int pageContent=e.getEsystemTeapage();
	
	if(pageNum!=null)
		pageNumber=Integer.parseInt(pageNum);
	
	int pageTotal=1;
	pageTotal=teacherLength/pageContent;
	
	if(teacherLength%pageContent!=0)
		pageTotal+=1;

	if(pageNumber !=1)
	{
		int lastPage=pageNumber-1;
		out.println("<a href=\"listSalaryData.jsp?order="+order+"&pageNum="+lastPage+"\">上一頁</a>");
	}
	for(int j=0;j<pageTotal;j++)
	{
		int jx=j+1;
		
		if(pageNumber==jx)
		{
			out.println("<b>"+jx+"頁</b>");
		
		}
		else
		{
			out.println("<a href=\"listSalaryData.jsp?order="+order+"&pageNum="+jx+"\">"+jx+"</a>");
		}
	}
	if(pageNumber !=pageTotal)
	{
		int lastPage=pageNumber+1;
		out.println("<a href=\"listSalaryData.jsp?order="+order+"&pageNum="+lastPage+"\">下一頁</a>");
	}

	
%>
<div align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共計: <font color=blue><b><%=teacherLength%></b></font> 筆資料</div>

	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td class=es02>姓名</td>
		<td>
			身份證字號
		</td>		
		<td>
			付款方式
		</td>	
		<tD> 
			薪轉帳號
		</tD> 
		
		<td class=es02>
			聘僱方式
		</td>
		<td>
		<%
		if(order==3)
		{
		%>
			<a href="listSalaryData.jsp?order=4&pageNum=<%=pageNumber%>">職稱 <img src="images/Upicon2.gif" border=0></a>
		<%
		}else{
		%>
			<a href="listSalaryData.jsp?order=3&pageNum=<%=pageNumber%>">職稱 <img src="images/Downicon2.gif" border=0></a>
		<%
		}
		%>
		</td>
		<td>
		<%
		if(order==5)
		{
		%>
			<a href="listSalaryData.jsp?order=6&pageNum=<%=pageNumber%>">所屬單位 <img src="images/Upicon2.gif" border=0></a>
		<%
		}else{
		%>
			<a href="listSalaryData.jsp?order=5&pageNum=<%=pageNumber%>">所屬單位 <img src="images/Downicon2.gif" border=0></a>
		<%
		}
		%>
		</td>  
			
		<td>
		<%
		if(order==7)
		{
		%>
			<a href="listSalaryData.jsp?order=8&pageNum=<%=pageNumber%>">到職日 <img src="images/Upicon2.gif" border=0></a>
		<%
		}else{
		%>
			<a href="listSalaryData.jsp?order=7&pageNum=<%=pageNumber%>">到職日 <img src="images/Downicon2.gif" border=0></a>
		<%
		}
		%>
		
		</td>
		<td></td>
		
	</tr>
<%
	DepartMgr dm=DepartMgr.getInstance();
	PositionMgr pm=PositionMgr.getInstance();
	ClassesMgr cm=ClassesMgr.getInstance();
	LevelMgr lm=LevelMgr.getInstance();

	TalentMgr tm2=TalentMgr.getInstance(); 
	
	int startRow=(pageNumber-1)*pageContent;
	int endRow=startRow+pageContent;
	if(endRow > teacherLength)
		endRow=teacherLength;
	for(int i=startRow;i<endRow;i++)
	{

%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></td>
			<%	
				boolean idStatus=true;
				if(tea[i].getTeacherIdNumber()==null ||tea[i].getTeacherIdNumber().length()!=10)
				{
					idStatus=false;
				}
				
			%>		
		<td class=es02 <%=(idStatus)?"":"bgcolor=FF8822"%>>
			<%
				out.println(tea[i].getTeacherIdNumber());
			 	
			 	if(!idStatus)
  				{
  					out.println("<font color=white>(未填或不是10碼)</font>");
  				}
 			%>
		</td>
		<td class=es02><%=(tea[i].getTeacherAccountPayWay())==0?"<font color=blue>櫃臺</font>":"匯款"%></td> 
		<%
			boolean accountStatus=true;
			
			String accountId="";
			String accountNum="";
			String accountName="";
			if(tea[i].getTeacherAccountPayWay()==1)
			{
				if(tea[i].getTeacherAccountDefaut()==1)
				{
					accountId=tea[i].getTeacherBank1(); 
					accountNum=tea[i].getTeacherAccountNumber1();
					accountName= tea[i].getTeacherAccountName1();
				}else{
					accountId=tea[i].getTeacherBank2(); 
					accountNum=tea[i].getTeacherAccountNumber2();
					accountName= tea[i].getTeacherAccountName2();
				}			
			} 
			
			String accoutError="";
			
			if(tea[i].getTeacherAccountPayWay()==1)
			{

				if(accountId.length()!=3)
				{
					accountStatus =false;
					accoutError +="銀行代號不全<br>";
				}	
				
				if(accountNum.length()!=14)
				{
					accountStatus =false;
					accoutError +="帳號不等於14位數<br>";
				}	
				
				if(accountName.length()==0)
				{
					accountStatus =false;
					accoutError +="未填帳戶名稱<br>";
				}	
			}			
		%>	
		
		<td class=es02 <%=(accountStatus)?"":"bgcolor=FF8822"%>>
		
			<%
				if(tea[i].getTeacherAccountPayWay()==1)
				{	
			%>
				<%=accountId%>-<%=accountNum%><br><%=accountName%>
				<%
					//out.println(accoutError);
				%>		
			<%
				}
			%>
		</td>	
		
		<td class=es02>
			<%
				switch(tea[i].getTeacherParttime()) 
				{ 
					case 0:
						out.println("正職"); 
						break;
					case 1:
						out.println("<font color=blue>課內約聘</font>");
						break;		
					case 2:
						out.println("<font color=blue>才藝約聘</font>");
						break;
				}
			%>		
		</td>
		<td class=es02><%
			int positionId=tea[i].getTeacherPosition();
			if(positionId !=0)
			{	
			
			Position po=(Position)pm.find(positionId);
			out.println(po.getPositionName());
			
			}else{
			out.println("未定");
			}
		   %></td>
		<td class=es02><% 
		
		if(tea[i].getTeacherParttime()!=2)
  		{
 			int classxId=tea[i].getTeacherClasses();
			int levelxId=tea[i].getTeacherLevel();
			int departId=tea[i].getTeacherDepart();
			
			if(departId !=0)
			{			
				Depart de=(Depart)dm.find(departId);
				out.println(de.getDepartName()+"-");
			}else{
				out.println("未定-");
			}
			if(classxId !=0)
			{
				Classes cla=(Classes)cm.find(classxId);
				out.println(cla.getClassesName()+"-");
			}else{
				out.println("跨班-");
			}
			if(levelxId !=0)
			{
				Level le=(Level)lm.find(levelxId);
				out.println(le.getLevelName());
			}else{
				out.println("跨年級");
			} 
		}else{
			
			TalentTeacher[] tt=ja.getTalentTeacherByTeacherId(tea[i].getId());
			
			if(tt ==null) 
			{ 
				out.println("尚未加入任何才藝班");			
			}else{
				
				for(int j=0;j<tt.length;j++) 
				{ 
                    if (j>0)
                        out.println(",");
					Talent ta=(Talent)tm2.find(tt[j].getTalentTeacherTalentId()); 
					out.println(ta.getTalentName());
 
					if(ta.getTalentActive()==0)
					{
						out.println("<font color=blue>(已停課)</font>");
					} 
				} 
			}
		}		
			
			%>
		
		</td>
		<td class=es02>
		<%=jt.ChangeDateToString(tea[i].getTeacherComeDate())%>
		</td>
		
		<td class=es02>
		<a href="#" onClick="javascript:openwindow16a('<%=tea[i].getId()%>');return false"><img src="pic/fix.gif" border=0>修改</a>
		</td>
		
	</tr>
<%
	}
%>
	</table>	
		</td>
			</tr>
				</table>

</center>
<!--- end 表單01 --->

<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addTeacher.jsp"><img src="pic/add.gif" border=0><font color=blue>新增教職員</font></a> 

</td>
</tr>
</table>



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	