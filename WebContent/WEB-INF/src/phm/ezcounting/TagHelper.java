package phm.ezcounting;

import java.util.*;
import java.text.*;
import jsf.User;

public class TagHelper {

    protected Map<Integer, ArrayList<CitemTag>> citemtagMap = null;
    protected Map<Integer, TagType> tagtypeMap = null;
    private Map<Integer, BillChargeItem> bcitemMap = null;
    private boolean show_all = false;
    private Tag _tag = null;
    protected int tran_id = 0;
    protected int bunitId = 0;
    private jsf.PaySystem ps = null;

    public static TagHelper getInstance(jsf.PaySystem ps, int tran_id, int bunitId)
    {
        TagHelper ret = null;
        if (ps.getPagetype()==7)
            ret = new mca.McaTagHelper(tran_id);
        else 
            ret = new TagHelper(tran_id);
        ret.ps = ps;
        ret.bunitId = bunitId;
        return ret;
    }

    /*
    // ## 全部用上面的 constructor
    public static TagHelper getInstance(jsf.PaySystem ps)
    {
        TagHelper ret = null;
        if (ps.getPagetype()==7) {
            ret = new mca.McaTagHelper();
        }
        else {
            ret = new TagHelper();
        }
        ret.ps = ps;
        return ret;
    }
    */

    protected TagHelper() {}
    protected TagHelper(int tran_id) { this.tran_id = tran_id; }

    public void setup_tags(ArrayList<Tag> tags)
        throws Exception
    {
        if (citemtagMap!=null)
            return;
        String tagIds = new RangeMaker().makeRange(tags, "getId");
        ArrayList<CitemTag> citemtags = ((tran_id==0)?CitemTagMgr.getInstance():new CitemTagMgr(tran_id)).
            retrieveList("tagId in (" + tagIds + ")", "order by id desc");
        citemtagMap = new SortingMap(citemtags).doSortA("getTagId");
        String citemIds = new RangeMaker().makeRange(citemtags, "getChargeItemId");
        ArrayList<BillChargeItem> bcitems = ((tran_id==0)?BillChargeItemMgr.getInstance():new BillChargeItemMgr(tran_id)).
            retrieveList("chargeitem.id in (" + citemIds + ")", "");
        bcitemMap = new SortingMap(bcitems).doSortSingleton("getId");        
        tagtypeMap = new SortingMap(((tran_id==0)?TagTypeMgr.getInstance():new TagTypeMgr(tran_id)).
            retrieveList("", "")).doSortSingleton("getId");
    }

    public void setup(Tag tag)
        throws Exception
    {
        if (citemtagMap!=null)
            return;
        ArrayList<Tag> tmp = new ArrayList<Tag>();
        tmp.add(tag);
        setup_tags(tmp);
    }

    public String getTypeName(int typeId)
    {
        TagType tt = tagtypeMap.get(typeId); 
        return tt.getName();
    }

    public String getTagFullname(Tag t)
    {
        TagType tt = tagtypeMap.get(t.getTypeId());
        StringBuffer sb = new StringBuffer();
        if (tt!=null) {
            sb.append(tt.getName());
            sb.append('-');
        }
        sb.append(t.getName());
        return sb.toString();
    }

    /*
    public ArrayList<Tag> getCurrentTags()
    {
        return TagMgr.getInstance().retrieveList("status=" + Tag.STATUS_CURRENT, "order by typeId asc, rootTag asc, id desc");
    }
    */

    public ArrayList<Tag> getTags(boolean show_all, String query, String space)
        throws Exception
    {
        String q = "status=" + Tag.STATUS_CURRENT;
        if (show_all)
            q = "";
        if (query!=null && query.length()>0) {
            if (q.length()>0)
                q += " and ";
            q += query;
        }
        return ((tran_id==0)?TagMgr.getInstance():new TagMgr(tran_id)).
            retrieveListX(q, "order by typeId asc, progId asc, name asc", space);
    }

    public ArrayList<BillChargeItem> getBillChargeItem(Tag tag)
        throws Exception
    {
        if (citemtagMap==null)
            throw new Exception("please call setup first");
        ArrayList<CitemTag> citemtags = citemtagMap.get(tag.getId());
        ArrayList<BillChargeItem> ret = new ArrayList<BillChargeItem>();
        for (int i=0; citemtags!=null && i<citemtags.size(); i++) {
            ret.add(bcitemMap.get(citemtags.get(i).getChargeItemId()));
        }
        return ret;
    }

    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
    public String getBillChargeItemString(Tag tag, boolean show_date)
        throws Exception
    {
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(tag);

        StringBuffer sb = new StringBuffer();
        if (bcitems.size()>0) {
            for (int i=0; i<bcitems.size(); i++) {
                BillChargeItem bcitem = bcitems.get(i);
                sb.append(" [");
                if (show_date)
                    sb.append(sdf.format(bcitem.getMonth())+" ");
                sb.append(bcitem.getName() + "]");
            }
        }
        return sb.toString();
    }

