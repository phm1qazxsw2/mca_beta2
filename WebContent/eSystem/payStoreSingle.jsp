<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>

<%@ include file="topMenu.jsp"%>

<%
	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
	String data=request.getParameter("data");

	PayStoreMgr psm=PayStoreMgr.getInstance();
	
	
	try
        {
           
		int psId=jt.insertPayStory(data.trim());                
            
    		PayStore ps=(PayStore)psm.find(psId);
    	
    		if(ps.getPayStoreStatus()!=90)
    		{
    	%>
    		<b>匯入失敗的檔案:</b>
            	<table>
            	<tr>
            	<td>原始資料</td><td>例外資訊</td><td></td>
            	</tr>
            	<tr>
            	<td><%=jt.formatString(ps.getPayStoreSource())%></td>
            	<td><%=ps.getPayStoreException()%></td>
            	<td>詳細資料</td>
            	</tr>	
            	</table>
            <%
            	}else{
            	
            		Feeticket ft=ja.getFeeticketByNumberId(ps.getPayStoreFeeticketId());
            	
            		StudentMgr sm=StudentMgr.getInstance();
            		Student stu=(Student)sm.find(ft.getFeeticketStuId());
            		
            		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM");
            %>
            <b>匯入成功的資料:</b>
            	<table>
            	<tr>
            	<td>流水序號</td><td>繳款人</td><td>繳款日期</td><td>金額</td><td></td>
            	</tr>
            	
            	<tr>
            	<td><%=ps.getPayStoreFeeticketId()%></td>
            	<td><%=stu.getStudentName()%></td>
            	<td><%=sdf2.format(ft.getFeeticketMonth())%></td>
            	<td><%=ps.getPayStorePayMoney()%></td>
            	<td>詳細資料</td>
            	</tr>
            	</table>
<%
           	}
        }
        catch (Exception e)
        {
            out.println(e.getMessage());   
        }                   
    
%>
