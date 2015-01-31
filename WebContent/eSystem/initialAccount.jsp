<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,3)) 
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }   

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss"); 
    DecimalFormat nf = new DecimalFormat("###,##0.00");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");
    JsfAdmin ja=JsfAdmin.getInstance();
    SalaryAdmin sa=SalaryAdmin.getInstance();

    JsfPay jp=JsfPay.getInstance();
    Tradeaccount[] tradeA=jp.getAllTradeaccount(_ws.getBunitSpace("bunitId"));
%>
    <br>
    <div class=es02>
    <b>&nbsp;&nbsp;&nbsp;帳戶初始化 </b>
    </div>
    <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>				

    <blockquote>
    <form action="initialAccount2.jsp" method="post" name="xs" id="xs">    
    <table width="70%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=f0f0f0 class=es02>
        <td width=100>初始化時間</td>
        <td bgcolor=ffffff>
            <input type=text name="initialDate" value="<%=sdf.format(new Date())%>" disabled>
            <br>
            說明:為了確保本次初始時間之後的資料完整性，初始時間之前的所有現金
            將無法再作修改(學費收款,薪資付款,雜費收付款,內部轉帳。。)
        </td>
    </tr>
    <tr bgcolor=f0f0f0 class=es02>
        <td>初始原因</td>
        <td bgcolor=ffffff>
            <textarea rows=3 cols=40 name="initialPs"></textarea>
        </td>
    </tr>
    <tr bgcolor=f0f0f0 class=es02>
        <td>零用金帳戶調結</td>
        <td bgcolor=ffffff>

<%
    if(tradeA==null)
    {
        out.println("<br><br><blockquote>沒有零用金帳戶</blockquote>");

    }else{ 
%>
            <table width="" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">


            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff align=left valign=middle>
                    <td bgcolor=#f0f0f0 class=es02 width=150 align=middle>帳戶名稱</tD>
                    <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>現有餘額</td>
                    <td bgcolor=#f0f0f0 class=es02 width=100 align=middle>調節餘額</tD>    
                </tr>
<% 			
            int total = 0;
            for(int j=0;j<tradeA.length;j++)
            {
                Tradeaccount t = (Tradeaccount) tradeA[j];
                IncomeCost ic = jp.getIncomeCost(1, t.getId(), 99, 99, new Date());
                total += (ic.getIncome() - ic.getCost());
%>
		    <tr bgcolor=#ffffff align=left valign=middle>
				<td class=es02>
                    <%=t.getTradeaccountName()%>
				</td>				   
				<td class=es02  align=right>
					 <%=mnf.format(ic.getIncome() - ic.getCost())%>
				</tD>	
                <td class=es02  align=right nowrap>
                    <input type=checkbox name="trade" value="<%=t.getId()%>" onClick="javascript:goChange('<%=j%>')">
				    <input type=text size=10 name="a##<%=t.getId()%>" value="<%=ic.getIncome() - ic.getCost()%>" disabled>
				</tD>
			</tr>
            <%
            }
            %>
            <tr>
                <td></td>
                <tD align=right><b><%=mnf.format(total)%></b></td> 
                <td></td>
            </tr>
            </table>
            </td>
            </tr>
            </table>
        <%  }   %>

                </td>
            </tr>
            <tr bgcolor=f0f0f0 class=es02>
                <td colspan=2 align=right bgcolor=ffffff>
<a href="javascript:openwindow_phm('addTradeaccount.jsp','新增零用金帳號',350,400,true);"><img src="pic/add.gif" width=15 border=0>&nbsp;新增零用金帳號</a> 
                </td>
            </tr>
            <tr bgcolor=f0f0f0 class=es02>
                <td>銀行帳戶調結</td>
                <td bgcolor=ffffff>
            <%	
                BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId"));

                if(ba==null)
                {
                    out.println("<br><br><blockquote>沒有銀行帳戶</blockquote>");
                }
                else {
            %>
                
                <table width="" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">


                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#ffffff align=left valign=middle>
                        <td bgcolor=#f0f0f0 class=es02 width=150 align=middle>帳戶名稱</tD>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>餘額</td>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle></tD> 
                    </tr>
                <%
                    int total = 0;                
                    for(int j=0;j<ba.length;j++)
                    {
                        BankAccount b = (BankAccount) ba[j];
                        IncomeCost ic = jp.getIncomeCost(2, b.getId(), 99, 99, new Date());
                        total += (ic.getIncome() - ic.getCost());             
                %>
                    <tr bgcolor=#ffffff align=left valign=middle>
                        <td class=es02>
                            <%=b.getBankAccountName()%>
                        </td>
                        <td class=es02  align=right>
                            <%=mnf.format(ic.getIncome() - ic.getCost())%>	
                        </tD>							
                        <td class=es02 nowrap>
                            <input type=checkbox name="bank" value="<%=b.getId()%>" onClick="javascript:goChange2('<%=j%>')">
                            <input type=text size=10 name="b##<%=b.getId()%>" value="<%=ic.getIncome()-ic.getCost()%>" disabled>
                        </td>
                    </tr>                        
                <%
                    }
                %>
                    <tr>
                        <td></td>
                        <tD align=right><b><%=mnf.format(total)%></b></td> 
                        <td></td>
                    </tr>
            <%
                }
            %>
                    </table>
                    
                </td>
            </tr>
            </table>


        </td>
    </tr>
    <tr bgcolor=f0f0f0 class=es02>
        <td colspan=2 align=right bgcolor=ffffff>
            <a href="javascript:openwindow_phm('addBankAccount.jsp','新增銀行帳戶',500,550,true);"><img src="pic/add.gif" border=0 width=15>&nbsp;新增銀行帳戶</a>        
        </td>
    </tr>
    <tr bgcolor=f0f0f0 class=es02>
        <td colspan=2 align=middle bgcolor=ffffff>
            <input type=submit value="開始初始化" onClick="return(confirm('確認初始化?'))">
        </td>
    </tr>         
        </table>
        </tD>
        </tr>
        </table>
    </form>       
    </blockquote>
    <script>
      
        function goChange(tradeId){
  
            var bid=document.xs.trade[tradeId].value;
            if (document.xs.trade[tradeId].checked==true){
                
                document.xs.elements['a##'+bid].disabled=false;

            }else{
                document.xs.elements['a##'+bid].disabled=true;
            }

        }

        function goChange2(tradeId){
  
            var bid=document.xs.bank[tradeId].value;
            if (document.xs.bank[tradeId].checked==true){

                document.xs.elements['b##'+bid].disabled=false;

            }else{
                document.xs.elements['b##'+bid].disabled=true;
            }

        }        
    </script>
<%@ include file="bottom.jsp"%>