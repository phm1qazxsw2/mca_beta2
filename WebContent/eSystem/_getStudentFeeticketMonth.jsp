<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

	try
	{
	JsfAdmin ja=JsfAdmin.getInstance();
	FeeAdmin fa=FeeAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	DecimalFormat mnf = new DecimalFormat("###,###,##0");  
	

 	int studentId=Integer.parseInt(request.getParameter("studentId"));
	String smonth=request.getParameter("month");
	String syear=request.getParameter("year");
	String z=request.getParameter("z");


	if(syear==null || smonth==null)
	{
		out.println("沒有輸入月份資料");
		return;
	}

	String parseDate=syear+"-"+smonth;

 	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM");
	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId); 

			
		
	Date runDate=sdf1.parse(parseDate);
	
	boolean FEEStatus=JsfPay.FEEStatus(runDate); 
	
	Feeticket[] ticket=ja.getFeeticketByStuID(runDate,studentId);

	int allShould=0;
	int allPay=0;
	int allTotal=0;
	
	int basicTicket=999; 
	
	if(ticket!=null)
	{
  		
		for(int i=0;i<ticket.length;i++)
		{
			if(ticket[i].getFeeticketNewFeenumber()==0)
				basicTicket=i;
		}
	}

	ClassesMgr cmes=ClassesMgr.getInstance();
	
	Classes cla=(Classes)cmes.find(stu.getStudentClassId());
	
%>

<link href=ft02.css rel=stylesheet type=text/css>
	
<script type="text/javascript" src="openWindow.js"></script>  

<div class=es02>
學生姓名:<b><%=stu.getStudentName()%></b> 月份:<b><%=parseDate%></b> 班級:<b><%=(cla==null)?"未定":cla.getClassesName()%></b> [<a href="listHistoryFeeticket.jsp?studentId=<%=stu.getId()%>"><font color=blue>所有帳單</font></a>]

