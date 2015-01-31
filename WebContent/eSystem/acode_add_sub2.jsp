<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    String main = "";
    String sub = "";
    try {           
        tran_id = dbo.Manager.startTransaction();
        AcodeMgr amgr = new AcodeMgr(tran_id);
        Acode parent = amgr.findX("id=" + request.getParameter("parentId"), _ws2.getAcodeBunitSpace("bunitId"));
        String name = request.getParameter("name");
        main = parent.getMain();
        sub = request.getParameter("subcode");
        
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionAcodeBunitId());
        Acode a = vsvc._get_acode(main, sub);
        if (a!=null)
            throw new AlreadyExists();

        vsvc.getAcode(main, sub, name);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (AlreadyExists a) {
       %><script>alert("子科目 [<%=main%> <%=sub%>]已存在!");history.go(-1);</script><%
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<link rel="stylesheet" href="style.css" type="text/css">
<blockquote>
<div class=es02>
<br>
新增成功!
<br>
<br>
<a href="acode_add_sub.jsp?a=<%=request.getParameter("parentId")%>">繼續加下一筆</a><br>
<a href="javascript:close()">關閉</a><br>
</div>

</blockquote>
<script>
   parent.do_reload = true;
   function close() {
       parent.location.reload();
   }
</script>
