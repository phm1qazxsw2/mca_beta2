package phm.ezcounting;

import phm.accounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;

public class VoucherService
{
    int tran_id;
    AcodeMgr amgr = null;
    VchrHolderMgr vhmgr = null;
    VchrItemMgr vimgr = null;
    LiteralStore store = null;
    MembrBillRecordMgr mbrmgr = null;
    VchrThreadMgr vtmgr = null;

    //##########################
    public static final String CASH                     = "1100";
    public static final String CHEQUE_RECEIVABLE        = "1141";
    public static final String CHEQUE_PAYABLE           = "2141";
    public static final String STUDENT_ACCOUNT          = "2253";
    public static final String PAYROLL_ACCOUNT          = "1251";
    public static final String REVENUE                  = "4100";
    public static final String DISCOUNT                 = "4109";
    public static final String INCOME_RECEIVABLE        = "1144";
    public static final String RECEIPTS_UNDER_CUSTODY   = "2284";
    public static final String DEFFERED_INCOME_TAX      = "2291";
    public static final String OTHER_ACCOUNT_RECEIVABLE = "1178";
    public static final String OTHER_EXPENSE_PAYABLE    = "2178";
    public static final String SALARY_EXPENSE           = "6251";
    public static final String COST_OF_GOODS            = "5122";
    public static final String CROSS_BUNIT              = "1294";
    //##########################
    public static final int MAINCODE_LENGTH = 6; // 4; ## for 馬禮遜

    public static int initialized = 1; // 2009/3/26, 不用再區分了，直接就 initialized
    protected int bunitId = 0;
    BunitHelper bh = null;

    /*
    //## 2009/3/20 這個 constructor 不能留，會和舊的只有傳 tran_id 進來的搞混
    public VoucherService(int bunitId) 
        throws Exception   
    {
        this(0, bunitId);
    }
    // ######################################################################
    */

    public VoucherService(int tran_id, int bunitId)
        throws Exception
    {
        this.tran_id = tran_id;
        this.bunitId = bunitId;
        amgr= new AcodeMgr(tran_id);
        store = new LiteralStore(tran_id, "literal", null);
        vhmgr = new VchrHolderMgr(tran_id);
        vimgr = new VchrItemMgr(tran_id);
        mbrmgr = new MembrBillRecordMgr(tran_id);
        vtmgr = new VchrThreadMgr(tran_id);
        bh = new BunitHelper(tran_id);
    }

    public static void init()
    {
        acodeMap = new HashMap<String, Acode>();
    }

    public Acode getAcode(String mainCode, String subCode, String name)
        throws Exception
    {
        boolean isSystem = false;
        return getAcode(mainCode, subCode, name, isSystem);
    }

    protected boolean is_acode_occupied(int acodeId)
    {
        return (vimgr.numOfRows("acodeId=" + acodeId)>0);
    }

    public Acode getAcodeFromAcctcode(String acctcode)
        throws Exception
    {
        if (acctcode==null || acctcode.length()<MAINCODE_LENGTH)
            return null;
        else if (acctcode.length()==MAINCODE_LENGTH)
            return _get_acode(acctcode);
        else {
            String main = acctcode.substring(0,MAINCODE_LENGTH);
            String sub = acctcode.substring(MAINCODE_LENGTH);
            if (acctcode.indexOf("-")>0) { // ## for 馬禮遜
                String[] tokens = acctcode.split("-");
                main = tokens[0];
                sub = tokens[1];
            }
            return _get_acode(main, sub);
        }
    }

    public Acode modifyAcode(int acodeId, String name)
        throws Exception
    {
        Acode a = amgr.find("id=" + acodeId);
        boolean create = false;
        if (is_acode_occupied(acodeId)) {
            Acode newa = a.clone();
            a.setActive(Acode.ACTIVE_NO);
            amgr.save(a);
            a = newa;
            create = true;
        }
        int id = (int) LiteralStore.create(store, name);
        a.setName1(id);
        if (create)
            amgr.create(a);
        else
            amgr.save(a);
        _clean_acode_cashe(a.getMain(), a.getSub());
        return _get_acode(a.getMain(), a.getSub());
    }

    public Acode getAcode(String mainCode, String subCode, String name, boolean isSystem)
        throws Exception
    {
        Acode a = _get_acode(mainCode, subCode);
        if (a!=null) 
            return a;
        a = new Acode();
        a.setMain(mainCode);
        a.setSub(subCode);
        int id = (int) LiteralStore.create(store, name);
        a.setName1(id);
        if (subCode!=null) {
            Acode root = _get_acode(mainCode, null);
            if (root==null)
                throw new Exception("supposed to have root");
            a.setRootId(root.getId());
        }
        a.setType((isSystem)?Acode.TYPE_SYSTEM:Acode.TYPE_MANUAL);
        a.setActive(Acode.ACTIVE_YES);
        a.setBunitId(bh.getAcodeBunitId(bunitId));
        amgr.create(a);
        _get_acode(mainCode, subCode); // put back to acodeMap
        return a;
    }

    private static Map<String, Acode> acodeMap = new HashMap<String, Acode>();
    public Acode _get_acode(String main)
        throws Exception
    {
        return _get_acode(main, null);
    }

    public Acode _get_acode(String main, String sub)
        throws Exception
    {
        String key = Acode.makeKey(main, sub);
        key = bh.getAcodeBunitId(bunitId) + "#" + key;
        Acode a = acodeMap.get(key);
        if (a==null) {
            a = amgr.find(Acode.makeQueryKey(main, sub, bh.getAcodeSpace("bunitId", bunitId)));
            acodeMap.put(key, a);
        }
        return a;
    }

    public void disableAcode(int aid)
        throws Exception
    {
        Acode a = amgr.find("id=" + aid);
        _clean_acode_cashe(a.getMain(), a.getSub());
        a.setActive(0);
        amgr.save(a);
    }

    public void _clean_acode_cashe(String main, String sub)
        throws Exception
    {
        String key = Acode.makeKey(main, sub);
        key = bh.getAcodeBunitId(bunitId) + "#" + key;
        acodeMap.put(key, null);
    }


    public Acode getCashAcode(int acctType, int acctId)
        throws Exception
    {
        Acode parent = _get_acode(CASH); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(CASH, null, "現金", isSystem);
            parent = _get_acode(CASH);
        }

