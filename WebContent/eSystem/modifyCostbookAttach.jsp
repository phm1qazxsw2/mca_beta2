<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%
		String ps=request.getParameter("ps");
		String cbName=request.getParameter("cbName");
		int attachway=Integer.parseInt(request.getParameter("attachway"));
		int attachStatus=Integer.parseInt(request.getParameter("attachStatus"));
		int costtradeId=Integer.parseInt(request.getParameter("costtradeId"));
		
		int cid=Integer.parseInt(request.getParameter("cid"));
		
		CostbookMgr cbm=CostbookMgr.getInstance();
		Costbook cb=(Costbook)cbm.find(cid);

        JsfTool jt=JsfTool.getInstance();
        Date accountDate = jt.ChangeToDate(request.getParameter("CostbookAccountDate"), cb.getCostbookAccountDate());

        boolean runStatus = (cb.getCostbookOutIn()==0)
            ?JsfPay.INCOMEStatus(accountDate):JsfPay.COSTStatus(accountDate);
        if(!runStatus)
        {
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM");
            out.println("<br><br><blockquote><img src=\"pic/warning.gif\" border=0><font color=red>Error:</font>"+sdf.format(accountDate)+"已結帳,不可更動.<br><br>");
            out.println("<a href=\"javascript:history.go(-1);\">回上一頁</a>");
            return;
        }
        //單頭可改，明細和付款明細不能改
        //if (cb.getCostbookVerifyStatus()==90) {
        //    response.sendRedirect("userError.jsp?reason=" + java.net.URLEncoder.encode("本單已確認不可修改","UTF-8"));
        //    return;
        //}
		
		cb.setCostbookName(cbName);
		cb.setCostbookLogPs(ps);
		cb.setCostbookAttachStatus(attachStatus);
		cb.setCostbookAttachType(attachway); 
		cb.setCostbookCosttradeId(costtradeId);

        cb.setCostbookAccountDate(accountDate);
		cbm.save(cb);
		
		response.sendRedirect("modifyCostbook.jsp?cid="+cid);
%>