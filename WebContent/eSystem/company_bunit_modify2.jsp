<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    boolean commit = false;
    int tran_id = 0;
    int bid = Integer.parseInt(request.getParameter("bid"));
    try {           
        tran_id = dbo.Manager.startTransaction();

        int status = Integer.parseInt(request.getParameter("status"));
      
        BunitMgr bm = new BunitMgr(tran_id);

        Bunit b = bm.find("id="+bid);
        b.setLabel(request.getParameter("name"));
        b.setStatus(status);
        bm.save(b);
        
        int bankId = Integer.parseInt(request.getParameter("bankId"));
        String serviceID = request.getParameter("serviceID");
        String storeID = request.getParameter("storeID");
        String virtualID = request.getParameter("virtualID");

        BunitHelper bh = new BunitHelper(tran_id);
        Binfo bi = bh.getBinfo(b.getId());
        bi.setBankId(bankId);
        bi.setServiceID(serviceID);
        bi.setStoreID(storeID);
        bi.setVirtualID(virtualID);

        bi.setAcodeBunitId(Integer.parseInt(request.getParameter("acodeBunitId")));
        bi.setStudentBunitId(Integer.parseInt(request.getParameter("studentBunitId")));
        bi.setMetaBunitId(Integer.parseInt(request.getParameter("metaBunitId")));

        bi.setFullname(request.getParameter("fullname"));
        bi.setAddress(request.getParameter("address"));
        bi.setPhone(request.getParameter("phone"));

        new BinfoMgr(tran_id).save(bi);

        bh.reset();

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) {
  %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        }
        else {
  %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }    
%>
<blockquote>
<div class=es02>
    修改完成.
    <br>
    <a href="company_bunit_modify.jsp?bid=<%=bid%>">繼續編輯</a>
</div>
</blockquote>
<script>
    parent.do_reload = true;
</script>