        String subcode = "$" + acctType + "$" + acctId;
        Acode acode = _get_acode(CASH, subcode);
        if (acode==null) {
            String name = "";
            if (acctType==1) {
                jsf.Tradeaccount ta = (jsf.Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + acctId);
                name = ta.getTradeaccountName() + "(臺幣)";
            }
            else if (acctType==2) {
                jsf.BankAccount ba = (jsf.BankAccount) ObjectService.find("jsf.BankAccount", "id=" + acctId);
                name = ba.getBankAccountName();
            }
            else if (acctType==3) {
                jsf.Tradeaccount ta = (jsf.Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + acctId);
                name = ta.getTradeaccountName() + "(臺支)";
            }
            else if (acctType==4) {
                jsf.Tradeaccount ta = (jsf.Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + acctId);
                name = ta.getTradeaccountName() + "(美金)";
            }
            else if (acctType==5) {
                jsf.Tradeaccount ta = (jsf.Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + acctId);
                name = ta.getTradeaccountName() + "(美支)";
            }

            boolean isSystem = true;
            acode = getAcode(CASH, subcode, name, isSystem);
        }
        return acode;
    }

    public Acode getDiscountAcode(int discountType)
        throws Exception
    {
        Acode parent = _get_acode(DISCOUNT); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(DISCOUNT, null, "折扣", isSystem);
            parent = _get_acode(DISCOUNT);
        }

        String subcode = "#" + discountType;
        Acode acode = _get_acode(DISCOUNT, subcode);
        if (acode==null) {
            jsf.DiscountType dt = (jsf.DiscountType) ObjectService.find("jsf.DiscountType", "id=" + discountType);
            String name = dt.getDiscountTypeName();

            boolean isSystem = true;
            acode = getAcode(DISCOUNT, subcode, name, isSystem);
        }
        return acode;
    }

    public void setupAcodeCashAccounts()
        throws Exception
    {
        jsf.TradeaccountMgr tmgr = jsf.TradeaccountMgr.getInstance();
        jsf.BankAccountMgr bmgr = jsf.BankAccountMgr.getInstance();
        Object[] objs = tmgr.retrieveX("tradeAccountActive=1", "", bh.getSpace("bunitId", bunitId));
        for (int i=0; objs!=null&&i<objs.length; i++) {
            getCashAcode(1, ((jsf.Tradeaccount)objs[i]).getId());
        }
        objs = bmgr.retrieveX("bankAccountActive=1", "", bh.getSpace("bunitId", bunitId));
        for (int i=0; objs!=null&&i<objs.length; i++) {
            getCashAcode(2, ((jsf.BankAccount)objs[i]).getId());
        }
    }

    public Acode getChequeReceivableAcode()
        throws Exception
    {
        Acode parent = _get_acode(CHEQUE_RECEIVABLE); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(CHEQUE_RECEIVABLE, null, "應收支票", isSystem);
            parent = _get_acode(CHEQUE_RECEIVABLE);
        }

        return _get_acode(CHEQUE_RECEIVABLE);
    }

    public Acode getChequePayableAcode()
        throws Exception
    {
        Acode parent = _get_acode(CHEQUE_PAYABLE); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(CHEQUE_PAYABLE, null, "應付支票", isSystem);
            parent = _get_acode(CHEQUE_PAYABLE);
        }

        return _get_acode(CHEQUE_PAYABLE);
    }

    public VchrItemSum getAccountBalance(String main, String sub)
        throws Exception
    {
        String q = "main='" + main + "'";
        if (sub!=null && sub.length()>0)
            q += " and sub='" + sub + "'";
        ArrayList<VchrItemSum> sums =VchrItemSumMgr.getInstance().retrieveListX(q, "group by main", bh.getSpace("vchr_holder.buId", bunitId));
        if (sums.size()==0)
            return new VchrItemSum();
        if (sums.size()>1)
            throw new Exception("餘額多餘一個帳戶");
        return sums.get(0);
    }

    private VchrHolder getBillItemVoucher(BillItem bi)
        throws Exception
    {
        return vhmgr.find("id=" + bi.getTemplateVchrId());
    }

    private VchrHolder getBillItemVoucher(String serial)
        throws Exception
    {
        return vhmgr.find("serial='" + serial+"' and type!=" + VchrHolder.TYPE_OBSOLETE);
    }

    // return only CREDIT portion of the template
    public VchrItem getBillItemInfo(BillItem bi, int FLAG, String default_template_name)
        throws Exception
    {
        VchrHolder vh = getBillItemVoucher(bi);
        if (vh==null) {
            vh = getBillItemVoucher(default_template_name);
        }
        ArrayList<VchrItem> items = new VchrItemMgr(tran_id).retrieveList("vchrId=" + vh.getId(), "");
        for (int i=0; i<items.size(); i++)
            if (items.get(i).getFlag()==FLAG)
                return items.get(i);
        return null;
    }

    public void setBillItemTemplate(BillItem bi, Acode a, int userId, int replacing_flag, String default_template_name)
        throws Exception
    {
        VchrHolder vh = getBillItemVoucher(bi);
        if (vh==null) {
            vh = getBillItemVoucher(default_template_name);
        }
        ArrayList<VchrItem> items = new VchrItemMgr(tran_id).retrieveList("vchrId=" + vh.getId(), "");
        for (int i=0; i<items.size(); i++) {
            if (items.get(i).getFlag()==replacing_flag) // 帳單的立帳一定針對 貸方
                items.get(i).setAcodeId(a.getId());
        }
        saveBillTemplate(bi, items, userId);        
    }

    public void deleteManualVoucher(int vchrId, int userId)
        throws Exception
    {
        VchrHolder v = vhmgr.find("id=" + vchrId);
        if (v.getUserId()!=userId)
            throw new Exception("傳票的 user 不同無法刪除");
        if (EzCountingService.getInstance().isFreezed(v.getRegisterDate(), bh.getSpace("bunitId", bunitId)))
            throw new Exception("已關帳不可修改 [3]");
        vimgr.executeSQL("delete from vchr_item where vchrId=" + v.getId());
        vhmgr.executeSQL("delete from vchr_holder where id=" + v.getId());

        if (v.getType()==VchrHolder.TYPE_INSTANCE) {
            Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
            // 如果這個傳票有現金的話
            String cpq = "costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_MANUAL_VOUCHER + " and costpayStudentAccountId=" + v.getId();
            ArrayList<Costpay2> costpays = cpmgr.retrieveList(cpq, "");
            for (int i=0; i<costpays.size(); i++) {
                if (costpays.get(i).getCostpayVerifyStatus()!=Costpay2.VERIFIED_NO)
                    throw new Exception("此筆記錄對應的現金帳戶狀態為已確認，不可修改");            
            }
            cpmgr.executeSQL("delete from costpay where " + cpq);
        }    
    }

    public void modifyManualVoucher(VchrHolder v, Date registerDate, ArrayList<VchrItem> vitems, int userId)
        throws Exception
    {
        // 不管3721刪掉在加?
        ArrayList<VchrItem> orgitems = vimgr.retrieveList("vchrId=" + v.getId(), "");
        vimgr.executeSQL("delete from vchr_item where vchrId=" + v.getId());

        if (v.getType()==VchrHolder.TYPE_INSTANCE) {
            Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
            // 如果這個傳票有現金的話
            String cpq = "costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_MANUAL_VOUCHER + " and costpayStudentAccountId=" + v.getId();
            ArrayList<Costpay2> costpays = cpmgr.retrieveList(cpq, "");
            for (int i=0; i<costpays.size(); i++) {
                if (costpays.get(i).getCostpayVerifyStatus()!=Costpay2.VERIFIED_NO)
                    throw new Exception("此筆記錄對應的現金帳戶狀態為已確認，不可修改");            
            }
            cpmgr.executeSQL("delete from costpay where " + cpq);
        }

        v.setCreated(new Date());
        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        v.setUserId(userId);
        int threadId = v.getThreadId();
        vhmgr.save(v);

        for (int i=0; i<vitems.size(); i++) {
            VchrItem vi = vitems.get(i);
            addItem(i, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), threadId, vi.getDebit(), 
                vi.getCredit(), vi.getNote());
        }

        
        if (v.getType()==VchrHolder.TYPE_INSTANCE) {
            // 如果新加的傳票有涉及現金帳戶的話要注意和 costpay 之間的連結
            vitems = vimgr.retrieveList("vchrId=" + v.getId(), "");
            VchrInfo vinfo = new VchrInfo(vitems, tran_id);
            for (int i=0; i<vitems.size(); i++) {
                VchrItem vi = vitems.get(i);
                int[] acctinfo = vinfo.getCashAccountInfo(vi);
                if (acctinfo!=null) {
                    this.makeCostpayOnVchrItem(vi, registerDate, acctinfo[0], acctinfo[1], userId, v.getBuId());
                }
            }
        }
    }

    public VchrHolder createVoucher(String serial, Date registerDate, ArrayList<VchrItem> vitems, int userId, int bunitId)
        throws Exception
    {
        VchrHolder v = vhmgr.find("serial='" + serial + "' and type=" + VchrHolder.TYPE_INSTANCE);
        if (v!=null)
            throw new AlreadyExists();

        VchrThread thread = new VchrThread();
        thread.setSrcType(VchrThread.SRC_TYPE_MANUAL);
        vtmgr.create(thread);

        v = new VchrHolder();
        v.setCreated(new Date());
        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        v.setUserId(userId);
        v.setThreadId(thread.getId());
        v.setType(VchrHolder.TYPE_INSTANCE);
        v.setSerial(serial);
        v.setBuId(bunitId);
        vhmgr.create(v);

        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        for (int i=0; i<vitems.size(); i++) {
            VchrItem vi = vitems.get(i);
            addItem(i, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), thread.getId(), vi.getDebit(), 
                vi.getCredit(), vi.getNote());
        }

        // 如果新加的傳票有涉及現金帳戶的話要注意和 costpay 之間的連結
        vitems = vimgr.retrieveList("vchrId=" + v.getId(), "");
        VchrInfo vinfo = new VchrInfo(vitems, tran_id);
        for (int i=0; i<vitems.size(); i++) {
            VchrItem vi = vitems.get(i);
            int[] acctinfo = vinfo.getCashAccountInfo(vi);
            if (acctinfo!=null) {
                this.makeCostpayOnVchrItem(vi, registerDate, acctinfo[0], acctinfo[1], userId, v.getBuId());
            }
        }

        return v;
    }

    public void saveBillTemplate(BillItem bi, ArrayList<VchrItem> vitems, int userId)
        throws Exception
    {
        VchrHolder v = vhmgr.find("id=" + bi.getTemplateVchrId() + " and type=" + VchrHolder.TYPE_INSTANCE);
        if (v!=null) {
            vimgr.executeSQL("delete from vchr_item where vchrId=" + v.getId());
        }
        else {
            v = createBillItemVoucher("_b" + bi.getId(), userId);
            bi.setTemplateVchrId(v.getId());
            new BillItemMgr(tran_id).save(bi);
        }

        for (int i=0; i<vitems.size(); i++) {
            VchrItem vi = vitems.get(i);
            addItem(i, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), -1, vi.getDebit(), 
                vi.getCredit(), vi.getNote());
        }
    }

    public VchrHolder createBillItemVoucher(String serial, int userId)
    {
        VchrHolder v = new VchrHolder();
        v.setCreated(new Date());
        v.setUserId(userId);
        v.setThreadId(0);
        v.setType(VchrHolder.TYPE_TEMPLATE);
        v.setSerial(serial);
        vhmgr.create(v);
        return v;
    }


    public Acode getStudentAccountAcode(int membrId)
        throws Exception
    {        
        Acode parent = _get_acode(STUDENT_ACCOUNT); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(STUDENT_ACCOUNT, null, "學生帳戶", isSystem);
            parent = _get_acode(STUDENT_ACCOUNT);
        }

        String subcode = "#" + membrId;
        Acode acode = _get_acode(STUDENT_ACCOUNT, subcode);
        if (acode==null) {
            Membr membr = new MembrMgr(tran_id).find("id=" + membrId);
            boolean isSystem = true;
            getAcode(STUDENT_ACCOUNT, subcode, membr.getName(), isSystem);
            acode = _get_acode(STUDENT_ACCOUNT, subcode);
        }
        return acode;
    }

    public Acode getBunitAcode(int bunitId)
        throws Exception
    {        
        Acode parent = _get_acode(CROSS_BUNIT); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(CROSS_BUNIT, null, "往來", isSystem);
            parent = _get_acode(CROSS_BUNIT);
        }

        String subcode = "@" + bunitId;
        Acode acode = _get_acode(CROSS_BUNIT, subcode);
        if (acode==null) {
            Bunit bunit = new BunitMgr(tran_id).find("id=" + bunitId);
            boolean isSystem = true;
            getAcode(CROSS_BUNIT, subcode, bunit.getLabel(), isSystem);
            acode = _get_acode(CROSS_BUNIT, subcode);
        }
        return acode;
    }

    public Acode getCostOfGoodAcode(int pitemId)
        throws Exception
    {        
        String subcode = "^" + pitemId;        
        Acode root = getAcode(COST_OF_GOODS, null, "進貨費用", true); // make sure COST_OF_GOOD is there
        Acode acode = _get_acode(COST_OF_GOODS, subcode);
        if (acode==null) {
            PItem pi = new PItemMgr(tran_id).find("id=" + pitemId);
            boolean isSystem = true;
            getAcode(COST_OF_GOODS, subcode, pi.getName(), isSystem);
            acode = _get_acode(COST_OF_GOODS, subcode);
        }
        return acode;
    }

    public Acode getSalaryAccountAcode(int membrId)
        throws Exception
    {
        Acode parent = _get_acode(PAYROLL_ACCOUNT); 
        if (parent==null) {
            boolean isSystem = true;
            getAcode(PAYROLL_ACCOUNT, null, "薪資帳戶", isSystem);
            parent = _get_acode(PAYROLL_ACCOUNT);
        }

        String subcode = "#" + membrId;
        Acode a = _get_acode(PAYROLL_ACCOUNT, subcode);
        if (a==null) {
            Membr membr = new MembrMgr(tran_id).find("id=" + membrId);
            boolean isSystem = true;
            getAcode(PAYROLL_ACCOUNT, subcode, membr.getName(), isSystem);
            a = _get_acode(PAYROLL_ACCOUNT, subcode);
        }
        return a;
    }

    public Acode getVenderAcode(String main, int costtradeId)
        throws Exception
    {
        String subcode = null;
        if (costtradeId>0)
            subcode = "@" + costtradeId;
        Acode a = _get_acode(main, subcode);
        if (a==null) {
            jsf.Costtrade ct = (jsf.Costtrade) ObjectService.find("jsf.Costtrade", "id=" + costtradeId);
            boolean isSystem = true;
            getAcode(main, subcode, ct.getCosttradeName(), isSystem);
            a = _get_acode(main, subcode);
        }
        return a;
    }

    public VchrItem addItem(int idx, VchrHolder v, int bunitId, int acodeId, int flag, int threadId, 
        double debit, double credit, int noteId)
        throws Exception
    {
        VchrItem vi = new VchrItem();
        vi.setVchrId(v.getId());
        vi.setId(idx);
        vi.setBunitId(bunitId);
        vi.setAcodeId(acodeId);               
        vi.setFlag(flag);
        vi.setThreadId(threadId);
        vi.setDebit(debit);                       
        vi.setCredit(credit);
        vi.setNote(noteId);
        vimgr.create(vi);
        return vi;
    }

    // ** 注意 call mergeItems 一定要注意意圖要 merge 起來的 VchrItem 一定要設好 Bunit, Acode, Thread 這些參數
    ArrayList<VchrItem> mergeItems(ArrayList<VchrItem> items)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        Map<String, Vector<VchrItem>> itemMap = new SortingMap(items).doSort("getBunitAcodeThreadSignedKey");
        Iterator<String> iter = itemMap.keySet().iterator();
        int i = 0;
        while (iter.hasNext()) {
            Vector<VchrItem> vv = itemMap.get(iter.next());
            VchrItem item = vv.get(0);
            double credit = 0.0;
            double debit = 0.0;
            for (int j=0; j<vv.size(); j++) {
                credit += vv.get(j).getCredit();
                debit += vv.get(j).getDebit();
            }
            if (credit==debit)
                continue;
            double diff = Math.abs(debit) - Math.abs(credit);
            if (diff>0) {
                item.setFlag(VchrItem.FLAG_DEBIT);
                if (debit<0)
                    diff = 0-diff; // 原來debit是負的, 新的debit就是負的
                item.setDebit(diff);
                item.setCredit(0);
                ret.add(item);
            }
            else {
                item.setFlag(VchrItem.FLAG_CREDIT);
                diff = 0-diff; // 變回正數
                if (credit<0)
                    diff = 0-diff; // 原來credit是負的, 新的credit就是負的
                item.setCredit(diff);
                item.setDebit(0);
                ret.add(item);
            }
        }
        return ret;
    }

    ArrayList<VchrItem> mergeItemsRegardlessThread(ArrayList<VchrItem> items)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        Map<String, Vector<VchrItem>> itemMap = new SortingMap(items).doSort("getBunitAcodeKey");
        Iterator<String> iter = itemMap.keySet().iterator();
        int i = 0;
        while (iter.hasNext()) {
            Vector<VchrItem> vv = itemMap.get(iter.next());
            VchrItem item = vv.get(0);
            double credit = 0.0;
            double debit = 0.0;
            for (int j=0; j<vv.size(); j++) {
                credit += vv.get(j).getCredit();
                debit += vv.get(j).getDebit();
            }
            if (debit>credit) {
                item.setFlag(VchrItem.FLAG_DEBIT);
                item.setDebit(debit-credit);
                item.setCredit(0);
                ret.add(item);
            } else if (credit>debit) {
                item.setFlag(VchrItem.FLAG_CREDIT);
                item.setCredit(credit-debit);
                item.setDebit(0);
                ret.add(item);
            }
        }
        return ret;
    }


    ArrayList<VchrItem> getDirectItems(int threadId,
        Map<Integer, ArrayList<VchrItem>> threaditemMap)
    {
        ArrayList<VchrItem> ret = threaditemMap.get(new Integer(threadId));
        if (ret==null)
            return new ArrayList<VchrItem>();
        return ret;
    }

    ArrayList<VchrItem> getBillCurrentItems(MembrBillRecord bill, 
        Map<String, Vector<ChargeItemMembr>> chargeMap,
        Map<String, Vector<Discount>> discountMap,
        Map<Integer, VchrHolder> bitemvchrMap,
        VchrHolder billitem_default,
        VchrHolder billitem_tempreceipt,
        Map<Integer, Vector<VchrItem>> templateitemMap,
        Map<Integer, jsf.DiscountType> discountTypeMap)
        throws Exception
    {
        Vector<ChargeItemMembr> cv = chargeMap.get(bill.getTicketId());
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        for (int j=0; cv!=null&&j<cv.size(); j++) {
            ChargeItemMembr ci = cv.get(j);
            Vector<Discount> dv = discountMap.get(ci.getMembrId()+"#"+ci.getChargeItemId());
            Vector<VchrItem> vitems = null;
            VchrHolder t = bitemvchrMap.get(ci.getTemplateVchrId());
            if (t==null) {
                if (ci.getPitemId()==0)
                    t = billitem_default;
                else
                    t = billitem_tempreceipt;
            }

            vitems = templateitemMap.get(new Integer(t.getId()));
if (vitems==null)
    System.out.println("## template vchrId=" + t.getId());
             
            // 算出按比例的實際金額的 vchritem
            double amt = ci.getMyAmount();
            
            for (int k=0; dv!=null&&k<dv.size(); k++) {
                amt -= dv.get(k).getAmount();
                int bunitId = 0;
                {   // 折扣的部門和從折扣標的收費項目的貸方收入來
                    for (int n=0; n<vitems.size(); n++) {
                        if (vitems.get(n).getFlag()==VchrItem.FLAG_CREDIT) {
                            bunitId = vitems.get(n).getBunitId();
                            break;
                        }
                    }
                    // 減免的對象也應從折扣標的收費項目的貸方收入來, 之后做
                }
                // 貸 折扣,兩個都是貸,這個為負,下個為正
                // ### 2009/2/8 by peter, 折扣要看有沒有設定科目
                Acode a = null;
                jsf.DiscountType dt = discountTypeMap.get(dv.get(k).getType());
                if (dt!=null && dt.getAcctcode()!=null && dt.getAcctcode().length()>0)
                    a = getAcodeFromAcctcode(dt.getAcctcode());
                else 
                    a = getDiscountAcode(dv.get(k).getType());
                VchrItem vi = new VchrItem();
                vi.setFlag(VchrItem.FLAG_CREDIT);
                vi.setBunitId(bunitId);
                vi.setAcodeId(a.getId());
                vi.setCredit(0-dv.get(k).getAmount());
                vi.setThreadId(bill.getThreadId());
                ret.add(vi);
                // 貸 學費收入,要找到原來收費項目的貸項
                int acodeId = 0;
                for (int p=0; p<vitems.size(); p++)
                    if (vitems.get(p).getFlag()==VchrItem.FLAG_CREDIT) {
                        acodeId = vitems.get(p).getAcodeId();
                        break;
                } 
                if (acodeId==0)
                    throw new Exception("找不到折扣對象收費的貸方");

                vi = new VchrItem();
                vi.setAcodeId(acodeId);
                vi.setBunitId(bunitId);
                vi.setFlag(VchrItem.FLAG_CREDIT);
                vi.setCredit(dv.get(k).getAmount());
                vi.setThreadId(bill.getThreadId());
                ret.add(vi);
            }
            for (int k=0; k<vitems.size(); k++) {
                VchrItem vi = vitems.get(k).clone();
                vi.setDebit(vi.getDebit() * amt);
                vi.setCredit(vi.getCredit() * amt);
                vi.setThreadId(bill.getThreadId());
                ret.add(vi);
            }
        }
        return ret;
    }


    ArrayList<VchrItem> getSalaryCurrentItems(MembrBillRecord salary, 
        Map<String, Vector<ChargeItemMembr>> chargeMap,
        Map<Integer, VchrHolder> bitemvchrMap,
        VchrHolder salary_default,
        Map<Integer, Vector<VchrItem>> templateitemMap)
        throws Exception
    {
        Vector<ChargeItemMembr> cv = chargeMap.get(salary.getTicketId());
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        for (int j=0; cv!=null&&j<cv.size(); j++) {
            ChargeItemMembr ci = cv.get(j);
            Vector<VchrItem> vitems = null;
            VchrHolder t = bitemvchrMap.get(ci.getTemplateVchrId());
            if (t==null) {
                t = salary_default;
            }
            vitems = templateitemMap.get(new Integer(t.getId()));
             
            // 算出按比例的實際金額的 vchritem
            double amt = ci.getMyAmount();
            for (int k=0; k<vitems.size(); k++) {
                VchrItem vi = vitems.get(k).clone();
                vi.setDebit(vi.getDebit() * amt);
                vi.setCredit(vi.getCredit() * amt);
                vi.setThreadId(salary.getThreadId());
                ret.add(vi);
            }
        }
        return ret;
    }

    ArrayList<VchrItem> getReverseItems(ArrayList<VchrItem> items)
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        for (int i=0; i<items.size(); i++) {
            VchrItem vi = items.get(i).clone();
            // 借貸互調
            {
                vi.setFlag((vi.getFlag()==VchrItem.FLAG_DEBIT)?VchrItem.FLAG_CREDIT:VchrItem.FLAG_DEBIT);
                double credit = vi.getCredit();
                vi.setCredit(vi.getDebit());
                vi.setDebit(credit);
            }
            ret.add(vi);
        }
        return ret;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    public String getSerialNo(String prefix, Date registerDate)
    {
        String left = prefix + sdf.format(registerDate); // "_b20081121"
        try {
            ArrayList<VchrHolder> v = vhmgr.retrieveListX("serial like '"+left+"%'", "order by id desc limit 1", bh.getSpace("vchr_holder.buId", bunitId));
            int len = v.get(0).getSerial().length();
            int no = Integer.parseInt(v.get(0).getSerial().substring(len-4, len));
            no ++;
            return left + PaymentPrinter.makePrecise(no+"", 4, false, '0');
        }
        catch (Exception e) {}
        return left + "0001";
    }

    VchrHolder _get_bill_voucher(int userId, Date billMonth, 
        VchrThread thread, String prefix, int noteId, boolean newly_created, int bunitId)
        throws Exception
    {
        VchrHolder v = null;

        // bill voucher 同一人同一天同一個 thread 只能產生一個 voucher, 其他 voucher 沒有此限, 所以 createDate 要設成一天的開始
        Date now = new Date();
        Date create_date = sdf.parse(sdf.format(now));
        String key = "userId=" + userId + " and created='" + sdf.format(create_date) + "' and threadId=" + thread.getId();
        if (vhmgr.numOfRows(key)==0) {
            v = new VchrHolder();
            v.setCreated(now);
            // if (newly_created) { // 修改的傳票不可在帳單月份前
            // ### 2009/3/3 by peter, 帳單或薪資都用該月來算
            {
                // 發佈新單的入帳日期應該--月份外以最接近該月日，月份內就用當天
                Date firstDayOfMonth = billMonth;
                Calendar c = Calendar.getInstance();
                c.setTime(firstDayOfMonth);
                c.add(Calendar.MONTH, 1); // billMonth 下個月的第一天
                c.add(Calendar.DATE, -1);
                Date lastDayOfMonth = c.getTime(); // billMonth月的最后一天
                // 如果今天在第一天之前，就用第一天
                if (now.compareTo(firstDayOfMonth)<0)
                    v.setRegisterDateCheck(firstDayOfMonth, bh.getSpace("bunitId", bunitId));
                else if (now.compareTo(lastDayOfMonth)>0) { // 如果今天在最后一天之后，就用最后一天
                    // v.setRegisterDateCheck(lastDayOfMonth, bh.getSpace("bunitId", bunitId));
                    // 馬禮遜要用 generate bill 那一天
                    v.setRegisterDateCheck(now, bh.getSpace("bunitId", bunitId)); 
                }
                else
                    v.setRegisterDateCheck(create_date, bh.getSpace("bunitId", bunitId)); // 在區間內,用今天

                v.setSerial(getSerialNo("_b", v.getRegisterDate()));
            }
            //}
            //else {
            //    v.setSerial(getSerialNo("_b", create_date));
            //    v.setRegisterDateCheck(create_date);
            //}
            v.setUserId(userId);
            v.setType(VchrHolder.TYPE_INSTANCE);
            v.setNote(noteId);
            v.setThreadId(thread.getId());
            v.setBuId(bunitId);
            vhmgr.create(v);
        }
        else {
            v = vhmgr.find(key);
        }
        return v;
    }

    void makeBillVoucher(MembrInfoBillRecord bill, 
        Map<Integer, VchrThread> threadMap,
        Map<Integer, ArrayList<VchrItem>> vchritemMap,
        ArrayList<VchrItem> merged_items,
        int userId, String reason, int billType)
        throws Exception
    {
        if (merged_items.size()==0)
            return;

        // 產生帳單的 voucher, 先看有沒有 thread 了。。
        VchrThread thread = threadMap.get(new Integer(bill.getThreadId()));
        boolean newly_created = false;
        String str = "";
        if (thread==null) {
            thread = new VchrThread();

            if (billType==Bill.TYPE_BILLING) {
                thread.setSrcType(VchrThread.SRC_TYPE_BILL);
                str = "帳單-";
            }
            else if (billType==Bill.TYPE_SALARY) {
                thread.setSrcType(VchrThread.SRC_TYPE_SALARY);
                str = "薪資-";
            }

            thread.setSrcInfo(bill.getTicketId());
            vtmgr.create(thread);
            bill.setThreadId(thread.getId());
            newly_created = true;
            mbrmgr.save(bill);
        }
            
        str =  str + bill.getTicketId()+bill.getMembrName() + " " + ((reason!=null)?reason:"");
        int noteId = (int) LiteralStore.create(store, str);    
        VchrHolder v = _get_bill_voucher(userId, bill.getBillMonth(), thread, "_b", noteId, newly_created, bill.getBunitId());

        // 如果通天同一人改單就會用到原先的 voucher, 此時就要再 merge 那些 items
        ArrayList<VchrItem> existing_items = vchritemMap.get(v.getId());
        int nextItemIdStart = (existing_items!=null)?existing_items.size()+1:0;

        for (int j=0; j<merged_items.size(); j++) {
            VchrItem item = merged_items.get(j);
            addItem((nextItemIdStart+j), v, item.getBunitId(), item.getAcodeId(), item.getFlag(), thread.getId(), 
                item.getDebit(), item.getCredit(), noteId);
        }
    }

    void makeBillPayVoucher(BillPay bpay, 
        Map<Integer, VchrThread> threadMap,
        ArrayList<VchrItem> merged_items,
        int userId, int srcType, String reason, Membr m)
        throws Exception
    { 
        if (merged_items.size()==0)
            return;

        // 產生帳單的 voucher, 先看有沒有 thread 了。。
        VchrThread thread = threadMap.get(new Integer(bpay.getThreadId()));
        if (thread==null) {
            thread = new VchrThread();
            thread.setSrcType(srcType);
            thread.setSrcInfo(bpay.getId()+"");
            vtmgr.create(thread);
            bpay.setThreadId(thread.getId());
            new BillPayMgr(tran_id).save(bpay);
        }
            
        VchrHolder v = new VchrHolder();
        Date registerDate = bpay.getRecordTime();
        v.setSerial(getSerialNo("_p", registerDate));
        Date create_date = new Date();
        v.setCreated(create_date);
        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        v.setUserId(userId);
        v.setType(VchrHolder.TYPE_INSTANCE);
        v.setBuId(bpay.getBunitId());

        String note = "";
        if (srcType==VchrThread.SRC_TYPE_BILLPAY) {
            note += "繳費-" + m.getName();
        }
        else
            note += "付薪";
        if (reason!=null && reason.length()>0)
            note += " " + reason;
        
        int noteId = (int) LiteralStore.create(store, note);
        v.setNote(noteId);
        v.setThreadId(thread.getId());
        vhmgr.create(v);
       
        for (int j=0; j<merged_items.size(); j++) {
            VchrItem item = merged_items.get(j);
            addItem(j, v, item.getBunitId(), item.getAcodeId(), item.getFlag(), thread.getId(), 
                item.getDebit(), item.getCredit(), noteId);
        }
    }

    void makeBillPaidVoucher(BillPaid bpaid, 
        MembrInfoBillRecord bill,
        Map<Integer, VchrThread> threadMap,
        ArrayList<VchrItem> merged_items,
        int userId, int srcType, String reason, Membr m)
        throws Exception
    { 
        if (merged_items.size()==0)
            return;

        // 產生 voucher, 先看有沒有 thread 了。。
        VchrThread thread = threadMap.get(new Integer(bpaid.getThreadId()));
        if (thread==null) {
            thread = new VchrThread();
            thread.setSrcType(srcType);
            thread.setSrcInfo(bpaid.getBillPayId()+"#"+bpaid.getTicketId());
            vtmgr.create(thread);
            bpaid.setThreadId(thread.getId());
            new BillPaidMgr(tran_id).save(bpaid);
            threadMap.put(thread.getId(), thread);
        }
            
        // 下面這個比較可確定沖款時間一定在收入時間之后
        // 在這之前看 balance sheet 會掛在 student account 餘額里
        Date registerDate = (bpaid.getRecordTime().compareTo(bill.getBillMonth())>0)?bpaid.getRecordTime():bill.getBillMonth();

        VchrHolder v = new VchrHolder();
        v.setSerial(getSerialNo("_d", registerDate));
        Date create_date = new Date();
        v.setCreated(create_date);
        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        v.setUserId(userId);
        v.setType(VchrHolder.TYPE_INSTANCE);
        v.setBuId(bpaid.getBunitId());
        
        String note = "沖帳-"+((reason!=null)?(reason+"-"):"") + m.getName();

        int noteId = (int) LiteralStore.create(store, note);
        v.setNote(noteId);
        v.setThreadId(thread.getId());
        vhmgr.create(v);
        
        for (int j=0; j<merged_items.size(); j++) {
            VchrItem item = merged_items.get(j);
            addItem(j, v, item.getBunitId(), item.getAcodeId(), item.getFlag(), thread.getId(), 
                item.getDebit(), item.getCredit(), noteId);
        }
    }

    public void genVoucherForBill(MembrInfoBillRecord bill, int userId, String reason)
        throws Exception
    {
        ArrayList<MembrInfoBillRecord> bills = new ArrayList<MembrInfoBillRecord>();
        bills.add(bill);
        genVoucherForBills(bills, userId, reason);
    }

    public void genVoucherForBills(ArrayList<MembrInfoBillRecord> bills, int userId, String reason)
        throws Exception
    {

        ChargeItemMembrMgr cimgr = new ChargeItemMembrMgr(tran_id);
        DiscountMgr dmgr = new DiscountMgr(tran_id);

        String billRecordIds = new RangeMaker().makeRange(bills, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(bills, "getMembrId");
        ArrayList<ChargeItemMembr> charges = cimgr.retrieveList("chargeitem.billRecordId in (" + 
            billRecordIds + ") and charge.membrId in (" + membrIds + ")", "");
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        ArrayList<Discount> discounts = dmgr.retrieveList("chargeItemId in (" + 
            chargeItemIds + ") and membrId in (" + membrIds + ")", "");
        Map<Integer, jsf.DiscountType> dtypeMap = new SortingMap(jsf.DiscountTypeMgr.getInstance().
            retrieve("", "")).doSortSingleton("getId");

        // 抓進所有的 學費相關的 billitem template (maybe 也需 discount template)
        VchrHolderMgr vhmgr = new VchrHolderMgr(tran_id);
        VchrHolder billitem_default = getBillItemVoucher(VchrHolder.BILLITEM_DEFAULT); // default
        VchrHolder billitem_tempreceipt = getBillItemVoucher(VchrHolder.BILLITEM_TEMPRECEIPT); // tempreceipt
        ArrayList<VchrHolder> templates = vhmgr.retrieveList("type=" + VchrHolder.TYPE_TEMPLATE, "");
System.out.println("## templates.size=" + templates.size());
        Map<Integer, VchrHolder> bitemvchrMap = new SortingMap(templates).doSortSingleton("getId");

        // 抓進所有這些 templates 的 vchr_items
        VchrItemMgr vimgr = new VchrItemMgr(tran_id);
        String vchrIds = new RangeMaker().makeRange(templates, "getId");
        ArrayList<VchrItem> items = vimgr.retrieveList("vchrId in (" + vchrIds + ")", "");
        Map<Integer, Vector<VchrItem>> templateitemMap = new SortingMap(items).doSort("getVchrId");

        // 這兩個就是整理出來的跟這些帳單有關的 chargeitemmembr 和 discount
        Map<String, Vector<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSort("getTicketId");
        Map<String, Vector<Discount>> discountMap = new SortingMap(discounts).doSort("getChargeKey");

        // 抓進這些 bill 的 threads and voucher and items
        String threadIds = new RangeMaker().makeRange(bills, "getThreadId");
        ArrayList<VchrThread> threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> threadMap = new SortingMap(threads).doSortSingleton("getId");
        ArrayList<VchrItem> vchritems = vimgr.retrieveList("threadId in (" + threadIds + ")", "");
        Map<Integer, ArrayList<VchrItem>> threaditemMap = new SortingMap(vchritems).doSortA("getThreadId");
        Map<Integer, ArrayList<VchrItem>> vchritemMap = new SortingMap(vchritems).doSortA("getVchrId");

        // 折扣要用到的 discountType
        Map<Integer, jsf.DiscountType> discountTypeMap = new SortingMap(
            jsf.DiscountTypeMgr.getInstance().retrieve("", "")).doSortSingleton("getId");

        // 一張一張來
        double total1 = 0;
        double total2 = 0;
        for (int i=0; i<bills.size(); i++) {
            MembrInfoBillRecord bill = bills.get(i);
            ArrayList<VchrItem> reverse_items = getReverseItems(getDirectItems(bill.getThreadId(), threaditemMap));
            ArrayList<VchrItem> current_items = getBillCurrentItems(bill, chargeMap, discountMap, 
                bitemvchrMap, billitem_default, billitem_tempreceipt, templateitemMap, discountTypeMap);

            phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>(reverse_items);
            all_items.concate(current_items);
            ArrayList<VchrItem> merged_items = mergeItems(all_items);
            if (merged_items.size()>0) {
                makeBillVoucher(bill, threadMap, vchritemMap, merged_items, userId, reason, Bill.TYPE_BILLING);
            }
        }
    }
    
    public ArrayList<VchrItem> getBillPayCurrentItems(BillPay bpay, Map<Integer, Costpay2> costpayMap)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        // 計算借方
        // VIA_INPERSON = 0; VIA_ATM = 1; VIA_STORE = 2; VIA_CHECK = 3; VIA_WIRE = 4; VIA_CREDITCARD = 5;
        int via = bpay.getVia();
        Acode acode = null;
        if (via==0 || via==1 || via==2 || via==4 || via==5 || via==3) {
            Costpay2 cp = costpayMap.get(bpay.getId());
            try { 
                acode = getCashAcode(cp.getCostpayAccountType(), cp.getCostpayAccountId()); 
            } catch (Exception e) {
                // 舊版的資料, 那時 billpay 沒有對應好 costpay
                acode = _get_acode(CASH);
            }
        }
        VchrItem vi = new VchrItem();
        vi.setFlag(VchrItem.FLAG_DEBIT);
        vi.setAcodeId(acode.getId());
        vi.setDebit(bpay.getAmount());
        vi.setThreadId(bpay.getThreadId());
        ret.add(vi);

        // 貸方
        Acode da = getStudentAccountAcode(bpay.getMembrId());
        VchrItem vi2 = new VchrItem();
        vi2.setFlag(VchrItem.FLAG_CREDIT);
        vi2.setAcodeId(da.getId());
        vi2.setCredit(bpay.getAmount());
        vi2.setThreadId(bpay.getThreadId());
        ret.add(vi2);

        // 如果有退費, 因為是少數狀況, 所以就直接 db 拿了
        // 退費會產生 借學生帳戶 貸現金戶頭
        if (bpay.getRefundCostPayId()>0) {
            Costpay2 cp = new Costpay2Mgr(tran_id).find("id=" + bpay.getRefundCostPayId());
            VchrItem vi3 = new VchrItem();
            vi3.setFlag(VchrItem.FLAG_DEBIT);
            vi3.setAcodeId(da.getId());
            vi3.setDebit(cp.getCostpayCostNumber());
            vi3.setThreadId(bpay.getThreadId());
            ret.add(vi3);

            Acode a = getCashAcode(cp.getCostpayAccountType(), cp.getCostpayAccountId());
            VchrItem vi4 = new VchrItem();
            vi4.setFlag(VchrItem.FLAG_CREDIT);
            vi4.setAcodeId(a.getId());
            vi4.setCredit(cp.getCostpayCostNumber());
            vi4.setThreadId(bpay.getThreadId());
            ret.add(vi4);
        }

        return ret;
    }

    public ArrayList<VchrItem> getCrossBunitItemsForBillPay(BillPay bpay, Vector<BillPaid> paids)
        throws Exception
    {
        // 如果單位不同，要產生 借-學生帳戶 貸-單位往來 for B 的傳票
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        if (paids==null)
            return ret;
        for (int i=0; i<paids.size(); i++) {
            if (paids.get(i).getBunitId()!=bpay.getBunitId()) {
                BillPaid p = paids.get(i);
                if (p.getAmount()==0)
                    continue;
                VchrItem vi = new VchrItem();
                vi.setFlag(VchrItem.FLAG_DEBIT);
                Acode acode = getStudentAccountAcode(bpay.getMembrId());
                vi.setAcodeId(acode.getId());
                vi.setDebit(p.getAmount());
                vi.setThreadId(bpay.getThreadId());
                ret.add(vi);

                // 貸方
                Acode da = getBunitAcode(p.getBunitId()); // 欠 billpaid 的單位
                VchrItem vi2 = new VchrItem();
                vi2.setFlag(VchrItem.FLAG_CREDIT);
                vi2.setAcodeId(da.getId());
                vi2.setCredit(p.getAmount());
                vi2.setThreadId(bpay.getThreadId());
                ret.add(vi2);
            }
        }
        return ret;
    }

    public ArrayList<VchrItem> getCrossBunitItemsForBillPaid(BillPaid paid, BillPay bpay)
        throws Exception
    {
        // 如果單位不同，要產生 借-單位往來 from A, 貸-學生帳戶 的傳票
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        if (paid.getAmount()>0 && paid.getBunitId()!=bpay.getBunitId()) {
            VchrItem vi = new VchrItem();
            vi.setFlag(VchrItem.FLAG_DEBIT);
            Acode acode = getBunitAcode(bpay.getBunitId());  // billpay 的單位 欠我
            vi.setAcodeId(acode.getId());
            vi.setDebit(paid.getAmount());
            vi.setThreadId(paid.getThreadId());
            ret.add(vi);

            // 貸方
            Acode da = getStudentAccountAcode(bpay.getMembrId());
            VchrItem vi2 = new VchrItem();
            vi2.setFlag(VchrItem.FLAG_CREDIT);
            vi2.setAcodeId(da.getId());
            vi2.setCredit(paid.getAmount());
            vi2.setThreadId(paid.getThreadId());
            ret.add(vi2);
        }
        return ret;
    }


    public ArrayList<VchrItem> getSalaryBillPayCurrentItems(BillPay bpay, Map<Integer, Vector<BillPaid>> paidMap, 
        Map<String, MembrInfoBillRecord> salaryMap, Map<Integer, Costpay2> costpayMap)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();

        // 計算貸方
        Costpay2 cp = costpayMap.get(bpay.getId());
        Acode acode = null;
        try { 
            acode = getCashAcode(cp.getCostpayAccountType(), cp.getCostpayAccountId());
        }
        catch (Exception e) {
            acode = _get_acode(CASH);
        }

        VchrItem vi = new VchrItem();
        vi.setFlag(VchrItem.FLAG_CREDIT);
        vi.setAcodeId(acode.getId());
        vi.setCredit(bpay.getAmount());
        vi.setThreadId(bpay.getThreadId());
        ret.add(vi);

        // 借方
        Vector<BillPaid> paids = paidMap.get(bpay.getId());
        int total = 0;
        for (int i=0; i<paids.size(); i++) {
            MembrInfoBillRecord ticket = salaryMap.get(paids.get(i).getTicketId());
            Acode a = getSalaryAccountAcode(ticket.getMembrId());
            VchrItem vi2 = new VchrItem();
            vi2.setFlag(VchrItem.FLAG_DEBIT);
            vi2.setAcodeId(a.getId());
            vi2.setDebit(paids.get(i).getAmount());
            total += paids.get(i).getAmount();
            vi2.setThreadId(bpay.getThreadId());
            ret.add(vi2);
        }
        if (total!=bpay.getAmount())
            throw new Exception("付款金額和薪資銷帳金額不同");

        return ret;
    }

    // 產生這一個 billpaid 會造成的影響的傳票
    // 應該是 貸[應付帳款] 借[學生帳戶] 之類的
    public ArrayList<VchrItem> getPaidCurrentItems(BillPaid paid, MembrBillRecord bill, 
        Map<Integer, ArrayList<VchrItem>> billthreaditemMap,
        Map<String, ArrayList<BillPaid>> ticketpaidMap,
        Map<Integer, ArrayList<VchrItem>> bpaidthreaditemMap)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        if (bill.getThreadId()==0)
            return ret;
