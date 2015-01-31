package phm.ezcounting;

import dbo.*;
import jsf.*;
import java.util.*;
import java.text.*;
import java.io.*;
import java.lang.reflect.*;
import mca.*;

public class EzCountingService
{
    private static EzCountingService instance;
    private boolean modify_alert = true;
    
    public void setModifyAlert(boolean do_alert)
    {
        this.modify_alert = do_alert;
    }

    EzCountingService() {}
    
    public synchronized static EzCountingService getInstance()
    {			
        if (instance==null)
        {
            instance = new EzCountingService();
        }
        return instance;
    }
    
    public boolean isFreezed(Date d, String space)
        throws Exception
    {
        Date freezeNextDay = getFreezeNextDay(space);
        if (freezeNextDay==null)
            return false;
        if (d.compareTo(freezeNextDay)<0)
            return true;
        return false;
    }

    private static SimpleDateFormat _sdffz = new SimpleDateFormat("yyyy-MM-dd");

    public static Freeze getFreeze(String space)
    {
        ArrayList<Freeze> fs = FreezeMgr.getInstance().retrieveListX("", "order by created desc limit 1", space);
        if (fs.size()==0)
            return null;
        return fs.get(0);
    }

    public static Date getFreezeNextDay(String space)
        throws Exception
    {
        ArrayList<Freeze> fs = FreezeMgr.getInstance().retrieveListX("", "order by created desc limit 1", space);
        if (fs.size()==0)
            return null;
        Calendar c = Calendar.getInstance();
        c.setTime(fs.get(0).getFreezeTime());
        c.add(Calendar.DATE, 1);
        return _sdffz.parse(_sdffz.format(c.getTime()));
    }

    public ChargeItem makeChargeItem(int tran_id, int billRecordId, int billItemId)
        throws Exception
    {
        ChargeItemMgr cimgr = (tran_id>0)?new ChargeItemMgr(tran_id):ChargeItemMgr.getInstance();
        BillItemMgr bimgr = (tran_id>0)?new BillItemMgr(tran_id):BillItemMgr.getInstance();
        BillItem bi = bimgr.find("id=" + billItemId);
        ChargeItem ci = new ChargeItem();
        ci.setBillRecordId(billRecordId);
        ci.setBillItemId(billItemId);
        ci.setSmallItemId(bi.getSmallItemId());
        ci.setChargeAmount(bi.getDefaultAmount());
        cimgr.create(ci);
        return ci;
    }

    public BillItem createBillItem(int tran_id, Bill b, String name, int smallitem, 
        String description, int defaultAmount)
        throws Exception
    {
        BillItem item = new BillItem();
        item.setBillId(b.getId());
        item.setName(name);
        item.setStatus(1);
        item.setDescription(description);
        item.setSmallItemId(smallitem);
        item.setDefaultAmount(defaultAmount);
        new BillItemMgr(tran_id).create(item);
        return item;
    }

    public BillRecord createBillRecord(int tran_id, Bill b, String name, 
        java.util.Date month, java.util.Date billDate, BillRecord copyfrom, int userId)
        throws Exception
    {
        BillRecordMgr brmgr = new BillRecordMgr(tran_id);
        BillRecord r = new BillRecord();
        r.setBillId(b.getId());
        r.setName(name);
        r.setMonth(month);
        r.setBillDate(billDate);
        brmgr.create(r);
        if (copyfrom!=null) {
            if (copyfrom.getBillId()!=b.getId())
                throw new Exception("不是同一種類型的帳單");
            if (b.getBillType()==Bill.TYPE_BILLING) {
                copyBillRecordV2(tran_id, r, copyfrom, userId, b.getBunitId());
            }
            else if (b.getBillType()==Bill.TYPE_SALARY)
                copyBillRecord(tran_id, r, copyfrom, userId);
        }
        return r;
    }

    private Map<Integer, ChargeItem> copyv2_getChargeItems(int tran_id, BillRecord newbr, 
        ArrayList<ChargeItem> o_citems, Map<Integer, BillItem> billitemMap)
        throws Exception
    {
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        Map<Integer, ChargeItem> ret = new HashMap<Integer, ChargeItem>();
        for (int i=0; i<o_citems.size(); i++) {
            ChargeItem o_ci = o_citems.get(i);
            BillItem bi = billitemMap.get(o_ci.getBillItemId());
            if (bi.getCopyStatus()==BillItem.COPY_NO)
                continue; // 不用延續的就不理
            ChargeItem n_ci = new ChargeItem();
            n_ci.setBillItemId(bi.getId());
            n_ci.setBillRecordId(newbr.getId());
            n_ci.setSmallItemId(o_ci.getSmallItemId());
            n_ci.setChargeAmount(o_ci.getChargeAmount());
            cimgr.create(n_ci);
            ret.put(o_ci.getId(), n_ci);
        }
        return ret;
    }

    private ArrayList<Membr> copyv2_getMembrs(int tran_id, ChargeItem o_ci, ChargeItem n_ci, BillRecord newbr,
        Map<Integer, Tag> allTagMap, Map<Integer, ArrayList<ChargeItem>> tagitemMap,
        Map<Integer, BillRecord> billrecordMap, int bunitId)
        throws Exception
    {
        boolean connectingTag = new CitemTagMgr(tran_id).numOfRows("chargeItemId=" + o_ci.getId())>0;
        String membrIds = null;

        if (!connectingTag) {
            ArrayList<Charge> charges = new ChargeMgr(tran_id).retrieveList("chargeItemId=" + o_ci.getId(), "");
            membrIds = new RangeMaker().makeRange(charges, "getMembrId");
        } 
        else { // 有對應 tags
            jsf.PaySystem ps = (jsf.PaySystem)jsf.PaySystemMgr.getInstance().find(1);
            BunitHelper bh = new BunitHelper(tran_id);
            TagHelper th = TagHelper.getInstance(ps, tran_id, bh.getStudentBunitId(bunitId));
            membrIds = th.fixNewChargeMembrIds(tran_id, o_ci, n_ci, newbr, allTagMap, tagitemMap, billrecordMap);
        }
        return new MembrMgr(tran_id).retrieveList("id in (" + membrIds + ")", "");
    }

    protected Map<String, ArrayList<Discount>> getDiscountMap(int tran_id, ArrayList<ChargeItem> citems)
        throws Exception
    {
        String ChargeItemIds = new RangeMaker().makeRange(citems, "getId");
        return new SortingMap(new DiscountMgr(tran_id).retrieveList("chargeItemId in (" + 
                ChargeItemIds + ")", "")).doSortA("getChargeKey");
    }

    protected Map<String, Charge> getChargeMap(int tran_id, ArrayList<ChargeItem> citems)
        throws Exception
    {
        String ChargeItemIds = new RangeMaker().makeRange(citems, "getId");
        return new SortingMap(new ChargeMgr(tran_id).retrieveList("chargeItemId in (" + 
                ChargeItemIds + ")", "")).doSortSingleton("getChargeKey");
    }

    protected Map<String, ArrayList<FeeDetail>> getFeeDetailMap(int tran_id, ArrayList<ChargeItem> citems)
        throws Exception
    {
        String ChargeItemIds = new RangeMaker().makeRange(citems, "getId");
        return new SortingMap(new FeeDetailMgr(tran_id).retrieveList("chargeItemId in (" + 
                ChargeItemIds + ")", "")).doSortA("getChargeKey");
    }

    private Map<Integer, ArrayList<ChargeItem>> getTagItemMap(int tran_id)
        throws Exception
    {
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        ArrayList<CitemTag> cts = ctmgr.retrieveList("", "");
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        Map<Integer, ChargeItem> citemMap = new SortingMap(cimgr.retrieveList("", "")).doSortSingleton("getId");
        Map<Integer, ArrayList<ChargeItem>> ret = new HashMap<Integer, ArrayList<ChargeItem>>();
        Map<Integer, ArrayList<CitemTag>> tagcitemMap = new SortingMap(cts).doSortA("getTagId");
        Iterator<Integer> iter = tagcitemMap.keySet().iterator();
        while (iter.hasNext()) {
            Integer tagId = iter.next();
            cts = tagcitemMap.get(tagId);
            ArrayList<ChargeItem> citems = new ArrayList<ChargeItem>();
            for (int i=0; i<cts.size(); i++) {
                ChargeItem ci = citemMap.get(cts.get(i).getChargeItemId());
                citems.add(ci);
            }
            ret.put(tagId, citems);
        }
    
        return ret;
    }

    protected void copyBillRecordV2(int tran_id, BillRecord newr, BillRecord orgr, int userId, int bunitId)
        throws Exception
    {
        Map<Integer, BillItem> billitemMap = new SortingMap(new BillItemMgr(tran_id).retrieveList("", "")).doSortSingleton("getId");
        // 原有的 chargeitems
        ArrayList<ChargeItem> o_citems = new ChargeItemMgr(tran_id).retrieveList("billRecordId=" + orgr.getId(), "");
        // 產生新的 chargeitems
        Map<Integer, ChargeItem> n_citemsMap = copyv2_getChargeItems(tran_id, newr, o_citems, billitemMap);
        // 抓回上期帳單相關的資料
        Map<String, ArrayList<Discount>> discountMap = getDiscountMap(tran_id, o_citems);
        Map<String, Charge> chargeMap = getChargeMap(tran_id, o_citems);
        Map<String, ArrayList<FeeDetail>> feedetailMap = getFeeDetailMap(tran_id, o_citems);
        Map<Integer, Tag> allTagMap = new SortingMap(new TagMgr(tran_id).retrieveList("", "")).doSortSingleton("getId");        
        Map<Integer, BillRecord> billrecordMap = new SortingMap(new BillRecordMgr(tran_id).retrieveList("", "")).doSortSingleton("getId");
        Map<Integer, ArrayList<ChargeItem>> tagitemMap = getTagItemMap(tran_id);    

        MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        for (int i=0; i<o_citems.size(); i++) {
            ChargeItem o_ci = o_citems.get(i);
            BillItem bi = billitemMap.get(o_ci.getBillItemId());
            if (bi.getCopyStatus()==BillItem.COPY_NO)
                continue;
            ChargeItem n_ci = n_citemsMap.get(o_ci.getId());
            // ####### 下面這一行是 copy 的 key， 找回這一次可能不同的 membrs (如果有標籤連結的話) #######
            ArrayList<Membr> n_membrs = copyv2_getMembrs(tran_id, o_ci, n_ci, newr, allTagMap, tagitemMap, billrecordMap, bunitId); 
            for (int j=0; j<n_membrs.size(); j++) {
                // ### create charge
                int membrId = n_membrs.get(j).getId();
                Charge orgc = chargeMap.get(membrId + "#" + o_ci.getId());                    
                Charge c = new Charge();
                c.setChargeItemId(n_ci.getId());
                c.setMembrId(membrId);
                if (orgc!=null) { // 有可能這個人是新加入 tag 上期沒有 charge, 如果沒有就用 default 的
                    c.setAmount(orgc.getAmount());
                    c.setNote(orgc.getNote());
                }
                c.setUserId(userId);
                cmgr.create(c);

                // ### create feedetails
                ArrayList<FeeDetail> fds = feedetailMap.get(membrId+"#"+o_ci.getId());
                if (fds!=null) {
                    for (int k=0; k<fds.size(); k++) {
                        FeeDetail newfd = fds.get(k).clone();
                        newfd.setUserId(userId);
                        newfd.setChargeItemId(n_ci.getId());
                        fdmgr.create(newfd);
                    }
                }
                // ## copy discount
                ArrayList<Discount> discountv = discountMap.get(membrId+"#"+o_ci.getId());
                for (int k=0; discountv!=null&&k<discountv.size(); k++) {
                    Discount orgd = discountv.get(k);
                    if (orgd.getCopy()==Discount.COPY_NO)
                        continue;
                    Discount d = new Discount();
                    d.setChargeItemId(n_ci.getId());
                    d.setMembrId(membrId);
                    d.setAmount(orgd.getAmount());
                    d.setNote(orgd.getNote());
                    d.setType(orgd.getType());
                    d.setUserId(userId);
                    dmgr.create(d);
                }
            }
        }
        // 全跑完一次 在用membr跑一編產生帳單
        ArrayList<ChargeItemMembr> n_items = new ChargeItemMembrMgr(tran_id).
            retrieveList("chargeitem.billRecordId=" + newr.getId(), "");
        String chargeItemIds = new RangeMaker().makeRange(n_items, "getChargeItemId");
        String membrIds = new RangeMaker().makeRange(n_items, "getMembrId");
        Map<Integer, ArrayList<ChargeItemMembr>> chargemembrMap = new SortingMap(n_items).doSortA("getMembrId");
        discountMap = new SortingMap(new DiscountMgr(tran_id).retrieveList("chargeItemId in (" + 
            chargeItemIds + ")","")).doSortA("getChargeKey");
        ArrayList<Membr> membrs = new MembrMgr(tran_id).retrieveList("id in (" + membrIds + ")", "");
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
        for (int i=0; i<membrs.size(); i++) {
            int membrId = membrs.get(i).getId();
            ArrayList<ChargeItemMembr> cmitems = chargemembrMap.get(membrId);
            int total = 0;
            for (int j=0; j<cmitems.size(); j++) {
                ChargeItemMembr cim = cmitems.get(j);
                total += cim.getMyAmount();
                ArrayList<Discount> da = discountMap.get(cim.getChargeKey());
                for (int k=0; da!=null&&k<da.size(); k++) {
                    total -= da.get(k).getAmount();
                }
            }
            MembrBillRecord newsbr = makeMembrBillRecord(sbrmgr, membrId, newr);
            newsbr.setReceivable(total);
            sbrmgr.save(newsbr);
        }
    }

    // ## 2009/2/11 by peter, 新標籤改變 copy 的方法，所以要重寫
    protected void copyBillRecord(int tran_id, BillRecord newr, BillRecord orgr, int userId)
        throws Exception
    {
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
        Iterator<MembrBillRecord> oldsbrs = sbrmgr.retrieveList
            ("billRecordId=" + orgr.getId(), "").iterator();

        // 先找舊 recored 的 billitem 出來，等下要檢查 copyStatus, 要 copy 才 copy
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        ArrayList<BillItem> billitems = bimgr.retrieveList("billId=" + orgr.getBillId(), "");
        Map<Integer/*billitemId*/, Vector<BillItem>> billitemMap = new SortingMap(billitems).doSort("getId");

        // 找舊 recored 的 chargeItem 出來
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ArrayList<ChargeItem> oldci = 
            cimgr.retrieveList("billRecordId=" + orgr.getId(), "");
        if (oldci.size()==0)
            return;

        // setup new chargeitems, make it ready (do it once)
        // use old chargeitem to build to chargeitem.
        Iterator<ChargeItem> old_ci_iter = oldci.iterator();
        // sb will contain all id for org chargeitem
        StringBuffer sb = new StringBuffer();
        // Integer: org chargeitem id
        // ChargeItem: new chargeitem
        Map<Integer,ChargeItem> chargeitemMap = new HashMap();
        while (old_ci_iter.hasNext()) {
            ChargeItem orgci = old_ci_iter.next();
            // 如果 copyStatus = COPY_NO 就跳過
            Vector<BillItem> bv = billitemMap.get(new Integer(orgci.getBillItemId()));
            if (bv.get(0).getCopyStatus()==BillItem.COPY_NO)
                continue;
            ChargeItem newci = cimgr.find("billItemId=" + orgci.getBillItemId() + 
                " and billRecordId=" + newr.getId());
            if (newci==null) {
                newci = new ChargeItem();
                newci.setBillItemId(orgci.getBillItemId());
                newci.setBillRecordId(newr.getId());
                newci.setSmallItemId(orgci.getSmallItemId());
                newci.setChargeAmount(orgci.getChargeAmount());
                cimgr.create(newci);
            }
            chargeitemMap.put(new Integer(orgci.getId()), newci); // use org chargeitem's id as key
            if (sb.length()>0) sb.append(",");
            sb.append(orgci.getId());
        }
        if (sb.length()==0)
            return;

        ChargeMgr cmgr = new ChargeMgr(tran_id);
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);

        // 這里的 sb 已經跳過了 COPY_NO 的 billitems
        ArrayList<Charge> all_old_charges = cmgr.retrieveList("chargeItemId in (" + sb.toString() + 
            ")", "");
        Map<Integer,Vector<Charge>> chargemap = new SortingMap(all_old_charges).doSort("getMembrId");
        ArrayList<Discount> all_old_discounts = dmgr.retrieveList("chargeItemId in (" + sb.toString() + 
            ") and (copy is NULL or copy=" + Discount.COPY_YES + ")", "");
        Map<String,Vector<Discount>> discountmap = new SortingMap(all_old_discounts).doSort("getChargeKey");
        ArrayList<FeeDetail> all_old_feedetails = fdmgr.retrieveList("chargeItemId in (" + sb.toString() + ")", "");
        Map<String,Vector<FeeDetail>> feedetailMap = new SortingMap(all_old_feedetails).doSort("getChargeKey");

