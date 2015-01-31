<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text\html;charset=UTF-8"%><%
	
	String search=request.getParameter("search").trim();
	String r=request.getParameter("r");

	DecimalFormat mnf = new DecimalFormat("###,###,##0");

	if(search ==null || search.length()<=0) 
	{ 
			
		return;
	}		
	String query="";
	String bank=""; 
	
	query=" studentAccountNumber1 like ('"+search+"%')";  
  
 	JsfAdmin ja=JsfAdmin.getInstance();
	StudentMgr um=StudentMgr.getInstance();
	
	Object[] objs = um.retrieve(query, "");


	ClassesMgr cmx=ClassesMgr.getInstance();
	DepartMgr dm=DepartMgr.getInstance();
	LevelMgr lm=LevelMgr.getInstance();

	if (objs==null || objs.length==0)
	{  
%>	
		<br>
		<br>
		<blockquote>
			在校生目前<font color=blue>尚未</font>登入此帳號! 
			<br>
			<br>
			

		</blockquote>
<%		
		return ;
	}
%>
	<div align=left>共計:<font color=blue><%=objs.length%></font>筆</div>


<% 
		Student[] u2 = new Student[objs.length];
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM"); 
		
		for (int i=0; i<u2.length; i++)
		{
			u2[i]=(Student)objs[i];
		
			Classes cla=(Classes)cmx.find(u2[i].getStudentClassId());  	
			
			String className="";
			if(cla ==null)
			{
				className="未定";
			}
			else
			{
				className=cla.getClassesName();
			}		
%>  
<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
			<td>學生姓名</tD>	
			<td>班級</tD>
			<td>帳號</tD> 
			<td></td>
 
			<td></td>
		</tr> 

		<tr class=es02 bgcolor="A9B0F6"> 
			<td><%=u2[i].getStudentName()%></td> 
			<tD><%=className%></tD>
			<tD><%=u2[i].getStudentBank1()%>-<%=u2[i].getStudentAccountNumber1()%></td>
			<td colspan=2></td>
		</tr> 
		<%
			Feeticket[] ticket=ja.getNotPayFeeticketByStuID(u2[i].getId());

			if(ticket==null) 
			{ 
		%>	
			<tr bgcolor=#ffffff  class=es02 align=left valign=top>
				<td></td>
				<tD colspan=4>沒有未付款帳單</tD>
			</tr>
		<%
			}else{
		%>
				<form action="payByAccount.jsp" method="post">		
		<%		
				int shouldTotal=0;
				
				for(int j=0;j<ticket.length;j++)	
				{
					int nowPay2=ticket[j].getFeeticketTotalMoney()-ticket[j].getFeeticketPayMoney(); 
				 	shouldTotal+=nowPay2;
		%>
			<tr bgcolor=#ffffff  class=es02 align=left valign=top>
				<td align=right><%=j+1%></tD>		
				<tD><%=sdf1.format(ticket[j].getFeeticketMonth())%></tD>
				<tD>流水號:<%=ticket[j].getFeeticketFeenumberId()%></tD>  
					
				<td><input type=checkbox name="ticketid" value="<%=ticket[j].getId()%>" checked><%=nowPay2%></td>
				<tD>
					<a href="#" onClick="getFeeticketByFeenumber('<%=ticket[j].getFeeticketFeenumberId()%>')">詳細資料</a>
				</tD>
			</tr>		
		<%
				} 
		%>
			<tr>
				<tD colspan=2>應繳合計</tD> 
				<td><%=mnf.format(shouldTotal)%></tD>	
				<td><input type=submit value="銷單"></tD>
			</tr> 
			</form>
		<%		
			}
		%>		
		
		</table>
	</td>
	</tr>
	</table>
	<br>
<%		

		}
%>
		
<%	    

/*
	String str="";
 
	
	
	str="<table width=\"85%\" height=\"\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">";
	str+="<tr align=left valign=top><td bgcolor=\"#e9e3de\">";	
	str+="<table width=\"100%\" border=0 cellpadding=4 cellspacing=1>";
	
	str+="<tr bgcolor=#f0f0f0 class=es02>";
	str+="<td><b>學生姓名</b></td><td>性別</td><td>單位</td><td>班級</td><td>年級</td><td colspan=3></td></tr>"; 

    Student[] u2 = new Student[objs.length];
    
    for (int i=0; i<u2.length; i++)
    {
  		u2[i]=(Student)objs[i];
		
		Classes cla=(Classes)cmx.find(u2[i].getStudentClassId());  		
  		
    	String stuId=String.valueOf(u2[i].getId());
    	
		str+="<tr class=\"es02\" bgcolor=\"ffffff\" onmouseover=\"this.className='highlight'\" onmouseout=\"this.className='es02'\">"+
				"<td><a href=\"#\" onClick=\"javascript:openwindow15('"+u2[i].getId()+"')\">";
	
		str +=u2[i].getStudentName()+"</a></td><td>";
		if(u2[i].getStudentSex()==1)
			str +="男";		 
		else
			str +="女";	
		str +="</td><td>"; 
		int departIdx=u2[i].getStudentDepart();
		if(departIdx==0)
		{
			str+="未定";
		}
		else
		{
			Depart dex=(Depart)dm.find(departIdx);
			str+=dex.getDepartName();
		}
		str+="</td><td>"; 
		
		int cid=u2[i].getStudentClassId(); 
		if(cid==0)
		{
			str+="未定";
		}
		else
		{
			Classes cla2=(Classes)cmx.find(cid);
			str+=cla2.getClassesName();
		}	
	  
	     str +="</td><td>";
	     
		int levelx=u2[i].getStudentLevel(); 
		if(levelx==0)
		{
			str+="未定";
		}
		else
		{
			Level leve=(Level)lm.find(levelx);
			str +=leve.getLevelName();
		}
	    str +="</td><td>";
	
		str +="<a href=\"#\" onClick=\"javascript:openwindow27('"+u2[i].getId()+"');return false\">繳費資訊</a>";
		str +="</td></tr>";
    }	
   	str+= "</table></td></tr></table>";  
   	 
	str+="<br><br><a href=\"listStudentType2.jsp\"><img src=\"pic/fix.gif\" border=0>ATM帳號編輯</a>";
	
	out.println(str);  
	
*/	
%>