/*
    2008/12/18
    這里有點複雜.. 這張帳單的借項先用部門科目歸類, 從頭開始一個一個看那些已經被 billpaid 貸掉
    最后還有餘額的放到 debit_items 里 用這個 list 來產生對應的貸項。
    再檢查過去 billpaid 已經貸掉的帳單借項時，要記得跳過這次的 billpaid
*/
        // 這個只有 bill 部分，也就是原始的借方
        ArrayList<VchrItem> items = billthreaditemMap.get(new Integer(bill.getThreadId()));  
        items = mergeItems(items); // 先自己銷一遍留下還有餘額的才來看
        Map<Integer, ArrayList<VchrItem>> tmp1 = new SortingMap(items).doSortA("getFlag");
        ArrayList<VchrItem> bill_debit_items = tmp1.get(VchrItem.FLAG_DEBIT);
        // 按 BunitAcode 排等著來銷
        Map<String, ArrayList<VchrItem>> debitmap = new SortingMap(bill_debit_items).doSortA("getBunitAcodeKey");

        // 看之前的 billpaid 可銷那些, 但碰到這次這個要跳過
        ArrayList<BillPaid> bill_paids = ticketpaidMap.get(bill.getTicketId());
        for (int i=0; bill_paids!=null&&i<bill_paids.size(); i++) {
            BillPaid bp = bill_paids.get(i);
            if (bp.getTicketId().equals(paid.getTicketId()) && bp.getBillPayId()==paid.getBillPayId()) // 這次算的這個要跳過
                continue;
            ArrayList<VchrItem> tmp2 = bpaidthreaditemMap.get(bp.getThreadId());
            for (int j=0; tmp2!=null&&j<tmp2.size(); j++) {
                // 把每個 billpaid 的對帳單貸掉的東西考慮進去
                VchrItem vi = tmp2.get(j);
                ArrayList<VchrItem> tmp3 = debitmap.get(vi.getBunitId()+"#"+vi.getAcodeId());
                if (tmp3!=null) // 原來帳單有借項才考慮
                    tmp3.add(vi); // tmp3 是原來帳單的借項，這里加上對應的 在billpaid上找到的貸項
            }
        }

        ArrayList<VchrItem> debit_items = new ArrayList<VchrItem>();
        Iterator<String> iter = debitmap.keySet().iterator();
        while (iter.hasNext()) {
            ArrayList<VchrItem> tmp4 = debitmap.get(iter.next());
            double debit = 0;
            for (int i=0; i<tmp4.size(); i++) {
                VchrItem vi = tmp4.get(i);
                if (vi.getFlag()==VchrItem.FLAG_DEBIT) {
                    debit += vi.getDebit();
                }
                else {
                    debit -= vi.getCredit();
                }
            }
            /*
            ###### 2009/1/23 借方有東西就可不一定要大于0, 因為現在借方有可能為負的 例如折扣產生的應收帳款
            #####    道禾有個 case 是應收帳款有份部分可是折扣負項沒有，造成這兩個應收不能合并計算因而負項的
            #####    那個應收會小於0
            if (debit<0)
                throw new Exception("產生 billpaid 傳票偵測出之前超銷 debit=" + debit);
            if (debit>0) {
                VchrItem vi = tmp4.get(0).clone();
                vi.setFlag(VchrItem.FLAG_DEBIT);
                vi.setDebit(debit);
                debit_items.add(vi);
            }
            */
            VchrItem vi = tmp4.get(0).clone();
            vi.setFlag(VchrItem.FLAG_DEBIT);
            vi.setDebit(debit);
            debit_items.add(vi);
        }

        // 貸方
        double amount = (double) paid.getAmount();
        for (int i=0; amount>0 && i<debit_items.size(); i++) {
            VchrItem vi = debit_items.get(i);
            double credit = Math.min(amount, vi.getDebit());
            VchrItem newvi = vi.clone();
            newvi.setFlag(VchrItem.FLAG_CREDIT);
            newvi.setCredit(credit);
            newvi.setDebit(0);
            newvi.setThreadId(paid.getThreadId()); // 不設會用到錯的 后來 merge_item 就沒法merge
            ret.add(newvi);
            amount -= credit;
        }
        if (amount>0) {
            for (int i=0; amount>0 && i<debit_items.size(); i++) {
                VchrItem vi = debit_items.get(i);
                double credit = Math.min(amount, vi.getDebit());
                System.out.println("credit=" + credit);
            }
            System.out.println("threadId=" + paid.getThreadId() + " amount=" + paid.getAmount() + " paid=" + paid.getTicketId() + ":" + paid.getBillPayId());
            throw new Exception("產生 billpaid 傳票時不平衡");
        }

        // 借方
        Acode da = getStudentAccountAcode(bill.getMembrId());
        VchrItem vi2 = new VchrItem();
        vi2.setFlag(VchrItem.FLAG_DEBIT);
        vi2.setAcodeId(da.getId());
        vi2.setDebit((double)paid.getAmount());
        vi2.setThreadId(paid.getThreadId());
        ret.add(vi2);

        return ret;
    }

    // 產生這一個 billpaid 會造成的影響的傳票
    // 應該是 貸[薪資帳戶] 借[應付薪資] 之類的
    public ArrayList<VchrItem> getSalaryPaidCurrentItems(BillPaid paid, MembrBillRecord salary, 
        Map<Integer, ArrayList<VchrItem>> salarythreaditemMap,
        Map<String, ArrayList<BillPaid>> ticketpaidMap,
        Map<Integer, ArrayList<VchrItem>> bpaidthreaditemMap)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        if (salary.getThreadId()==0)
            return ret;
