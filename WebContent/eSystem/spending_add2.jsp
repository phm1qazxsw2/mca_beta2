<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,mca.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
if(!checkAuth(ud2,authHa,201))
{
    response.sendRedirect("authIndex.jsp?code=201");
}
%>

<%@ include file="leftMenu2-new.jsp"%>

<%
    String title = request.getParameter("title");
    int type = Integer.parseInt(request.getParameter("type"));
    Vitem vi = null;

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

        Date recordTime = sdf.parse(request.getParameter("recordTime"));
        String acctcode = request.getParameter("acctcode");
        int total = Integer.parseInt(request.getParameter("total"));
        int attachtype = Integer.parseInt(request.getParameter("attachtype"));

        int costTradeId=0;
        try{
             costTradeId= Integer.parseInt(request.getParameter("costTradeId"));
        }
        catch(Exception ex){}

        String note=request.getParameter("note");

        vi = new Vitem();
        vi.setRecordTime(recordTime);
        if (title.length()>40)
            title = title.substring(0,39);
        vi.setTitle(title);
        vi.setAcctcode(acctcode);
        vi.setTotal(total);
        vi.setAttachtype(attachtype);
        vi.setCostTradeId(costTradeId);
        vi.setType(type);
        vi.setUserId(ud2.getId());
        vi.setNote(note);
        vi.setBunitId(_ws.getSessionBunitId());
        new VitemMgr(tran_id).create(vi);

        Acode a = McaService.getMcaAcode(tran_id, _ws.getSessionBunitId(), acctcode);

        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());
        vsvc.genVoucherForVitem(vi, ud2.getId(), "");

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
        return;
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
    if(type==0)
        out.println("<img src=pic/costAdd.png border=0>&nbsp;新增支出 成功");        
    else
        out.println("<img src=pic/incomeAdd.png border=0>&nbsp;新增收入 成功");                
%>
</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<div class=es02>

<table width="40%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#ffffff  class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0 width=120>
                雜費項目編號:
			</td>
            <tD>
                <font color="<%=(type==0)?"blue":"red"%>">I<%=vi.getId()%></font>
            </tD>
        </tr>
		<tr bgcolor=#ffffff  class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0>
                摘要:
			</td>
            <tD>	
                <%=title%>
            </tD>
        </tr>
		<tr bgcolor=#ffffff  class=es02 align=left valign=middle>
        <td bgcolor=#f0f0f0>
                金額:
			</td>
            <tD><%=vi.getTotal()%></tD>
        </tr>   
		<tr bgcolor=#ffffff  class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0>
                廠商:
            </tD>
            <td bgcolor=#ffffff>
                <%
                int ctId=vi.getCostTradeId();

                if(ctId <=0){
                    out.println("未指定廠商");                 
                }else{

                    Costtrade2Mgr ctm=Costtrade2Mgr.getInstance();
                    Costtrade2 ct2=ctm.find("id='"+ctId+"'");
                    if(ct2 !=null)
                        out.println(ct2.getCosttradeName());
                }
                %>
          </td>
        </tr>                
    </table>
    </td>
    </tr>
    </table>
    <br>

        <div class=es02>
            建議: 將 <b>雜費項目編號:<font color="<%=(type==0)?"blue":"red"%>">I<%=vi.getId()%></font></b> 註記於原始憑證中,以方便查閱及對帳.
        </div>
    <br>    
<a href="spending_voucher.jsp?id=I<%=vi.getId()%>&backurl=spending_list.jsp"><img src="pic/costSpend.png" border=0>&nbsp;雜費明細 & 進行收付款</a> | 
<a href="spending_add.jsp?type=<%=type%>"><img src="pic/add.gif" border=0 width=12>&nbsp;繼續新增</a> | 
<a href="spending_list.jsp">回雜費收支總覽</a>
</div>
</blockquote>

<%@ include file="bottom.jsp"%>