        while (oldsbrs.hasNext()) {
            MembrBillRecord orgsbr = oldsbrs.next();
            if (chargemap.get(new Integer(orgsbr.getMembrId()))==null)
                continue; // 有可能該 user 所有的 billitem 都是 copy_no, 那在 chargemap 就不要過了
            __copy_each_membrbillrecord(tran_id, newr, orgsbr, chargeitemMap, chargemap, discountmap, feedetailMap, userId);
        }
    }

    private void __copy_each_membrbillrecord(int tran_id, BillRecord newr, MembrBillRecord orgsbr, 
            Map<Integer,ChargeItem> chargeitemMap, Map<Integer,Vector<Charge>> chargemap, 
            Map<String,Vector<Discount>> discountmap, 
            Map<String, Vector<FeeDetail>> feedetailMap,
            int userId)
        throws Exception
    {
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);

        int membrId = orgsbr.getMembrId();
        // 一個 billRecord+membrId 只會有一個一個帳單, 所以下面這個 call 就會只有這個 membr 在這張帳單的 charges
        Vector<Charge> chargev = chargemap.get(new Integer(membrId));
        int receivable = 0;
        boolean create_bill = false;
        for (int i=0; chargev!=null&&i<chargev.size(); i++) {
            Charge orgc = chargev.get(i);
            create_bill = true;
            Charge c = new Charge();
            ChargeItem newci = chargeitemMap.get(new Integer(orgc.getChargeItemId()));
            c.setChargeItemId(newci.getId());
            c.setMembrId(membrId);
            c.setAmount(orgc.getAmount());
            c.setNote(orgc.getNote());
            c.setUserId(userId);
            c.setTagId(orgc.getTagId());
            cmgr.create(c);
            receivable += ChargeItemMembr.getMyAmount(c,newci);

            // #### 2009/1/19 by peter, manhour obsolete, feedetail 還是要 copy
                    // 如果有 feedetail 就不 copy 了
                    // 因為日期已定不對，又如果是由 manhour 產生的就更麻煩了
            Vector<FeeDetail> fds = feedetailMap.get(orgc.getMembrId()+"#"+orgc.getChargeItemId());
            if (fds!=null) {
                for (int j=0; j<fds.size(); j++) {
                    FeeDetail newfd = fds.get(j).clone();
                    newfd.setUserId(userId);
                    newfd.setChargeItemId(newci.getId());
                    fdmgr.create(newfd);
                }
            }

            // copy discount
            Vector<Discount> discountv = discountmap.get(membrId+"#"+orgc.getChargeItemId());
            for (int j=0; discountv!=null&&j<discountv.size(); j++) {
                Discount orgd = discountv.get(j);
                if (orgd.getCopy()==Discount.COPY_NO)
                    continue;
                Discount d = new Discount();
                d.setChargeItemId(newci.getId());
                d.setMembrId(membrId);
                d.setAmount(orgd.getAmount());
                d.setNote(orgd.getNote());
                d.setType(orgd.getType());
                d.setUserId(userId);
                dmgr.create(d);
                receivable -= d.getAmount();
            }
        }   
        if (create_bill) {
            MembrBillRecord newsbr = makeMembrBillRecord(sbrmgr, orgsbr.getMembrId(), newr);
            newsbr.setReceivable(receivable);
            sbrmgr.save(newsbr);
        }
    }

    public Bill createBill(String name, String prettyName, int balanceWay, int bunitId) 
    {
        Bill b = new Bill();
        b.setName(name);
        b.setPrettyName(prettyName);
        b.setStatus(1);
        b.setBalanceWay(balanceWay);
        b.setBunitId(bunitId);
        BillMgr.getInstance().create(b);
        return b;
    }

    public void setupDiscount(int tran_id, ChargeItem citem, int discountType, int amount,
        String note, int copystatus, int[] membrIds, User user, Date nextFreezeDay)
        throws Exception
    {
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        int cid = citem.getId();
        int uid = user.getId();
        Discount d = new Discount();
        d.setChargeItemId(cid);
        d.setUserId(uid);
        d.setType(discountType);
        d.setNote(note);
        d.setAmount(amount);
        d.setCopy(copystatus);
        StringBuffer sb = new StringBuffer();
        int c = 0;
        for (int i=0; i<membrIds.length; i++) {
            if (dmgr.numOfRows("chargeItemId=" + cid + " and membrId=" + membrIds[i])>0)
                continue; // skip those already has discount
            d.setMembrId(membrIds[i]);
            dmgr.create(d);
            if (sb.length()>0)
                sb.append(",");
            sb.append(membrIds[i]);
            c ++;
        }
        if (c>0)
            __commit_membrbillrecord_ammount_change(tran_id, citem, sb, (0-amount), nextFreezeDay);
    }

    public void updateChargeAmountForAllMembrs(int tran_id, ChargeItem citem, int diffAmount, Date nextFreezeDay)
        throws Exception
    {
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        String q = "update chargeitem set chargeAmount=chargeAmount" + 
                        ((diffAmount<0)?"-":"+") + Math.abs(diffAmount) +
                        " where id=" + citem.getId();
        cimgr.executeSQL(q);
        citem.setChargeAmount(citem.getChargeAmount()+diffAmount);

        // find all membrs that has this charge
        ArrayList<ChargeMembr> membrs = ChargeMembrMgr.getInstance().
            retrieveList("chargeItemId=" + citem.getId(), "");
        if (membrs.size()==0)
            return;
        
        boolean a = true;
        if (a)
            throw new Exception("應該不能到這來");
        
        StringBuffer sb = new StringBuffer();
        Iterator<ChargeMembr> iter = membrs.iterator();
        for (ChargeMembr c=iter.next(); iter.hasNext(); c=iter.next())
        {
            if (sb.length()>0) sb.append(",");
            sb.append(c.getMembrId());
        }
        __commit_membrbillrecord_ammount_change(tran_id, citem, sb, diffAmount, nextFreezeDay);
    }

    // 要改 membrbillrecord 的金額一定要 call 這里
    // =============
    private void __commit_membrbillrecord_ammount_change
            (int tran_id, ChargeItem citem, StringBuffer membr_ids_sb, int diffAmount, Date nextFreezeDay)
        throws Exception
    {
        // 部分或付清的 membrbillrecord 不能改，UI 就要檔了，但這里最后防線也要擋

        long min5ago = new Date().getTime() - 60*5*1000;
        MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
        if (modify_alert && sbmgr.numOfRows("billrecordId=" + citem.getBillRecordId() +
                        " and membrId in (" + membr_ids_sb.toString() + ")" +
                        " and paidStatus in (1,2) and (forcemodify<" + min5ago + ")")>0) 
        {
                throw new Exception("部分或付清的帳單不能改");
        }

        if (modify_alert && sbmgr.numOfRows("billrecordId=" + citem.getBillRecordId() +
                        " and membrId in (" + membr_ids_sb.toString() + ")" +
                        " and printDate>0 and (forcemodify<" + min5ago + ")")>0)
        {
            throw new Locked();
        }

        // ## 2009/3/3 by peter 加關帳功能。。
        BillRecordMgr brmgr = new BillRecordMgr(tran_id);
        if (nextFreezeDay!=null) {
            if (brmgr.numOfRows("id=" + citem.getBillRecordId() + " and month<'" + _sdffz.format(nextFreezeDay) + "'")>0)
                throw new Exception("已關帳不可修改 [1]");
        }

        String q = "update membrbillrecord set receivable=receivable" + 
                        ((diffAmount<0)?"-":"+") + Math.abs(diffAmount) +
                        " where billrecordId=" + citem.getBillRecordId() +
                        " and membrId in (" + membr_ids_sb.toString() + ")";
        sbmgr.executeSQL(q);

		MembrBillRecord mbr = sbmgr.find("billrecordId=" + citem.getBillRecordId() +
                        " and membrId in (" + membr_ids_sb.toString() + ")");

		// ### update status, 2011/8/24 update by peter
		if (mbr.getReceivable()>mbr.getReceived() && (mbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)) {
             mbr.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
			 sbmgr.save(mbr);
		}
		else if (mbr.getReceivable()==mbr.getReceived() && (mbr.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID)) {
			 mbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
			 sbmgr.save(mbr);
		}
    }


    public void setChargeItemMembrAmount(int tran_id, ChargeItemMembr ci, int amount, int userId, Date nextFreezeDay)
        throws Exception
    {
        int org_amount = ci.getMyAmount();
        if (org_amount!=amount) {
            ChargeMgr cmgr = new ChargeMgr(tran_id);
            Charge c = cmgr.find("chargeItemId=" + ci.getChargeItemId() + " and membrId=" + ci.getMembrId());
            if (amount!=ci.getChargeAmount()) { 
                c.setAmount(amount);
                c.setUserId(userId);
                cmgr.save(c);
            }
            else if (c.getAmount()!=0) {
                c.setAmount(0);
                c.setUserId(userId);
                cmgr.save(c);
            }
            int diff = amount - org_amount;
            updateCharge(tran_id, ci.getChargeItemId(), ci.getMembrId(), diff, nextFreezeDay);
        }
    }

    public void updateCharge(int tran_id, int chargeItemId, int membrId, int diffamount, Date nextFreezeDay)
        throws Exception
    {
        ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + chargeItemId);
        StringBuffer sb = new StringBuffer();
        sb.append(membrId);
        __commit_membrbillrecord_ammount_change(tran_id, ci, sb, diffamount,  nextFreezeDay);

        MembrInfoBillRecord mbr = new MembrInfoBillRecordMgr(tran_id).
            find("billRecordId=" + ci.getBillRecordId() + " and membrId=" + membrId);
        if (mbr.getReceivable()<0)
            throw new Exception("x");

        ensureBillIntegrity(tran_id, mbr);
    }

    /* 
       因為付款後要能強制改帳單，所以新改的金額有可能
       1. 小於付款的金額: 帳單要改成 fully paid, 然后多的部分要退回學生帳戶
       2. 大于付款的金額: 帳單要改成 partly paid
    */
    public ArrayList<BillPay> fixupReceivableReceived(int tran_id, int billRecordId, int membrId)
        throws Exception
    {
        ArrayList<BillPay> ret = new ArrayList<BillPay>();
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        MembrBillRecord mbr = mbrmgr.find("billRecordId=" + billRecordId + " and membrId=" + membrId);
        if (mbr.getReceivable()==mbr.getReceived())
            return ret;
        BillPayMgr paymgr = new BillPayMgr(tran_id);
        BillPaidMgr paidmgr = new BillPaidMgr(tran_id);
        ArrayList<BillPaid> paids =  new BillPaidMgr(tran_id).retrieveList("ticketId='" + mbr.getTicketId() + "'", ""); 
        if (paids.size()==0)
            return ret;

        if (mbr.getReceived() < mbr.getReceivable()) {
            int diff = mbr.getReceivable() - mbr.getReceived();
            // 當初有沖的 billpay 如果還有餘額直接拿來沖(嗎？)
            String bpayIds = new RangeMaker().makeRange(paids, "getBillPayId");
            Map<Integer, BillPaid> paidMap = new SortingMap(paids).doSortSingleton("getBillPayId");
            ArrayList<BillPay> pays =  new BillPayMgr(tran_id).retrieveList("id in (" + bpayIds + ")", "");
            for (int i=0; i<pays.size(); i++) { // 從前面開始沖
                BillPay bpay = pays.get(i);
                if (bpay.getRemain()==0)
                    continue;
                BillPaid bpaid = paidMap.get(bpay.getId());
                int amount = Math.min(bpay.getRemain(), diff);
                bpay.setRemain(bpay.getRemain() - amount);
                paymgr.save(bpay);
                ret.add(bpay);

                bpaid.setRecordTime(new Date());
                bpaid.setAmount(bpaid.getAmount()+amount);
                paidmgr.save(bpaid);

                mbr.setReceived(mbr.getReceived()+amount);

                diff -= amount;
                if (diff==0)
                    break;
            }

            if (diff==0)
                mbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
            else 
                mbr.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
            mbrmgr.save(mbr);
        }
        else if (mbr.getReceived() > mbr.getReceivable()) {
            int diff = mbr.getReceived() - mbr.getReceivable();
            mbr.setReceived(mbr.getReceivable());
            mbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
            mbrmgr.save(mbr);
            // 還要從 billpay 退錢
            String bpayIds = new RangeMaker().makeRange(paids, "getBillPayId");
            Map<Integer, BillPaid> paidMap = new SortingMap(paids).doSortSingleton("getBillPayId");
            ArrayList<BillPay> pays =  new BillPayMgr(tran_id).retrieveList("id in (" + bpayIds + ")", "");
            for (int i=pays.size()-1; i>=0; i--) { // 從後面的開始退
                BillPay bpay = pays.get(i);
                BillPaid bpaid = paidMap.get(bpay.getId());
                int amount = Math.min(bpaid.getAmount(), diff);
                bpay.setRemain(bpay.getRemain() + amount);
                paymgr.save(bpay);
                ret.add(bpay);

                bpaid.setRecordTime(new Date());
                bpaid.setAmount(bpaid.getAmount()-amount);
                paidmgr.save(bpaid);

                diff -= amount;
                if (diff==0)
                    break;
            }
        }
        return ret;
    }

    public Charge addChargeMembr(int tran_id, ChargeItem citem, 
        int membrId, BillRecord br, int userId, Date nextFreezeDay)
        throws Exception
    {
        return addChargeMembr(tran_id, citem, membrId, br, userId, null, nextFreezeDay);
    }

    public Charge addChargeMembr(int tran_id, ChargeItem citem, 
        int membrId, BillRecord br, int userId, Tag t, Date nextFreezeDay)
        throws Exception
    {
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        if (cmgr.numOfRows("chargeItemId=" + citem.getId() + " and membrId=" + membrId)>0)
        {
            System.out.println("## AlreadyExists chargeItemId=" + citem.getId() + " and membrId=" + membrId);
            throw new AlreadyExists();
        }

        //FeeticketBridge bridge = new FeeticketBridge(tran_id);
        //MembrBillRecord sbr = bridge.retrieveMembrBillRecord(membrId, citem.getBillRecordId());
        //bridge.addChargeAmount(sbr);
        
        MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
        if (sbmgr.numOfRows("membrId=" + membrId + " and billrecordId=" + citem.getBillRecordId())==0) {
            makeMembrBillRecord(sbmgr, membrId, br);
        }
        StringBuffer sb = new StringBuffer();
        sb.append(membrId);
        __commit_membrbillrecord_ammount_change(tran_id, citem, sb, citem.getChargeAmount(), nextFreezeDay);

        Charge c = new Charge();
        c.setChargeItemId(citem.getId());
        c.setMembrId(membrId);
        c.setUserId(userId);
        if (t!=null)
            c.setTagId(t.getId());
        cmgr.create(c);

        //## 加上 bill integrity 和不能小于 0 的 check, 2008/09/25
        MembrBillRecord mbr =sbmgr.find("membrId=" + membrId + " and billrecordId=" + citem.getBillRecordId());

        if (mbr.getReceivable()<0)
            throw new Exception("x");
        ensureBillIntegrity(tran_id, mbr);
        // ############3

        return c;
    }

    public void deleteCharge(int tran_id, ChargeItemMembr cs, User u, Date nextFreezeDay)
        throws Exception
    {
        deleteCharge(tran_id, cs, u, true, nextFreezeDay);
    }

    public void deleteCharge(int tran_id, ChargeItemMembr cs, User u, boolean keepBill, Date nextFreezeDay)
        throws Exception
    {
        if (cs==null || u==null)
            throw new Exception("deleteCharge error, c=null or u=null");

        int amount = cs.getMyAmount(); // to be reduced

        DiscountMgr dmgr = new DiscountMgr(tran_id);
        Iterator<Discount> diter = dmgr.retrieveList("chargeItemId=" + cs.getChargeItemId() + 
            " and membrId=" + cs.getMembrId(), "").iterator();
        while (diter.hasNext()) {
            Discount d = diter.next();
            amount -= d.getAmount();
            Object[] to_be_removed2 = { d };
            dmgr.remove(to_be_removed2);
        }

        int diffamount = 0 - amount;
        StringBuffer sb = new StringBuffer();
        sb.append(cs.getMembrId());
        ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + cs.getChargeItemId());

        __commit_membrbillrecord_ammount_change(tran_id, ci, sb, diffamount, nextFreezeDay);

        ChargeMgr cmgr = new ChargeMgr(tran_id);
        Charge c = cmgr.find("chargeItemId=" + cs.getChargeItemId() + " and membrId=" + cs.getMembrId());
        Object[] to_be_removed = { c };
        cmgr.remove(to_be_removed);

        // remove feedetails of this charge
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        Object[] objs = fdmgr.retrieve("chargeItemId=" + cs.getChargeItemId() + 
            " and membrId=" + cs.getMembrId(), "");

        // 2009/1/20, by peter, 如果是 salary item, 且 feedetail 是帳單產生的就不行刪(要從帳單刪)
        if (cs.getBillType()==Bill.TYPE_SALARY) {
            for (int i=0; objs!=null && i<objs.length; i++) {
                FeeDetail fd = (FeeDetail) objs[i];
                if (fd.getPayrollFdId()>0)
                    throw new Exception("由帳單產生的派遣薪資不可由此刪除, 請由帳單刪除");
            }
        }
        // 派遣的 前面濾掉薪資, 能到這的只有帳單
        for (int i=0; objs!=null && i<objs.length; i++) {
            FeeDetail fd = (FeeDetail) objs[i];
            if (fd.getPayrollFdId()>0) { // 附屬的就不理
                // update Salary counter part
                FeeDetailHandler fdh = new FeeDetailHandler();
                fdh.deletePayrollEntry(tran_id, fd, u, nextFreezeDay);
            }            
        }

        /*
        // 2009/1/8 by peter, obsolete manhour
        // ####### 2008-12-23 by peter, check if generated by manhour, deny it 
        StringBuffer sb2 = new StringBuffer();
        sb2.append("-1");
        for (int i=0; objs!=null&&i<objs.length; i++) {
            sb2.append(",");
            sb2.append(((FeeDetail)objs[i]).getId());
        }
        if (new ManHourMgr(tran_id).numOfRows("billfdId in (" + sb2.toString() + ") or salaryfdId in (" + sb2.toString() + ")")>0)
            throw new Exception("請由派遣記錄刪除");
        // ####################################################################
        */

        if (objs!=null)
            fdmgr.remove(objs);

        // check if this is the last charge, then remove the whole membrbillrecord
        ChargeItemMembrMgr csmgr = new ChargeItemMembrMgr(tran_id);
        if (csmgr.numOfRows("chargeitem.billRecordId=" + cs.getBillRecordId() + " and membr.id=" + cs.getMembrId())==0)
        {
            if (!keepBill) {
                throw new Exception("keepBill obsolete, should be handled by jsp");
            }
            else {
                //throw new Exception("z");
				System.out.println("membrbillrecord has no charge");
            }
        }
    }

    /*
    public ArrayList<ManHour> findBillManhours(int tran_id, MembrBillRecord mbr)
        throws Exception
    {
        ArrayList<FeeDetailInfo> fees = new FeeDetailInfoMgr(tran_id).retrieveList(
            "membrbillrecord.billRecordId=" + mbr.getBillRecordId() + 
            " and membrbillrecord.membrId=" + mbr.getMembrId(), "");
        String manhourIds = "";
        if (fees.size()>0) {
            manhourIds = new RangeMaker().makeRange(fees, "getManhourId");
        }
        if (manhourIds.length()==0)
            manhourIds = "0";
        return new ManHourMgr(tran_id).retrieveList("id in (" + manhourIds + ")", "");
    }

    public void removeManhours(int tran_id, ArrayList<ManHour> manhours, User u)
        throws Exception
    {
        if (manhours==null || manhours.size()==0)
            return;
        String manhourIds = new RangeMaker().makeRange(manhours, "getId");
   
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);        
        MembrInfoBillRecordMgr mibmgr = new MembrInfoBillRecordMgr(tran_id);
        ArrayList<FeeDetail> fds = fdmgr.retrieveList("manhourId in (" + manhourIds + ")", ""); //包括主的副的薪資的
        // 先把相關的 bill 找進來好等下處理 voucher
        String chargeItemIds = new RangeMaker().makeRange(fds, "getChargeItemId");
        ArrayList<ChargeItem> citems = new ChargeItemMgr(tran_id).retrieveList("id in (" + chargeItemIds + ")", "");
        String billRecordIds = new RangeMaker().makeRange(citems, "getBillRecordId");
        String membrIds = new RangeMaker().makeRange(fds, "getMembrId");
        ArrayList<MembrInfoBillRecord> minfos = mibmgr.retrieveList("membrbillrecord.membrId in (" + membrIds + 
            ") and membrbillrecord.billRecordId in (" + billRecordIds + ")", "");
        Map<Integer, ChargeItem> chargeitemMap = new SortingMap(citems).doSortSingleton("getId");
        Map<String, MembrInfoBillRecord> minfoMap = new SortingMap(minfos).doSortSingleton("getBillKey"); // membrId#billRecordId
        
        VoucherService vsvc = new VoucherService(tran_id);
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
        for (int i=0; i<fds.size(); i++) {
            FeeDetail fd = fds.get(i);
            Object[] targets = { fd };
            fdmgr.remove(targets);

            ChargeItem ci = chargeitemMap.get(fd.getChargeItemId());
            MembrInfoBillRecord bill = minfoMap.get(fd.getMembrId()+"#"+ci.getBillRecordId());
            try {
                boolean do_remove = true;
                updateFeeDetail(tran_id, fd, do_remove, u);
                vsvc.genVoucherForBill(bill, u.getId(), "派遣(刪)");
            }
            catch (Exception e) {
                if (e.getMessage()!=null&&e.getMessage().equals("z")) {
                    vsvc.genVoucherForBill(bill, u.getId(), "派遣(刪)" + bill.getTicketId());
                    sbrmgr.executeSQL("delete from membrbillrecord where ticketId='" + bill.getTicketId() + "'");                                    
                }
                else
                    throw e;
            }
        }

        ManHourMgr mhmgr = new ManHourMgr(tran_id);
        Object[] tmp = mhmgr.retrieve("id in (" + manhourIds + ")", "");
        mhmgr.remove(tmp);
    }
    */

    public void updateFeeDetail(int tran_id, FeeDetail fd, boolean do_remove, User u, Date nextFreezeDay)
        throws Exception
    {
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        Charge c = cmgr.find("chargeItemId=" + fd.getChargeItemId() + " and membrId=" + fd.getMembrId());
        ChargeItemMembrMgr cimgr = new ChargeItemMembrMgr(tran_id);
        ChargeItemMembr ci = null;
        int orgAmount = 0;
        if (c==null) {
            c = new Charge();
            c.setChargeItemId(fd.getChargeItemId());
            c.setMembrId(fd.getMembrId());
            c.setUserId(u.getId());
            cmgr.create(c);

            // 如果帳單還沒有，產生它
            ChargeItem citem = new ChargeItemMgr(tran_id).find("id=" + fd.getChargeItemId());
            MembrBillRecordMgr sbmgr = new MembrBillRecordMgr(tran_id);
            if (sbmgr.numOfRows("membrId=" + fd.getMembrId() + " and billrecordId=" + citem.getBillRecordId())==0) {
                BillRecord br = new BillRecordMgr(tran_id).find("id=" + citem.getBillRecordId());
                makeMembrBillRecord(sbmgr, fd.getMembrId(), br);
            }
            ci = cimgr.find("charge.chargeItemId=" + fd.getChargeItemId() + 
                " and charge.membrId=" + fd.getMembrId());
            orgAmount = 0;
        }
        else {        
            ci = cimgr.find("charge.chargeItemId=" + fd.getChargeItemId() + 
                " and charge.membrId=" + fd.getMembrId());
            orgAmount = ci.getMyAmount();
        }
        
        int amount = 0;
        int quant = 0;
        ArrayList<FeeDetail> fees = new FeeDetailMgr(tran_id).retrieveList("chargeItemId=" + 
                fd.getChargeItemId() + " and membrId=" + fd.getMembrId(), "");
        for (int i=0; i<fees.size(); i++) {
            FeeDetail f = fees.get(i);
            amount += f.getUnitPrice() * f.getNum();
            quant += f.getNum();
        }

        c.setAmount((amount==0)?ChargeItemMembr.ZERO:amount); // 重新算出新的 amount
        int diff = amount - orgAmount;
System.out.println("### FeeDetail=" + fd.getId() + " diff = " + diff + " amount=" + amount + "  orgAmount=" + orgAmount);

        //#### caculate pitemNum #### 有連結庫存的 chargeitem, 那就用數量算出扣幾個
        if (ci.getPitemId()>0) {
            c.setPitemNum(quant);
        }
        //###########################
        cmgr.save(c);

        // if (do_remove && amount==0) {
        int rows = new FeeDetailMgr(tran_id).numOfRows("chargeItemId=" + ci.getChargeItemId() + 
            " and membrId=" + ci.getMembrId());
        if (do_remove && rows==0) {
            boolean keepBill = true; // 2008-11-30 by peter 留給jsp delete bill 才可在之前產生傳票
            deleteCharge(tran_id, ci, u, keepBill, nextFreezeDay);
        }
        else 
            updateCharge(tran_id, fd.getChargeItemId(), fd.getMembrId(), diff, nextFreezeDay);
    }    

    public void deleteMembrBillRecord(int tran_id, String ticketId, User u, Date nextFreezeDay)
        throws Exception
    {
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        ChargeItemMembrMgr cimmgr = new ChargeItemMembrMgr(tran_id);

        MembrBillRecord mbr = mbrmgr.find("ticketId='" + ticketId + "'");

        /* 
        ##### 2009/1/8 by peter, obsolite manhour ##########
        // 先處理跟這張帳單有關的 manhours
        ArrayList<ManHour> manhours = findBillManhours(tran_id, mbr);
        removeManhours(tran_id, manhours, u);
        */

        // got all chargeitem id for this membrbillrecord
        ArrayList<ChargeItemMembr> allcharges = cimmgr.retrieveList("chargeitem.billRecordId=" + 
            mbr.getBillRecordId() + " and membr.id=" + mbr.getMembrId(),"");
        Iterator<ChargeItemMembr> citer = allcharges.iterator();
        while (citer.hasNext()) {
            ChargeItemMembr ci = citer.next();            
            // deleteCharge(tran_id, ci, u, false/*keepBill*/);
            deleteCharge(tran_id, ci, u, true/*keepBill*/, nextFreezeDay); // 2008-11-30 by peter, 這樣才能在 jsp 產生 voucher 然后再刪除bill
        }
    }

    public int calcAmountForChargeItem(ChargeItem ci)
    {
        // 要考慮特別 specified amount in Charge
        ChargeItemMgr cimgr = ChargeItemMgr.getInstance();
        int sum = 0;
        int singleAmount = ci.getChargeAmount();
        ChargeMgr cmgr = ChargeMgr.getInstance();
        DiscountMgr dmgr = DiscountMgr.getInstance();
        ArrayList<Charge> charges = cmgr.retrieveList("chargeItemId=" + ci.getId(), "");
        ArrayList<Discount> discounts = dmgr.retrieveList("chargeItemId=" + ci.getId(), "");
        Iterator<Charge> iter = charges.iterator();
        while (iter.hasNext()) {
            Charge c = iter.next();
            sum += ChargeItemMembr.getMyAmount(c, ci);
        }
        Iterator<Discount> diter = discounts.iterator();
        while (diter.hasNext()) {
            Discount d = diter.next();
            sum -= d.getAmount();
        }
        return sum;
    }

    public int calcDiscountAmountForChargeItem(ChargeItem ci)
    {
        DiscountMgr dmgr = DiscountMgr.getInstance();
        ArrayList<Discount> discounts = dmgr.retrieveList("chargeItemId=" + ci.getId(), "");
        Iterator<Discount> iter = discounts.iterator();
        int sum = 0;
        while (iter.hasNext()) {
            Discount d = iter.next();
            sum += d.getAmount();
        }
        return sum;
    }

    public MembrBillRecord makeMembrBillRecord(MembrBillRecordMgr sbmgr, int membrId, BillRecord br)
        throws Exception
    {
        JsfTool jtool = JsfTool.getInstance();

        MembrBillRecord sbr = new MembrBillRecord();
        sbr.setMembrId(membrId);
        sbr.setBillRecordId(br.getId());
        String tid = jtool.generateFeenumber(br.getMonth());
        sbr.setTicketId(tid);
        sbmgr.create(sbr);
        return sbr;
    }

    // return "" : all students 
    // return null : no students
    // taginfo format is   1|tagname1,2|tagname2
    public String/*studentIds*/ getStudentIds(String[] tagIds, String taginfo, String isAnd)
    {
        if (tagIds==null && taginfo==null)
            return "";
        TagStudentMgr tsmgr = TagStudentMgr.getInstance();
        String studentIds = "";
        try {
            // taginfo = 63#圍棋班,78#音樂課
            if (isAnd!=null && isAnd.equals("1") && (taginfo!=null)) {  // 交集, 作出 tagIds 就是交集了
                String[] pairs = taginfo.split(",");
                tagIds = new String[pairs.length];
                for (int i=0; i<pairs.length; i++) {
                    String[] tokens = pairs[i].trim().split("#");
                    tagIds[i] = tokens[0];
                }
                taginfo = null;
            }

            if (taginfo==null) {
                for (int i=0; i<tagIds.length; i++) {
                    if (Integer.parseInt(tagIds[i])<=0)
                        continue;
                    String q = "tagId=" + tagIds[i];
                    if (studentIds.length()>0)
                        q += " and student.id in (" + studentIds + ")";
                    ArrayList<TagStudent> ts = tsmgr.retrieveList(q, "");
                    if (ts.size()==0)
                        return null;
                    studentIds = new RangeMaker().makeRange(ts, "getStudentId");
                }
            }  
            else { // 聯集
                // taginfo = 63#圍棋班,78#音樂課
                String[] pairs = taginfo.split(",");
                StringBuffer ids = new StringBuffer();
                for (int i=0; i<pairs.length; i++) {
                    String[] tokens = pairs[i].trim().split("#");
                    if (ids.length()>0) ids.append(",");
                    ids.append(tokens[0]);
                }
                ArrayList<TagStudent> ts = tsmgr.retrieveList("tagId in (" + ids.toString() + ")", "");
                if (ts.size()==0)
                    return null;
                studentIds = new RangeMaker().makeRange(ts, "getStudentId");
            }
        }
        catch (Exception e) {}

        return studentIds;
    }

    public Student[] searchStudent(String searchWord, String studentIds, int orderNum, String statusStr, String space)
    {
        if (studentIds==null)
            return null;

        String orderString = "";
        switch(orderNum)
    	{
    		case 1: orderString=" order by studentSex desc";
    			break;	
    		case 2: orderString=" order by studentSex ";
    			break;	
    		case 3: orderString=" order by tag.id desc";
    			break;	
    		case 4: orderString=" order by tag.id ";
    			break;
    		case 9: orderString=" order by studentBirth desc";
    			break;	
    		case 10: orderString=" order by studentBirth ";
    			break;
            case 100: orderString=" order by student.id desc"; // 馬禮遜要按時間排 Descending
                break;
    		default:
    			orderString=" order by studentName asc";
    			break;	
    	}
        
        String query = statusStr;
        /*
        if (tagId>0) 
            query += " and tagmembr.tagId=" + tagId;
        else
            orderString = " group by student.id " + orderString; // elminate multiple entries of one student
        */
        if(searchWord !=null && searchWord.length()>=1)
        {
            if (query.length()>0)
                query+=" and ";
            query+=" (studentName like '%"+searchWord+"%'";            
            query+=" or studentNickname like '%"+searchWord+"%'";
            query+=" or studentIDNumber like '%"+searchWord+"%'";
            query+=" or studentFather like '%"+searchWord+"%'";                 
            query+=" or studentMother like '%"+searchWord+"%'";                
            query+=" or studentFatherMobile like '%"+searchWord+"%'";
            query+=" or studentFatherMobile2 like '%"+searchWord+"%'"; 
            query+=" or studentMotherMobile like '%"+searchWord+"%'";                        
            query+=" or studentMotherMobile2 like '%"+searchWord+"%'";
            query+=" or studentFatherEmail like '%"+searchWord+"%'";
            query+=" or studentMotherEmail like '%"+searchWord+"%'";    
            query+=" or studentPhone like '%"+searchWord+"%'";
            query+=" or studentPhone2 like '%"+searchWord+"%'";
            query+=" or studentPhone2 like '%"+searchWord+"%'";
            query+=" or studentAddress like '%"+searchWord+"%'";
            query+=" )";
        }

        if (studentIds.length()>0) {
            if (query.length()>0)
                query += " and ";
            query += " id in (" + studentIds + ")";
        } 

        try {
			int sid = Integer.parseInt(searchWord);
			ArrayList<McaStudent> mts = McaStudentMgr.getInstance().
				retrieveList("StudentID=" + sid, "");
			String sids = new RangeMaker().makeRange(mts, "getStudId");
			query += " or (id in (" + sids + "))";
		}
		catch (Exception e) { 
		}


        StudentMgr smgr = StudentMgr.getInstance();
        Object[] objs = smgr.retrieveX(query, orderString, space);
        if (objs==null || objs.length==0)
            return null;
        
        Student[] ret = new Student[objs.length];
        for (int i=0; i<objs.length; i++)
            ret[i] = (Student) objs[i];
        return ret;
    }

    /*
    public BillPay doATMBalance(String line, ArrayList<MembrInfoBillRecord> fully_paid)
    {
		boolean commit = false;
        int tran_id = 0;
        BillPay bpay = null;
		//String exampleLine="00002068010002830620080108000003A082832ATM  67770      +C9548197010015900          013 
        //new verion of ticket(or account) length of 8 (88880015 is account, 7 is checksum)
        //String exampleLine="00002068010002830620080108000003A082832ATM  67770      +C9548188880015700          013 
		try { 
            tran_id = Manager.startTransaction();             			
            line = line.trim();
	        String sourceString = line.substring(0,113); // after this .. could change
            BillPayMgr bpmgr = new BillPayMgr(tran_id);
            BillSourceMgr bsmgr = new BillSourceMgr(tran_id);
            if (bsmgr.numOfRows("line='" + sourceString + "'")>0)
                return null;
            bpay = new BillPay();
            BillSource bsrc = new BillSource();
            bsrc.setLine(sourceString);
            bsmgr.create(bsrc);

 			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
			String payDateString=line.substring(18,26) + line.substring(33,39);
			Date payDate=sdf.parse(payDateString); 

SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
if (payDate.compareTo(sdf2.parse("2008-05-24"))<0)
    return null; // don't handle anything older than 2008-05-25

			String payAtmNumberString=line.substring(26,32);
			int payAtmNumber=Integer.parseInt(payAtmNumberString);
			
			String payMoneyString=line.substring(43,55).trim();	
			int payMoney=Integer.parseInt(payMoneyString)/10;

            char sign = line.charAt(55);
            StringBuffer msg = new StringBuffer();
            if (sign=='-') {
                payMoney = 0 - payMoney;
                msg.append("## negative amount in atm line");
            }
			
			String accountFirst5=line.substring(57,62).trim();	
						
			//int defaulAccountLength=9; // must be length = 8;(ticketId or 約定帳號)
			int defaulAccountLength=8; // must be length = 8;(ticketId or 約定帳號)
			
            PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
            
			if(ps.getPaySystemFixATMAccount()!=null 
                && ps.getPaySystemFixATMAccount().length()>0 
                 && ps.getPaySystemFixATMNum()>3)
				defaulAccountLength=ps.getPaySystemFixATMAccount().length()+ps.getPaySystemFixATMNum();

			int endAccountPosition=62+defaulAccountLength;	
			String ticketIdS=line.substring(62,endAccountPosition).trim();  // 88880012 or 97100001
System.out.println("## defaulAccountLength=" + defaulAccountLength + " ticketIdS=" + ticketIdS);

            bpay.setVia(BillPay.VIA_ATM); // ATM
            bpay.setRecordTime(payDate);
            bpay.setCreateTime(new Date());
            bpay.setAmount((int)payMoney);
            bpay.setUserId(0); // ftp done by system
            bpay.setBillSourceId(bsrc.getId());
            bpmgr.create(bpay);

            // getPaySystemFixATMAccount = 8888
            boolean isFixedAccount = false;
            String fixATMAccount = ps.getPaySystemFixATMAccount().trim(); //8888
            String ticketIndex=ticketIdS.substring(0,fixATMAccount.length());  // 8888
            String ticketLast=ticketIdS.substring(fixATMAccount.length());  // 0012
            Membr membr = null;
            String payerName = "";
            int remain = (int)payMoney;
            
            if(fixATMAccount.equals(ticketIndex)) // 如果是用 fixed virtual account
            {
                // if is 8888, then 帳單是用新系統印的 ##### 2008/08/12 ######
                // fix for 劍聲臺北, 換系統時為五碼,但是是帳單標號，現在既然是 8888 新系統印的，應該是4碼
                ticketLast = ticketLast.substring(0, 4); 
                // ############################################################
                isFixedAccount = true;
                int membrId=Integer.parseInt(ticketLast);
                membr = MembrMgr.getInstance().find("id=" + membrId);

                // #### 2008/10/6 by peter, ATM fix virtual 才用 autoBalanceBills
                remain = autoBalanceBills(tran_id, membr, bpay, remain, fully_paid);
                bpay.setMembrId(membr.getId());
                msg.append("\n## atm2 fix account membr id "+membr.getId()+" 銷單:" + remain);
                payerName = membr.getName();
            }
            else {  // 如果是用 floating virtual account
                MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().
                    find("ticketId='" + ticketIdS + "'");
                membr = MembrMgr.getInstance().find("id=" + sinfo.getMembrId());

                remain = __doBalanceSingleWithUnpaid(tran_id, sinfo, bpay, remain, fully_paid); // floating account 都用這個銷
                bpay.setMembrId(membr.getId());
                msg.append("\n## atm ticket id "+ticketIdS+"銷單:" + remain);
                payerName = membr.getName();
            }


            BunitHelper bh = new BunitHelper(tran_id);
            Bunit bunit = bh.getBunitFromVirtual(accountFirst5);
            int bankId = bh.getBankId(bunit);

            bpay.setRemain(remain);
            bpay.setBunitId(bunit.getId());
            bpmgr.save(bpay);

            updateIncomeCostPay(tran_id, bpay, payMoney, payDate, 2, bankId, 3, 0, payerName, bunit.getId());

            // #### 2008/11/27 added by peter for voucher
            VoucherService vsvc = new VoucherService(tran_id, bunit.getId());
            vsvc.genVoucherForBillPay(bpay, 0, "轉帳繳費");

            commit = true;
            Manager.commit(tran_id);

            if (remain>0 || sign=='-')
                // need to warning somebody that a ftp line cannot be balanced
                sendWarningMessage("ftp ATM abnormal:" + msg.toString() + "\n" + line);

            if (payerName.equals("不明帳號"))
                sendWarningMessage("ftp ATM abnormal: 不明帳號, bpay id=" + bpay.getId() + "\n" + line);

            return bpay;
        }
        catch (Exception e) {
            sendWarningException(e, line);
        }
        finally {
            if (!commit) {
    			try { Manager.rollback(tran_id); } catch (Exception e) {}
            }
        }
        return null;
    }


    public BillPay doUOBBalance(String line, ArrayList<MembrInfoBillRecord> fully_paid)
    {
  		//String exampleLine=2008 10 01 87100-71  971001325ECT            6500
        int tran_id = 0;
        boolean commit = false;
        BillPay bpay = null;
	  	try{	
            tran_id = Manager.startTransaction();  
            line = line.trim();
            BillPayMgr bpmgr = new BillPayMgr(tran_id);
            BillSourceMgr bsmgr = new BillSourceMgr(tran_id);
            if (bsmgr.numOfRows("line='" + line + "'")>0)
                return null;
            bpay = new BillPay();
            BillSource bsrc = new BillSource();
            bsrc.setLine(line);
            bsmgr.create(bsrc);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy MM dd");
            String _dstr = line.substring(0,10);
            System.out.println("## _dstr = " + _dstr);
            Date payDate = sdf.parse(_dstr);
            
            String _5digits = line.substring(11, 16);
            System.out.println("## _5digits = " + _5digits);

            String _method = line.substring(17, 19);
            System.out.println("## _method = " + _method);

            String _acctId = line.substring(21, 29);
            System.out.println("## _acctId = " + _acctId);

            String _amountStr = line.substring(40, 49).trim();
            System.out.println("## _amountStr = " + _amountStr);
            int money = Integer.parseInt(_amountStr);
            StringBuffer msg = new StringBuffer();
            String payerName = null;

            BunitHelper bh = new BunitHelper(tran_id);
            Bunit bunit = bh.getBunitFromVirtual(_5digits);
            
//71：統一  FA：全家  HI：萊爾富  OK：來來
//TL：銀行臨櫃繳款  　ATM：自行ATM轉入  ATMF：跨行ATM轉入
//RM：跨行匯款匯入　　RT：自行匯款匯入
//EB：全國性繳費 　　 CC：信用卡繳費
            PaySystem ps = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");

            if (!_5digits.equals(bh.getVirtualID(bunit.getId()))) {
                throw new Exception("公司代碼5碼不對！ " + bh.getVirtualID(bunit.getId()));
            }

            String method = null;
            if (_method.equals("71") || _method.equals("HI") || _method.equals("OK") || _method.equals("FA")) {
                bpay.setVia(BillPay.VIA_STORE); // Store
                method = "便利商店";
            }
            else if (_method.equals("AT") || _method.equals("TL") ||  _method.equals("RM") ||  _method.equals("RT")) {
                bpay.setVia(BillPay.VIA_ATM); // ATM
                method = "轉帳";
            }
            else if (_method.equals("EB") || _method.equals("CC")) {
                bpay.setVia(BillPay.VIA_CREDITCARD); // Creditcard
                method = "信用卡";
            }

            bpay.setRecordTime(payDate);
            bpay.setCreateTime(new Date());
            bpay.setAmount((int)money);
            bpay.setUserId(0); // ftp done by system
            bpay.setBillSourceId(bsrc.getId());
            bpmgr.create(bpay);

            Membr membr = null;
            int remain = money;
            if(_acctId.indexOf(ps.getPaySystemFixATMAccount())>=0) // 如果是用 8888
            {
                int membrId=Integer.parseInt(_acctId.substring(4));
                membr = MembrMgr.getInstance().find("id=" + membrId);
                remain = autoBalanceBills(tran_id, membr, bpay, remain, fully_paid);
                bpay.setMembrId(membr.getId());
                msg.append("\n## uob fix account membr id "+membr.getId()+" 銷單:" + remain);
                payerName = membr.getName();
            }
            else {  // 如果是用 floating virtual account
                MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().
                    find("ticketId='" + _acctId + "'");
                membr = MembrMgr.getInstance().find("id=" + sinfo.getMembrId());

                remain = __doBalanceSingleWithUnpaid(tran_id, sinfo, bpay, remain, fully_paid); // floating account 都用這個銷
                bpay.setMembrId(membr.getId());
                msg.append("\n## uob ticket id "+_acctId+" 銷單:" + remain);
                payerName = membr.getName();
            }

            int bankId = bh.getBankId(bunit);

            bpay.setRemain(remain);
            bpay.setBunitId(bunit.getId());
            bpmgr.save(bpay);
            
            updateIncomeCostPay(tran_id, bpay, money, payDate, 2, bankId, 3, 0, payerName, bunit.getId());

            // #### 2008/11/27 added by peter for voucher
            VoucherService vsvc = new VoucherService(tran_id, bunit.getId());
            vsvc.genVoucherForBillPay(bpay, 0, method + "繳費");

            commit = true;
            Manager.commit(tran_id);

            if (remain>0)
                // need to warning somebody that a ftp line cannot be balanced
                sendWarningMessage("UOB abnormal:" + msg.toString() + "\n" + line);

            if (payerName.equals("不明帳號"))
                sendWarningMessage("UOB abnormal: 不明帳號, bpay id=" + bpay.getId() + "\n" + line);

            return bpay;
        }
        catch (Exception e) {
            sendWarningException(e, line);
        }
        finally {
            if (!commit)
    			try { Manager.rollback(tran_id); } catch (Exception e2) {}  
        }
        return null;
    }
    */

    public BillPay doMcaBalance(String line, ArrayList<MembrInfoBillRecord> fully_paid)
        throws Exception
    {
		boolean commit = false;
        int tran_id = 0;
        BillPay bpay = null;
		//1852765196507 0971001 CSBN  00000000000  00000014000  00000237407 1450 0006709 
		try { 
            tran_id = Manager.startTransaction();             			
            line = line.trim();
	        String sourceString = line; // after this .. could change
            BillPayMgr bpmgr = new BillPayMgr(tran_id);
            BillSourceMgr bsmgr = new BillSourceMgr(tran_id);
            if (bsmgr.numOfRows("line='" + sourceString + "'")>0)
                return null;
            bpay = new BillPay();
            BillSource bsrc = new BillSource();
            bsrc.setLine(sourceString);
            bsmgr.create(bsrc);

 			CoopData cd = new CoopData(tran_id, line);

            Date payDate = cd.getPayDate();
			if (payDate.compareTo(_sdffz.parse("2011-01-01"))<0)
			{
				throw new Exception("invaid date " + _sdffz.format(payDate));
			}
            int payMoney = cd.getPayMoney();

            bpay.setVia(BillPay.VIA_ATM); // ATM
            bpay.setRecordTime(payDate);
            bpay.setCreateTime(new Date());
            bpay.setAmount((int)payMoney);
            bpay.setUserId(0); // ftp done by system
            bpay.setBillSourceId(bsrc.getId());
            bpmgr.create(bpay);

            int remain = (int)payMoney;            
            mca.McaStudent ms = cd.getMcaStudent();
            if (ms==null)
                throw new Exception("coop: mca student not found");
            Membr membr = MembrMgr.getInstance().find("id=" + ms.getMembrId());

            // #### 2008/10/6 by peter, ATM fix virtual 才用 autoBalanceBills
            remain = autoBalanceBills(tran_id, membr, bpay, remain, fully_paid);
            bpay.setMembrId(membr.getId());
            String payerName = membr.getName();

            //真實帳號就是存摺上面秀的銀行帳戶號碼
            //台北是1852-765-196337 台中是1852-765-196507  嘉義高雄是1852-765-196604

            BunitHelper bh = new BunitHelper(tran_id);
            Bunit bunit = bh.getBunitFromVirtual(cd.getCoopAccountId()); // 1852765
            int bankId = bh.getBankId(bunit);

            bpay.setRemain(remain);
            bpay.setBunitId(bunit.getId());
            bpmgr.save(bpay);
 
            updateIncomeCostPay(tran_id, bpay, payMoney, payDate, 2, bankId, 3, 0, payerName, bunit.getId(), 
                (double)0, 0, 0, null);

            // #### 2008/11/27 added by peter for voucher
            VoucherService vsvc = new VoucherService(tran_id, bunit.getId());
            vsvc.genVoucherForBillPay(bpay, 0, "轉帳繳費");

            commit = true;
            Manager.commit(tran_id);

            if (remain>0)
                // need to warning somebody that a ftp line cannot be balanced
                sendWarningMessage("mca coop abnormal remain =" + remain + "\n" + line);

            return bpay;
        }
        catch (Exception e) {
            sendWarningException(e, line);
            throw e;
        }
        finally {
            if (!commit) {
    			try { Manager.rollback(tran_id); } catch (Exception e) {}
            }
        }
    }

    public BillPay doMcaBalanceNew(String line, ArrayList<MembrInfoBillRecord> fully_paid)
        throws Exception
    {
		boolean commit = false;
        int tran_id = 0;
        BillPay bpay = null;
        //代收類別	繳款管道	銷帳編號	實繳金額	繳費日期	繳款時間	學校代號	公司代號	代收機構代號	代收門市店號	扣繳狀況	入帳日期	條碼一	條碼二	條碼三	傳送日期
		//185302	Host	1853020008475	40067	20110208	150810	185302					20110208				20110208
		try { 
            tran_id = Manager.startTransaction();             			
            line = line.trim();
	        String sourceString = line; // after this .. could change
            BillPayMgr bpmgr = new BillPayMgr(tran_id);
            BillSourceMgr bsmgr = new BillSourceMgr(tran_id);
            if (bsmgr.numOfRows("line='" + sourceString + "'")>0)
                return null;
            bpay = new BillPay();
            BillSource bsrc = new BillSource();
            bsrc.setLine(sourceString);
            bsmgr.create(bsrc);

 			CoopData2 cd = new CoopData2(tran_id, line);

            Date payDate = cd.getPayDate();
			if (payDate.compareTo(_sdffz.parse("2011-01-01"))<0)
			{
				throw new Exception("invaid date " + _sdffz.format(payDate));
			}

            int payMoney = cd.getPayMoney();

            bpay.setVia(cd.getVia()); // ATM
            bpay.setRecordTime(payDate);
            bpay.setCreateTime(new Date());
            bpay.setAmount((int)payMoney);
            bpay.setUserId(0); // ftp done by system
            bpay.setBillSourceId(bsrc.getId());
            bpmgr.create(bpay);

            int remain = (int)payMoney;            
            mca.McaStudent ms = cd.getMcaStudent();
            if (ms==null)
                throw new Exception("coop: mca student not found");
            Membr membr = MembrMgr.getInstance().find("id=" + ms.getMembrId());

            // #### 2008/10/6 by peter, ATM fix virtual 才用 autoBalanceBills
            remain = autoBalanceBills(tran_id, membr, bpay, remain, fully_paid);
            bpay.setMembrId(membr.getId());
            String payerName = membr.getName();

            //真實帳號就是存摺上面秀的銀行帳戶號碼
            //台北是185301 台中是185302  嘉義高雄是185303

            BunitHelper bh = new BunitHelper(tran_id);
            Bunit bunit = bh.getBunitFromStoreID(cd.getCoopStoreId()); // 185301
            int bankId = bh.getBankId(bunit);

            bpay.setRemain(remain);
            bpay.setBunitId(bunit.getId());
            bpmgr.save(bpay);
 
            updateIncomeCostPay(tran_id, bpay, payMoney, payDate, 2, bankId, 3, 0, payerName, bunit.getId(), 
                (double)0, 0, 0, null);

            // #### 2008/11/27 added by peter for voucher
            VoucherService vsvc = new VoucherService(tran_id, bunit.getId());
            vsvc.genVoucherForBillPay(bpay, 0, "轉帳繳費");

            commit = true;
            Manager.commit(tran_id);

            if (remain>0)
                // need to warning somebody that a ftp line cannot be balanced
                sendWarningMessage("mca coop abnormal remain =" + remain + "\n" + line);

            return bpay;
        }
        catch (Exception e) {
            sendWarningException(e, line);
            throw e;
        }
        finally {
            if (!commit) {
    			try { Manager.rollback(tran_id); } catch (Exception e) {}
            }
        }
    }

    /*
    public BillPay doStoreBalance(String line, ArrayList<MembrInfoBillRecord> fully_paid)
    {
  		//String exampleLine="2008010720080106JSM000097010016800001115297017111111 20680100028306";	
        int tran_id = 0;
        boolean commit = false;
        BillPay bpay = null;
	  	try{	
            tran_id = Manager.startTransaction();  
            line = line.trim();
            BillPayMgr bpmgr = new BillPayMgr(tran_id);
            BillSourceMgr bsmgr = new BillSourceMgr(tran_id);
            if (bsmgr.numOfRows("line='" + line + "'")>0)
                return null;
            bpay = new BillPay();
            BillSource bsrc = new BillSource();
            bsrc.setLine(line);
            bsmgr.create(bsrc);

	  		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd"); 
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyyMM"); 
			
	  	 	String[] token = new String[7];
	  		
	  		String dataDateString=line.substring(0,8).trim();
	  		Date dataDate=sdf.parse(dataDateString);
	  		
	  		String payDateString=line.substring(8,16).trim();
	  		Date payDate=sdf.parse(payDateString);		

SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd");
if (payDate.compareTo(sdf3.parse("2008-05-24"))<0)
    return null; // don't handle anything older than 2008-05-25
            
            // JSM0000{9}ticketId
	  		// String feeticketIdString=line.substring(19,32).trim();
            // PHM00100{8}ticketId
            String feeticketIdString=line.substring(23,32).trim();
            int ticketId = Integer.parseInt(feeticketIdString);
System.out.println("## store parse ticketId=" + ticketId);
            feeticketIdString = ticketId + "";
	  		
	  		String moneyString=line.substring(32,41).trim();	
	  		int money=Integer.parseInt(moneyString);

			String endDateString=line.substring(41,45).trim();
			int payYear=Integer.parseInt(endDateString.substring(0,2))+1911;
	        String payMonthFormat=String.valueOf(payYear)+endDateString.substring(2);
	        Date payMonth=sdf2.parse(payMonthFormat);		
	   		
	   		String storeId=line.substring(45,53).trim();
	   		String accountId=line.substring(53).trim();

            bpay.setVia(BillPay.VIA_STORE); // Store
            bpay.setRecordTime(payDate);
            bpay.setCreateTime(new Date());
            bpay.setAmount((int)money);
            bpay.setUserId(0); // ftp done by system
            bpay.setBillSourceId(bsrc.getId());
            bpmgr.create(bpay);

            StringBuffer msg = new StringBuffer();			
            MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().
                find("ticketId='" + feeticketIdString + "'");
            msg.append("\n## store1 ticketId=" + feeticketIdString);
            Membr membr = MembrMgr.getInstance().find("id=" + sinfo.getMembrId());

            String payerName = "";
            int remain = (int)money;
            if (membr!=null) {
                // ## 便利商店進來的還是用單號來銷帳，因為碰到彰化銷月費跑去先銷註冊費他們
                //    就不太諒解。但是要考慮單張銷單有 unpaid 的部分
                remain = __doBalanceSingleWithUnpaid(tran_id, sinfo, bpay, remain, fully_paid); // floating account 都用這個銷
                bpay.setMembrId(membr.getId());
                payerName = membr.getName();
            }
            else
                payerName = "不明帳號";

            String storeID = line.substring(16,22); // PHM001, JSM000
            BunitHelper bh = new BunitHelper(tran_id);
            Bunit bunit = bh.getBunitFromStoreID(storeID);
            int bankId = bh.getBankId(bunit);

            bpay.setRemain(remain);
            bpay.setBunitId(bunit.getId());
            bpmgr.save(bpay);

            updateIncomeCostPay(tran_id, bpay, money, payDate, 2, bankId, 3, 0, payerName, bunit.getId());

            // #### 2008/11/27 added by peter for voucher
            VoucherService vsvc = new VoucherService(tran_id, bunit.getId());
            vsvc.genVoucherForBillPay(bpay, 0, "便利商店繳費");

            commit = true;
            Manager.commit(tran_id);

            if (remain>0) 
                // need to warning somebody that a ftp line cannot be balanced
                sendWarningMessage("ftp STORE abnormal:" + msg.toString() + "\n" + line);

            if (payerName.equals("不明帳號"))
                sendWarningMessage("ftp STORE abnormal: 不明帳號, bpay id=" + bpay.getId() + "\n" + line);

            return bpay;
        }
        catch (Exception e) {
            sendWarningException(e, line);
        }
        finally {
            if (!commit)
    			try { Manager.rollback(tran_id); } catch (Exception e2) {}  
        }
        return null;
    }
    */

    public int getMembrRemain(int membrId)
    {
        BillPayMgr bpmgr = BillPayMgr.getInstance();
        ArrayList<BillPay> history = bpmgr.retrieveList("membrId=" + membrId + " and remain>0", "");
        Iterator<BillPay> iter = history.iterator();
        int remain = (int) 0;
        while (iter.hasNext()) {
            remain += iter.next().getRemain();
        }
        return remain;
    }

    // 人工銷單一定是會從剩下餘額開始，也一定要 specify 那幾張
    // caller 決定如何產生 costpay (因為支票暫不產生)
    public BillPay doManualBalance(int tran_id, int amount, Membr membr, User user, 
        ArrayList<MembrInfoBillRecord> bills, int via, Date recordTime,
        ArrayList<MembrInfoBillRecord> fully_paid, int bunitId)
            throws Exception
    {
        BillPay bpay = null;
            
        // ####### pay by 前次剩下餘額 ##########
        BillPayMgr bpmgr = new BillPayMgr(tran_id);
        ArrayList<BillPay> history = bpmgr.
            retrieveList("membrId=" + membr.getId() + " and remain>0", "order by id asc");                
            
        Iterator<MembrInfoBillRecord> billiter = bills.iterator();
        while (billiter.hasNext()) {
            MembrInfoBillRecord bill = billiter.next();
            if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                continue;
            Iterator<BillPay> iter = history.iterator();
            while (iter.hasNext()) {
                BillPay bp = iter.next();
                if (bp.getRemain()<=0)
                    continue;
                int orgRemain = bp.getRemain();
                int newRemain = __doBalanceSingle(tran_id, bill, bp, orgRemain);
                if (newRemain!=orgRemain) {
                    bp.setRemain(newRemain);
                    bpmgr.save(bp);
                    // #### 2008/11/27 added by peter for voucher
                    VoucherService vsvc = new VoucherService(tran_id, bunitId);
                    vsvc.genVoucherForBillPay(bp, user.getId(), "學生帳戶餘額沖款");
                }
                if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) {
                    fully_paid.add(bill);
                    break;
                }
            }
        }
        // #############################################

        // #### 以下為這次的 pay #######
        int remain = 0;
        if (amount>0) {
            bpay = new BillPay();
            bpay.setVia(via); 
            bpay.setRecordTime(recordTime);
            bpay.setCreateTime(new Date());
            bpay.setAmount(amount);
            bpay.setUserId(user.getId()); // ftp done by system
            bpay.setBillSourceId(0);
            bpmgr.create(bpay);

            // pay by 這次的付款
            billiter = bills.iterator();
            remain = amount;
            while (billiter.hasNext()) {
                MembrInfoBillRecord bill = billiter.next();
                if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    continue;
                remain = __doBalanceSingle(tran_id, bill, bpay, remain);
                if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    fully_paid.add(bill);
                if (remain==(int)0)
                    break;
            }

            bpay.setMembrId(membr.getId());
            bpay.setRemain(remain);
            bpay.setBunitId(bunitId);
            bpmgr.save(bpay);
        }

        return bpay;
    }


    // 付薪水，一定要 specify 那幾張
    // public static final int SALARY_CASH = 100;
    // public static final int SALARY_WIRE = 101;
    // public static final int SALARY_CHECK = 102;

    public BillPay doSalaryBalance(int tran_id, int amount, User user, 
        ArrayList<MembrInfoBillRecord> bills, int via, int acctId, boolean pending, 
        ArrayList<MembrInfoBillRecord> fully_paid, int bunitId)
            throws Exception
    {
        BillPayMgr bpmgr = new BillPayMgr(tran_id);  
        int remain = amount;          
        BillPay bpay = null;
        if (amount>0) {
            bpay = new BillPay();
            if (via!=BillPay.SALARY_CASH && via!=BillPay.SALARY_WIRE && via!=BillPay.SALARY_CHECK)
                throw new Exception("unrecognized VIA in salaryBalance");
            bpay.setVia(via);
            bpay.setRecordTime(new Date());
            bpay.setCreateTime(new Date());
            bpay.setAmount(amount);
            bpay.setUserId(user.getId()); // ftp done by system
            bpay.setBillSourceId(0);
            //bpay.setAccountId(acctId);
            //bpay.setFutureCommitDate(futureCommitDate);
            bpay.setPending(pending?1:0);
            bpmgr.create(bpay);

            // pay by 這次的付款
            Iterator<MembrInfoBillRecord> billiter = bills.iterator();
            while (billiter.hasNext()) {
                MembrInfoBillRecord bill = billiter.next();
                if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    continue;
                remain = __doBalanceSingle(tran_id, bill, bpay, remain);
                if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    fully_paid.add(bill);
                if (remain==(int)0)
                    break;
            }

            bpay.setRemain(remain);
            bpay.setBunitId(bunitId);
            bpmgr.save(bpay);

            if (!pending) {
                String payTitle = bills.get(0).getMembrName();
                if (bills.size()>1)
                    payTitle += "等" + bills.size() + "人";
                updateSalaryCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), via,
                    acctId, user.getId(), payTitle, bunitId);
            }
        }

        if (remain>0 && bpay!=null) 
            sendWarningMessage("in salary pay abnormal :" + remain + " billpay id=" + bpay.getId());

        return bpay;
    }

    ArrayList<MembrInfoBillRecord> reOrderByAmount(ArrayList<MembrInfoBillRecord> unpaid, int amount)
        throws Exception
    {
        ArrayList<MembrInfoBillRecord> ret = new ArrayList<MembrInfoBillRecord>();
        int i=0;
        for (i=0; i<unpaid.size(); i++) {
            MembrInfoBillRecord b = unpaid.get(i);
            if (b.getReceivable()==amount) {
                ret.add(b);
                break;
            }
        }
        for (int j=0; j<unpaid.size(); j++) {
            if (j==i)
                continue;
            ret.add(unpaid.get(j));
        }
        return ret;
    }

    // 銷單，如果是自動銷就都銷   
    //       如果是手工判斷單的話只銷沒過期的
    // #######
    public int autoBalanceBills(int tran_id, Membr membr, BillPay bpay, 
        int payAmount, ArrayList<MembrInfoBillRecord> fully_paid)
        throws Exception
    {
        MembrInfoBillRecordMgr sbrmgr = new MembrInfoBillRecordMgr(tran_id);
        ArrayList<MembrInfoBillRecord> unpaid = sbrmgr.retrieveList("membrId=" + membr.getId() + 
             //" and paidStatus in (0,1)", "order by ticketId asc");
             " and paidStatus in (0,1)", "order by billrecord.billDate asc");

        //####### 2009/2/7 by peter, 全部舊的先銷 + 如果有金額相同的要先銷
        unpaid = reOrderByAmount(unpaid, bpay.getAmount());

        Iterator<MembrInfoBillRecord> iter = unpaid.iterator();
        int remain = payAmount;
        while (iter.hasNext()) {
            MembrInfoBillRecord sbr = iter.next();            
            //####### 2009/2/7 by peter, 全部舊的先銷
            // 如果是自動銷就都銷, 如果是手工判斷單的話只銷沒過期的
            //boolean expire = sbr.getMyBillDate().compareTo(bpay.getRecordTime())<0;
            //boolean handle = (sbr.getBalanceWay()==Bill.FIFO) || (sbr.getBalanceWay()==Bill.MANUAL && !expire); 
            //if (handle) {
                remain = __doBalanceSingle(tran_id, sbr, bpay, remain);
                if (sbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    fully_paid.add(sbr);
                if (remain<=(int)0)
                    break;
            //}
        }
        return remain;
    }

    /*
    // 人工銷確定的單號
    public int manualBalanceBill(int tran_id, MembrInfoBillRecord bills, BillPay bpay, 
        int payAmount, ArrayList<MembrInfoBillRecord> fully_paid)
        throws Exception
    {
        boolean fifo = (sinfo.getBalanceWay()==1);
        MembrInfoBillRecordMgr sbrmgr = new MembrInfoBillRecordMgr(tran_id);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        int remain = payAmount;
        if (fifo) {
            // 如果先進先銷，要找到所有之前還沒銷的
            ArrayList<MembrInfoBillRecord> unpaid = sbrmgr.retrieveList("membrId=" + sinfo.getMembrId() + 
                " and billId=" + sinfo.getBillId() + " and  paidStatus in (0,1)" + 
                " and billrecord.month<='"+sdf.format(sinfo.getBillMonth())+ "'", 
                "order by ticketId asc");
            Iterator<MembrInfoBillRecord> iter = unpaid.iterator();
            while (iter.hasNext()) {
                MembrInfoBillRecord sbr = iter.next();
                remain = __doBalanceSingle(tran_id, sbr, bpay, remain);
                if (sbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    fully_paid.add(sbr);
                if (remain<=(int)0)
                    break;
            }
        }
        else {
            remain = __doBalanceSingle(tran_id, sinfo, bpay, payAmount);
            if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                fully_paid.add(sinfo);
        }
        return remain;
    }
    */

    private int __doBalanceSingleWithUnpaid(int tran_id, MembrInfoBillRecord sinfo, BillPay bpay, int payAmount,
         ArrayList<MembrInfoBillRecord> fully_paid)
        throws Exception
    {
        int beforeStatus = sinfo.getPaidStatus();
        int remain = __doBalanceSingle(tran_id, sinfo, bpay, payAmount);
        if (beforeStatus!=MembrBillRecord.STATUS_FULLY_PAID && sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
            fully_paid.add(sinfo);
        // 處理這張印出來的帳單如果有記錄之前未付的部分,注意一定是同類型的才會有 inheritunpaid
        if (sinfo.getInheritUnpaid()>0 && remain>0) {
            MembrInfoBillRecordMgr sbrmgr = new MembrInfoBillRecordMgr(tran_id);
            ArrayList<MembrInfoBillRecord> unpaid = sbrmgr.retrieveList("membrId=" + sinfo.getMembrId() + 
             // " and paidStatus in (0,1) and billType=" + sinfo.getBillType(), "order by ticketId desc"); 
            " and paidStatus in (0,1) and billType=" + sinfo.getBillType(), "order by billrecord.billDate desc"); 
            // 同一帳單類型，由新的算回去
            Iterator<MembrInfoBillRecord> iter = unpaid.iterator();
            while (iter.hasNext()) {
                MembrInfoBillRecord sbr = iter.next();
                remain = __doBalanceSingle(tran_id, sbr, bpay, remain);
                if (sbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
                    fully_paid.add(sbr);
                if (remain<=(int)0)
                    break;
            }
        }
        return remain;
    }

    // 這個就只銷一張
    private int __doBalanceSingle(int tran_id, MembrInfoBillRecord sbr, BillPay bpay, int payAmount)
        throws Exception
    {
        if (sbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
            return payAmount;
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
        BillPaidMgr bpmgr = new BillPaidMgr(tran_id);
        int unpaid = sbr.getReceivable()-sbr.getReceived();
        int remain = (int) payAmount;
        int paid = 0;
        if (payAmount>=unpaid) {
            paid = unpaid;
            sbr.setReceived(sbr.getReceivable());
            sbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
            remain = payAmount - unpaid;
        }
        else {
            paid = payAmount;
            sbr.setReceived(sbr.getReceived() + payAmount);
            sbr.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
            remain = 0;
        }
        BillPaid bp = bpmgr.find("billPayId=" + bpay.getId() + " and ticketId='" + sbr.getTicketId() + "'");
        if (bp==null) {
            bp = new BillPaid();
            bp.setBillPayId(bpay.getId());
            bp.setTicketId(sbr.getTicketId());
            bp.setAmount(paid);
            bp.setRecordTime(bpay.getRecordTime()); // 2009/1/13, 現在用傳票時間看預付，沒有下面說的問題了。           
            // bp.setRecordTime(new Date()); // 未必是 bpay.getRecordTime 如此可知道實際銷單時間(比如預付就會比付款時間晚)
            bp.setBunitId(sbr.getBunitId());
            bpmgr.create(bp);
        }
        else { // 可能之前有，然后又用同個 bpay 來沖
            bp.setAmount(bp.getAmount() + paid);
            bp.setRecordTime(new Date()); // make sure voucher time is now, 傳票來講，也是用這時沖
            bpmgr.save(bp);
        }

        sbrmgr.save(sbr);
        return remain;
    }
    
    // if bankType is 1, 當面親付 then accountId is 現金賬戶的 tradeAccount id
    // if bankType is 2, 銀行來的的銷帳資料, then accountId is 0, 系統預設的交易帳戶
    // payway: 0:現金，1：支票，2：匯款：3：其他
    // ------------
    public void updateIncomeCostPay(int tran_id, BillPay billpay,
        int money, Date recordDate, int bankType, int acctId, 
        int payway, int userId, String payerName, int bunitId, 
        double org_amount, int exRateId, double exrate, 
        String checkInfo)
        throws Exception
    {
        if (acctId==0)
            throw new Exception("updateIncomeCostPay 時 帳戶 acctId 不可為 0");

        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);

        //存入現金帳戶
        Costpay2 cost = new Costpay2();
        cost.setCostpayDate(recordDate);
        cost.setCostpaySide(1); // 外部交易
        cost.setCostpaySideID(0);

        cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_TUITION); // -9999, make paidByStudent aware this is new version
        cost.setCostpayNumberInOut(0);
        cost.setCostpayFeeticketID(1); // 隨便設個>0的值告訴 search 這個有 feeticketId

        String sum="";

        if (bankType==1) 
        {
            cost.setCostpayPayway(Costpay2.PAYWAY_CASH);
            cost.setCostpayAccountType(1);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(1); 
        }
        else if (bankType==2) 
        {
            cost.setCostpayPayway(Costpay2.PAYWAY_WIRE);
            cost.setCostpayAccountType(2);
            cost.setCostpayAccountId(acctId); 
            cost.setCostpayLogWay(2);
            cost.setExRateId(exRateId);
            cost.setExrate(exrate);
            cost.setOrgAmount(org_amount);
        }
        else if (bankType==3) 
        {
            cost.setCostpayPayway(Costpay2.PAYWAY_CHEQUE);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_CHEQUE);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(3); 
        }
        else if (bankType==4) 
        { 
            cost.setCostpayPayway(Costpay2.PAYWAY_USD_CASH);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_USD_CASH);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(4); 
            cost.setExRateId(exRateId);
            cost.setExrate(exrate);
            cost.setOrgAmount(org_amount);
        }
        else if (bankType==5) 
        { 
            cost.setCostpayPayway(Costpay2.PAYWAY_USD_CHECK);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_USD_CHECK);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(5); 
            cost.setExRateId(exRateId);
            cost.setExrate(exrate);
            cost.setOrgAmount(org_amount);
        }


        cost.setCostpayLogPs(sum);
        cost.setCostpayCostNumber(0);
        cost.setCostpayIncomeNumber((int)money);
        cost.setCostpayLogDate(recordDate);
        cost.setCostpayLogId(userId);
        cost.setCostpayCostbookId(0);
        cost.setCostpayCostCheckId(0);
        cost.setCostpayStudentAccountId(billpay.getId()); // billpay 取代原來的 studentAccount
        cost.setCheckInfo(checkInfo);
        cost.setBunitId(bunitId);
        cpmgr.create(cost);

        // 這里假設馬禮遜一次付款不會跨
        ArrayList<BillPaid> bpaids = new BillPaidMgr(tran_id).retrieveList("billPayId=" + billpay.getId(), "");
        McaReceiptHelper mh = new McaReceiptHelper(tran_id, billpay, bpaids.get(0).getTicketId(), false);
        cost.setReceiptNo(mh.getReceiptNo());
        cpmgr.save(cost);
    }

    // ------------
    private void updateSalaryCostPay(int tran_id, BillPay billpay,
        int money, Date commitDate, int via, int acctId, 
        int userId, String title, int bunitId)
        throws Exception
    {
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);

        //存入現金帳戶
        Costpay2 cost = new Costpay2();
        cost.setCostpayDate(commitDate);
        cost.setCostpaySide(1); // 外部交易
        cost.setCostpaySideID(0);
        cost.setCostpayFeeticketID(0); 
        cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_SALARY); // make aware this is new version
        cost.setCostpayNumberInOut(1);  // out
        cost.setCostpaySalaryTicketId(1); // 隨便設個大的零的值讓 search 知道這是 salary

        String sum="";

        if (via==BillPay.SALARY_CASH) 
        {
            cost.setCostpayPayway(Costpay2.PAYWAY_CASH);
            cost.setCostpayAccountType(1);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(1); 
            sum = title +" 薪資 現金支付<br>";
        }
        else if (via==BillPay.SALARY_WIRE) 
        {
            cost.setCostpayPayway(Costpay2.PAYWAY_WIRE);
            cost.setCostpayAccountType(2);
            cost.setCostpayAccountId(acctId); //找系統預設的帳號
            cost.setCostpayLogWay(2);
            sum = title +" 薪資 匯款<br>";
        }
        else 
            throw new Exception("目前暫不支援");

        cost.setCostpayLogPs(sum);
        cost.setCostpayCostNumber(money);
        cost.setCostpayIncomeNumber(0);
        cost.setCostpayLogDate(commitDate);
        cost.setCostpayLogId(userId);
        cost.setCostpayLogWay(1);
        cost.setCostpayCostbookId(0);
        cost.setCostpayCostCheckId(0);
        cost.setCostpayStudentAccountId(billpay.getId()); // billpay 取代原來的 studentAccount
        cost.setBunitId(bunitId);
        cpmgr.create(cost);
    }
        
    public void sendWarningMessage(String msg)
    {
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String notify_str = sdf.format(new java.util.Date())+"\n"+msg;
            String urlstr = "http://218.32.77.180:8090/a/notify-peter.jsp?msg=" + java.net.URLEncoder.encode(notify_str, "UTF-8");
            phm.util.URLConnector.getContent(urlstr, 1000, "UTF-8");
        }
        catch (Exception e) 
        {}        
    }

    public void sendWarningException(Exception e, String msg)
    {
        try {
            ByteArrayOutputStream bout = new ByteArrayOutputStream();
            PrintWriter pr = new PrintWriter(new OutputStreamWriter(bout));
            e.printStackTrace(pr);
            pr.flush();
            bout.flush();
            String str = new String(bout.toByteArray());
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String notify_str = sdf.format(new java.util.Date())+"\n"+str + "\n" + msg;
            String urlstr = "http://218.32.77.180:8090/a/notify-peter.jsp?msg=" + java.net.URLEncoder.encode(notify_str, "UTF-8");
            bout.close();
            pr.close();
            phm.util.URLConnector.getContent(urlstr, 1000, "UTF-8");
        }
        catch (Exception ee) 
        {}
    }

    public static boolean paidByMembr(Costpay costpay)
    {
        int v = costpay.getCostpayFeePayFeeID();
        if (v==Costpay2.COSPAY_TYPE_TUITION || v==Costpay2.COSPAY_TYPE_CHEQUE_TUITION)
            return true;
        return false;
    }

    public static String[] getCostPayDescription(Costpay costpay, CostpayDescription cpd)
        throws Exception
    {
        BillPayInfo bps = cpd.getPayInfo(costpay);
        if (bps==null) {
            String[] ret = {"學費收入",""};
            return ret;
        }
        String[] ret = new String[2];
        ret[0] = "<img src=\"pic/feeIn.png\" border=0> 學費收入-" + bps.getMembrName();
        switch (bps.getVia())
        {
            case BillPay.VIA_INPERSON: ret[0] += ",臨櫃繳款"; break;
            case BillPay.VIA_ATM: ret[0] += ",ATM轉帳"; break;
            case BillPay.VIA_STORE: ret[0] += ",便利商店代收"; break; 
            case BillPay.VIA_CHECK: ret[0] += ",支票"; break; 
            case BillPay.VIA_WIRE: ret[0] += ",轉帳"; break; 
            case BillPay.VIA_CREDITCARD: ret[0] += ",信用卡"; break;             
        }
        
        ret[1] = "<a href=\"javascript:openwindow_phm('pay_info.jsp?sid="+
            bps.getMembrId()+"','繳費歷史',800,500,false);\">詳細資料</a>";
        return ret;
    }

    public static boolean isSalaryPay(Costpay costpay)
    {
        if (costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_SALARY)
            return true;
        return false;
    }

    public static boolean isRefund(Costpay costpay)
    {
        if (costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_REFUND)
            return true;
        return false;
    }

    public static String[] getSalaryCostPayDescription(Costpay costpay, CostpayDescription cpd)
        throws Exception
    {
        BillPayInfo bps = cpd.getPayInfo(costpay);
        if (bps==null) {
            String[] ret = {"薪資發放",""};
            return ret;
        }
        String[] ret = new String[2];
        ret[0] = "<img src=\"pic/salaryOut.png\" border=0> 薪資發放";
        switch (bps.getVia())
        {
            case BillPay.SALARY_CASH: ret[0] += ",現金"; break;
            case BillPay.SALARY_WIRE: ret[0] += ",轉帳"; break;
            case BillPay.SALARY_CHECK: ret[0] += ",支票"; break;        
        }
        
        ret[1] = "<a href=\"javascript:openwindow_phm('salary_payinfo.jsp?payId="+
            bps.getId()+"','薪資支付歷史',800,500,false);\">詳細資料</a>";
        return ret;
    }

    public static String[] getRefundCostPayDescription(Costpay costpay)
        throws Exception
    {
        ArrayList<BillPayInfo> bps = BillPayInfoMgr.getInstance().
            retrieveList("billpay.refundCostPayId=" + costpay.getId(), "");

        String[] ret = new String[2];
        ret[0] = "<img src=\"pic/costOut.png\" border=0> 退費,現金";        
        ret[1] = "";
        //ret[1] = "<a href=\"javascript:openwindow_phm('salary_payinfo.jsp?payId="+
        //    bps.getId()+"','退費記錄',800,500,false);\">詳細資料</a>";
        return ret;
    }


    private static SimpleDateFormat sdfx = new SimpleDateFormat("MM月dd日");
    private static DecimalFormat mnf = new DecimalFormat("###,###,##0");
    protected String prepareSmsNotifyMessage(PaySystem2 ps, Membr membr, BillPay bpay, 
        ArrayList<MembrInfoBillRecord> fully_paid)
    {
        String text = ps.getPaySystemMessageText();
        text = text.replace("XXX",membr.getName());
        text = text.replace("YYY", sdfx.format(PaymentPrinter.convertToTaiwanDate(bpay.getRecordTime())));
        switch (bpay.getVia()) {
        case BillPay.VIA_INPERSON: text = text.replace("ZZZ", "櫃臺繳款"); break;
        case BillPay.VIA_ATM: text = text.replace("ZZZ", "銀行轉帳"); break;
        case BillPay.VIA_STORE: text = text.replace("ZZZ", "便利商店代收"); break;            
        case BillPay.VIA_CHECK: text = text.replace("ZZZ", "支票"); break;            
        case BillPay.VIA_WIRE: text = text.replace("ZZZ", "轉帳"); break;            
        case BillPay.VIA_CREDITCARD: text = text.replace("ZZZ", "信用卡"); break;            
        }
        text = text.replace("MMM", mnf.format(bpay.getAmount()));
        Iterator<MembrInfoBillRecord> iter = fully_paid.iterator();
        StringBuffer sb = new StringBuffer();
        while (iter.hasNext())
        {
            MembrInfoBillRecord mi = iter.next();
            String bname = (mi.getBillMonth().getMonth()+1)+"月" + mi.getBillPrettyName();
            if (sb.length()>0) sb.append(",");
            sb.append(bname);
        }
        text = text.replace("FFF", sb.toString());
        return text;
    }

    protected ArrayList<String> getSmsNotifyPhones(PaySystem2 ps, jsf.Student student)
    {
        ArrayList<String> ret = new ArrayList<String>();
        jsf.JsfPay jp = jsf.JsfPay.getInstance();

        switch (ps.getPaySystemMessageTo()) {
            case PaySystem2.SMS_TARGET_DEFAULT :
                String mobileNum = "";
                switch(student.getStudentEmailDefault())
                {
                    case 0:
                        JsfAdmin ja=JsfAdmin.getInstance();
                        Contact[] cons=ja.getAllContact(student.getId());                        
                        if(cons !=null)
                            mobileNum=cons[0].getContactMobile();
                        break;
                    case 1:								
                        mobileNum=student.getStudentFatherMobile();
                        break;
                    case 2:
                        mobileNum=student.getStudentMotherMobile();
                        break;	
                }
                if (jp.checkMobile(mobileNum))
                    ret.add(jp.getRealPhone(mobileNum));
                break;

            case PaySystem2.SMS_TARGET_BOTH :
                if (jp.checkMobile(student.getStudentFatherMobile()))
                    ret.add(jp.getRealPhone(student.getStudentFatherMobile()));
                if (jp.checkMobile(student.getStudentMotherMobile()))
                    ret.add(jp.getRealPhone(student.getStudentMotherMobile()));
                break;
        }
        return ret;
    }

    /*
    class RangeMaker<T>
    {
        String makeRange(ArrayList<T> list, String getIdMethod)
            throws Exception
        {
            StringBuffer sb = new StringBuffer();
            Class c = list.get(0).getClass();
            Class[] paramTypes = {};
            Method m = c.getMethod(getIdMethod, paramTypes);

            Object[] params = {};
            Iterator<T> iter = list.iterator();
            while (iter.hasNext()) {
                T t = iter.next();
                Integer i = (Integer) m.invoke(t, params);
                if (sb.length()>0) sb.append(',');
                sb.append(i.intValue());
            }
            return sb.toString();
        }

        String makeStringRange(ArrayList<T> list, String getStringMethod)
            throws Exception
        {
            StringBuffer sb = new StringBuffer();
            Class c = list.get(0).getClass();
            Class[] paramTypes = {};
            Method m = c.getMethod(getStringMethod, paramTypes);

            Object[] params = {};
            Iterator<T> iter = list.iterator();
            while (iter.hasNext()) {
                T t = iter.next();
                String str = (String) m.invoke(t, params);
                if (sb.length()>0) sb.append(',');
                sb.append('\'');
                sb.append(str);
                sb.append('\'');
            }
            return sb.toString();
        }
    }
    */

    /*
        nums[0] = income_total;
        nums[1] = income_received;
        nums[2] = spending_total;
        nums[3] = spending_paid;
        nums[4] = revenue_total;
        nums[5] = revenue_received;
        nums[6] = salary_total;
        nums[7] = salary_paid;
    */
    public void getMonthlyNumbers(int bunitId, int[] nums, Date start, Date nextStart, 
        ArrayList<MembrInfoBillRecord> bills, ArrayList<MembrInfoBillRecord> salaries,
        ArrayList<Vitem> income, ArrayList<Vitem> cost)
        throws Exception
    {
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
        SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");

        BunitHelper bh = new BunitHelper();

        // find all bills of this month
        MembrInfoBillRecordMgr.getInstance().retrieveListX("billrecord.month>='"+sdf2.format(start)+
                "' and billrecord.month<'"+ sdf2.format(nextStart) +
                "' and bill.billType=" + Bill.TYPE_BILLING, "", bills, bh.getSpace("bill.bunitId", bunitId));

        int revenue_total = 0;
        int revenue_received = 0;
        Iterator<MembrInfoBillRecord> iter = bills.iterator();
        while (iter.hasNext()) {
            MembrInfoBillRecord bill = iter.next();
            revenue_total += bill.getReceivable();
            revenue_received += bill.getReceived();
        }

        // find all salaries of this month
        MembrInfoBillRecordMgr.getInstance().retrieveListX("billrecord.month>='"+sdf2.format(start)+
                "' and billrecord.month<'"+ sdf2.format(nextStart) +
                "' and bill.billType=" + Bill.TYPE_SALARY, "", salaries, bh.getSpace("bill.bunitId", bunitId));
        
        int salary_total = 0;
        int salary_paid = 0;
        iter = salaries.iterator();
        while (iter.hasNext()) {
            MembrInfoBillRecord salary = iter.next();
            salary_total += salary.getReceivable();
            salary_paid += salary.getReceived();
        }
        
        int income_total = 0;
        int income_received = 0;
        int spending_total = 0;
        int spending_paid = 0;
        /*
        Object[] objs = CostbookMgr.getInstance().retrieve("costbookAccountDate>='" + sdf.format(start) + 
            "' and costbookAccountDate<'" + sdf.format(nextStart) + "'","");
        for (int i=0; objs!=null&&i<objs.length; i++) {
            Costbook cb = (Costbook) objs[i];
            if (cb.getCostbookOutIn()==0) {
                income.add(cb);
                income_total += cb.getCostbookTotalMoney();
                income_received += cb.getCostbookPaiedMoney();
            }
            else {
                cost.add(cb);
                spending_total += cb.getCostbookTotalMoney();
                spending_paid += cb.getCostbookPaiedMoney();
            }
        }
        */
        ArrayList<Vitem> vitems = VitemMgr.getInstance().retrieveListX("recordTime>='" + sdf2.format(start) +
            "' and recordTime<'" + sdf2.format(nextStart) + "'","", bh.getSpace("bunitId", bunitId));
        Iterator<Vitem> iter2 = vitems.iterator();
        while (iter2.hasNext()) {
            Vitem vi = iter2.next();
            if (vi.getType()==Vitem.TYPE_SPENDING) {
                spending_total += vi.getTotal();
                spending_paid += vi.getRealized();
                cost.add(vi);
            }
            else {
                income_total += vi.getTotal();
                income_received += vi.getRealized();
                income.add(vi);
            }
        }

        nums[0] = income_total;
        nums[1] = income_received;
        nums[2] = spending_total;
        nums[3] = spending_paid;
        nums[4] = revenue_total;
        nums[5] = revenue_received;
        nums[6] = salary_total;
        nums[7] = salary_paid;
    }

    public void getNumbers(ArrayList<BillRecordInfo> targetRecords,
        // all members that has 帳單 in this records
        ArrayList<Membr> membrs,
        // membrId
        Map<Integer, Vector<MembrInfoBillRecord>> billMap,
        // ticketId
        Map<String, Vector<ChargeItemMembr>> feeMap,
        // chargeKey
        Map<String, Vector<DiscountInfo>> discountMap)
            throws Exception
    {
        getNumbers(targetRecords, membrs, billMap, feeMap, discountMap, null);
    }

    public void getNumbers(ArrayList<BillRecordInfo> targetRecords,
        // all members that has 帳單 in this records
        ArrayList<Membr> membrs,
        // membrId
        Map<Integer, Vector<MembrInfoBillRecord>> billMap,
        // ticketId
        Map<String, Vector<ChargeItemMembr>> feeMap,
        // chargeKey
        Map<String, Vector<DiscountInfo>> discountMap,
        // membrSmallItemId
        Map<String, Vector<ChargeItemMembr>> feeMap2)
            throws Exception
    {
        if (targetRecords.size()==0)
            return;

        // 把target 的 billrecords 的 id 取出
        String brids = new RangeMaker().makeRange(targetRecords, "getId");

        // 找出所有的帳單
        ArrayList<MembrInfoBillRecord> all_bills = MembrInfoBillRecordMgr.getInstance().
            retrieveList("billRecordId in (" + brids + ")", "");

        getBillNumbers(all_bills, membrs, billMap, feeMap, discountMap, feeMap2);
    }

    public void getBillNumbers(ArrayList<MembrInfoBillRecord> all_bills,
        // all members that has 帳單 in this records
        ArrayList<Membr> membrs,
        // membrId
        Map<Integer, Vector<MembrInfoBillRecord>> billMap,
        // ticketId
        Map<String, Vector<ChargeItemMembr>> feeMap,
        // chargeKey
        Map<String, Vector<DiscountInfo>> discountMap,
        // membrSmallItemId
        Map<String, Vector<ChargeItemMembr>> feeMap2)
            throws Exception
    {
        if (all_bills.size()==0)
            return;

        // 找出這些帳單的 membr, 并放到 billMap 里
        String membrIds = new RangeMaker().makeRange(all_bills, "getMembrId");
        MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "", membrs);
        new SortingMap(all_bills).doSort("getMembrId", billMap);

        String brids = new RangeMaker().makeRange(all_bills, "getBillRecordId");

        // 找出這批record 所有的 charge, 并放到 feeMap 里
        ArrayList<ChargeItemMembr> all_fees = ChargeItemMembrMgr.getInstance().retrieveList
            ("chargeitem.billRecordId in (" + brids + ") and charge.membrId in (" + membrIds + ")", "");

        new SortingMap(all_fees).doSort("getTicketId", feeMap);

        if (feeMap2!=null)
            new SortingMap(all_fees).doSort("getMembrSmallItemIdKey", feeMap2);
        
        String chargeIds = new RangeMaker().makeRange(all_fees, "getChargeItemId");
        ArrayList<DiscountInfo> all_discounts = DiscountInfoMgr.getInstance().
            retrieveList("chargeItemId in (" + chargeIds + ")", "");
        new SortingMap(all_discounts).doSort("getChargeKey", discountMap);
    }

    private String smsserver = "http://218.32.77.178/smsserver/do-send.jsp";
    protected String doSendSms(String sender, String phone, String msg)
        throws Exception
    {
        System.out.println("sending <" + phone + "> sms : " + msg);
        String url = smsserver + "?phone=" + phone + "&msg=" + java.net.URLEncoder.encode(msg, "UTF-8") + "&sender=" + sender;
        return phm.util.URLConnector.getContent(url, 3000, "UTF-8");
    }

    public void sendSms(PaySystem2 ps, String phone, String msg)
        throws Exception
    {
        if (ps.getPaySystemMessageActive()==9)
            throw new Exception("sms not enabled");
        if (!checkMobileFormat(phone))
            return;
        String companyCode = ps.getPaySystemCompanyStoreNickName();
        String result = doSendSms(companyCode, phone, msg);        
    }

    public boolean checkMobileFormat(String mobileNumber)
    {
        if (mobileNumber==null || mobileNumber.trim().length()==0)
            return false;
        int i = 0;
        if (mobileNumber.indexOf("+8869")>=0)
            i += 5;
        else if (mobileNumber.indexOf("09")>=0)
            i += 2;
        else
            return false;
        StringBuffer sb = new StringBuffer();
        while (i<mobileNumber.length()) {
            char c = mobileNumber.charAt(i);
            if (c>='0' && c<='9')
                sb.append(c);
            i++;
        }
        String n = sb.toString();
        return n.length()==8;
    }

    public void sendSmsNotifications(PaySystem2 ps, BillPay bpay, ArrayList<MembrInfoBillRecord> fully_paid)
    {
        try {
            Membr membr = MembrMgr.getInstance().find("id=" + bpay.getMembrId());
            String msg = prepareSmsNotifyMessage(ps, membr, bpay, fully_paid);
            Student student = (Student) ObjectService.find("jsf.Student", "id=" + membr.getSurrogateId());
            ArrayList<String> phones = getSmsNotifyPhones(ps, student);
            Iterator<String> iter = phones.iterator();
            while (iter.hasNext()) {
                String phone = iter.next();
                sendSms(ps, phone, msg);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    // public void refundMembr(int tran_id, Membr membr, int amount, Tradeaccount acct, User user, 
    public void refundMembr(int tran_id, Membr membr, int amount, int acctType, int acctId, User user, 
        ArrayList<BillPay> affected, int bunitId)
        throws Exception
    {
        // update costpay
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);

        // 提出現金帳戶
        Costpay2 cost = new Costpay2();
        cost.setCostpayDate(new Date());
        cost.setCostpaySide(1); // 外部交易
        cost.setCostpaySideID(0);
        cost.setCostpayFeeticketID(0); 
        cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_REFUND); // make paidByStudent aware this is new version
        cost.setCostpayNumberInOut(1); // this is 支出
        cost.setCostpayFeeticketID(1); // 隨便設個>0的值告訴 search 這個有 feeticketId

        cost.setCostpayPayway(Costpay2.PAYWAY_CASH); //0:現金
        cost.setCostpayAccountType(acctType);
        cost.setCostpayAccountId(acctId);
        cost.setCostpayLogWay(1); 
        String sum = "櫃臺退費 to "+membr.getName()+"<br>";

        cost.setCostpayLogPs(sum);
        cost.setCostpayCostNumber(amount);
        cost.setCostpayIncomeNumber(0);
        cost.setCostpayLogDate(new Date());
        cost.setCostpayLogId(user.getId());
        cost.setCostpayCostbookId(0);
        cost.setCostpayCostCheckId(0);
        //cost.setCostpayStudentAccountId(billpay.getId()); // billpay 取代原來的 studentAccount
        cost.setBunitId(bunitId);
        cpmgr.create(cost);

        BillPayMgr bpmgr = new BillPayMgr(tran_id);
        ArrayList<BillPay> history = bpmgr.retrieveList("membrId=" + membr.getId() + " and remain>0", 
            "order by id desc");
        // deduct from last one
        Iterator<BillPay> iter = history.iterator();
        while (iter.hasNext() && amount>0) {
            BillPay bp = iter.next();
            if (bp.getPending()>0)
                throw new Exception("未兌現支票不可退費");
            int remain = bp.getRemain();
            int refund = Math.min(remain, amount);
            remain -= refund;
            amount -= refund;
            if (bp.getRefundCostPayId()>0)
                throw new Exception("尚未支援多次退費。。");
            bp.setRefundCostPayId(cost.getId());
            bp.setRemain(remain);
            bpmgr.save(bp);
            affected.add(bp);
        }
        if (amount<0)
            throw new Exception("退費金額大於帳戶餘額");
    }

    // 銷完后 amount 一定要為 0, 不然不知要放到哪
    public Costpay2 realizeVitems(int tran_id, ArrayList<Vitem> vitems, Date payDate, 
        int acctType, int acctId, int amount, int vitemType, User user,String ps, 
        int bunitId, double org_amount, int exRateId, double exrate, String checkInfo)
        throws Exception
    {
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);

        //存入現金帳戶
        Costpay2 cost = new Costpay2();
        cost.setCostpayDate(payDate);
		if (payDate.compareTo(_sdffz.parse("2011-01-01"))<0)
		{
			throw new Exception("invaid date " + _sdffz.format(payDate));
		}
        cost.setCostpaySide(1); // 外部交易
        cost.setCostpaySideID(0);
        cost.setCostpayFeeticketID(0); 
        cost.setCostpayFeeticketID(0); 

        int pending = 0;
        if (acctType==1) 
        {
            cost.setCostpayPayway(Costpay2.PAYWAY_CASH);
            cost.setCostpayAccountType(1);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(Costpay2.ACCOUNT_TYPE_CASH); 
        }
        else if (acctType==2) 
        { 
            cost.setCostpayPayway(Costpay2.PAYWAY_WIRE);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_BANK);
            cost.setCostpayAccountId(acctId); //找系統預設的帳號
            cost.setCostpayLogWay(2);
            cost.setExRateId(exRateId);
            cost.setExrate(exrate);
            cost.setOrgAmount(org_amount);
        }
        else if (acctType==3) 
        { 
            cost.setCostpayPayway(Costpay2.PAYWAY_CHEQUE);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_CHEQUE);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(3); 
        }
        else if (acctType==4) 
        { 
            cost.setCostpayPayway(Costpay2.PAYWAY_USD_CASH);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_USD_CASH);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(4); 
            cost.setExRateId(exRateId);
            cost.setExrate(exrate);
            cost.setOrgAmount(org_amount);
        }
        else if (acctType==5) 
        { 
            cost.setCostpayPayway(Costpay2.PAYWAY_USD_CHECK);
            cost.setCostpayAccountType(Costpay2.ACCOUNT_TYPE_USD_CHECK);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(5); 
            cost.setExRateId(exRateId);
            cost.setExrate(exrate);
            cost.setOrgAmount(org_amount);
        }

        if (vitemType==Vitem.TYPE_SPENDING) {
            cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_SPENDING); // -10002
            cost.setCostpayCostNumber(amount);
            cost.setCostpayNumberInOut(1);
        }        
        else if (vitemType==Vitem.TYPE_INCOME) {
            cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_INCOME); // -10003
            cost.setCostpayIncomeNumber(amount);
            cost.setCostpayNumberInOut(0);
        }
        else if (vitemType==Vitem.TYPE_COST_OF_GOODS) {
            cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_COST_OF_GOODS); // -10006
            cost.setCostpayCostNumber(amount);
            cost.setCostpayNumberInOut(1);
        }

        // cost.setCostpayLogPs(sum);
        cost.setCostpayLogDate(payDate); // payDate need to be 入帳日期，因為帳戶列表使用這個日期來判斷
        cost.setCostpayLogId(user.getId());
        cost.setCostpayCostbookId(1); // 設 1 表是雜費
        cost.setCostpayCostCheckId(0);
        // cost.setCostpayStudentAccountId(billpay.getId()); // billpay 取代原來的 studentAccount
        cost.setBunitId(bunitId);
        cost.setCheckInfo(checkInfo);
        cpmgr.create(cost);
        
        VPaidMgr vpmgr = new VPaidMgr(tran_id);
        VitemMgr vimgr = new VitemMgr(tran_id);
        Iterator<Vitem> iter = vitems.iterator();
        //StringBuffer sb = new StringBuffer();
        while (iter.hasNext() && amount>0) {
            Vitem vi = iter.next();
            if (vi.getPaidstatus()==Vitem.STATUS_FULLY_PAID)
                continue;
            int unrealized_amount = vi.getTotal() - vi.getRealized();            
            if (unrealized_amount<=0) {
                vi.setPaidstatus(Vitem.STATUS_FULLY_PAID);
                vimgr.save(vi);
                continue;
            }
            int thispaid = 0;
            if (amount>=unrealized_amount) {
                vi.setRealized(vi.getTotal());
                vi.setPaidstatus(Vitem.STATUS_FULLY_PAID);
                amount -= unrealized_amount;
                thispaid = unrealized_amount;
            }
            else {
                vi.setRealized(vi.getRealized()+amount);
                vi.setPaidstatus(Vitem.STATUS_PARTLY_PAID);
                thispaid = amount;
                amount = 0;
            }
            //if (pending==1)
            //    vi.setPending(vi.getPending()+1); // 多張支票
            vimgr.save(vi);
            VPaid vp = new VPaid();
            vp.setCostpayId(cost.getId());
            vp.setVitemId(vi.getId());
            vp.setAmount(thispaid);
            vp.setBunitId(vi.getBunitId()); // 和 vitem 一樣，但未必和 costpay 一樣
            vpmgr.create(vp);
        }

        if(ps !=null && ps.length()>0)
            cost.setCostpayLogPs(ps); // sb.toString()+"<br>"+
        //else
            //cost.setCostpayLogPs(sb.toString());                
        cpmgr.save(cost);

        if (amount!=0)
            throw new Exception("m");

        return cost;
    }

    public static boolean isVpaid(Costpay costpay)
    {
        if (costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_SPENDING ||
            costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_INCOME ||
            costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_COST_OF_GOODS)
            return true;
        else if (costpay.getCostpayCostbookId()>0) { // 這是處理 henry 舊的資料
            if (costpay.getCostpayNumberInOut()==1)
                costpay.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_SPENDING);
            else
                costpay.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_INCOME);
            return true;
        }
        return false;
    }    

    public static String[] getVpaidCostPayDescription(Costpay costpay, CostpayDescription cpd, String backurl)
        throws Exception
    {
        String[] ret = new String[2];
        if (costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_SPENDING)
            ret[0] = "<img src=\"pic/costOut.png\" border=0> 雜費支出";
        else if (costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_INCOME)
            ret[0] = "<img src=\"pic/costIn.png\" border=0> 雜費收入";
        else if (costpay.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_COST_OF_GOODS)
            ret[0] = "<img src=\"pic/costIn.png\" border=0> 進貨成本";
        ret[0] += cpd.getVitemDescription(costpay);

        ret[1] = "<a href=\"spending_costpay.jsp?id="+costpay.getId();
        if (backurl!=null)
            ret[1] += "&backurl="+java.net.URLEncoder.encode(backurl);
        ret[1] += "\">詳細資料</a>";
        return ret;
    }

    public ArrayList<Costpay2> getVpaidForVitems(ArrayList<Vitem> vitems)
        throws Exception
    {
        if (vitems.size()==0)
            return null;
        String vids = new RangeMaker().makeRange(vitems, "getId");
        ArrayList<VPaid> paids = VPaidMgr.getInstance().retrieveList("vitemId in (" + vids + ") and amount>0", "");
        if (paids.size()==0)
            return null; 
        String costpayIds = new RangeMaker().makeRange(paids, "getCostpayId");
        return Costpay2Mgr.getInstance().retrieveList("id in (" + costpayIds + ")", "");
    }

    public ArrayList<Tag> getMainTags(String space)
        throws Exception
    {
        TagTypeMgr ttmgr = TagTypeMgr.getInstance();
        TagType tt = ttmgr.findX("main=1", space);
        if (tt==null) {
            ArrayList<TagType> tmp = ttmgr.retrieveListX("","",space);
            if (tmp.size()==0)
                return null;
            tt = tmp.get(0);
        }
        return TagMgr.getInstance().retrieveListX("typeId=" + tt.getId(), "", space);
    }

    public void ensureBillIntegrity(int tran_id, MembrBillRecord mbr)
        throws Exception
    {
        int bill_amount = 0;
        int charge_subtotal = 0;
        int discount_subtotal = 0;
        bill_amount = mbr.getReceivable();
        ChargeItemMembrMgr cismgr = new ChargeItemMembrMgr(tran_id);
        DiscountInfoMgr dimgr = new DiscountInfoMgr(tran_id);
        ArrayList<ChargeItemMembr> items = cismgr.retrieveList(
            "charge.membrId=" + mbr.getMembrId() + " and chargeitem.billRecordId=" + mbr.getBillRecordId(), "");
        Iterator<ChargeItemMembr> citer = items.iterator();
        while (citer.hasNext()) {
            ChargeItemMembr ci = citer.next();
            ArrayList<DiscountInfo> discounts = dimgr.retrieveList(
                "chargeItemId=" + ci.getChargeItemId() + " and membrId=" + mbr.getMembrId(), "");
            charge_subtotal += ci.getMyAmount();
            Iterator<DiscountInfo> diter = discounts.iterator();
            while (diter.hasNext()) {
                DiscountInfo di = diter.next();
                discount_subtotal += di.getAmount();
            }
        }
        if (bill_amount != (charge_subtotal - discount_subtotal)) {
System.out.println("### bill_amount=" + bill_amount + " charge_subtotal=" + charge_subtotal + " discount_subtotal=" + discount_subtotal);
            throw new Exception("f");
        }
    }

    private static Map<Integer,Vector<User>> __userMapById = null;
    public static String getUserName(int uid)
        throws Exception
    {
        if (__userMapById==null)
        {
            Object[] users2 = UserMgr.getInstance().retrieve("", "");
            __userMapById = new SortingMap().doSort(users2, new ArrayList<User>(), "getId");
        }

        Vector<User> vu = __userMapById.get(new Integer(uid));
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }

    public void updateBillPendingCheque(int tran_id, BillPay bpay, boolean pending_cheque)
        throws Exception
    {
        ArrayList<BillPaid> paids = new BillPaidMgr(tran_id).retrieveList("billPayId=" + bpay.getId(), "");
        if (paids.size()>0) { // 有可能=0, 因為已經退入學費帳戶
            String ticketIds = new RangeMaker().makeRange(paids, "getTicketId");   
            MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
            String q = "update membrbillrecord set pending_cheque=" + ((pending_cheque)?1:0) + 
                " where ticketId in (" + ticketIds + ")";
            mbrmgr.executeSQL(q);
        }
        BillPayMgr bpmgr = new BillPayMgr(tran_id);
        bpay.setPending((pending_cheque)?1:0);
        bpmgr.save(bpay);
    }

    public int adjustCashAccount(int tran_id, Date d, int acctType, int acctId,  int amount, User user, int bunitId)
        throws Exception
    {
        if (1==1)
            throw new Exception("Obsolete!");
        int diff = 0;
        JsfPay jp=JsfPay.getInstance();
        if (acctType==1) {
            IncomeCost ic = jp.getIncomeCost(1, acctId, 99, 99, d);
            diff = amount - (ic.getIncome()-ic.getCost());
        }
        else {
            IncomeCost ic = jp.getIncomeCost(2, acctId, 99, 99, d);
            diff = amount - (ic.getIncome()-ic.getCost());
        }

        if (diff==0)
            return 0;

        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);

        Costpay2 cost = new Costpay2();
        cost.setCostpayDate(d);
        cost.setCostpaySide(1); // 外部交易
        cost.setCostpaySideID(0);
        cost.setCostpayFeeticketID(0); 
        cost.setCostpayFeeticketID(0); 

        cost.setCostpayAccountType(acctType);
        cost.setCostpayAccountId(acctId);
        cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_INITIALIZE);

        if (diff<0) {
            cost.setCostpayCostNumber(0-diff);
            cost.setCostpayNumberInOut(1);  // 錢減少 = 支出
        }        
        else {
            cost.setCostpayIncomeNumber(diff);
            cost.setCostpayNumberInOut(0);  // 錢增加 = 收入
        }

        cost.setCostpayLogDate(d); // payDate need to be 入帳日期，因為帳戶列表使用這個日期來判斷
        cost.setCostpayLogId(user.getId());
        cost.setCostpayLogPs("帳戶初始化");
        cost.setBunitId(bunitId);
        cpmgr.create(cost);

        return diff;
    }


    // 資產有
    //    現金(0), 未兌現收款支票3, 應收(學費1, 雜費2)
    // 負債有
    //    預收款4, 未兌現付款支票5, 應付(應付薪資13, 雜費6), 
    // 股東權益有
    //    股東挹注7 提領8, 累計盈虧(學費9 薪資支出10 雜費收入11 雜費支出12)
    // 
    // ######################
    // numbers[0] : 現金
    // numbers[1] : 應收學費
    // numbers[2] : 應收雜費
    // numbers[3] : 未兌現收款支票
    // numbers[4] : 學費預收款
    // numbers[5] : 未兌現付款支票
    // numbers[6] : 應付雜費
    // numbers[7] : 股東挹注
    // numbers[8] : 提領
    // numbers[9] : 學費收入
    // numbers[10] : 薪資支出
    // numbers[11] : 雜費收入
    // numbers[12] : 雜費支出
    // numbers[13] : 應付薪資
    // numbers[14] : 現金調整
    // numbers[15] : 銷貨成本
    // numbers[16] : 進貨成本
    // numbers[17] : 應付存貨
    // numbers[18] : 雜費預付
    // numbers[19] : 雜費預收
    // numbers[20] : 薪資預付
    // numbers[21] : 存貨預付

    public void getAccountingNumbers(Date d, Map<Object, Integer/*餘額*/> cashaccounts, int[] numbers)
        throws Exception
    {
        // 問那天指的是那天結束，所以要用小於隔天來算
        Calendar ctmp = Calendar.getInstance();
        ctmp.setTime(d);
        ctmp.add(Calendar.DATE, 1);
        Date nextDay = ctmp.getTime();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        // 先算現金
        {
            Object[] objs = TradeaccountMgr.getInstance().retrieve("", ""); 
            JsfPay jp = JsfPay.getInstance();
            int total_cash = 0;
            for (int i=0; objs!=null && i<objs.length; i++) {
                Tradeaccount t = (Tradeaccount) objs[i];
                IncomeCost ic = jp.getIncomeCost(1, t.getId(), 99, 99, d);//getIncomeCost 里面有算 nextday, 所以傳d進去
                int c = ic.getIncome() - ic.getCost();
                cashaccounts.put(t, new Integer(c));
                total_cash += c;
            }
            objs = BankAccountMgr.getInstance().retrieve("", "");
            for (int i=0; objs!=null && i<objs.length; i++) {
                BankAccount b = (BankAccount) objs[i];
                IncomeCost ic = jp.getIncomeCost(2, b.getId(), 99, 99, d);//getIncomeCost 里面有算 nextday, 所以傳d進去
                int c = ic.getIncome() - ic.getCost();
                cashaccounts.put(b, new Integer(c));
                total_cash += c;
            }
            numbers[0] = total_cash; // ## 0
        }

        // 算到該日的未兌現支票有哪些, recordTime 小於 d 表示已登入了, cashed 大於 d 表示在 d 時還未兌現
        {
            ArrayList<ChequeSum> sum = ChequeSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + 
                "' and (cashed is NULL or cashed=0 or cashed>='" + sdf.format(nextDay) + "')", "");
            numbers[3] = sum.get(0).getReceivable(); // 未兌現收款支票
            numbers[5] = sum.get(0).getPayable(); // 未兌現付款支票
        }