</div>
<br>
	<div class=es02><font color=blue><b>月帳單</b></font>:</div>
	<%
	Hashtable baBasic=new Hashtable(); 
	int ftlock =0;
	
	if(basicTicket==999)
	{
		out.println("<br><blockquote><div class=es02><font color=blue>尚未加入任何收費項目</font></div></blockquote>");
	
	}else{
%>

<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border="0" cellpadding="4" cellspacing="1">
		<tr bgcolor="#f0f0f0" class="es02">
				<td class="es02">狀態</td>
				<td bgcolor="#ffffff">
					<%
						ftlock=ticket[basicTicket].getFeeticketLock();
						if(ftlock==0)
						{
					%>
						<img src="images/lockyes.gif" title="可以改單">
					<%
						
						}else if(ftlock==1){
					%>
						(<img src="images/lockno.gif" title="鎖定中">
						<font size=2><a href="#" onClick="javascript:openwindow49('<%=ticket[basicTicket].getFeeticketFeenumberId()%>');return false"><font color=blue>修改狀態</font></a></font>)
						<%}else if(ftlock==2){%>
						<img src="images/lockfinish.gif" title="已付款,禁止改單">
						<%}%>

                        <a href=addPayFeeType4x.jsp?z=<%=ticket[basicTicket].getFeeticketFeenumberId()%>><%=ticket[basicTicket].getFeeticketFeenumberId()%></a>
			
				</td>
		</tr>

        <tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>繳款狀態</td>
            <td class=es02>
        <%
                    if(ticket[basicTicket].getFeeticketStatus()==1)
                        out.println("尚未繳款");
                    else if(ticket[basicTicket].getFeeticketStatus()==2)
                        out.println("已繳款,尚未繳清");
                    else if(ticket[basicTicket].getFeeticketStatus()==91)
                        out.println("已繳清");
                    else if(ticket[basicTicket].getFeeticketStatus()==92)
                        out.println("超繳");
        %>
        </td>
        </tr>

        <tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>應繳金額</td><td align=right><%=mnf.format(ticket[basicTicket].getFeeticketTotalMoney())%></td>
        </tr>

        <tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>已繳金額</td><td align=right><%=mnf.format(ticket[basicTicket].getFeeticketPayMoney())%></td>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>需繳金額</td><td align=right><b><%=mnf.format(ticket[basicTicket].getFeeticketTotalMoney()-ticket[basicTicket].getFeeticketPayMoney())%></b></td>
        </tr>

		<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>繳款截止日</td>
		<td>
		<%=jt.ChangeDateToString(ticket[basicTicket].getFeeticketEndPayDate())%>
		 
		
		<%
		if((ticket[basicTicket].getFeeticketTotalMoney()-ticket[basicTicket].getFeeticketPayMoney())>0)
		{
		%>
			<a href="#" Onclick="javascript:openwindow33V2('<%=ticket[basicTicket].getFeeticketFeenumberId()%>');return false"><img src="pic/fix.gif" border=0>修改</a>
		<%
			}
		%>
		
		</td>
		</tr>
		
		<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>備註攔:</td>
		<td class=es02>
		<%=ticket[basicTicket].getFeeticketPs()%>
		 
		
		<%
		if((ticket[basicTicket].getFeeticketTotalMoney()-ticket[basicTicket].getFeeticketPayMoney())>0)
		{
		%>
		<a href="#" Onclick="javascript:openwindow33V2('<%=ticket[basicTicket].getFeeticketFeenumberId()%>');return false"><img src="pic/fix.gif" border=0>修改</a>
		<%
			}
		%>
		</td>
		</tr>
		<%
		if((ticket[basicTicket].getFeeticketTotalMoney()-ticket[basicTicket].getFeeticketPayMoney())>0)
		{
		%>
		<tr bgcolor=#ffffff align=left valign=middle>
		<td colspan=2 class=es02>
		<center>
		<%=fa.getPrintUpdateGif(ticket[basicTicket])%>
        <a href="#" Onclick="javascript:if(confirm('帳單將被鎖定,確認產生繳款單?')){ openwindow28('<%=ticket[basicTicket].getFeeticketFeenumberId()%>')};return false">[產生繳款單]</a>
		</center>
		</td>
		</tr>
		<%
		}else{
		%>
		 
		<tr bgcolor=#ffffff align=left valign=middle>
		<td colspan=2 class=es02>
		<center>
		<a href="#" Onclick="javascript:openwindow281('<%=ticket[basicTicket].getFeeticketFeenumberId()%>');return false"><b>產生收據</b></a>
		</center>
		</td>
		</tr>
		<%
		}
		%>

		</table>
		</td>
		</tr>
		</table>		
 
			<% 
					}
	
	if(basicTicket !=999)
	{ 
	%> 
	<br>
	<div class=es02><b>月帳單-已加入的收費項目:</b></div>
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border="0" cellpadding="4" cellspacing="1">
		<tr bgcolor="#f0f0f0" class="es02">
				<td class="es02">收費項目</td>
				<td class="es02">應收款項</td>
				<td class="es02">折扣</td>
				<td class="es02">小計</td>
				<td></td>
		</tr>
		<% 
			int totalShould=0;
			int totalDiscount=0;
		
			ClassesFee[] cf=ja.getClassesFeeByNumber(ticket[basicTicket].getFeeticketFeenumberId());
			
			if(cf==null)
			{ 
		%>
				<tr>  
				  	<td colspan=5  class="es02">尚未加入</td>
				</tr>
		<%		
			}else{
		
				for(int i=0;i<cf.length;i++)
				{
 
					baBasic.put((String)String.valueOf(cf[i].getClassesFeeCMId()),(String)"1"); 

					totalShould+=cf[i].getClassesFeeShouldNumber();
					totalDiscount+=cf[i].getClassesFeeTotalDiscount();
				
					int cmId=cf[i].getClassesFeeCMId();
					ClassesMoney cm=(ClassesMoney)cmm.find(cmId);
 
					
	%>
	
	<tr bgcolor="#ffffff" align="left" valign="middle">	
		<td  class="es02"><%=cm.getClassesMoneyName()%></td>
		<td class="es02" align="right"><%=mnf.format(cf[i].getClassesFeeShouldNumber())%></td>
		<td class="es02" align="right"><%=mnf.format(cf[i].getClassesFeeTotalDiscount())%></td>
		<td class="es02" align="right"><%=mnf.format(cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount())%></td>
		<td class="es02" align="right"><a href="#" onClick="javascript:openwindow30V2('<%=cf[i].getId()%>','cla');return false">詳細資料</a></td>
	</tr> 
	
	
	<%
				} 
	%>
	<tr align="left" valign="middle" class=es02>	
		<td  class="es02">合計</td>
		<td class="es02" align="right"><%=mnf.format(ticket[basicTicket].getFeeticketSholdMoney())%></td>
		<td class="es02" align="right"><%=mnf.format(ticket[basicTicket].getFeeticketDiscountMoney())%></td>
		<td class="es02" align="right"><b><%=mnf.format(ticket[basicTicket].getFeeticketTotalMoney())%></b></td>
		<td class="es02" align="right"><a href="addPayFeeType4x.jsp?z=<%=ticket[basicTicket].getFeeticketFeenumberId()%>"><font color=blue>[臨櫃繳款]</font></a></td>
	</tr>

	<%
		}
	%>
		</table> 
		</td></tr></table>
		<br>

	<%
	}   

	if(ftlock==0)
	{  

	%>


<!-- <form action="addClassmoneybyPerson.jsp" method="post" target="_blank">	 -->

<form action="#" method="get" name="checkbox_form">
<br>
<div class=es02><b>月帳單-新增收費項目:</b></div>
 	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align="left" valign="top">
	<td bgcolor="#e9e3de">
	<table width="100%" border="0" cellpadding="4" cellspacing="1"> 
		 <tr bgcolor="#f0f0f0">
			<td align=left>  
				收費項目
			</tD>
			<td> 
				金額
			</td>
		  </tr>
		<%
			ClassesMoney[] cm=ja.getActiveBasicFeenumber(); 
			
			int actualNum=0;
			if(cm !=null)
			{  
			
				for(int j=0;j<cm.length;j++)
				{  
					if(baBasic.get(String.valueOf(cm[j].getId()))==null) 
					{  
						 actualNum ++;
		%> 
				 <tr bgcolor="#ffffff" align="left"> 
				 	
					<%  
						boolean isTalent=true;
						boolean openCC=true;
						CmxLog[] cl =null;
						if(cm[j].getClassesMoneyCategory()==2)
						{ 
							cl=ja.getCmxLogByCMid(cm[j].getId());
						
							Tadent[] td=ja.getTadentByStuId(studentId,cl[0].getCmxLogXId());
							if(td==null)
								isTalent=false;	
						}
						if(cm[j].getClassesMoneyCategory()==1)
						{ 			 
  							ClassesCharge cc=ja.getClassesChargeByClass(
                                runDate,cm[j].getId(),stu.getStudentClassId(),stu.getStudentGroupId(),1);
							if(cc==null)	
								openCC	=false;
						}		
				%>
				<td align="left" class="es02"> 
				<%							 
						if(isTalent && openCC)
  						{
 					%>		
						<input type="checkbox" name="cmItems" value="<%=cm[j].getId()%>">
					<%
						}
					%>  
					<%=cm[j].getClassesMoneyName()%> 
									 	</td>
 					<td align="left" class="es02"> 				
				
					<% 
					
						if(cm[j].getClassesMoneyCategory()==3)
						{
					%>
							<input type="text" name="mNumber<%=cm[j].getId()%>" value="<%=cm[j].getClassesMoneyNumber()%>" size="5">
					<%  }else{
					%>
							<%=mnf.format(cm[j].getClassesMoneyNumber())%>
						<%
							if(!isTalent)	
							{
								if(cl !=null)
									out.println("<a href=\"addTadent.jsp?talentId="+cl[0].getCmxLogXId()+"\">(沒有加入此才藝班)</a>");	
								else 
									out.println("(沒有加入此才藝班)");		
							}
							if(!openCC)	
								out.println("<br><a href=\"addClassChargeTypeClassX.jsp?cmId="+cm[j].getId()+"&month="+smonth+"&year="+syear+"\">(本月尚未產生班級收費項目)</a>");	
									
						%>			
							<input type="hidden" name="mNumber<%=cm[j].getId()%>" value="<%=cm[j].getClassesMoneyNumber()%>">
 					<%  		
						}
						
					%>
						</td></tr>
				<%
					} 
				}		
			}
	%>  
		<tr> 
			<td colspan=2>
					<%
						if(FEEStatus){ 
					%>		  
                            <center>
                                <input type="button" value="加入" onClick="javascript:checkbox_checker();return false">
                            </center>
					<%
						}else{
							out.println("<center>本月已結帳</center>");			
						} 
					%>
		
					</td>
				</tr>		
			</table>	
			</td>
			</tr>
			</table>
	</form>
	<br>


	<% 
	}  

	%>
	
	<% 
	
	boolean showNew=false;
	int totalShould=0;
	int totalDiscount=0;


	if(ticket!=null)
	{
		for(int j=0;j<ticket.length;j++)
		{
			if(ticket[j].getFeeticketNewFeenumber()!=0)
			{
				if(!showNew) 
				{
%>
				<div class=es02><b><font color=blue>獨立帳單:</font>已加入的收費項目</b></div>
				<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
				<tr align="left" valign="top">
				<td bgcolor="#e9e3de">
				
				<table width="100%" border="0" cellpadding="4" cellspacing="1">
					<tr bgcolor="#ffffff" class="es02">
					<tD></tD>
					<td class="es02">收費項目</td>
					<td class="es02">應收款項</td>
					<td class="es02">折扣</td>
					<td class="es02">小計</td>
					<td></td>
					</tr>
<%	
					showNew =true;
				}		
%>
			<tr bgcolor="#f0f0f0" class="es02">

				<td class="es02">帳單流水號</td>
				<td  class="es02" colspan="5"> 
					<%
						ftlock=ticket[j].getFeeticketLock();
						if(ftlock==0)
						{
					%>
							<img src="images/lockyes.gif" title="可以改單">
					<%
						
						}else if(ftlock==1){
					%>
                            <img src="images/lockno.gif" title="鎖定中" border=0>
						<%}else if(ftlock==2){%>
							<img src="images/lockfinish.gif" title="已付款,禁止改單">
						<%}%>
						<%=ticket[j].getFeeticketFeenumberId()%>
                        <%
                        if((ticket[j].getFeeticketTotalMoney()-ticket[j].getFeeticketPayMoney())>0)
                        {
                        %> 
                            <a href="addPayFeeType4x.jsp?z=<%=ticket[j].getFeeticketFeenumberId()%>">[櫃臺繳費]</a>
                            <a href="#" Onclick="javascript:if(confirm('帳單將被鎖定,確認產生繳款單?')){ openwindow28('<%=ticket[j].getFeeticketFeenumberId()%>')};return false">[產生繳款單]</a>
                        <%
                        }else{
                        %>
                            <a href="#" Onclick="javascript:openwindow281('<%=ticket[j].getFeeticketFeenumberId()%>');return false">[產生收據]</b></a>
                        <%
                        }
                        %>
                        </tD>
                    </tr>
<%
			ClassesFee[] cf=ja.getClassesFeeByNumber(ticket[j].getFeeticketFeenumberId());
			if(cf==null)
			{ 
		%>
				<tr>   
					 <tD></tD>
				  	<td colspan="5"  class="es02">尚未加入</td>
				</tr>
		<%		
			}else{

                    for(int i=0;i<cf.length;i++)
                    { 
                        totalShould+=cf[i].getClassesFeeShouldNumber();
                        totalDiscount+=cf[i].getClassesFeeTotalDiscount();
                         
                        int cmId=cf[i].getClassesFeeCMId();
                        ClassesMoney cm=(ClassesMoney)cmm.find(cmId);
%>
                        <tr bgcolor="#ffffff" align="left" valign="middle">	
                            <td></td>
                            <td  class="es02"><%=cm.getClassesMoneyName()%></td>
                            <td class="es02" align="right"><%=mnf.format(cf[i].getClassesFeeShouldNumber())%></td>
                            <td class="es02" align="right"><%=mnf.format(cf[i].getClassesFeeTotalDiscount())%></td>
                            <td class="es02" align="right"><%=mnf.format(cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount())%></td>
                            <td class="es02" align="right"><a href="#" onClick="javascript:openwindow30V2('<%=cf[i].getId()%>','cla');return false">詳細資料</a></td>
                        </tr>
	<%
		
					} 
            }
         }
      }
	%> 
	
			</table>
			</td>
			</tr>
			</table>

            <br>
            <br>
	<%					
       
        } 

	}catch(Exception eg){

	    System.out.println(eg.getMessage());
	} 
%>