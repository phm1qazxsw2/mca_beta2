<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);

        ArrayList<Charge> modified_charges = new ArrayList<Charge>();

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        EzCountingService ezsvc = EzCountingService.getInstance();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String str = (String)e.nextElement();
            if (str.charAt(0)=='_') {
                String key = str.substring(1);
                String[] tokens = key.split("#");
                int membrId = Integer.parseInt(tokens[0]);
                int chargeItemId = Integer.parseInt(tokens[1]);
                int amount = Integer.parseInt(request.getParameter(str));
                Charge c = cmgr.find("chargeItemId=" + chargeItemId + " and membrId=" + membrId);
                ChargeItem ci = cimgr.find("id=" + chargeItemId);
                int org_num = Math.abs(c.getAmount());
                int salaryType = ci.getSmallItemId();
                int diff = BillItem.calc_salary_diff(org_num, amount, salaryType, salaryType);
                if (diff!=0) {
                    c.setAmount(c.getAmount()+diff);
                    cmgr.save(c);
                    ezsvc.updateCharge(tran_id, chargeItemId, membrId, diff, nextFreezeDay);
                    modified_charges.add(c);
                }
            }
        }

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateSalaryCharges(modified_charges, ud2.getId(),"");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("修改造成有人薪資金額小於0，沒有存入");history.go(-1);</script><%
          return;
        } else {
            if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
                e.printStackTrace();
          %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
            return;
        }
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect(request.getParameter("backurl"));
%>

