<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<% 

if(!AuthAdmin.authPage(ud2,4))
{
    response.sendRedirect("authIndex.jsp?page=6&info=1");
}

if (1==1)
    throw new Exception("obsolete!");

DecimalFormat mnf = new DecimalFormat("###,###,##0");

Date nowDate=new Date();
long nowLong=nowDate.getTime();



SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");  
SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/01"); 

if (1==1)
    throw new Exception("obsolete!");

JsfAdmin ja=JsfAdmin.getInstance();
Costtrade[] ct=ja.getAllCosttrade();
  
   
Costbook[] cbs=null;

int type=1;
try { type=Integer.parseInt(request.getParameter("type")); } catch (Exception e){}

int trader =0; 
try { trader=Integer.parseInt(request.getParameter("trader")); } catch (Exception e){}

int logId=0; 
try { logId=Integer.parseInt(request.getParameter("logId")); } catch (Exception e){}
    
int attachstatus=0;  
try { attachstatus=Integer.parseInt(request.getParameter("attachstatus")); } catch (Exception e){}

int vstatus=99;
try { vstatus=Integer.parseInt(request.getParameter("vstatus")); } catch (Exception e){}

int paystaus =0;
try { paystaus=Integer.parseInt(request.getParameter("paystaus")); } catch (Exception e){}
	
String startDate = request.getParameter("startDate");
if (startDate==null)
    startDate =sdf2.format(new Date());
String endDate = request.getParameter("endDate"); 
if (endDate==null)
    endDate =sdf.format(new Date());

JsfPay jp=JsfPay.getInstance();
cbs=jp.getCostbooksAdvanced(type,trader,logId,sdf.parse(startDate),sdf.parse(endDate),paystaus,vstatus,attachstatus);

%>
<br> 

<b>&nbsp;&nbsp;&nbsp;<img src="pic/list.gif" border=0>傳票進階查詢</b> 
<br>  
<blockquote>
<form action="listCostbook.jsp" method="get">
<table  class=es02>
	<tr> 
		<td> 
			形式
		</tD>	
		<tD>
			交易對象
		</tD>
		<td>
			登入人
		</tD> 
		<tD>
			付/收款狀態 
		</td> 
		<td>附件狀態</tD> 
		<td>審核狀態</tD> 
		<td>入帳日期 </td>		
	</tr> 
		
		<td>
			
			<select size=1 name="type">
				<option value="99" <%=(type==99)?"selected":""%>>全部</option>
				<option value="1" <%=(type==1)?"selected":""%>>支出</option>
				<option value="0" <%=(type==0)?"selected":""%>>收入</option>
			</select>
		</td>
		
		<td>
			
			<select size=1 name="trader">
				<option value="0" <%=(trader==0)?"selected":""%>>全部</option>
		<%
            
				for(int i=0;ct !=null && i<ct.length;i++)	
				{
		%>
				<option value="<%=ct[i].getId()%>" <%=(trader==ct[i].getId())?"selected":""%>><%=ct[i].getCosttradeName()%></option> 
		<%
				}
		%>	
			
			</select> 
			
		</td>
		<td>
			
 
			<%
			 User[] u2=ja.getAllUsers();

			%>
	
			<select size=1 name="logId">
				<option value="0" <%=(logId==0)?"selected":""%>>全部</option>
				<%
					if(u2 !=null)
 
					{
						for(int i=0;u2!=null&& i<u2.length;i++)
						{ 
				%>	
						<option value="<%=u2[i].getId()%>" <%=(logId==u2[i].getId())?"selected":""%>><%=u2[i].getUserFullname()%></option>	
				<% 
						}
					}
				%>
			</select> 
		</td>
		<td>
			
			<select name="paystaus" size=1>
				<option value=0 <%=(paystaus==0)?"selected":""%>>全部</option>
				<option value=1 <%=(paystaus==1)?"selected":""%>>尚未結清</option>
				<option value=90 <%=(paystaus==90)?"selected":""%>>已結清</option>
			</select>
		</td>
		<td>
 
			<select name="attachstatus" size=1>
				<option value=0 <%=(attachstatus==0)?"selected":""%>>全部</option>
				<option value=1 <%=(attachstatus==1)?"selected":""%>>未附</option>
				<option value=2 <%=(attachstatus==2)?"selected":""%>>不完整</option>
				<option value=99 <%=(attachstatus==99)?"selected":""%>>完整</option>
			</select>
		</tD>

		<td>		
			<select name="vstatus" size=1>
				<option value=99 <%=(vstatus==99)?"selected":""%>>全部</option>
				<option value=0 <%=(vstatus==0)?"selected":""%>>尚未</option>
				<option value=1 <%=(vstatus==1)?"selected":""%>>警示</option>
				<option value=90 <%=(vstatus==90)?"selected":""%>>OK</option>
			</select>
		</td>	
		
		<td>
			
			<input type=text name="startDate" value="<%=startDate%>" size=7>
			-
			<input type=text name="endDate" value="<%=endDate%>" size=7>
		</td>
		<td>
			<input type="submit" value="查詢">
		</td>
	</tr>	
