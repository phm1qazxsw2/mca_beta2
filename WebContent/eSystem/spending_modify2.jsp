<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,200))
    {
        response.sendRedirect("authIndex.jsp?code=200");
    }
%>
<%@ include file="leftMenu2-new.jsp"%>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String backurl=request.getParameter("backurl");

    if(backurl ==null)
        backurl="spending_list.jsp";

    Vitem vi = null;
    try { vi = VitemMgr.getInstance().find("id=" + request.getParameter("id")); } 
    catch (Exception e) {%><script>alert("參數不正確,找不到id");history.go(-1);</script><%}

    // ## 2009/3/3 by peter, 因傳票關系修改不行改入帳日期 (但還是可刪掉再加)
    // Date recordTime = sdf.parse(request.getParameter("recordTime"));

    String title = request.getParameter("title");
    String acctcode = request.getParameter("acctcode");
    int total = Integer.parseInt(request.getParameter("total"));
    int attachtype = Integer.parseInt(request.getParameter("attachtype"));
    int costTradeId =0;

    try{
        costTradeId=Integer.parseInt(request.getParameter("costTradeId"));
    }
    catch(Exception ex){}

    String note=request.getParameter("note");

    if (vi.getRealized()>total) {
      %><script>alert("金額不可小於已收付金額");history.go(-1)</script><%
        return;
    }

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        // ## 理由看上面
        // vi.setRecordTime(recordTime);
        vi.setTitle(title);
        vi.setAcctcode(acctcode);
        if (vi.getTotal()!=total) {
            vi.setTotal(total);
            if (vi.getOrgtype()==Vitem.ORG_TYPE_INVENTORY) {
                InventoryMgr invmgr = new InventoryMgr(tran_id);
                Inventory inv = invmgr.find("id=" + vi.getOrgId());
                inv.setTotalPrice(total);
                invmgr.save(inv);
            }
        }
        vi.setAttachtype(attachtype);
        if (vi.getRealized()>0 && vi.getCostTradeId()!=costTradeId)
            throw new Exception("已有收付款記錄不可改變廠商,會影響應收應付帳款記錄.");
        vi.setCostTradeId(costTradeId);
        vi.setNote(note);
        if (vi.getPaidstatus()!=Vitem.STATUS_FULLY_PAID && vi.getTotal()==vi.getRealized())
            vi.setPaidstatus(Vitem.STATUS_FULLY_PAID);
        new VitemMgr(tran_id).save(vi);

        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());
        vsvc.genVoucherForVitem(vi, ud2.getId(), "(修)");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
       if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
          return;
       } else {
          %><script>alert("發生錯誤");history.go(-1);</script><%
          return;
       }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    

%>

<br>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<%
    int tp=vi.getType();

    if(tp==0)
        out.println("<img src=pic/costticket.png border=0>&nbsp;修改支出");        
    else
        out.println("<img src=pic/incometicket.png border=0>&nbsp;修改收入");                
%>
</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<br>
<blockquote>
<div class=es02>
修改成功！
<br>
<br>
<a href="<%=backurl%>">回雜費明細 & 進行收付款</a>
</div>
<br>

</blockquote>

<%@ include file="bottom.jsp"%>