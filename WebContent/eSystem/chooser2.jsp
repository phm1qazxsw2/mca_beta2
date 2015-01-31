<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%	
    //##v2
    int tagId = Integer.parseInt(request.getParameter("tag"));
    Tag t = TagMgr.getInstance().find("id=" + tagId);
    if (t == null)
        throw new Exception("找不到學生標籤");
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int recordId = Integer.parseInt(tokens[0]);
    int bitemId = Integer.parseInt(tokens[1]);
    int citemId = Integer.parseInt(tokens[2]);
    BillRecord billrecord = BillRecordMgr.getInstance().find("id="+recordId);

    TagMembrStudentMgr tsmgr = TagMembrStudentMgr.getInstance();
    Object[] objs = tsmgr.retrieve("tag.id=" + t.getId() + " and studentStatus=4", "");

    EzCountingService ezsvc = EzCountingService.getInstance();
    ChargeItem citem = null;    
    WebSecurity ws2 = WebSecurity.getInstance(pageContext);

    int tran_id = 0;
    boolean commit = false;
    int added = 0;
    int locked = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        if (citemId<=0) {
            citem = new BillChargeItemMgr(tran_id).find("billrecord.id=" + recordId + " and billitem.id=" + bitemId);
            if (citem.getId()==0) // 一定會 return a citem, 但 id=0 就代表還沒有 chargeItem
                citem = ezsvc.makeChargeItem(tran_id, recordId, bitemId);
        }
        else {
            citem = new ChargeItemMgr(tran_id).find("id=" + citemId);
        }
        int cid = citem.getId();
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bi = bimgr.find("id=" + citem.getBillItemId());
        boolean connecting_product = (bi.getPitemId()>0);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ArrayList<Charge> modified_charges = new ArrayList<Charge>();
        for (int i=0; objs!=null&&i<objs.length; i++) {
            TagMembrStudent s = (TagMembrStudent) objs[i];
            try {
                Charge c = ezsvc.addChargeMembr(tran_id, citem, s.getMembrId(), billrecord, ud2.getId(), t, nextFreezeDay);
                modified_charges.add(c);
                added ++;
                if (connecting_product) {
                    c.setPitemNum(1);
                    cmgr.save(c);
                }
            }
            catch (AlreadyExists a) {
                if (cmgr.numOfRows("chargeItemId=" + cid + " and membrId=" + s.getMembrId() + " and tagId=" + t.getId())==0) 
                {
                    System.out.println("chargeItemId=" + cid + " and membrId=" + s.getMembrId());
                    cmgr.executeSQL("update charge set tagId=" + t.getId() + " where chargeItemId=" + cid + " and membrId=" + s.getMembrId());
                }
            }
            catch (Locked l) {
                locked ++;
            }
        }

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateCharges(modified_charges, ud2.getId(), bi.getName());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
          %><script>alert("此批加入造成有人金額小於0,沒有成功!");history.go(-1)</script><%
        } else {
            if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
          %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
            return;
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
<div class=es02>
    <b>加入成功:</b> <font color=blue><%=added%></font> 筆<%=(pd2.getCustomerType()==0)?"學生":"客戶"%>成功加入到收費項目!
    <br>
    <br>
    <% if (added<objs.length) { %>
       <b>加入失敗:</b> 
            <blockquote>
            <%
            if((objs.length-added-locked)!=0){
            %>
                <font color=red><%=(objs.length-added-locked)%></font>  筆重複不再加入 ; 
            <% }
             if(locked !=0){ %>
            <br><br>            
            <font color=red><%=locked%></font> 筆帳單已鎖住,請先解鎖才能加入 .

            <%  }   %>
            </blockquote>
    <%
       }    
    %>

    <br>
    <a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁</a>
</div>

</blockquote>