</table> 
</form>  
</blockquote> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>				



<%
if(cbs==null){
 
	out.println("<br><blockquote><font color=blue>本期間沒有資料</font></blockquote></b>");
%>
    <%@ include file="bottom.jsp"%>	
<%	
	return;
}
%>

<br>
<center> 
<div align=right>
	<img src="pic/list.gif" border=0>傳票進階查詢 |
	<a href="CostbookReport.jsp?type=<%=type%>&trader=<%=trader%>&logId=<%=logId%>&startDate=<%=startDate%>&endDate=<%=endDate%>"><img src="pic/lane.gif" border=0>雜費統計報表</a> 
</div> 

<table width="98%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#ffffff align=left valign=middle> 
		 <td bgcolor=#f0f0f0 class=es02>形式</td>	
		<td bgcolor=#f0f0f0 class=es02>傳票編號</td>
		<td bgcolor=#f0f0f0 class=es02>入帳日期</td>
		<td bgcolor=#f0f0f0 class=es02>傳票抬頭</td>
		<td bgcolor=#f0f0f0 class=es02>登入人</td>
		<td bgcolor=#f0f0f0 class=es02  width=58>帳面金額</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>
			<%
			if(type==1)
				out.println("已付金額");
			else if(type==0)
				out.println("已收金額"); 
			else 
				out.println("已付/已收");
 		
			%>				
		</td> 
		<td bgcolor=#f0f0f0 class=es02  width=58>
 		<%
					if(type==1)
						out.println("未付金額");
					else if(type==0)
						out.println("未收金額");
					else
						out.println("未付/未收");	
					%>
 			</td>	
 		<td bgcolor=#f0f0f0 class=es02 width=60>註記</td>		
 		<td bgcolor=#f0f0f0 class=es02 width=20>附件</td>		
 		<td bgcolor=#f0f0f0 class=es02 width=68>審核狀態</tD>			
		<td bgcolor=#f0f0f0 class=es02></tD> 
	</tr>
