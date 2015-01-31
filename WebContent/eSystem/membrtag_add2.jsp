<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    boolean commit = false;
    int tran_id = 0;
    int cid = -1;
    try {            
        tran_id = dbo.Manager.startTransaction();

        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        int typeId = Integer.parseInt(request.getParameter("tagtype"));
        Tag t = new Tag();
        t.setName(name);
        t.setTypeId(typeId);
        t.setBunitId(_ws2.getSessionBunitId());
        new TagMgr(tran_id).create(t);

        //####### 加入從收費項目匯出名單至標籤 #####
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        cid = Integer.parseInt(request.getParameter("cid"));
        if (cid>0) {
            ArrayList<ChargeItemMembr> charges = new ChargeItemMembrMgr(tran_id).
                retrieveList("charge.chargeItemId=" + cid, "");

            Iterator<ChargeItemMembr> iter = charges.iterator();
            StringBuffer sb = new StringBuffer();
            while (iter.hasNext()) {
                ChargeItemMembr ci = iter.next();
                TagMembr tm = new TagMembr();
                tm.setTagId(t.getId());
                tm.setMembrId(ci.getMembrId());
                tmmgr.create(tm);
                if (sb.length()>0) sb.append(" or ");
                sb.append("(chargeItemId=" + ci.getChargeItemId() + " and membrId=" + ci.getMembrId() + ")");
            }

            if (sb.length()>0) {
                ChargeMgr cmgr = new ChargeMgr(tran_id);
                cmgr.executeSQL("update charge set tagId=" + t.getId() + " where " + sb.toString());
            }
        }            
        //##########################################

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
新增成功！
<% if (cid>0) { %>
<br><br>
新增的標籤可在學生管理界面看到
<% } %>
</blockquote>