    public ArrayList<Tag> getTagsForChargeItem(ChargeItem ci)
        throws Exception
    {
        ArrayList<CitemTag> cts = ((tran_id==0)?CitemTagMgr.getInstance():new CitemTagMgr(tran_id)).
            retrieveList("chargeItemId=" + ci.getId(), "");
        String tagIds = new RangeMaker().makeRange(cts, "getTagId");
        return ((tran_id==0)?TagMgr.getInstance():new TagMgr(tran_id)).retrieveList("id in (" + tagIds + ")", "");
    }

    public String getTagNamesForChargeItem(ChargeItem ci)
        throws Exception
    {
        ArrayList<Tag> tags = getTagsForChargeItem(ci);
        StringBuffer sb = new StringBuffer();
        if (tags.size()>0) {
            for (int i=0; i<tags.size(); i++) {
                Tag tag = tags.get(i);
                sb.append(" [" + tag.getName() + "]");
            }
        }
        return sb.toString();
    }

    public ArrayList<Tag> getHistory(Tag tag)
        throws Exception
    {
        ArrayList<Tag> taghistory = null;
        TagMgr tmgr = new TagMgr(tran_id);
        if (tag.getRootTag()>0) {
            taghistory = tmgr.retrieveList("rootTag=" + tag.getRootTag() + " and status!=" + Tag.STATUS_DELETED, 
                "order by id desc");
        }
        else {
            taghistory = new ArrayList<Tag>();
            taghistory.add(tag);
        }
        return taghistory;
    }

    public String getDeletectedConnectingHTML(Tag tag) 
    {
        return "";
    }

    public void removeVersion(Tag tag)
        throws Exception
    {
        ArrayList<Tag> myhistory = getHistory(tag);
        setup(tag);
        /*
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(tag);
        if (bcitems.size()>0)
        */
        String connectingHTML = getConnectingHTML(tag);
        if (connectingHTML.length()>0)
            throw new Exception("已連結收費不可刪除");
        TagMgr tmgr = new TagMgr(tran_id);
        if (tag.getStatus()==Tag.STATUS_CURRENT) { // 如果刪的是現在的，那就要找個歷史的浮出來
            for (int i=0; i<myhistory.size(); i++) {
                Tag t = myhistory.get(i);
                if (t.getStatus()==Tag.STATUS_HISTORY) {
                    t.setBranchTag(0);
                    t.setStatus(Tag.STATUS_CURRENT);
                    tmgr.save(t);
                    break;
                }
            }
        }
        tag.setStatus(Tag.STATUS_DELETED);
        tmgr.save(tag);
    }

    public Tag branchTag(int tran_id, Tag tag)
        throws Exception
    {
        TagMgr tmgr = new TagMgr(tran_id);
        Tag newt = tag.copy();
        if (tag.getRootTag()==0)
            tag.setRootTag(tag.getId());
        if (tag.getBranchTag()>0)
            throw new Exception("此標籤已經 branch 過");
        newt.setCreated(new Date());
        newt.setRootTag(tag.getRootTag());
        newt.setBranchVer(tag.getBranchVer()+1);
        tmgr.create(newt);

        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        ArrayList<TagMembr> tms = tmmgr.retrieveList("tagId=" + tag.getId(), "");
        for (int i=0; i<tms.size(); i++) {
            TagMembr tm = new TagMembr();
            tm.setTagId(newt.getId());
            tm.setMembrId(tms.get(i).getMembrId());
            tm.setBindTime(tms.get(i).getBindTime());
            tmmgr.create(tm);
        }

        tag.setStatus(Tag.STATUS_HISTORY);
        tag.setBranchTag(newt.getId());
        tag.setBranchTime(new Date());
        tmgr.save(tag);

        return newt;
    }
    
    // 畢業的結果就是留下新一期的空 tag, 然后里面的人status設成畢業
    // 所以如果還沒對應收費，就將人移除
    // 如果已經對應收費，就先 branch 在將人移除

