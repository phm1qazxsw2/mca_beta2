<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%
    String para=request.getParameter("backurl");
    int Vstatus=Integer.parseInt(request.getParameter("status"));
    Voucher vchr = null;
    Vitem vitem = null;
    ArrayList<Vitem> vitems = null;
    String idstr = null;
    try { 
        idstr = request.getParameter("id");
        if (idstr.charAt(0)=='V') {
            vchr = VoucherMgr.getInstance().find("id=" + idstr.substring(1)); 
            vitems = VitemMgr.getInstance().retrieveList("voucherId=" + vchr.getId(), "");
            if (vitems.size()==0) {
              %><script>alert("此傳票已沒有項目,返回前頁");location.href="<%=para%>";</script><%
                return;
            }
        }
        else {
            vitems = new ArrayList<Vitem>();
            vitem = VitemMgr.getInstance().find("id=" + idstr.substring(1));
            if (vitem==null) {
                System.out.println("### para=" + para);
               %><script>alert("找不到資料，可能已被刪除");location.href='<%=para%>';</script><%
                return;
            }
            vitems.add(vitem);
        }
    } 
    catch (Exception e) 
    {%><script>alert("參數不正確,找不到id");history.go(-1);</script><%}

    Iterator<Vitem> iter = vitems.iterator();

    VitemMgr vm=VitemMgr.getInstance();
    while (iter.hasNext()) {

        Vitem vi = iter.next();
        vi.setVerifystatus(Vstatus);
        vi.setVerifyDate(new Date());
        vi.setVerifyUserId(ud2.getId());
        vm.save(vi);
    }
    response.sendRedirect(para);
%>