<% 
    UserMgr  umc=UserMgr.getInstance();
    int total1=0;
    int total2=0;
    int total3=0;
    
    for(int j=0;j<cbs.length;j++)	
    { 
%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=(cbs[j].getCostbookOutIn()==0)?"<img src=\"pic/costIn.png\" border=0>收":"<img src=\"pic/costOut.png\" border=0>支"%></td>
		<td class=es02><%=cbs[j].getCostbookCostcheckId()%></td>
		<td class=es02><%=sdf.format(cbs[j].getCostbookAccountDate())%></td>
		<td class=es02>
			<%=cbs[j].getCostbookName()%>
		</td>
		<td class=es02>
<%
        User ux=(User)umc.find(cbs[j].getCostbookLogId());
        out.println(ux.getUserFullname());				
%>
        </td>					
		
		<td  class=es02 align=right><%=mnf.format(cbs[j].getCostbookTotalMoney())%></td>
		<td  class=es02 align=right>
			<%=mnf.format(cbs[j].getCostbookPaiedMoney())%>
		</td> 
		<td  class=es02 align=right>
<%
        int shouldPay=cbs[j].getCostbookTotalMoney()-cbs[j].getCostbookPaiedMoney();
        out.println(mnf.format(shouldPay));
    
        total1+=cbs[j].getCostbookTotalMoney();
        total2+=cbs[j].getCostbookPaiedMoney();        
%>

		</td>  
		<td class=es02 align=left>
			<%=(cbs[j].getCostbookLogPs()!=null && cbs[j].getCostbookLogPs().length()>0)?cbs[j].getCostbookLogPs():""%>		
		</tD>
		<td  class=es02>
<%
        switch(cbs[j].getCostbookAttachStatus()){
            case 1:
                out.println("<font color=red>未附</font>"); 
                break;
            case 2:	
                out.println("<font color=red>不完整</font>");
                break; 
            case 99:
                out.println("完整");
                break; 				
        }		
%>
		</td>
		<td class=es02 <%=(cbs[j].getCostbookVerifyStatus()==1)?"bgcolor=FF8822":""%>>
<%					
        if(cbs[j].getCostbookVerifyStatus()<90)
        { 
            if(cbs[j].getCostbookVerifyStatus()==0) 
            {
                if (cbs[j].getCostbookTotalMoney()==0)
                    out.println("<font color=red>無明細</font>");	
                else if(shouldPay!=0)
                    out.println("<font color=red>尚未結清</font>");	
                else					
                    out.println("<font color=blue>尚未審核</font>");		
            }
            else { 
                out.println("<font color=white>緊示</font>");
            } 
                
            if(shouldPay==0 && cbs[j].getCostbookTotalMoney()>0)
            {
                if(ud2.getUserRole()<=2) 
                {
%> 
                    <br>
                    <a href="verifyCostbook.jsp?cbStatus=90&cbId=<%=cbs[j].getId()%>&trader=<%=trader%>&logId=<%=logId%>&startDate=<%=startDate%>&endDate=<%=endDate%>&attachstatus=<%=attachstatus%>&vstatus=<%=vstatus%>"  onClick="return confirm('審核狀態將改為-OK')"><font color=blue>確認</font></a> |
<%
                    if(cbs[j].getCostbookVerifyStatus()==0) {
%>
                    <a href="verifyCostbook.jsp?cbStatus=1&cbId=<%=cbs[j].getId()%>&trader=<%=trader%>&logId=<%=logId%>&startDate=<%=startDate%>&endDate=<%=endDate%>&attachstatus=<%=attachstatus%>&vstatus=<%=vstatus%>"  onClick="return confirm('審核狀態將改為-警示')"><font color=blue>警示</font></a>
<%
                    }
                    else {
%>
				    <a href="verifyCostbook.jsp?cbStatus=0&cbId=<%=cbs[j].getId()%>&trader=<%=trader%>&logId=<%=logId%>&startDate=<%=startDate%>&endDate=<%=endDate%>&attachstatus=<%=attachstatus%>&vstatus=<%=vstatus%>"  onClick="return confirm('審核狀態將改為-解除警示')"><font color=blue>解除</font></a>
<%
                    }
                }
            }	
        }
        else if(cbs[j].getCostbookVerifyStatus()==90)
        {
            User vu=(User)umc.find(cbs[j].getCostbookVerifyId());
            out.println("OK-"+vu.getUserFullname()+"<br>"+sdf.format(cbs[j].getCostbookVerifyDate()));
        }
%>
		</tD>
		<td  class=es02><a href="modifyCostbook.jsp?cid=<%=cbs[j].getId()%>">詳細資料</a></tD> 
	</tr>
<%
    }

    if(type !=99)	
    {
%>
	<tr class=es02>
		<td  colspan=5>合計</td>
		<td align=right><b><%=mnf.format(total1)%></b></td><td align=right><%=mnf.format(total2)%></td><td align=right><%=mnf.format(total1-total2)%></td>
 	</tr>
<%
	}
%>
</table>		
</td>
</tr>
</table>

</center>
<br>
<%@ include file="bottom.jsp"%>	