/*
    2008/12/18
    這里有複雜.. 這張帳單的借項先用部門科目歸類, 從頭開始一個一個看那些已經被 billpaid 貸掉
    最后還有餘額的放到 debit_items 里 用這個 list 來產生對應的貸項。
    再檢查過去 billpaid 已經貸掉的帳單借項時，要記得跳過這次的 billpaid
*/
        // 這個只有 salary 部分，也就是原始的貸方
        ArrayList<VchrItem> items = salarythreaditemMap.get(new Integer(salary.getThreadId()));  
        items = mergeItems(items); // 先自己銷一遍留下還有餘額的才來看
        Map<Integer, ArrayList<VchrItem>> tmp1 = new SortingMap(items).doSortA("getFlag");
        ArrayList<VchrItem> bill_credit_items = tmp1.get(VchrItem.FLAG_CREDIT);
        // 按 BunitAcode 排等著來銷
        Map<String, ArrayList<VchrItem>> creditmap = new SortingMap(bill_credit_items).doSortA("getBunitAcodeKey");

        // 看之前的 billpaid 可銷那些, 但碰到這次這個要跳過
        ArrayList<BillPaid> bill_paids = ticketpaidMap.get(salary.getTicketId());
        for (int i=0; bill_paids!=null&&i<bill_paids.size(); i++) {
            BillPaid bp = bill_paids.get(i);
            if (bp.getTicketId().equals(paid.getTicketId()) && bp.getBillPayId()==paid.getBillPayId()) // 這次算的這個要跳過
                continue;
            ArrayList<VchrItem> tmp2 = bpaidthreaditemMap.get(bp.getThreadId());
            for (int j=0; tmp2!=null&&j<tmp2.size(); j++) {
                // 把每個 billpaid 的對薪資借掉的東西考慮進去
                VchrItem vi = tmp2.get(j);
                ArrayList<VchrItem> tmp3 = creditmap.get(vi.getBunitId()+"#"+vi.getAcodeId());
                if (tmp3!=null) // 原來薪資有貸項才考慮
                    tmp3.add(vi); // tmp3 是原來薪資的貸項，這里加上對應的 在billpaid上找到的借項
            }
        }

        ArrayList<VchrItem> credit_items = new ArrayList<VchrItem>();
        Iterator<String> iter = creditmap.keySet().iterator();
        while (iter.hasNext()) {
            ArrayList<VchrItem> tmp4 = creditmap.get(iter.next());
            double credit = 0;
            for (int i=0; i<tmp4.size(); i++) {
                VchrItem vi = tmp4.get(i);
                if (vi.getFlag()==VchrItem.FLAG_CREDIT)
                    credit += vi.getCredit();
                else
                    credit -= vi.getCredit();
            }
            /*
            #### 看上面 getBillPaidCurrentItems 的注解 這里意思一樣
            if (credit<0)
                throw new Exception("產生薪資 billpaid 傳票偵測出之前超銷");
            if (credit>0) {
                VchrItem vi = tmp4.get(0).clone();
                vi.setFlag(VchrItem.FLAG_CREDIT);
                vi.setDebit(credit);
                credit_items.add(vi);
            }
            */
            VchrItem vi = tmp4.get(0).clone();
            vi.setFlag(VchrItem.FLAG_CREDIT);
            vi.setDebit(credit);
            credit_items.add(vi);
        }

        // 借方
        double amount = (double) paid.getAmount();
        for (int i=0; amount>0 && i<credit_items.size(); i++) {
            VchrItem vi = credit_items.get(i);
            double debit = Math.min(amount, vi.getCredit());
            VchrItem newvi = vi.clone();
            newvi.setFlag(VchrItem.FLAG_DEBIT);
            newvi.setDebit(debit);
            newvi.setCredit(0);
            newvi.setThreadId(paid.getThreadId()); // 不設會用到錯的 后來 merge_item 就沒法merge
            ret.add(newvi);
            amount -= debit;
        }
        if (amount>0)
            throw new Exception("產生 billpaid 傳票時不平衡");

        // 貸方
        Acode a = getSalaryAccountAcode(salary.getMembrId());
        VchrItem vi2 = new VchrItem();
        vi2.setFlag(VchrItem.FLAG_CREDIT);
        vi2.setAcodeId(a.getId());
        vi2.setCredit((double)paid.getAmount());
        vi2.setThreadId(paid.getThreadId());
        ret.add(vi2);

        return ret;
    }

    public void genVoucherForBillPay(BillPay billpay, int userId, String reason)
        throws Exception
    {
        ArrayList<BillPay> billpays = new ArrayList<BillPay>();
        billpays.add(billpay);
        genVoucherForBillPays(billpays, userId, reason);
    }

    public void genVoucherForBillPays(ArrayList<BillPay> billpays, int userId, String reason)
        throws Exception
    {
        String billpayIds = new RangeMaker().makeRange(billpays, "getId");
        ArrayList<BillPaid> pay_paids = new BillPaidMgr(tran_id).retrieveList("billpayId in (" + billpayIds + ")", "");
        String ticketIds = new RangeMaker().makeRange(pay_paids, "getTicketIdAsString");
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")", "");
        // 先確定這些帳單有傳票了
        genVoucherForBills(bills, userId, "");

        Map<Integer, Vector<BillPaid>> paidMap = new SortingMap(pay_paids).doSort("getBillPayId");
        ArrayList<BillPaid> bill_paids = new BillPaidMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")", "");
        Map<String, ArrayList<BillPaid>> ticketpaidMap = new SortingMap(bill_paids).doSortA("getTicketId");
        
        // 抓進這些 bill 的 threads and items
        String threadIds = new RangeMaker().makeRange(bills, "getThreadId");
        ArrayList<VchrThread> threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> billthreadMap = new SortingMap(threads).doSortSingleton("getId");
        Map<Integer, ArrayList<VchrItem>> billthreaditemMap = new SortingMap(vimgr.
            retrieveList("threadId in (" + threadIds + ")", "")).doSortA("getThreadId");
        Map<String, MembrInfoBillRecord> billMap = new SortingMap(bills).doSortSingleton("getTicketId");

        // 抓進這些 billpay 的 threads and voucher and items
        threadIds = new RangeMaker().makeRange(billpays, "getThreadId");
        threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> bpaythreadMap = new SortingMap(threads).doSortSingleton("getId");
        Map<Integer, ArrayList<VchrItem>> bpaythreaditemMap = new SortingMap(vimgr.
            retrieveList("threadId in (" + threadIds + ")", "")).doSortA("getThreadId");

        // 抓進這些 billpaid 的 threads and voucher and items
        phm.util.PArrayList<BillPaid> all_paids = new phm.util.PArrayList<BillPaid>(pay_paids);
        all_paids.concate(bill_paids);
        threadIds = new RangeMaker().makeRange(all_paids, "getThreadId");
        threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> bpaidthreadMap = new SortingMap(threads).doSortSingleton("getId");
        Map<Integer, ArrayList<VchrItem>> bpaidthreaditemMap = new SortingMap(vimgr.
            retrieveList("threadId in (" + threadIds + ")", "")).doSortA("getThreadId");

        // 抓進 billpay 相關的 costpay
        ArrayList<Costpay2> costpays = new Costpay2Mgr(tran_id).retrieveList("costpayFeePayFeeID=" + 
            Costpay2.COSPAY_TYPE_TUITION + " and costpayStudentAccountId in (" + billpayIds + ")", "");
        Map<Integer, Costpay2> costpayMap = new SortingMap(costpays).doSortSingleton("getCostpayStudentAccountId");

        // membrMap
        String membrIds = new RangeMaker().makeRange(billpays, "getMembrId");
        Map<Integer,Membr> membrMap = new SortingMap(MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "")).
            doSortSingleton("getId");

        for (int i=0; i<billpays.size(); i++) {
            BillPay bpay = billpays.get(i);
            Membr m = membrMap.get(bpay.getMembrId());
            ArrayList<VchrItem> reverse_items = getReverseItems(getDirectItems(bpay.getThreadId(), bpaythreaditemMap));
            ArrayList<VchrItem> current_items = getBillPayCurrentItems(bpay, costpayMap);
            // ### 2009/3/19 by peter, 要加往來項目
            Vector<BillPaid> my_paids = paidMap.get(bpay.getId());
            ArrayList<VchrItem> xbunit_items = getCrossBunitItemsForBillPay(bpay, my_paids);
            // ###

            // 產生 billpay 的 vouchr
            phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>(reverse_items);
            all_items.concate(current_items);
//System.out.println("######## current_items : " + bpay.getId() + "  ###########");
//VchrInfo.print(current_items, tran_id);
            all_items.concate(xbunit_items);
//System.out.println("######## xbunit_items : " + bpay.getId() + "  ###########");
//VchrInfo.print(xbunit_items, tran_id);
            ArrayList<VchrItem> merged_items = mergeItems(all_items);
//System.out.println("######## billpay : " + bpay.getId() + "  ###########");
//VchrInfo.print(merged_items, tran_id);
            if (merged_items.size()>0) {
                makeBillPayVoucher(bpay, bpaythreadMap, merged_items, userId, VchrThread.SRC_TYPE_BILLPAY, reason, m);  
            }
            // for each paid bill, 產生對應的 voucher
            // 計算貸方
            Vector<BillPaid> vpaids = paidMap.get(new Integer(bpay.getId()));

            for (int j=0; vpaids!=null&&j<vpaids.size(); j++) {
                BillPaid p = vpaids.get(j);
                MembrInfoBillRecord b = billMap.get(p.getTicketId());
                if (b==null || b.getThreadId()==0) // 如果 bill 沒有傳票就沒有產生銷帳傳票的必要
                    continue;
                reverse_items = getReverseItems(getDirectItems(p.getThreadId(), bpaidthreaditemMap));
                ArrayList<VchrItem> paid_items = getPaidCurrentItems(p, b, billthreaditemMap, ticketpaidMap, bpaidthreaditemMap);
                // ### 2009/3/19 by peter, 要加往來項目
                xbunit_items = getCrossBunitItemsForBillPaid(p, bpay);
                // ###
                all_items = new phm.util.PArrayList<VchrItem>(reverse_items);
                all_items.concate(paid_items);
                all_items.concate(xbunit_items);
                merged_items = mergeItems(all_items);
//System.out.println("######## billpaid : " + b.getTicketId() + "  ###########");
//VchrInfo.print(merged_items, tran_id);
                if (merged_items.size()==0)
                    continue;
                makeBillPaidVoucher(p, b, bpaidthreadMap, merged_items, userId, VchrThread.SRC_TYPE_BILLPAID, reason, m);
                bpaidthreaditemMap.put(p.getThreadId(), merged_items);
            }
        }
    }


    // calling from bill modify jsps
    // ######################################
    public void updateBillRecord(BillRecord br, int userId)
        throws Exception
    {
        ArrayList<MembrInfoBillRecord> bills =  new MembrInfoBillRecordMgr(tran_id).
            retrieveList("billRecordId=" + br.getId(), "");
        genVoucherForBills(bills, userId, null);
    }

    /*
    public void ceanupForBills(ArrayList<MembrInfoBillRecord> bills)
        throws Exception
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<bills.size(); i++) {
            if (bills.get(i).getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID && bills.get(i).getThreadId()>0) {
                if (sb.length()>0) 
                    sb.append(",");
                sb.append(bills.get(i).getThreadId());
            }
        }
        if (sb.length()==0)
            return;
        vtmgr.executeSQL("delete from vchr_thread where id in (" + sb.toString() + ")");      
        vhmgr.executeSQL("delete from vchr_holder where threadId in (" + sb.toString() + ")");
        vimgr.executeSQL("delete from vchr_item where threadId in (" + sb.toString() + ")");
    }
    */

    public String getBillRelatedThreadIds(ArrayList<MembrInfoBillRecord> bills) 
        throws Exception
    {
        String ticketIds = new RangeMaker().makeRange(bills, "getTicketIdAsString");
        ArrayList<BillPaid> paids = BillPaidMgr.getInstance().retrieveList("ticketId in (" + ticketIds + ")", "");
        String billpayIds = new RangeMaker().makeRange(paids, "getBillPayId");
        ArrayList<BillPay> pays = BillPayMgr.getInstance().retrieveList("id in (" + billpayIds + ")", "");

        String bill_threadIds = new RangeMaker().makeRange(bills, "getThreadId");
        String paid_threadIds = new RangeMaker().makeRange(paids, "getThreadId");
        String pay_threadIds = new RangeMaker().makeRange(pays, "getThreadId");

        return bill_threadIds + "," + paid_threadIds + "," + pay_threadIds;
    }

    public void updateSalaryBillRecord(BillRecord br, int userId)
        throws Exception
    {
        ArrayList<MembrInfoBillRecord> salaries =  new MembrInfoBillRecordMgr(tran_id).
            retrieveList("billRecordId=" + br.getId(), "");
        genVoucherForSalaries(salaries, userId, null);
    }

    public void updateCharge(Charge charge, int userId, String reason)
        throws Exception
    {
        ArrayList<Charge> tmp = new ArrayList<Charge>();
        tmp.add(charge);
        updateCharges(tmp, userId, reason);
    }

    public void updateChargeItemMembr(ChargeItemMembr charge, int userId, String reason)
        throws Exception
    {
        ArrayList<ChargeItemMembr> tmp = new ArrayList<ChargeItemMembr>();
        tmp.add(charge);
        updateChargeItemMembrs(tmp, userId, reason);
    }


    public void updateCharges(ArrayList<Charge> modified_charges, int userId, String reason)
        throws Exception
    {
        String chargeItemIds = new RangeMaker().makeRange(modified_charges, "getChargeItemId");
        ArrayList<ChargeItem> chargeitems = new ChargeItemMgr(tran_id).retrieveList("id in (" + chargeItemIds + ")", "");
        String billRecordIds = new RangeMaker().makeRange(chargeitems, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(modified_charges, "getMembrId");
        String q = "membrId in (" + membrIds + ") and billRecordId in (" + billRecordIds + ")";
        q += " and threadId>0"; // 2008/12/30 by decided, decide only track modification if bill already has voucher
                                // voucher is created upon 發布         
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).
            retrieveList(q, "");
        genVoucherForBills(bills, userId, reason);
    }

    public void updateChargeItemMembrs(ArrayList<ChargeItemMembr> modified_charges, int userId, String reason)
        throws Exception
    {
        String billRecordIds = new RangeMaker().makeRange(modified_charges, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(modified_charges, "getMembrId");
        String q = "membrId in (" + membrIds + ") and billRecordId in (" + billRecordIds + ")";
        q += " and threadId>0"; // 2008/12/30 by decided, decide only track modification if bill already has voucher
                                // voucher is created upon 發布         
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).
            retrieveList(q, "");
        genVoucherForBills(bills, userId, reason);
    }

    public ArrayList<VchrItem> parse(String[] lines)
        throws Exception
    {
        // id:0|flag:1|debit:0|credit:1|main:4104|sub:|bu:0|name:學費收入|note:摘要
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        for (int i=0; i<lines.length; i++) {
            if (lines[i].trim().length()==0)
                continue;
            String[] pairs = lines[i].split("[|]");
            VchrItem vi = new VchrItem();
            vi.setId(i);

            // get acode
            String main = pairs[4].split(":")[1];
            String sub = null;
            try {
                sub = pairs[5].split(":")[1];
            }
            catch (Exception e) {}
            Acode a = _get_acode(main, sub);
            if (a==null)
                throw new Exception("");
            vi.setAcodeId(a.getId());

            // debit, credit
            double debit = Double.parseDouble(pairs[2].split(":")[1]);
            double credit = Double.parseDouble(pairs[3].split(":")[1]);
            if (debit!=0) {
                vi.setDebit(debit);
                vi.setFlag(VchrItem.FLAG_DEBIT);
            }
            else {
                vi.setCredit(credit);
                vi.setFlag(VchrItem.FLAG_CREDIT);
            }

            // get bunit
            vi.setBunitId(Integer.parseInt(pairs[6].split(":")[1])); // bu:0
            // get note
            try {
                int c = pairs[8].indexOf(":");
                if (c>0) {
                    String note = pairs[8].substring(c+1);
                    int id = (int) LiteralStore.create(store, note);                    
                    vi.setNote(id);
                }
            }
            catch (Exception e) {}
            
            ret.add(vi);
        }
        return ret;
    }

    public void genVoucherForDeleteInsideTrade(jsf.Insidetrade in, int userId)
        throws Exception
    {
        VchrThread thread = vtmgr.find("id=" + in.getThreadId());
        if (thread==null) 
            return; // nothing to reverse
        ArrayList<VchrItem> items = vimgr.retrieveList("threadId=" + thread.getId(), "");
        items = getReverseItems(items);

        VchrHolder orgv = vhmgr.find("id=" + items.get(0).getVchrId());

        Date registerDate = orgv.getRegisterDate(); // 用產生的時間來刪
        String str = "刪除內部轉帳";

        VchrHolder v = new VchrHolder();
        v.setSerial(getSerialNo("_i", registerDate));
        Date create_date = new Date();
        v.setCreated(create_date);
        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        v.setUserId(userId);
        v.setType(VchrHolder.TYPE_INSTANCE);
        int noteId = (int) LiteralStore.create(store, str);
        v.setNote(noteId);
        v.setThreadId(thread.getId());
        v.setBuId(in.getBunitId());
        vhmgr.create(v);

        for (int i=0; i<items.size(); i++) {
            VchrItem vi = items.get(i);
            addItem(i, v, 0, vi.getAcodeId(), vi.getFlag(), thread.getId(), vi.getDebit(), vi.getCredit(), noteId);
        }
    }

    // 傳 InsidetradeMgr 進來是不得已的因為用的 tran_id 不同
    public void genVoucherForInsideTransfer(jsf.Insidetrade in, jsf.InsidetradeMgr imgr, int userId)
        throws Exception
    {
        // 產生 thread
        VchrThread thread = new VchrThread();
        thread.setSrcType(VchrThread.SRC_TYPE_INSIDETRADE);
        thread.setSrcInfo(in.getId()+"");
        vtmgr.create(thread);
        
        in.setThreadId(thread.getId());
        imgr.save(in);
            
        Date registerDate = in.getInsidetradeDate();
        String str = "內部轉帳";

        VchrHolder v = new VchrHolder();
        v.setSerial(getSerialNo("_i", registerDate));
        Date create_date = new Date();
        v.setCreated(create_date);
        v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
        v.setUserId(userId);
        v.setType(VchrHolder.TYPE_INSTANCE);
        int noteId = (int) LiteralStore.create(store, str);
        v.setNote(noteId);
        v.setThreadId(thread.getId());
        v.setBuId(in.getBunitId());
        vhmgr.create(v);

        Acode from = (in.getInsidetradeFromType()!=3)?
                        getCashAcode(in.getInsidetradeFromType(), in.getInsidetradeFromId()):
                        getChequeReceivableAcode();
        Acode to = (in.getInsidetradeToType()!=3)?
                        getCashAcode(in.getInsidetradeToType(), in.getInsidetradeToId()):
                        getChequePayableAcode();

        int note1 = (int) LiteralStore.create(store, "轉出");
        int note2 = (int) LiteralStore.create(store, "轉入");

        addItem(0, v, 0, from.getId(), VchrItem.FLAG_CREDIT, thread.getId(), 0, (double)in.getInsidetradeNumber(), note1);
        addItem(1, v, 0, to.getId(), VchrItem.FLAG_DEBIT, thread.getId(), (double)in.getInsidetradeNumber(), 0, note2);
    }

    public String getVchrNote(VchrHolder v)
    {
        return store.restore(v.getNote());
    }

    public Costpay2 makeCostpayOnVchrItem(VchrItem vi, Date registerDate, int acctType, int acctId, int userId, int bunitId) 
        throws Exception
    {
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
        Costpay2 cp = new Costpay2();
        cp.setCostpayDate(registerDate);
        cp.setCostpaySide(0);
        if (vi.getFlag()==VchrItem.FLAG_CREDIT) {
            cp.setCostpayNumberInOut(1); // out
            cp.setCostpayCostNumber((int)vi.getCredit());
        }
        else {
            cp.setCostpayNumberInOut(0); // in
            cp.setCostpayIncomeNumber((int)vi.getDebit());
        }
        cp.setCostpayAccountType(acctType);
        cp.setCostpayAccountId(acctId);
        cp.setCostpayLogDate(registerDate);
        cp.setCostpayLogId(userId);
        cp.setCostpayLogPs("傳票輸入");
        cp.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_MANUAL_VOUCHER);
        cp.setCostpayStudentAccountId(vi.getVchrId());
        cp.setBunitId(bunitId);
        cpmgr.create(cp);
        return cp;
    }

    public void genVoucherForSalary(MembrInfoBillRecord salary, int userId, String reason)
        throws Exception
    {
        ArrayList<MembrInfoBillRecord> salaries = new ArrayList<MembrInfoBillRecord>();
        salaries.add(salary);
        genVoucherForSalaries(salaries, userId, reason);
    }

    public void genVoucherForSalaries(ArrayList<MembrInfoBillRecord> salaries, int userId, String reason)
        throws Exception
    {
        ChargeItemMembrMgr cimgr = new ChargeItemMembrMgr(tran_id);

        String billRecordIds = new RangeMaker().makeRange(salaries, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(salaries, "getMembrId");
        ArrayList<ChargeItemMembr> charges = cimgr.retrieveList("chargeitem.billRecordId in (" + 
            billRecordIds + ") and charge.membrId in (" + membrIds + ")", "");
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");

        // 抓進所有的 薪資相關的 billitem template 
        VchrHolderMgr vhmgr = new VchrHolderMgr(tran_id);
        VchrHolder salary_default = getBillItemVoucher(VchrHolder.SALARY_BILLITEM_DEFAULT); // default
        ArrayList<VchrHolder> templates = vhmgr.retrieveList("type=" + VchrHolder.TYPE_TEMPLATE, "");
        Map<Integer, VchrHolder> bitemvchrMap = new SortingMap(templates).doSortSingleton("getId");

        // 抓進所有這些 templates 的 vchr_items
        VchrItemMgr vimgr = new VchrItemMgr(tran_id);
        String vchrIds = new RangeMaker().makeRange(templates, "getId");
        ArrayList<VchrItem> items = vimgr.retrieveList("vchrId in (" + vchrIds + ")", "");
        Map<Integer, Vector<VchrItem>> templateitemMap = new SortingMap(items).doSort("getVchrId");

        // 這兩個就是整理出來的跟這些薪資有關的 chargeitemmembr 和 discount
        Map<String, Vector<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSort("getTicketId");

        // 抓進這些 salaries 的 threads and voucher and items
        String threadIds = new RangeMaker().makeRange(salaries, "getThreadId");
        ArrayList<VchrThread> threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> threadMap = new SortingMap(threads).doSortSingleton("getId");
        ArrayList<VchrItem> vchritems = vimgr.retrieveList("threadId in (" + threadIds + ")", "");
        Map<Integer, ArrayList<VchrItem>> threaditemMap = new SortingMap(vchritems).doSortA("getThreadId");
        Map<Integer, ArrayList<VchrItem>> vchritemMap = new SortingMap(vchritems).doSortA("getVchrId");

        // 一張一張來
        double total1 = 0;
        double total2 = 0;
        for (int i=0; i<salaries.size(); i++) {
            MembrInfoBillRecord salary = salaries.get(i);
            ArrayList<VchrItem> reverse_items = getReverseItems(getDirectItems(salary.getThreadId(), threaditemMap));
            ArrayList<VchrItem> current_items = getSalaryCurrentItems(salary, chargeMap,  
                bitemvchrMap, salary_default, templateitemMap);
            phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>(reverse_items);
            all_items.concate(current_items);
            ArrayList<VchrItem> merged_items = mergeItems(all_items);
            if (merged_items.size()>0) {
                makeBillVoucher(salary, threadMap, vchritemMap, merged_items, userId, reason, Bill.TYPE_SALARY);
            }
        }
    }

    public void updateSalaryCharge(Charge charge, int userId, String reason)
        throws Exception
    {
        ArrayList<Charge> tmp = new ArrayList<Charge>();
        tmp.add(charge);
        updateSalaryCharges(tmp, userId, reason);
    }

    public void updateSalaryCharges(ArrayList<Charge> modified_charges, int userId, String reason)
        throws Exception
    {
        String chargeItemIds = new RangeMaker().makeRange(modified_charges, "getChargeItemId");
        ArrayList<ChargeItem> chargeitems = new ChargeItemMgr(tran_id).retrieveList("id in (" + chargeItemIds + ")", "");
        String billRecordIds = new RangeMaker().makeRange(chargeitems, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(modified_charges, "getMembrId");
        ArrayList<MembrInfoBillRecord> salaries = new MembrInfoBillRecordMgr(tran_id).
            retrieveList("membrId in (" + membrIds + ") and billRecordId in (" + billRecordIds + ")", "");
        genVoucherForSalaries(salaries, userId, reason);
    }

    public void updateSalaryChargeItemMembr(ChargeItemMembr charge, int userId, String reason)
        throws Exception
    {
        ArrayList<ChargeItemMembr> tmp = new ArrayList<ChargeItemMembr>();
        tmp.add(charge);
        updateSalaryChargeItemMembrs(tmp, userId, reason);
    }

    public void updateSalaryChargeItemMembrs(ArrayList<ChargeItemMembr> modified_charges, int userId, String reason)
        throws Exception
    {
        String billRecordIds = new RangeMaker().makeRange(modified_charges, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(modified_charges, "getMembrId");
        ArrayList<MembrInfoBillRecord> salaries = new MembrInfoBillRecordMgr(tran_id).
            retrieveList("membrId in (" + membrIds + ") and billRecordId in (" + billRecordIds + ")", "");
        genVoucherForSalaries(salaries, userId, reason);
    }

    public void genVoucherForSalaryPay(BillPay billpay, int userId, String reason)
        throws Exception
    {
        ArrayList<BillPay> billpays = new ArrayList<BillPay>();
        billpays.add(billpay);
        genVoucherForSalaryPays(billpays, userId, reason);
    }

    public void genVoucherForSalaryPays(ArrayList<BillPay> billpays, int userId, String reason)
        throws Exception
    {
        String billpayIds = new RangeMaker().makeRange(billpays, "getId");
        ArrayList<BillPaid> pay_paids = new BillPaidMgr(tran_id).retrieveList("billpayId in (" + billpayIds + ")", "");
        String ticketIds = new RangeMaker().makeRange(pay_paids, "getTicketIdAsString");
        ArrayList<MembrInfoBillRecord> salaries = new MembrInfoBillRecordMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")", "");

        // 先確定這些薪資單有傳票了
        genVoucherForSalaries(salaries, userId, "");

        Map<Integer, Vector<BillPaid>> paidMap = new SortingMap(pay_paids).doSort("getBillPayId");
        ArrayList<BillPaid> bill_paids = new BillPaidMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")", "");
        Map<String, ArrayList<BillPaid>> ticketpaidMap = new SortingMap(bill_paids).doSortA("getTicketId");
        
        // 抓進這些 bill 的 threads and items
        String threadIds = new RangeMaker().makeRange(salaries, "getThreadId");
        ArrayList<VchrThread> threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> billthreadMap = new SortingMap(threads).doSortSingleton("getId");
        Map<Integer, ArrayList<VchrItem>> billthreaditemMap = new SortingMap(vimgr.
            retrieveList("threadId in (" + threadIds + ")", "")).doSortA("getThreadId");
        Map<String, MembrInfoBillRecord> salaryMap = new SortingMap(salaries).doSortSingleton("getTicketId");

        // 抓進這些 billpay 的 threads and voucher and items
        threadIds = new RangeMaker().makeRange(billpays, "getThreadId");
        threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> bpaythreadMap = new SortingMap(threads).doSortSingleton("getId");
        Map<Integer, ArrayList<VchrItem>> bpaythreaditemMap = new SortingMap(vimgr.
            retrieveList("threadId in (" + threadIds + ")", "")).doSortA("getThreadId");

        // 抓進這些 billpaid 的 threads and voucher and items
        phm.util.PArrayList<BillPaid> all_paids = new phm.util.PArrayList<BillPaid>(pay_paids);
        all_paids.concate(bill_paids);
        threadIds = new RangeMaker().makeRange(all_paids, "getThreadId");
        threads = vtmgr.retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> bpaidthreadMap = new SortingMap(threads).doSortSingleton("getId");
        Map<Integer, ArrayList<VchrItem>> bpaidthreaditemMap = new SortingMap(vimgr.
            retrieveList("threadId in (" + threadIds + ")", "")).doSortA("getThreadId");

        // 抓進 billpay 相關的 costpay
        ArrayList<Costpay2> costpays = new Costpay2Mgr(tran_id).retrieveList("costpayFeePayFeeID=" + 
            Costpay2.COSPAY_TYPE_SALARY + " and costpayStudentAccountId in (" + billpayIds + ")", "");
        Map<Integer, Costpay2> costpayMap = new SortingMap(costpays).doSortSingleton("getCostpayStudentAccountId");

        // membrMap
        String membrIds = new RangeMaker().makeRange(salaries, "getMembrId");
        Map<Integer,Membr> membrMap = new SortingMap(MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "")).
            doSortSingleton("getId");

        for (int i=0; i<billpays.size(); i++) {
            BillPay bpay = billpays.get(i);
            ArrayList<VchrItem> reverse_items = getReverseItems(getDirectItems(bpay.getThreadId(), bpaythreaditemMap));
            ArrayList<VchrItem> current_items = getSalaryBillPayCurrentItems(bpay, paidMap, salaryMap, costpayMap);

            // 產生 billpay 的 vouchr
            phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>(reverse_items);
            all_items.concate(current_items);
            ArrayList<VchrItem> merged_items = mergeItems(all_items);
            if (merged_items.size()>0) {
                makeBillPayVoucher(bpay, bpaythreadMap, merged_items, userId, VchrThread.SRC_TYPE_SALARYPAY, reason, null);
            }  

            // for each paid salary, 產生對應的 voucher
            // 計算貸方
            Vector<BillPaid> vpaids = paidMap.get(new Integer(bpay.getId()));

            for (int j=0; vpaids!=null&&j<vpaids.size(); j++) {
                BillPaid p = vpaids.get(j);
                MembrInfoBillRecord b = salaryMap.get(p.getTicketId());
                if (b==null || b.getThreadId()==0) // 如果 bill 沒有傳票就沒有產生銷帳傳票的必要
                    continue;
                reverse_items = getReverseItems(getDirectItems(p.getThreadId(), bpaidthreaditemMap));
                ArrayList<VchrItem> paid_items = getSalaryPaidCurrentItems(p, b, billthreaditemMap, ticketpaidMap, bpaidthreaditemMap);
                all_items = new phm.util.PArrayList<VchrItem>(reverse_items);
                all_items.concate(paid_items);
                merged_items = mergeItems(all_items);
                if (merged_items.size()==0)
                    continue;
                Membr m = membrMap.get(b.getMembrId());
                makeBillPaidVoucher(p, b, bpaidthreadMap, merged_items, userId, VchrThread.SRC_TYPE_SALARYPAID, reason, m);
                bpaidthreaditemMap.put(p.getThreadId(), merged_items);
            }
        }
    }

    public ArrayList<VchrItem> getVitemCurrentItems(Vitem vvi, VchrThread thread)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        if (vvi.getType()==Vitem.TYPE_SPENDING || vvi.getType()==Vitem.TYPE_COST_OF_GOODS) {
            // 借方
            VchrItem vi = new VchrItem();
            Acode a = getAcodeFromAcctcode(vvi.getAcctcode());
            if (a==null) {
                a = _get_acode(COST_OF_GOODS); // 有可能會計科目亂填。。用個科目糖塞
            }
            vi.setFlag(VchrItem.FLAG_DEBIT);
            vi.setDebit((double)vvi.getTotal());
            vi.setAcodeId(a.getId());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);

            // 貸方
            vi = new VchrItem();
            Acode b = getVenderAcode(OTHER_EXPENSE_PAYABLE, vvi.getCostTradeId());
            vi.setFlag(VchrItem.FLAG_CREDIT);
            vi.setCredit((double)vvi.getTotal());
            vi.setAcodeId(b.getId());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);
        }
        else if (vvi.getType()==Vitem.TYPE_INCOME) {
            // 借方
            VchrItem vi = new VchrItem();
            Acode b = getVenderAcode(OTHER_ACCOUNT_RECEIVABLE, vvi.getCostTradeId());
            vi.setFlag(VchrItem.FLAG_DEBIT);
            vi.setDebit(vvi.getTotal());
            vi.setAcodeId(b.getId());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);

            // 貸方
            vi = new VchrItem();
            Acode a = getAcodeFromAcctcode(vvi.getAcctcode());
            if (a==null) {
                a = _get_acode(COST_OF_GOODS); // 有可能會計科目亂填。。用個科目糖塞
            }
            vi.setFlag(VchrItem.FLAG_CREDIT);
            vi.setCredit(vvi.getTotal());
            vi.setAcodeId(a.getId());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);
        }
        return ret;
    }

    public void genVoucherForVitem(Vitem vvi, int userId, String reason)
        throws Exception
    {
        VitemMgr vvimgr = new VitemMgr(tran_id);
        VchrThread thread = vtmgr.find("id=" + vvi.getThreadId());
        phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>();
        if (thread!=null) {
            ArrayList<VchrItem> vitems = vimgr.retrieveList("threadId=" + thread.getId(), "");
            ArrayList<VchrItem> reverse_items = getReverseItems(vitems);
            all_items.concate(reverse_items);
        }
        ArrayList<VchrItem> current_items = getVitemCurrentItems(vvi, thread);
        all_items.concate(current_items);        
        ArrayList<VchrItem> merged_items = mergeItems(all_items);
        if (merged_items.size()>0) {

            String str = vvi.getTitle() + " " + reason;
            if (thread==null) {
                thread = new VchrThread();
                int srcType = (vvi.getType()==Vitem.TYPE_INCOME)?VchrThread.SRC_TYPE_INCOME
                              :(vvi.getType()==Vitem.TYPE_SPENDING)?VchrThread.SRC_TYPE_SPENDING
                              :VchrThread.SRC_TYPE_BUYGOODS;
                thread.setSrcType(srcType);
                thread.setSrcInfo(vvi.getId()+"");
                vtmgr.create(thread);
                vvi.setThreadId(thread.getId());
                vvimgr.save(vvi);
            }
            
            Date registerDate = vvi.getRecordTime();

            VchrHolder v = new VchrHolder();
            v.setSerial(getSerialNo("_s", registerDate));
            Date create_date = new Date();
            v.setCreated(create_date);
            v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
            v.setUserId(userId);
            v.setType(VchrHolder.TYPE_INSTANCE);
            int noteId = (int) LiteralStore.create(store, str);
            v.setNote(noteId);
            v.setThreadId(thread.getId());
            v.setBuId(vvi.getBunitId());
            vhmgr.create(v);

            for (int i=0; i<merged_items.size(); i++) {
                VchrItem vi = merged_items.get(i);
                addItem(i, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), thread.getId(), vi.getDebit(), vi.getCredit(), noteId);
            }
        }
    }

    int getSrcType(Costpay2 costpay)
    {
        int tp = costpay.getCostpayFeePayFeeID();
        return (tp==Costpay2.COSPAY_TYPE_SPENDING)?VchrThread.SRC_TYPE_SPENDING:
                        (tp==Costpay2.COSPAY_TYPE_INCOME)?VchrThread.SRC_TYPE_INCOME:
                          VchrThread.SRC_TYPE_BUYGOODS;
    }

    public ArrayList<VchrItem> getVitemPayCurrentItems(Costpay2 cpay, VchrThread thread)
        throws Exception
    {
        ArrayList<VchrItem> ret = new  ArrayList<VchrItem>();
        ArrayList<VPaid> paids = new VPaidMgr(tran_id).retrieveList("costpayId=" + cpay.getId(), "");
        String vitemIds = new RangeMaker().makeRange(paids, "getVitemId");

        // 找到這個 cpay 付的 vitems
        ArrayList<Vitem> vitems = new VitemMgr(tran_id).retrieveList("id in (" + vitemIds + ")", "");
        String threadIds = new RangeMaker().makeRange(vitems, "getThreadId");
        PArrayList<VchrItem> vchritems = new PArrayList<VchrItem>(vimgr.retrieveList("threadId in (" + threadIds + ")", ""));

        // 這些 vitems 之前付過的記錄也要算進來
        ArrayList<VPaid> prev_paids = new VPaidMgr(tran_id).retrieveList("vitemId in (" + vitemIds + ")", "");
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<prev_paids.size(); i++) {
            if (prev_paids.get(i).getBunitId()!=cpay.getBunitId())
                throw new Exception("跨單位雜費收付款尚未完成，請洽必亨");
            if (prev_paids.get(i).getCostpayId()==cpay.getId())
                continue;
            if (sb.length()>0)
                sb.append(",");
            sb.append(prev_paids.get(i).getCostpayId());
        }
        if (sb.length()>0) { 
            ArrayList<Costpay2> other_costpays = new Costpay2Mgr(tran_id).retrieveList("id in (" + sb.toString() + ")", "");
            threadIds = new RangeMaker().makeRange(other_costpays, "getThreadId");
            ArrayList<VchrItem> tmp = vimgr.retrieveList("threadId in (" + threadIds + ")", "");
            vchritems.concate(tmp); 
        }

        // 先自己借貸銷一遍, 再來看剩余的有沒有需要銷的, use mergeItemsRegardlessThread 因為這些來自不同的 thread
        ArrayList<VchrItem> merged_items = mergeItemsRegardlessThread(vchritems); 
        Map<Integer, ArrayList<VchrItem>> flagvchritemsMap = new SortingMap(merged_items).doSortA("getFlag");
        if (cpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_SPENDING ||
            cpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_COST_OF_GOODS) 
        {
            // 借方, 要沖應付的貸項
            ArrayList<VchrItem> credit_items = flagvchritemsMap.get(VchrItem.FLAG_CREDIT);
            double amount = (double) cpay.getCostpayCostNumber();
            for (int i=0; credit_items!=null&&i<credit_items.size() && amount>0; i++) {
                VchrItem vi = credit_items.get(i).clone();
                double credit = vi.getCredit();
                double thisamount = Math.min(amount, credit);
                vi.setFlag(VchrItem.FLAG_DEBIT);
                vi.setCredit(0);
                vi.setDebit(thisamount);
                vi.setThreadId((thread!=null)?thread.getId():0);
                amount -= thisamount;
                ret.add(vi);
            }
            if (amount!=0)
                throw new Exception("付款沒沖完應付");

            // 貸方
            Acode a = null;
            if (cpay.getCostpayAccountType()!=3)
                a = getCashAcode(cpay.getCostpayAccountType(), cpay.getCostpayAccountId());
            else
                a = getChequeReceivableAcode();
            VchrItem vi = new VchrItem();
            vi.setFlag(VchrItem.FLAG_CREDIT);
            vi.setAcodeId(a.getId());
            vi.setCredit((double) cpay.getCostpayCostNumber());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);
        }
        else if (cpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_INCOME) {
            // 貸方, 要沖應收的借項
            ArrayList<VchrItem> debit_items = flagvchritemsMap.get(VchrItem.FLAG_DEBIT);
            double amount = (double) cpay.getCostpayIncomeNumber();
            for (int i=0; debit_items!=null && i<debit_items.size() && amount>0; i++) {
                VchrItem vi = debit_items.get(i).clone();
                double debit = vi.getDebit();
                double thisamount = Math.min(amount, debit);
                vi.setFlag(VchrItem.FLAG_CREDIT);
                vi.setDebit(0);
                vi.setCredit(thisamount);
                vi.setThreadId((thread!=null)?thread.getId():0);
                amount -= thisamount;
                ret.add(vi);
            }
            if (amount!=0)
                throw new Exception("收款沒沖完應收");

            // 借方
            Acode a = null;
            if (cpay.getCostpayAccountType()!=3)
                a = getCashAcode(cpay.getCostpayAccountType(), cpay.getCostpayAccountId());
            else
                a = getChequeReceivableAcode();
            VchrItem vi = new VchrItem();
            vi.setFlag(VchrItem.FLAG_DEBIT);
            vi.setAcodeId(a.getId());
            vi.setDebit((double) cpay.getCostpayIncomeNumber());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);
        }
        return ret;
    }

    public void genVoucherForVitemPay(Costpay2 costpay, int userId, String reason)
        throws Exception
    {
        // 先確定 Vitem 的傳票在
        ArrayList<VPaid> vpaids = new VPaidMgr(tran_id).retrieveList("costpayId=" + costpay.getId(), "");
        String vitemIds = new RangeMaker().makeRange(vpaids, "getVitemId");
        ArrayList<Vitem> items = new VitemMgr(tran_id).retrieveList("id in (" + vitemIds + ")", "");
        for (int i=0; i<items.size(); i++) {
            if (items.get(i).getThreadId()==0)
                genVoucherForVitem(items.get(i), userId, "");
        }
        
        VchrThread thread = vtmgr.find("id=" + costpay.getThreadId());
        phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>();
        if (thread!=null) {
            ArrayList<VchrItem> vitems = vimgr.retrieveList("threadId=" + thread.getId(), "");
            ArrayList<VchrItem> reverse_items = getReverseItems(vitems);
            all_items.concate(reverse_items);
        }
        ArrayList<VchrItem> current_items = getVitemPayCurrentItems(costpay, thread);
        all_items.concate(current_items);

        ArrayList<VchrItem> merged_items = mergeItems(all_items);

        if (merged_items.size()>0) {

            if (thread==null) {
                thread = new VchrThread();
                thread.setSrcType(getSrcType(costpay));
                thread.setSrcInfo(costpay.getId()+"");
                vtmgr.create(thread);
                costpay.setThreadId(thread.getId());
                new Costpay2Mgr(tran_id).save(costpay);
            }
            
            Date registerDate = costpay.getCostpayLogDate();

            int noteId = 0;
            if (reason!=null)
                noteId = (int) LiteralStore.create(store, reason);

            VchrHolder v = new VchrHolder();
            v.setSerial(getSerialNo("_v", registerDate));
            Date create_date = new Date();
            v.setCreated(create_date);
            v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
            v.setUserId(userId);
            v.setType(VchrHolder.TYPE_INSTANCE);
            v.setThreadId(thread.getId());
            v.setNote(noteId);
            v.setBuId(costpay.getBunitId());
            vhmgr.create(v);

            for (int i=0; i<merged_items.size(); i++) {
                VchrItem vi = merged_items.get(i);
                addItem(i, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), thread.getId(), vi.getDebit(), vi.getCredit(), noteId);
            }
        }
    }

    public ArrayList<VchrItem> getChequeCurrentItems(Cheque chk, VchrThread thread)
        throws Exception
    {
        ArrayList<VchrItem> ret = new ArrayList<VchrItem>();
        // 如果是尚未兌現, 就沒有任何 items
        if (chk.getCashed()==null)
            return ret;
        // 如果兌現, 就看兌現到哪
        Costpay2 cp = new Costpay2Mgr(tran_id).find("id=" + chk.getCostpayId());
        Acode cash = getCashAcode(cp.getCostpayAccountType(), cp.getCostpayAccountId());
        if (cp.getCostpayNumberInOut()==0) { // income
            // 借 現金
            VchrItem vi = new VchrItem();
            vi.setFlag(VchrItem.FLAG_DEBIT);
            vi.setAcodeId(cash.getId());
            vi.setDebit((double) chk.getInAmount());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);

            // 貸 應收票據
            vi = new VchrItem();
            Acode a = getChequeReceivableAcode();
            vi.setFlag(VchrItem.FLAG_CREDIT);
            vi.setAcodeId(a.getId());
            vi.setCredit((double) chk.getInAmount());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);
        }
        else {  // 付款
            // 貸 現金
            VchrItem vi = new VchrItem();
            vi.setFlag(VchrItem.FLAG_CREDIT);
            vi.setAcodeId(cash.getId());
            vi.setCredit((double) chk.getOutAmount());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);

            // 借 應收票據
            vi = new VchrItem();
            Acode a = getChequePayableAcode();
            vi.setFlag(VchrItem.FLAG_DEBIT);
            vi.setAcodeId(a.getId());
            vi.setDebit((double) chk.getOutAmount());
            vi.setThreadId((thread!=null)?thread.getId():0);
            ret.add(vi);
        }
        return ret;
    }

    public void genVoucherForCheque(Cheque chk, int userId, String reason)
        throws Exception
    {
        VchrThread thread = vtmgr.find("id=" + chk.getThreadId());
        phm.util.PArrayList<VchrItem> all_items = new phm.util.PArrayList<VchrItem>();
        if (thread!=null) {
            ArrayList<VchrItem> vitems = vimgr.retrieveList("threadId=" + thread.getId(), "");
            ArrayList<VchrItem> reverse_items = getReverseItems(vitems);
            all_items.concate(reverse_items);
        }
        ArrayList<VchrItem> current_items = getChequeCurrentItems(chk, thread);
        all_items.concate(current_items);
        ArrayList<VchrItem> merged_items = mergeItems(all_items);
        if (merged_items.size()>0) {

            if (thread==null) {
                thread = new VchrThread();
                int srcType = (chk.getType()==Cheque.TYPE_INCOME_TUITION || chk.getType()==Cheque.TYPE_SPENDING_INCOME)?
                                VchrThread.SRC_TYPE_CHEQUE_CASHIN:
                                VchrThread.SRC_TYPE_CHEQUE_CASHOUT;
                thread.setSrcType(srcType);
                thread.setSrcInfo(chk.getId()+"");
                vtmgr.create(thread);
                chk.setThreadId(thread.getId());
                new ChequeMgr(tran_id).save(chk);
            }
            
            int noteId = 0;
            if (reason!=null)
                noteId = (int) LiteralStore.create(store, reason);

            /* for a 支票, cashDate 是兌現日, cashed 是真的兌現那一天, 也就是可能是現在
               入帳時間：          
            */
            Date registerDate = chk.getCashDate();

            Date create_date = new Date();
            VchrHolder v = new VchrHolder();
            v.setSerial(getSerialNo("_c", registerDate));
            v.setCreated(create_date);
            v.setRegisterDateCheck(registerDate, bh.getSpace("bunitId", bunitId));
            v.setUserId(userId);
            v.setType(VchrHolder.TYPE_INSTANCE);
            v.setThreadId(thread.getId());
            v.setNote(noteId);
            v.setBuId(chk.getBunitId());
            vhmgr.create(v);

            for (int i=0; i<merged_items.size(); i++) {
                VchrItem vi = merged_items.get(i);
                addItem(i, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), thread.getId(), vi.getDebit(), vi.getCredit(), noteId);
            }
        }
    }
}
