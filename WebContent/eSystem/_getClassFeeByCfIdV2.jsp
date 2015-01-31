<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    try
    {
        request.setCharacterEncoding("UTF-8");
		String sz=request.getParameter("z");
		String r=request.getParameter("r");
		String page2=request.getParameter("page2");
		int cfid=Integer.parseInt(sz);
		
		JsfAdmin js=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		DecimalFormat mnf = new DecimalFormat("###,###,##0");
		
		ClassesFeeMgr cfm=ClassesFeeMgr.getInstance();
		ClassesFee cf=(ClassesFee)cfm.find(cfid);

		if(cf==null)
		{
			out.println("沒有資料");
			return;
		}
%>
<link href=ft02.css rel=stylesheet type=text/css>
<%	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(cf.getClassesFeeStudentId());
 
 
 	int feenumberId=cf.getClassesFeeFeenumberId();
	Feeticket ftx=js.getFeeticketByNumberId(feenumberId);
	
	
	boolean FEEStatus=JsfPay.FEEStatus(ftx.getFeeticketMonth());
	if(ftx==null)
	{
		out.println("沒有帳單資料");
		return;
	}
	int ftlock=ftx.getFeeticketLock();
	
	int Fstatus=ftx.getFeeticketStatus();
	
	int cmId=cf.getClassesFeeCMId();
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();	
	ClassesMoney cm=(ClassesMoney)cmm.find(cmId);
	
	
	
	 DiscountType[] dts=js.getAactiveDiscountType();
	
	if(dts==null)
	{
		out.println("尚未加入折扣類別");
		return;
	}
	%>

	
 <script type="text/javascript" src="openWindow.js"></script>
 <form action="addClassesFeePs.jsp" method="post" target="_blank">
 	<b><%=stu.getStudentName()%></b>-<%=cm.getClassesMoneyName()%> 收款明細
<br>
<br>

<center>

<table width="318" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 class=es02>
	<td>應收金額</td>
	<td bgcolor=#ffffff class=es02>
	<%=mnf.format(cf.getClassesFeeShouldNumber())%>
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>折扣金額</td>
		<td bgcolor=#ffffff class=es02>
		<%=mnf.format(cf.getClassesFeeTotalDiscount())%></td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>合計</td>
		<td bgcolor=#ffffff class=es02>
		<b><font color=blue><%=mnf.format(cf.getClassesFeeShouldNumber()-cf.getClassesFeeTotalDiscount())%></font></b></td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>帳單編號</td>
	<td bgcolor=#ffffff class=es02>
	<%
	if(ftlock==0)
	{
	%>
		<img src="images/lockyes.gif" title="可以改單">
		
	<%}else if(ftlock ==1){%>
		<img src="images/lockno.gif" title="禁止改單">
	<%}else if(ftlock==2){%>
		<img src="images/lockfinish.gif" title="禁止改單">
	<% }  %>
	    <%=cf.getClassesFeeFeenumberId()%>  
	</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>繳款狀態</td>
		<td bgcolor=#ffffff class=es02>

	<%
	int status2=ftx.getFeeticketStatus();
	
	switch(status2){
		case 1:
			out.println("尚未繳款");
			break;
		case 2:
			out.println("已繳款尚未繳清");
			break;
		case 91:
			out.println("已繳清");
			break;
		case 92:
			out.println("超繳");
			break;	
	}
	
	
	%>
	</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>登入</td>
		<td bgcolor=#ffffff class=es02>

	<%
	UserMgr umx2=UserMgr.getInstance();
	int userId=cf.getClassesFeeLogId();
	
	if(userId==0)
	{
		out.println("沒有登入");
	}else{
		User ux=(User)umx2.find(userId);
		out.println(ux.getUserFullname());
	}
	Date create2=cf.getCreated();
	out.println("-"+jt.ChangeDateToString(create2));
	%>
	</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 class=es02>
	<td>備註</td>
	<td bgcolor=#ffffff class=es02>
		<textarea name="tfPs" cols=28 rows=3><%=cf.getClassesFeeLogPs()%></textarea>
		<input type=hidden name="cfId" value="<%=cfid%>">
	</td>
	</tr>
	<tr><td colspan=2>
        <center>
            <input type=button value="修改備註" onclick="javascript:openRun2('addClassesFeePs.jsp?tfPs='+encodeURI(this.form.tfPs.value)+'&cfId=<%=cfid%>')"></center></td></tr>
	
	<tr bgcolor=#ffffff class=es02>
	<td colspan=2 align=right>
	<%	
		if(ftlock ==0)
		{ 
			if(FEEStatus)
 
			{ 
	%>	

            <a href="#" onClick="javascript:if(confirm('確認刪除此收費項目?')){ openRun2('deleteClassesFee.jsp?cfId=<%=cfid%>')}"><img src="pic/delete.gif" border=0>刪除此收費項目</a>
	
	<%
			}else{
				out.println("本月已結帳");
			}
		}else{
 
			if(FEEStatus)
			{ 
				out.println("本帳單已鎖定");
			}else{
				out.println("<img src=\"pic/warning.gif\" border=0>本月已結帳");
			}
		}
			%>
	</td>
	</tr>
	</form>
	</table> 
	
	</td>
	</tR>
	</table>
	<br>
	
	
	<%
		CfDiscount[] cd=js.getCfDiscountByCfid(cfid);
	
		if(cd==null)
		{
		%>
			<b><div class=es02>沒有折扣登入</div></b><br><br>
		
	<%
		}else{
		
	%>
	<b>折扣紀錄</b>
<table width="318" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 class=es02>
	<td>類別</td>
	<td>折扣金額</td>
 
	<td>延續</td>
	<td>登入人</td>
	<td></td>
	

	</tr>
	
	<%
		DiscountTypeMgr dtm=DiscountTypeMgr.getInstance();

		for(int j=0;j<cd.length;j++)
		{
	%>
		<tr bgcolor=#ffffff class=es02>
			<%
			DiscountType dt=(DiscountType)dtm.find(cd[j].getCfDiscountTypeId());
			%>
			<td><%=dt.getDiscountTypeName()%></td>				
			<td align=right>
				<%=cd[j].getCfDiscountNumber()%>
			</td>
 
			<td align=right>
				<%=(cd[j].getCfDiscountContinue()==1)?"是":"否"%>
 
				<br>

			   <a href="#" onClick="javascript:if(confirm('確認修改延續狀態?')){ openRun2('modifyCfDiscountCintinue.jsp?cfdId=<%=cd[j].getId()%>')}">修改</a>
            </td>
                


			<td>
			<% 
				if(cd[j].getCfDiscountLogId()==9999)
				{
					out.println("沒有登入");
				}else{
					UserMgr um=UserMgr.getInstance();
					User us=(User)um.find(cd[j].getCfDiscountLogId());
					out.println(us.getUserFullname());
				}	
				Date create3=cd[j].getCreated();
				out.println("<br>"+jt.ChangeDateToString(create3));
		
			%>
 
			</td>
			<td>
		<%
		if(ftlock ==0){	
			if(Fstatus<90){
 
				 if(FEEStatus){ 
	    %>
		    <a href="#" onClick="javascript:if(confirm('確認刪除此項折扣?')){ openRun2('deleteCfDiscount.jsp?cfd=<%=cd[j].getId()%>')}"><img src="pic/delete.gif" border=0>刪除</a>
        <%	
				}
			}
		}	
		%>
		</td>
		</tr>
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
	
	if(ftlock ==0 && Fstatus <90 && FEEStatus)
	{
	%>
	
<form action="addcfDiscount.jsp" method="post" target="_blank">
 	
<table width="318" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff class=es02>
		<td colspan=2><b>新增折扣</b></td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>折扣種類</td>
	<td bgcolor=#ffffff class=es02>
		<select name="discpuntType" size=1>
		<%
		for(int k=0;k<dts.length;k++)
		{
		%>
			<option value="<%=dts[k].getId()%>"><%=dts[k].getDiscountTypeName()%></option>
		<%
		}
		%>
		</select>
	</td>
	</tr>

	<tr bgcolor=#f0f0f0 class=es02>
		<td>折扣金額</td>
		<td  bgcolor=#ffffff class=es02>
		<input type=text name="discountNumber" size=10 value="0">
		</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>延續折扣</td>
		<td  bgcolor=#ffffff class=es02>
            <select name="cfDiscountContinue">
                <option value="1" selected>延續</option>
                <option value="0">不延續</option>
            </select>
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>折扣原因</td>
		<td  bgcolor=#ffffff class=es02>
			<textarea name="discountPs" cols=28 rows=3></textarea>
		</td>
	</tr>
	<input type=hidden name="cfId" value="<%=cfid%>">
	<input type=hidden name="page2" value="<%=page2%>">
	
	<tr>
	<td colspan=2><center>        
        <input type=button value="新增折扣" onClick="javascript:if(confirm('確認新增折扣?')){ 
			openRun2('addcfDiscount.jsp?discpuntType='+this.form.discpuntType.value+'&discountNumber='+this.form.discountNumber.value+'&cfDiscountContinue='+this.form.cfDiscountContinue.value+'&cfId=<%=cfid%>')}"
	
            
    </center></td></tr>
	</table>
 
	</td>
	</tr>
	</table>
	
        </form>
<%
		}
    }catch(Exception e){
        e.printStackTrace();
        //out.print("bad");
    }
%>
</center>