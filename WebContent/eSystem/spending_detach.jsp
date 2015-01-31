<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        int id = Integer.parseInt(request.getParameter("id"));
        VitemMgr vimgr = new VitemMgr(tran_id);
        VPaidMgr vpmgr = new VPaidMgr(tran_id);

        ArrayList<VPaid> paids = vpmgr.retrieveList("vitemId=" + id, "");
        if (paids.size()>0) {
            String costpayIds = new RangeMaker().makeRange(paids, "getCostpayId");
            ArrayList<VPaid> paids2 = vpmgr.retrieveList("costpayId in (" + costpayIds + ")", "");
            if (paids.size()!=paids2.size())
                throw new Exception("1");
        }

        Vitem vi = vimgr.find("id=" + id);
        int voucherId = vi.getVoucherId();
        vi.setVoucherId(0);
        vimgr.save(vi);

        if (vimgr.numOfRows("voucherId=" + voucherId)==1) {
            Vitem vi2 = vimgr.find("voucherId=" + voucherId);
            vi2.setVoucherId(0);
            vimgr.save(vi2);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("1")) {
          %><script>alert("有合倂收付款不可拆開,請先刪除該筆款項收付");history.go(-1);</script><%
              return;
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect(request.getParameter("backurl"));
%>
