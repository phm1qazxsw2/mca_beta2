<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    int cid = Integer.parseInt(request.getParameter("cid"));
    try {
        tran_id = dbo.Manager.startTransaction();
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ArrayList<ChargeItemMembr> allcharges = new ChargeItemMembrMgr(tran_id).
            retrieveList("chargeItemId=" + cid, "");
        // MembrId
        Map<Integer, Vector<ChargeItemMembr>> chargeMap = 
            new SortingMap(allcharges).doSort("getMembrId");

        EzCountingService ezsvc = EzCountingService.getInstance();
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String str = (String)e.nextElement();
            if (str.charAt(0)=='_') {
                String key = str.substring(1);
                String[] tokens = key.split("#");
                int membrId = Integer.parseInt(tokens[0]);
                int chargeItemId = Integer.parseInt(tokens[1]);
                int amount = Integer.parseInt(request.getParameter(str));
                ChargeItemMembr ci = chargeMap.get(new Integer(membrId)).get(0);                
                if (amount!=ci.getMyAmount()) {
                    ezsvc.setChargeItemMembrAmount(tran_id, ci, amount, ud2.getId(), nextFreezeDay);

                    // ###### handle 學用品 ######
                    if (ci.getPitemId()>0) {
                        int pitemnum = Integer.parseInt(request.getParameter("@" + key));
                        if (ci.getPitemNum()!=pitemnum) {
                            Charge c = cmgr.find("chargeItemId=" + chargeItemId + " and membrId=" + membrId);
                            c.setPitemNum(pitemnum);
                            cmgr.save(c);
                        }
                    }
                    // ###########################
               }
            }
        }
 
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        User u =  _ws2.getCurrentUser();
        vsvc.updateChargeItemMembrs(allcharges, u.getId(), "");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("修改造成有人收費金額小於0，沒有存入");history.go(-1);</script><%
          return;
        } else {
            if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
          %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
            e.printStackTrace();
            return;
        }
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect(request.getParameter("backurl"));
%>

