<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,phm.ezcounting.*,mca.*,java.lang.reflect.*,java.util.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>	
<%
boolean commit = false;
int tran_id = 0;
String do_action = "";
String fname = "";
try {           
    tran_id = dbo.Manager.startTransaction();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    McaFeeMgr feemgr = new McaFeeMgr(tran_id);
    Enumeration names = request.getParameterNames();
    McaFee fee = feemgr.find("id=" + request.getParameter("id"));
    String oldTitle = fee.getTitle();
    Date oldMonth = fee.getMonth();
    Date oldBillDate = fee.getBillDate();

    Class c = fee.getClass();
    Method[] methods = c.getDeclaredMethods();
    Map<String, Method> methodMap = new SortingMap(methods).doSortSingleton("getName");

    Object[] params = new Object[1];
    while(names.hasMoreElements()) {
        String name=(String)names.nextElement();
        if (name.equals("title") || name.equals("month") || name.equals("billDate") || name.equals("do_action") ||
            name.equals("feeType") || name.equals("noname") || name.equals("regPrepayDeadline") || name.equals("regPenalty") || name.equals("b2") || name.equals("b1"))
            continue;
        String methodName = "set" + name.substring(0,1).toUpperCase() + name.substring(1);
        Method m = methodMap.get(methodName);
        int v = Integer.parseInt(request.getParameter(name));
        params[0] = new Integer(v);
        Object ret = m.invoke(fee, params);
    }
    
    fee.setTitle(request.getParameter("title"));
    String month = request.getParameter("month");
    fee.setMonth(sdf.parse(month));
    String billDate = request.getParameter("billDate");
    fee.setBillDate(sdf1.parse(billDate));
    try {
        String regPrepayDeadline = request.getParameter("regPrepayDeadline");
        fee.setRegPrepayDeadline(sdf1.parse(regPrepayDeadline));
    }
    catch (Exception e) 
    {
    }
    try {
        fee.setRegPenalty(Integer.parseInt(request.getParameter("regPenalty")));
    }
    catch (Exception e)
    {
        e.printStackTrace();
    }

    /*
    String feeType = request.getParameter("feeType");
    try {   
        fee.setFeeType((feeType.equals("1"))?McaFee.FALL:(feeType.equals("2"))? McaFee.SPRING:McaFee.REGISTRATION_ONLY); 
    } catch (Exception e) {}
    if (fee.getFeeType()==McaFee.FALL) {
        int checkFeeId = 0;
        try { checkFeeId = Integer.parseInt(request.getParameter("checkFeeId")); } catch (Exception e) {}
        fee.setCheckFeeId(checkFeeId);
    }
    */

    feemgr.save(fee);
    ArrayList<Charge> conflict_list = new ArrayList<Charge>();
    do_action = request.getParameter("do_action");   
    
	boolean monty_overflow_after_change = false;
	String msg = null;
    if (do_action.equals("create") || do_action.equals("dry")) {
        McaService mcasvc = new McaService(tran_id);
        ArrayList<Charge> newcharges = new ArrayList<Charge>();
        ArrayList<Charge> modifiedcharges = new ArrayList<Charge>();
        ArrayList<Charge> deletedcharges = new ArrayList<Charge>();
        StringBuffer sbuf = new StringBuffer();
        sbuf.append("Run details:<br>\n");

		try {
			mcasvc.generateBills(fee, _ws2.getSessionBunitId(), conflict_list, newcharges, 
				modifiedcharges, deletedcharges, sbuf);
		}
		catch (Exception e) {
			msg = e.getMessage();
			if (msg==null || msg.indexOf("This change will cause")<0) {
				throw e;
			}
			else {
				monty_overflow_after_change = true;
			}
		}

        File f1 = new File(request.getRealPath("/"),"pdf_output");
        fname = new Date().getTime() + ".htm"; 
        PrintWriter pr = new PrintWriter(new OutputStreamWriter(new FileOutputStream(
            new File(f1, fname))));
        pr.println(sbuf.toString());
        pr.close();

        out.println("new charges: " + newcharges.size()+ ((newcharges.size()>0)?" <a href=\"javascript:show_detail(1)\">detail</a>":"")+"<br>");
        out.println("modified charges: " + modifiedcharges.size() + ((modifiedcharges.size()>0)?" <a href=\"javascript:show_detail(2)\">detail</a>":"")+"<br>");
        out.println("deleted charges: " + deletedcharges.size() + ((deletedcharges.size()>0)?" <a href=\"javascript:show_detail(3)\">detail</a>":"")+"<br>");

        if (conflict_list.size()>0) {
            String membrIds = new RangeMaker().makeRange(conflict_list, "getMembrId");
            String chargeItemIds = new RangeMaker().makeRange(conflict_list, "getChargeItemId");
            EzCountingService ezsvc = EzCountingService.getInstance();
            Map<String, Charge> conflictchargeMap = new SortingMap(conflict_list).doSortSingleton("getChargeKey");
            ArrayList<ChargeItemMembr> citems = new ChargeItemMembrMgr(tran_id).retrieveList("charge.membrId in (" + membrIds + 
                ") and charge.chargeItemId in (" + chargeItemIds + ")", "");
            DecimalFormat mnf = new DecimalFormat("###,###,##0");
            %>
              Conflicts: <br>
              <table width="390" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                    
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr class=es02 align=center bgcolor=f0f0f0>
                        <td>
                            Student 
                        </td>
                        <td>
                            Fee
                        </td>
                        <td nowrap>
                            Calulated Amount
                        </td>
                        <td nowrap>
                            Current Amount
                        </td>
                        <td nowrap>
                            Modified By
                        </td>
                    </tr>
    <%
            for (int i=0; i<citems.size(); i++) {
                ChargeItemMembr ci = citems.get(i);
                Charge newcharge = conflictchargeMap.get(ci.getChargeKey());
                String kk = newcharge.getChargeKey().replace("#", "_");
    %>
                    <tr class=es02 bgcolor=ffffff>
                        <td align=left nowrap>
                           &nbsp;<%=ci.getMembrName()%>&nbsp;
                        </td>
                        <td  align=left nowrap>
                            &nbsp;<%=ci.getChargeName()%>&nbsp;
                        </td>
                        <td align=right nowrap>
                        <% if (!do_action.equals("dry")) { %>
                            &nbsp;<span id="<%=kk%>"><input type=button value="use" onclick="use_new('<%=kk%>',<%=newcharge.getAmount()%>)"></span> 
                        <% } %>
                            &nbsp;<%=mnf.format(newcharge.getAmount())%>
                        </td>
                        <td align=right nowrap>
                            &nbsp;<a target=_blank href="bill_detail.jsp?rid=<%=ci.getBillRecordId() %>&sid=<%=ci.getMembrId()%>&backurl="><%=mnf.format(ci.getMyAmount())%></a>
                        </td>
                        <td align=right nowrap>
                            &nbsp;<%=ezsvc.getUserName(ci.getUserId())%>&nbsp;
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
    %>
        <!--START
    <%
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<newcharges.size(); i++) {
            if (i>0) sb.append(",");
            sb.append(newcharges.get(i).getChargeKey());
        }
        %>create_list = '<%=phm.util.TextUtil.escapeJSString(sb.toString())%>';<%
        sb = new StringBuffer();
        for (int i=0; i<modifiedcharges.size(); i++) {
            if (i>0) sb.append(",");
            sb.append(modifiedcharges.get(i).getChargeKey());
        }
        %>modified_list = '<%=phm.util.TextUtil.escapeJSString(sb.toString())%>';<%
        sb = new StringBuffer();
        for (int i=0; i<deletedcharges.size(); i++) {
            if (i>0) sb.append(",");
            sb.append(deletedcharges.get(i).getChargeKey());
        }
        %>deleted_list = '<%=phm.util.TextUtil.escapeJSString(sb.toString())%>';    
        END-->
    <%
    }

    // update BillRecord Title, Month and billDate if necessary
    ArrayList<McaRecord> mrs = new McaRecordMgr(tran_id).retrieveList("mcaFeeId=" + fee.getId(), "");
    if (mrs.size()>0) {
        BillRecordMgr brmgr = new BillRecordMgr(tran_id);
        for (int i=0; i<mrs.size(); i++) {
            BillRecord br = brmgr.find("id=" + mrs.get(i).getBillRecordId());
            MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
            boolean br_modified = false;
            if (!oldTitle.equals(fee.getTitle())) {
                Bill b = new BillMgr(tran_id).find("id=" + br.getBillId());
                br.setName(b.getPrettyName() + " " + fee.getTitle());
                br_modified = true;
            }
            if (oldMonth.compareTo(fee.getMonth())!=0) {
                if (mbrmgr.numOfRows("billRecordId=" + br.getId() + " and paidStatus!=" + MembrBillRecord.STATUS_NOT_PAID)>0)
                    throw new Exception("Some bills already paid, cannot modify month");
                if (mbrmgr.numOfRows("billRecordId=" + br.getId() + " and printDate>0")>0)
                    throw new Exception("Some bills are locked, unlock them before change month");
                br.setMonth(fee.getMonth());
                br_modified = true;
            }
            if (oldBillDate.compareTo(fee.getBillDate())!=0) {
                br.setBillDate(fee.getBillDate());
                br_modified = true;
                mbrmgr.executeSQL("update membrbillrecord set billDate='" + 
                    sdf1.format(fee.getBillDate()) + "' where billRecordId=" + br.getId());
            }
            if (br_modified)
                brmgr.save(br);        
        }
    }

    if (!do_action.equals("dry") && !monty_overflow_after_change) {
        dbo.Manager.commit(tran_id);
        commit = true;
    }

    if (do_action.equals("create") || do_action.equals("dry")) {
		if (monty_overflow_after_change) {
			out.println("<h1><font color=red>" + msg + " Change Not Commit!</font></h1>");
		}
        out.println("<br><a target=_blank href=\"../pdf_output/"+fname+"\">show details</a>");
        out.println("<br><br> <a href=\"mca_fee_list.jsp\">go to fee listing</a>");
        out.println("<br> <a href=\"javascript:parent.feewin.hide()\">close</a>");
    }
    else 
        response.sendRedirect("mca_fee.jsp?id=" + request.getParameter("id"));
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
  %>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
    } else {
  %>@@錯誤發生，設定沒有寫入<%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>