    public void doGraduate(int tran_id, Tag tag)
        throws Exception
    {
        // 畢業就一定 branch
        _tag = branchTag(tran_id, tag);

        ArrayList<TagMembrStudent> tagstudents = new TagMembrStudentMgr(tran_id).
            retrieveList("tagId=" + tag.getId(),"");
      
        Student2Mgr smgr = new Student2Mgr(tran_id);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);

        for (int i=0; i<tagstudents.size(); i++) {
            Student2 s = smgr.find("id=" + tagstudents.get(i).getStudentId());
            s.setStudentStatus(99);
            smgr.save(s);
            tmmgr.executeSQL("delete from tagmembr where tagId=" + tag.getId() + 
                " and membrId=" + tagstudents.get(i).getMembrId());
        }
    }

    // 檢查是跟同樣 billitem 但比 o_ci 新, 比 n_ci 舊的連結
    private boolean needBranch(Tag t, ChargeItem o_ci, ChargeItem n_ci, BillRecord newbr,
        Map<Integer, ArrayList<ChargeItem>> tagitemMap, Map<Integer, BillRecord> billrecordMap)
    {
        ArrayList<ChargeItem> citems = tagitemMap.get(t.getId());
        // 如果 citem 中有
        for (int i=0; citems!=null&&i<citems.size(); i++) {
            ChargeItem ci = citems.get(i);
            if (ci.getBillItemId()==n_ci.getBillItemId()) {
                BillRecord br = billrecordMap.get(ci.getBillRecordId());
                if (br.getMonth().compareTo(newbr.getMonth())<0)
                    return true;
            }
        }
        return false;
    }

    public String fixNewChargeMembrIds(int tran_id, ChargeItem o_ci, ChargeItem n_ci, BillRecord newbr,
        Map<Integer, Tag> allTagMap, Map<Integer, ArrayList<ChargeItem>> tagitemMap,
        Map<Integer, BillRecord> billrecordMap)
        throws Exception
    {
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        // 策略：就是找到每個 chargeitem 的最新 version, 如果是自己，就 branch
        ArrayList<CitemTag> o_cts = new CitemTagMgr(tran_id).retrieveList("chargeItemId=" + o_ci.getId(), "");
        if (o_cts.size()==0)
            return "-1";
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<o_cts.size(); i++) {
            Tag t = allTagMap.get(o_cts.get(i).getTagId()); // 原 chargeItem 對應的 tag 之一
            int mytid = t.getId();
            // 先找最新的 branch 出來
            while (t.getBranchTag()>0) {
                t = allTagMap.get(t.getBranchTag());
            }
            // 如果最新的 tag 是停用的那就不用繼續了
            if (t.getStatus()==Tag.STATUS_HISTORY)
                return "-1";

            // 找到最新的後有兩種情況要 branch, 一個是跟自己連結, 一個是跟同樣 billitem 但比 o_ci 新, 比 n_ci 舊的連結
            if (t.getId()==mytid || needBranch(t, o_ci, n_ci, newbr, tagitemMap, billrecordMap)) {
                t = branchTag(tran_id, t);
                allTagMap.put(t.getId(), t);
            }
            
            CitemTag ct = new CitemTag();
            ct.setChargeItemId(n_ci.getId());
            ct.setTagId(t.getId());
            ctmgr.create(ct);

            if (sb.length()>0) sb.append(",");
            sb.append(t.getId());
        }
        ArrayList<TagMembr> tmembrs = new TagMembrMgr(tran_id).retrieveList("tagId in (" + sb.toString() + ")", "");
        return new RangeMaker().makeRange(tmembrs, "getMembrId");
    }

    private Map<Integer, ArrayList<TagMembrInfo>> tagmembrMap = null;
    public void prepareMembrTags(String membrIds)
        throws Exception
    {
        ArrayList<TagMembrInfo> tagmembrs = ((tran_id==0)?TagMembrInfoMgr.getInstance():new TagMembrInfoMgr(tran_id)).
            retrieveList("membrId in (" + membrIds + ") and "+ "tag.status=" + Tag.STATUS_CURRENT, "");
        tagmembrMap = new SortingMap(tagmembrs).doSortA("getMembrId");
    }

    public String getMembrTagString(int membrId)
        throws Exception
    {
        if (tagmembrMap==null)
            throw new Exception("call prepareTagMembrStudentInfo first!");
        ArrayList<TagMembrInfo> tagmembrs = tagmembrMap.get(membrId);
        if (tagmembrs==null)
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<tagmembrs.size(); i++) {
            if (sb.length()>0) sb.append(",");
            sb.append(tagmembrs.get(i).getTagName());
        }
        return sb.toString();
    }

    private Map<Integer, BillRecord> getBillRecordMap(ArrayList<BillChargeItem> bcitems)
        throws Exception
    {
        String billRecordIds = new RangeMaker().makeRange(bcitems, "getBillRecordId");
        return new SortingMap(((tran_id==0)?BillRecordMgr.getInstance():new BillRecordMgr(tran_id)).
            retrieveList("id in (" + billRecordIds + ")", "")).doSortSingleton("getId");
    }

    public void addTagMembr(int tran_id, int tid, String membrIds, jsf.User ud2)
        throws Exception
    {
        Tag tag = new TagMgr(tran_id).find("id=" + tid);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        Date now = new Date();
        ArrayList<Membr> membrs = mmgr.retrieveList("id in (" + membrIds + ")", "");
        for (int i=0; i<membrs.size(); i++) {
            TagMembr tm = new TagMembr();
            tm.setTagId(tag.getId());
            tm.setMembrId(membrs.get(i).getId());
            tm.setBindTime(now);
            tmmgr.create(tm);
        }

        setup(tag);
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(tag);
        EzCountingService ezsvc = EzCountingService.getInstance();
        VoucherService vsvc = new VoucherService(tran_id, bunitId);
        Map<Integer, BillRecord> billrecordMap = getBillRecordMap(bcitems);
        BunitHelper bh = new BunitHelper(tran_id);
        Date nextFreezeDay = ezsvc.getFreezeNextDay(bh.getSpace("bunitId", bunitId));
        for (int i=0; i<bcitems.size(); i++) {
            for (int j=0; j<membrs.size(); j++) {
                BillRecord br = billrecordMap.get(bcitems.get(i).getBillRecordId());
                Charge c = ezsvc.addChargeMembr(tran_id, bcitems.get(i), membrs.get(j).getId(), br, ud2.getId(), nextFreezeDay);
                vsvc.updateCharge(c, ud2.getId(), bcitems.get(i).getName()+"(加)");
            }
        }
    }

    public void removeTagMembr(int tran_id, int tid, String membrIds, jsf.User ud2)
        throws Exception
    {
        Tag tag = new TagMgr(tran_id).find("id=" + tid);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        tmmgr.executeSQL("delete from tagmembr where tagId=" + tid + " and membrId in (" + membrIds + ")");

        // 移掉 tagmembr 如果有影響收費項目也要處理收費和傳票的事
        setup(tag);
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(tag);
        EzCountingService ezsvc = EzCountingService.getInstance();
        VoucherService vsvc = new VoucherService(tran_id, bunitId);
        ChargeItemMembrMgr csmgr = new ChargeItemMembrMgr(tran_id);
        BunitHelper bh = new BunitHelper(tran_id);
        Date nextFreezeDay = ezsvc.getFreezeNextDay(bh.getSpace("bunitId", bunitId));
        for (int i=0; i<bcitems.size(); i++) {
            ArrayList<ChargeItemMembr> citems = csmgr.retrieveList("chargeItemId=" + 
                bcitems.get(i).getId() + " and membr.id in (" + membrIds + ")", "");
            for (int j=0; j<citems.size(); j++) {
                ChargeItemMembr cs = citems.get(j);
                try {
                    ezsvc.deleteCharge(tran_id, cs, ud2, true, nextFreezeDay);
                    vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"(刪)");
                }
                catch (Exception e) {
                    if (e.getMessage()!=null&&e.getMessage().equals("z")) {
                        MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("billRecordId=" + 
                            cs.getBillRecordId() + " and membrId=" + cs.getMembrId());
                        vsvc.genVoucherForBill(bill, ud2.getId(), "刪除" + bill.getTicketId());
                        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
                        sbrmgr.executeSQL("delete from membrbillrecord where ticketId='" + bill.getTicketId() + "'");
                    }
                    else
                        throw e;
                }
            }
        }
    }
    
    Map<Integer, ArrayList<ChargeItemMembr>> billrecordchargeMap = null;
    Map<String, ChargeItemMembr> chargeitemmembrMap = null;
    private void prepareFindChargeStatus(Tag tag)
        throws Exception
    {
        if (billrecordchargeMap!=null)
            return;
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(tag);
        String billrecordIds = new RangeMaker().makeRange(bcitems, "getBillRecordId");
        ArrayList<ChargeItemMembr> cimembrs = ((tran_id==0)?ChargeItemMembrMgr.getInstance():new ChargeItemMembrMgr(tran_id)).
            retrieveList("membrbillrecord.billRecordId in (" + billrecordIds + ")", "");
        chargeitemmembrMap = new SortingMap(cimembrs).doSortSingleton("getChargeKey");
        billrecordchargeMap = new SortingMap(cimembrs).doSortA("getMembrId");
    }

    public final static int CLEAN    = 0;
    public final static int LOCKED   = 1;
    public final static int PAID     = 2;
    public final static int EXISTED  = 3;
    public int findChargeStatusForTag(int membrId, Tag toTag)
        throws Exception
    {
        setup(toTag);
        prepareFindChargeStatus(toTag);
        ArrayList<ChargeItemMembr> citems = billrecordchargeMap.get(membrId);
        if (citems==null)
            return CLEAN;
        for (int i=0; i<citems.size(); i++) {
            if (citems.get(i).getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                return PAID;
            else if (citems.get(i).getPrintDate()>0)
                return LOCKED;
        }
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(toTag);
        for (int i=0; i<bcitems.size(); i++)
            if (chargeitemmembrMap.get(membrId+"#"+bcitems.get(i).getId())!=null)
                return EXISTED;

        return CLEAN;
    }

    private Tag get_prev_tag(Tag t)
        throws Exception
    {
        ArrayList<Tag> chain = tagrootMap.get(t.getRootTag());
        if (chain==null || chain.size()<2)
            return null;
        return chain.get(1);
    }
    Map<Integer, ArrayList<Tag>> tagrootMap = null;
    TagHelper myth = null;
    void prepareChain(ArrayList<Tag> tags)
        throws Exception
    {
        ArrayList<Tag> all_tags = ((tran_id==0)?TagMgr.getInstance():new TagMgr(tran_id)).retrieveList("", "order by id desc");
        tagrootMap = new SortingMap(all_tags).doSortA("getRootTag");
        ArrayList<Tag> prev_tags = new ArrayList<Tag>();
        for (int i=0; i<tags.size(); i++) {
            Tag prev_tag = get_prev_tag(tags.get(i));
            if (prev_tag!=null)
                prev_tags.add(prev_tag);
        }
        myth = TagHelper.getInstance(ps, tran_id, bunitId);
        myth.setup_tags(prev_tags);
    }

    // 在加學生時用的, 如果最新一期沒有連結但舊一期有則回傳舊一期的
    public String getBillChargeItemStringInChain(ArrayList<Tag> tags, Tag tag)
        throws Exception
    {
        if (tagrootMap==null) {
            setup_tags(tags);
            prepareChain(tags);
        }
        String str = getBillChargeItemString(tag, true);
        if (str.length()>0)
            return str;
        // tag 沒有連, 要看 tag 的上一期有沒有
        Tag pt = get_prev_tag(tag);
        if (pt==null)
            return "";
        return myth.getBillChargeItemString(pt, true);
    }

    public void addMembrToChain(int tran_id, int tagId, int membrId, boolean addCharge, User user)
        throws Exception
    {
        // 要 addCharge 就要找到有連結收費那個 tag 加, 如果是前一期, 加完還要在加本期
        // 不要 addCharge 就要找到最后一期, 如果是自己 就要 branch
        TagMgr tmgr = new TagMgr(tran_id);
        ArrayList<Tag> tags = new ArrayList<Tag>();
        Tag t = tmgr.find("id=" + tagId);
        tags.add(t);
        setup_tags(tags);
        prepareChain(tags);
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(t);
        if (addCharge) {
            if (bcitems.size()>0)
                addTagMembr(tran_id, tagId, membrId+"", user);
            else { 
                Tag pt = get_prev_tag(t);
                addTagMembr(tran_id, pt.getId(), membrId+"", user);
                addTagMembr(tran_id, tagId, membrId+"", user);
            }
        }
        else {
            ArrayList<Tag> chain = tagrootMap.get(t.getRootTag());
            if (bcitems.size()>0)
                t = branchTag(tran_id, t);
            addTagMembr(tran_id, t.getId(), membrId+"", user);
        }
    }

    // ############# for display, can be overload by McaTagHelper
    public String getConnectingHTML(Tag tag)
        throws Exception
    {
        ArrayList<BillChargeItem> bcitems = getBillChargeItem(tag);

        StringBuffer sb = new StringBuffer();
        if (bcitems.size()>0) {
            for (int i=0; i<bcitems.size(); i++) {
                BillChargeItem bcitem = bcitems.get(i);
                sb.append("&nbsp;<a target=_blank href=\"editChargeItem.jsp?cid="+bcitem.getId()+"\">" + sdf.format(bcitem.getMonth()) + " " + bcitem.getName() + "</a><br>");
            }
        }
        return sb.toString();
    }
}
