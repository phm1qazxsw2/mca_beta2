<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
    String first = request.getParameter("firstCode");
    String next3 = request.getParameter("acctCode");
    String main = first + next3;
    String name = request.getParameter("name");

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionAcodeBunitId());
        Acode a = vsvc._get_acode(main);
        if (a!=null)
            throw new AlreadyExists();
        vsvc.getAcode(main, null, name);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (AlreadyExists a) {
       %><script>alert("科目 [<%=main%>]已存在!");history.go(-1);</script><%
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
<a href="acode_add.jsp">繼續加下一筆</a><br>
<a href="javascript:close()">關閉</a><br>
</div>

</blockquote>
<script>
   parent.do_reload = true;
   function close() {
       parent.location.reload();
   }
</script>