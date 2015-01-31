<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%
	
    	String userIdS=request.getParameter("userId");
        String sz=request.getParameter("z");

		CostMgr cm=CostMgr.getInstance();
		
		Cost co=(Cost)cm.find(Integer.parseInt(sz));

		if(co==null)	
		{
			out.println("沒有資料");
			return;
		}	
		int userId=Integer.parseInt(userIdS);
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
		
		BigItemMgr bim=BigItemMgr.getInstance();
		SmallItemMgr sim=SmallItemMgr.getInstance(); 
		
		
		CostbookMgr cms=CostbookMgr.getInstance();
		Costbook cb=(Costbook)cms.find(co.getCostCostbookId());

		boolean runStatus=false;
		int type=cb.getCostbookOutIn();
 
		if(type==0)
			  runStatus =JsfPay.INCOMEStatus(cb.getCostbookAccountDate());
		else if(type==1)
			 runStatus =JsfPay.COSTStatus(cb.getCostbookAccountDate());

%>		

<form action="modifyCostX.jsp" method="post">

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
			 <tr>
				<td bgcolor=#f0f0f0 class=es02>序號</td>
				<td bgcolor=#ffffff class=es02><%=co.getId()%></td> 	
			</tr>
			<tr>
				<td bgcolor=#f0f0f0 class=es02>名稱</td>
				<td bgcolor=#ffffff class=es02><input type=text name=costName value="<%=co.getCostName()%>"></td> 	
			</tr>
			<tr> 	
				<td bgcolor=#f0f0f0 class=es02>登入日期</td>
				<td bgcolor=#ffffff class=es02><%=df.format(co.getCreated())%></td>
			</tr> 
			<tr>
				<td bgcolor=#f0f0f0 class=es02> 
					最後修改日期
				</td>
				<td bgcolor=#ffffff class=es02> 
					<%=df.format(co.getModified())%>
				</td>
			</tr>	
			<tr>
				<td  bgcolor=#f0f0f0 class=es02>科目<img src="pic/file.gif" border=0></td> 
				<td bgcolor=#ffffff class=es02>
				<%
							BigItem biX=(BigItem)bim.find(co.getCostBigItem());
							out.println(biX.getBigItemName()+"->");			
							SmallItem siX=(SmallItem)sim.find(co.getCostSmallItem());							
							out.println(siX.getSmallItemName());
				%>
				</td>
			
            </tr>
            <tr>
				<td  bgcolor=#f0f0f0 class=es02>金額</td> 
				<td  bgcolor=#ffffff class=es02>
					<input type=text name="costMoney" value="<%=co.getCostMoney()%>">
				</td>
			
            </tr>	
			<tr>
				<td  bgcolor=#f0f0f0 class=es02>註記</td> 
				<td  bgcolor=#ffffff class=es02> 
				<textarea name="ps" rows=3 cols=25><%=co.getCostPs()%></textarea>
				</td>		
			
            </tr>	
            <tr>
			<td colspan=2>	
                <center>
<%		
		if(co.getCostLogId()==userId)
		{ 				
			
			if(cb.getCostbookVerifyStatus()<90) 
			{ 
				if(runStatus)
{
 			%>
       

                    <input type=hidden name="cid" value="<%=co.getId()%>">
				
                    <input type=submit value="修改" onClick="return confirm('將修改此項金額')">
                    <div align=right><a href="deleteCostX.jsp?cid=<%=co.getId()%>"  onClick="return confirm('將刪除此明細')"><img src="pic/delete.gif" border=0>刪除</a></div>
           
			
				<% 
					}else{
						out.println("本月已結帳,不得修改");
					} 	
				
				}else{
					out.println("已審核");
				}
				%>
<% 
		
		}else{
%>
			非登入者,沒有修改權限.
    
<%
            }
    %>	
            </form>
            </center>
            </td>
            </tr>	
		</table>		
		</td>
		</tr>
		</table>	

	