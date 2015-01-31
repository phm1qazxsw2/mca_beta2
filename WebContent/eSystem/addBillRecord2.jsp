<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int billId = Integer.parseInt(request.getParameter("billId"));
    String name = request.getParameter("record");
    String month = request.getParameter("month");
    String billDateStr = request.getParameter("billDate");
    Date mm = new java.text.SimpleDateFormat("yyyy-MM").parse(month);
    Date billDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(billDateStr);
    if (name==null)
        throw new Exception("name is null");
    int copyfrom = -1;
    try { copyfrom = Integer.parseInt(request.getParameter("copyfrom")); } catch (Exception e) {}
    EzCountingService ezsvc = EzCountingService.getInstance();
    boolean outsourcing = (pd2.getWorkflow()==2);    

    boolean commit = false;
    int tran_id = 0;
    BillRecord br = null;
    try { 
        tran_id = Manager.startTransaction();  

        Bill b = BillMgr.getInstance().find("id="+billId);
        BillRecord copybr = BillRecordMgr.getInstance().find("id="+copyfrom);
        br = ezsvc.createBillRecord(tran_id, b, name, mm, billDate, copybr, ud2.getId());
        //##
        //VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        //vsvc.updateBillRecord(br, ud2.getId());

        if (outsourcing) {
            FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
            // 找出所有的這個 billrecord 有 payrollFdId 的 feedetail
            ArrayList<FeeDetailInfo> fds = new FeeDetailInfoMgr(tran_id).retrieveList("chargeitem.billRecordId=" + 
                br.getId() + " and payrollFdId>0", "");
            String fdIds = new RangeMaker().makeRange(fds, "getPayrollFdId");
            ArrayList<FeeDetail> org_sfds = fdmgr.retrieveList("id in (" + fdIds + ")", "");
            Map<Integer, FeeDetail> orgpayrollMap = new SortingMap(org_sfds).doSortSingleton("getId");

            // 不 call updatePayrollEntry 就是要避開重算 percent 的問題，要用舊的
            // 找出payroll的chargeItem
            ChargeItem nci = FeeDetailHandler.findPayrollChargeItem(tran_id, br);
            for (int i=0; i<fds.size(); i++) {
                FeeDetail fd = fds.get(i); // 新的帳單 fd
                FeeDetail opfd = orgpayrollMap.get(fd.getPayrollFdId()); // 舊的薪資 fd
                if (opfd==null) {
                    fd.setPayrollFdId(0);
                    fdmgr.save(fd);
                    continue;                
                }
                FeeDetail npfd = opfd.clone();
                npfd.setId(0);
                npfd.setChargeItemId(nci.getId()); // 設成新薪資的 chargeitem
                npfd.setPayrollFdId(fd.getId()); 
                fdmgr.create(npfd);

                boolean do_remove = false;
                Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
                ezsvc.updateFeeDetail(tran_id, npfd, do_remove, ud2, nextFreezeDay);

                fd.setPayrollFdId(npfd.getId());
                fdmgr.save(fd);
            }
        }

        commit = true;
        Manager.commit(tran_id);

        // finish creation, check if any need to modified
        if (copyfrom>0) {
            response.sendRedirect("billrecord_tag.jsp?&brid=" + br.getId());
            return;
        }
    }
    finally {
        if (!commit) {
            try { Manager.rollback(tran_id); } catch (Exception e) {}
        }
    }
%>
<body>
<blockquote>
產生成功！
<br>
<br>
<a target=_top href="editBillRecord.jsp?recordId=<%=br.getId()%>">編輯帳單</a>
</blockquote>
</body>
