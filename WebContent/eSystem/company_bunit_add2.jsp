<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    boolean commit = false;
    int tran_id = 0;
    Bunit b = null;
    try {           
        tran_id = dbo.Manager.startTransaction();

        BunitMgr bm = new BunitMgr(tran_id);

        b = new Bunit();
        b.setLabel(request.getParameter("name"));
        b.setStatus(1);
        b.setFlag(Bunit.FLAG_BIZ);
        bm.create(b);
        
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
        bi.setUnpaidBunitId(Integer.parseInt(request.getParameter("unpaidBunitId")));

        bi.setFullname(request.getParameter("fullname"));
        bi.setAddress(request.getParameter("address"));
        bi.setPhone(request.getParameter("phone"));

        new BinfoMgr(tran_id).save(bi);
        bh.reset();

        VoucherService vsvc = new VoucherService(tran_id, b.getId());
        boolean isSystem = true;
        vsvc.getAcode(VoucherService.CASH, null, "現金", isSystem);
        vsvc.getAcode(VoucherService.CHEQUE_RECEIVABLE, null, "應收票據", isSystem);
        vsvc.getAcode(VoucherService.CHEQUE_PAYABLE, null, "應付票據", isSystem);
        vsvc.getAcode(VoucherService.STUDENT_ACCOUNT, null, "學生帳戶餘額", isSystem);
        vsvc.getAcode(VoucherService.PAYROLL_ACCOUNT, null, "薪資帳戶", isSystem);
        vsvc.getAcode(VoucherService.OTHER_ACCOUNT_RECEIVABLE, null, "其他應收", isSystem);
        vsvc.getAcode(VoucherService.OTHER_EXPENSE_PAYABLE, null, "其他應付", isSystem);
        vsvc.getAcode(VoucherService.DISCOUNT, null, "折扣", isSystem);
        vsvc.getAcode(VoucherService.REVENUE, null, "學費收入", isSystem);
        vsvc.getAcode(VoucherService.INCOME_RECEIVABLE, null, "應收帳款", isSystem);
        vsvc.getAcode(VoucherService.RECEIPTS_UNDER_CUSTODY, null, "補助款", isSystem);
        vsvc.getAcode("6200", null, "管理及總務費用", isSystem);
        vsvc.getAcode("2147", null, "應付費用", isSystem);
        vsvc.getAcode(VoucherService.SALARY_EXPENSE, null, "薪資支出", isSystem);
        vsvc.getAcode(VoucherService.COST_OF_GOODS, null, "進貨費用", isSystem);

        isSystem = false;
        vsvc.getAcode(VoucherService.REVENUE, "001", "月費收入", isSystem);
        vsvc.getAcode(VoucherService.REVENUE, "002", "才藝班收入", isSystem);
        vsvc.getAcode(VoucherService.REVENUE, "003", "交通車收入", isSystem);
        vsvc.getAcode(VoucherService.REVENUE, "004", "餐點費收入", isSystem);
        vsvc.getAcode(VoucherService.REVENUE, "005", "學用品收入", isSystem);

        vsvc.getAcode("6252", null, "租金支出", isSystem);
        vsvc.getAcode("6253 ", null, "文具用品", isSystem);
        vsvc.getAcode("6253 ", "001", "文具", isSystem);
        vsvc.getAcode("6253 ", "002", "影印紙", isSystem);
        vsvc.getAcode("6253 ", "003", "美勞工具", isSystem);

        vsvc.getAcode("6254", null, "旅費", isSystem);
        vsvc.getAcode("6255", null, "交通車費", isSystem);
        vsvc.getAcode("6255", "001", "交通車相關費用", isSystem);
        vsvc.getAcode("6255", "002", "油資", isSystem);

        vsvc.getAcode("6256", null, "郵電費", isSystem);
        vsvc.getAcode("6256", "001", "電話費", isSystem);
        vsvc.getAcode("6256", "002", "郵資", isSystem);
        vsvc.getAcode("6257", null, "修繕費", isSystem);
        vsvc.getAcode("6257", "001", "硬體修繕", isSystem);
        vsvc.getAcode("6257", "002", "消防安檢", isSystem);
        vsvc.getAcode("6259", null, "廣告費", isSystem);
        vsvc.getAcode("6259", "001", "平面廣告", isSystem);
        vsvc.getAcode("6259", "002", "設計費用", isSystem);
        vsvc.getAcode("6261", null, "水電瓦斯費", isSystem);
        vsvc.getAcode("6261", "001", "水費", isSystem);
        vsvc.getAcode("6261", "002", "電費", isSystem);
        vsvc.getAcode("6261", "003", "瓦斯費", isSystem);
        vsvc.getAcode("6262", null, "保險費", isSystem);
        vsvc.getAcode("6262", "001", "親子旅遊保險費", isSystem);
        vsvc.getAcode("6262", "002", "幼兒平安保險", isSystem);
        vsvc.getAcode("6262", "003", "產物保險", isSystem);
        vsvc.getAcode("6262", "004", "勞保", isSystem);
        vsvc.getAcode("6262", "005", "健保", isSystem);
        vsvc.getAcode("6264", null, "交際費", isSystem);
        vsvc.getAcode("6264", "001", "禮品", isSystem);
        vsvc.getAcode("6264", "002", "聚餐", isSystem);
        vsvc.getAcode("6265", null, "捐贈", isSystem);
        vsvc.getAcode("6266", null, "稅捐", isSystem);
        vsvc.getAcode("6266", "001", "房屋稅", isSystem);
        vsvc.getAcode("6266", "002", "印花稅", isSystem);
        vsvc.getAcode("6266", "003", "所得稅", isSystem);
        vsvc.getAcode("6272", null, "伙食費", isSystem);
        vsvc.getAcode("6273", null, "職工福利", isSystem);
        vsvc.getAcode("6273", "001", "員工聚餐", isSystem);
        vsvc.getAcode("6273", "002", "員工旅遊", isSystem);
        vsvc.getAcode("6273", "003", "員工禮品", isSystem);
        vsvc.getAcode("6273", "004", "員工津貼", isSystem);
        vsvc.getAcode("6273", "005", "員工健康檢查", isSystem);
        vsvc.getAcode("6274", null, "研究發展費用", isSystem);
        vsvc.getAcode("6274", "001", "員工研習", isSystem);
        vsvc.getAcode("6274", "002", "研討會相關費用", isSystem);
        vsvc.getAcode("6276", null, "訓練費", isSystem);
        vsvc.getAcode("6278", null, "勞務費", isSystem);
        vsvc.getAcode("6278", "001", "律師顧問費", isSystem);
        vsvc.getAcode("6278", "002", "會計師顧問費", isSystem);
        vsvc.getAcode("6288", null, "其他總務費用", isSystem);
        vsvc.getAcode("6288", "001", "教具", isSystem);
        vsvc.getAcode("6288", "002", "電腦軟硬體", isSystem);
        vsvc.getAcode("6288", "003", "手續費", isSystem);
        vsvc.getAcode("6288", "004", "退費", isSystem);
        vsvc.getAcode("6288", "005", "雜項硬體設備", isSystem);
        vsvc.getAcode("6288", "006", "管理費", isSystem);
        vsvc.getAcode("6288", "007", "圖書費", isSystem);
        vsvc.getAcode("6288", "008", "會費", isSystem);
        vsvc.getAcode("6288", "009", "活動費", isSystem);
        vsvc.getAcode("6288", "0010", "醫藥費", isSystem);
        vsvc.getAcode("6288", "0011", "其他", isSystem);
        vsvc.getAcode("7111", null, "利息收入", isSystem);
        vsvc.getAcode("7140", null, "投資收益", isSystem);
        vsvc.getAcode("7480", null, "其他營業外收益", isSystem);

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
    新增成功.
    <br>
    <a href="company_bunit_modify.jsp?bid=<%=b.getId()%>">繼續編輯</a>
</div>
</blockquote>
<script>
    parent.do_reload = true;
</script>