System.out.println("### numbers[3] cheque_receivable = " + numbers[3]);

        // 學費收入,應收,預收 below
        {
            // 到 d day 學費的收入數字
            BillSum billsum = BillSumMgr.getInstance().retrieveList("billType=" + Bill.TYPE_BILLING + 
                " and month<'" + sdf.format(nextDay) + "'" , "").get(0);
            // 收到的錢 = 現金+未兌現支票-退費  (已兌現的已經算到現金里了)
            int money = 0;
            {
                 // 學費收款現金 ##### 1 #####
                IncomeCost ic = IncomeCostMgr.getInstance().retrieveList // 這是 henry 用學生帳戶的時期的
                    ("costpayStudentAccountId>0 and costpayFeeticketID=0 and costpayFeePayFeeID>=0 "
                      + " and costpayLogDate<'" + sdf.format(nextDay) + "'","").get(0);
                IncomeCost ic2 = IncomeCostMgr.getInstance().retrieveList // 這是后來新的 + henry 最早不用studentaccount時的
                    ("costpayFeeticketID>0 and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
                // ##### 1 #####
                ChequeSum cks = ChequeSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + "'" +
                    " and type=" + Cheque.TYPE_INCOME_TUITION + " and (cashed is NULL or cashed=0 or cashed>='" + sdf.format(nextDay) + "')", "").get(0);
                IncomeCost ic3 = IncomeCostMgr.getInstance().retrieveList("costpayLogDate<'" + sdf.format(nextDay) + "'" +
                    " and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_REFUND, "").get(0); 
                money = ic.getIncome() + ic2.getIncome() + cks.getReceivable() - ic3.getCost();
System.out.println("### money=" + money + " refund=" + ic3.getCost());
            }

            PaidSum realpaid = PaidSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + "'" +
                " and billType=" + Bill.TYPE_BILLING + " and month<'" + sdf.format(nextDay) + "'", "").get(0);
            numbers[1] = billsum.getReceivable() - realpaid.getSum();  // 學費應收 = 學費總額 - 已經被沖的學費
System.out.println("### 學費預收 = 收到的錢 - 已經被沖的學費=" + money + "-" + realpaid.getSum());
            numbers[4] = money - realpaid.getSum(); // 學費預收 = 收到的錢 - 已經被沖的學費
            numbers[9] = billsum.getReceivable(); // 學費收入
        }

        // 雜費收入,應收,預收 below
        {
            // 雜費收款
            VitemSum vs1 = VitemSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + 
                "' and type=" + Vitem.TYPE_INCOME, "").get(0);
            // 到 d 日的實際收款(現金+支票)
            IncomeCost ic = IncomeCostMgr.getInstance().retrieveList
                ("costpayCostbookId>0 and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_INCOME +" and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            // 沖以後的部分
            VPaidItemSum prepaid = VPaidItemSumMgr.getInstance().retrieveList(
                "recordTime>='" + sdf.format(nextDay) + "' and type=" + Vitem.TYPE_INCOME + 
                " and costpayCostbookId>0 and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_INCOME +
                " and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);

            numbers[19] = prepaid.getSum(); // 雜費預收
            numbers[2] = vs1.getTotal() - (ic.getIncome() - prepaid.getSum()); // 雜費應收 = 收入 - (收到的錢-沖以後的部分)
System.out.println("### 1=" + vs1.getTotal() + " 2=" + ic.getIncome() + " 3=" + prepaid.getSum());
            numbers[11] = vs1.getTotal(); // 雜費收入
        }
        
        // 雜費支出,應付,預付 below
        {
            // 雜費付款
            VitemSum vs1 = VitemSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + 
                "' and type=" + Vitem.TYPE_SPENDING, "").get(0);
            // 到 d 日的實際付款(現金+支票)
            IncomeCost ic = IncomeCostMgr.getInstance().retrieveList
                ("costpayCostbookId>0 and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SPENDING +" and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            // 沖以后的部分
            VPaidItemSum prepaid = VPaidItemSumMgr.getInstance().retrieveList(
                "recordTime>='" + sdf.format(nextDay) + "' and type=" + Vitem.TYPE_SPENDING + 
                " and costpayCostbookId>0 and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SPENDING +
                " and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            numbers[18] = prepaid.getSum(); // 雜費預付
System.out.println("### 雜費應付 = 支出 - (付出的錢-預付的部分) " + vs1.getTotal() + "-("+ic.getCost()+"-"+prepaid.getSum()+")");
            numbers[6] = vs1.getTotal() - (ic.getCost()-prepaid.getSum()); // 雜費應付 = 支出 - (付出的錢-預付的部分)
            numbers[12] =  vs1.getTotal(); // 雜費支出
        }


        // 薪資支出, 應付, 預付
        {
            BillSum salarysum = BillSumMgr.getInstance().retrieveList("billType=" + Bill.TYPE_SALARY + 
                " and month<'" + sdf.format(nextDay) + "'" , "").get(0);
            numbers[10] = salarysum.getReceivable(); // 薪資支出
            IncomeCost ic = IncomeCostMgr.getInstance().retrieveList
                ("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SALARY +" and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            PaidSum prepaid = PaidSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + "'" +
                " and billType=" + Bill.TYPE_SALARY + " and month>='" + sdf.format(nextDay) + "'", "").get(0);
/*
PaidSum paid = PaidSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + "'" +
    " and billType=" + Bill.TYPE_SALARY + " and month<'" + sdf.format(nextDay) + "'", "").get(0);
System.out.println("### 薪資已經沖的部分: " + paid.getSum());
*/
System.out.println("### 薪資應付 = 總額 - (已付的錢 - 預付) " + salarysum.getReceivable() + "-("+ic.getCost()+"-"+prepaid.getSum()+")");
            numbers[13] = salarysum.getReceivable() - ic.getCost() + prepaid.getSum(); // 薪資應付 = 總額 - (已付的錢 - 預付)
            numbers[20] = prepaid.getSum(); // 薪資預付
        }

        // 股東
        {
            IncomeCost ic4 = IncomeCostMgr.getInstance().retrieveList
                ("costpayOwnertradeId>0 and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            
            numbers[7] = ic4.getIncome(); // 股東挹注
            numbers[8] = ic4.getCost(); // 股東提領
        }

        // 初始化
        {
            IncomeCost ic6 = IncomeCostMgr.getInstance().retrieveList
                ("costpayFeePayFeeID="+Costpay2.COSPAY_TYPE_INITIALIZE+" and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            numbers[14] = ic6.getIncome() - ic6.getCost();
        }

        // 進貨成本, 銷貨成本, 存貨應付, 存貨預付
        {
            // ##### 庫存金額 ####### 
            // ##### 銷貨成本 #######
            // 庫存金額 = 到該日的進貨算出的成本 * 到該日的存貨
            // 銷貨成本 = 到該日的進貨算出的成本 * 到該日的銷貨數量
            ArrayList<InvInfo> inv_infos = InvInfoMgr.getInstance().
                retrieveList("orderDate<'"+sdf.format(nextDay)+"'", "group by pitemId");
            ArrayList<PitemOut> pitemouts = PitemOutMgr.getInstance().
                retrieveList("billrecord.month<'" + sdf.format(nextDay) + "'", "group by pitemId");
            Map<Integer, Vector<PitemOut>> pitemoutMap = new SortingMap(pitemouts).doSort("getPitemId");

            float saleCost = (float)0.0;
            int allCost = 0;
            Iterator<InvInfo> iter = inv_infos.iterator();
            while (iter.hasNext()) {
                InvInfo inv = iter.next();
                float unitCost = ((float)inv.getCost())/((float)inv.getQuantity());            
                Vector<PitemOut> pouts = pitemoutMap.get(new Integer(inv.getPitemId()));
                int invNum = inv.getQuantity();
                allCost += inv.getCost();
                if (pouts!=null) {
                    invNum -= pouts.get(0).getQuantity(); // 減掉出貨
                    saleCost += pouts.get(0).getQuantity() * unitCost; // 銷貨成本增加量
                }
            }

            VitemSum vs3 = VitemSumMgr.getInstance().retrieveList("recordTime<'" + sdf.format(nextDay) + 
                "' and type=" + Vitem.TYPE_COST_OF_GOODS, "").get(0);

            // 到 d 日的實際付款(現金+支票)
            IncomeCost ic = IncomeCostMgr.getInstance().retrieveList
                ("costpayCostbookId>0 and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_COST_OF_GOODS +" and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            //System.out.println("### allCost=" + allCost + " = vs3.getTotal=" + vs3.getTotal());
            numbers[15] = (int) saleCost; //銷貨成本
            numbers[16] = vs3.getTotal(); //進貨成本
            VPaidItemSum prepaid = VPaidItemSumMgr.getInstance().retrieveList(
                "recordTime>='" + sdf.format(nextDay) + "' and type=" + Vitem.TYPE_COST_OF_GOODS + 
                " and costpayCostbookId>0 and costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_COST_OF_GOODS +
                " and costpayLogDate<'" + sdf.format(nextDay) + "'", "").get(0);
            numbers[21] = prepaid.getSum(); // 存貨預付
            numbers[17] = vs3.getTotal() - (ic.getCost() - prepaid.getSum()); // 存貨應付 = 成本 - (付出的錢 - 預付的部分)
            // ######################   
        }
    }

    public ArrayList<ChargeItemMembr> getChargeItemMembrs(int tran_id, 
        ArrayList<Charge> charges, String spec)
        throws Exception
    {
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        String membrIds =  new RangeMaker().makeRange(charges, "getMembrId");
        return new ChargeItemMembrMgr(tran_id).retrieveList("charge.chargeItemId in (" + chargeItemIds + ") and " +
            "charge.membrId in (" + membrIds + ")", spec);
    }

    public Membr getStudentMembr(int studentId)
        throws Exception
    {
        return MembrMgr.getInstance().find("type=" + Membr.TYPE_STUDENT + " and surrogateId=" + studentId);
    }
}


