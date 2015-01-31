package mca;

import phm.ezcounting.*;
import java.util.*;
import java.text.*;
import jsf.User;

public class McaTagHelper extends TagHelper {
    public McaTagHelper() {}
    public McaTagHelper(int tran_id)
    {
        super(tran_id);
    }

    // ############# for display, can be overload by McaTagHelper
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    private Map<Integer, ArrayList<CitemTag>> mcacitemtagMap = null;
    private Map<Integer, McaFee> mcafeeMap = null;

    public void setup_tags(ArrayList<Tag> tags)
        throws Exception
    {
        if (citemtagMap!=null)
            return;
        String tagIds = new RangeMaker().makeRange(tags, "getId");
        ArrayList<CitemTag> citemtags = ((tran_id==0)?CitemTagMgr.getInstance():new CitemTagMgr(tran_id)).
            retrieveList("tagId in (" + tagIds + ")", "order by id desc");
        ArrayList<CitemTag> empty = new ArrayList<CitemTag>();
        citemtagMap = new SortingMap(empty).doSortA("getTagId"); // 讓 parent 以為有但是是空的
        // mca 的 CitemTag 的 chargeItemId 放的是 McaFee.id
        String mcaFeeIds = new RangeMaker().makeRange(citemtags, "getChargeItemId");
        ArrayList<McaFee> fees = new McaFeeMgr(tran_id).retrieveList("id in (" + mcaFeeIds + ")", "");
        mcacitemtagMap = new SortingMap(citemtags).doSortA("getTagId");
        mcafeeMap = new SortingMap(fees).doSortSingleton("getId");
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

    public void deleteFeeTags(McaFee fee)
        throws Exception
    {
        /*
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        ArrayList<CitemTag> citags = ctmgr.retrieveList("chargeItemId=" + fee.getId(), "");
        if (citags.size()==0)
            return;
        String tagIds = new RangeMaker().makeRange(citags, "getTagId");
        */
        ArrayList<Tag> tags = getFeeTags(fee);
        for (int i=0; i<tags.size(); i++)
            removeVersion(tags.get(i));
    }

    void fixLeaveStudent(Tag t)
        throws Exception
    {
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        ArrayList<TagMembr> tms = tmmgr.retrieveList("tagId=" + t.getId(), "");
        String membrIds = new RangeMaker().makeRange(tms, "getMembrId");
        ArrayList<TagMembrStudent> leaves = new TagMembrStudentMgr(tran_id).retrieveList
            ("membr.id in (" + membrIds + ") and studentStatus=99", "");
        if (leaves.size()==0)
            return;
        membrIds = new RangeMaker().makeRange(leaves, "getMembrId");
        tmmgr.executeSQL("delete from tagmembr where tagId=" + t.getId() + " and membrId in (" + membrIds + ")");
    }

    public ArrayList<Tag> getFeeTags(McaFee fee)
        throws Exception
    {
        return getFeeTags(fee, null);
    }

    public ArrayList<Tag> getFeeTags(McaFee fee, String space)
        throws Exception
    {
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        ArrayList<CitemTag> citags = ctmgr.retrieveList("chargeItemId=" + fee.getId(), "");
        ArrayList<Tag> ret = null;
        if (citags.size()==0) {
            // 找到所有 current 的，如果已經連結別的 fee, 就要先 branch
            ret = new ArrayList<Tag>();
            BunitHelper bh = new BunitHelper(tran_id);
            ArrayList<Tag> tags = getTags(false, "", null);
            String tagIds = new RangeMaker().makeRange(tags, "getId");
            citags = ctmgr.retrieveList("tagId in (" + tagIds + ")", "");
            Map<Integer, ArrayList<CitemTag>> citemtagMap = new SortingMap(citags).doSortA("getTagId");
            for (int i=0; i<tags.size(); i++) {
                Tag t = tags.get(i);
                if (citemtagMap.get(t.getId())!=null) {
                    t = branchTag(tran_id, t);
                    fixLeaveStudent(t);
                }

                CitemTag ct = new CitemTag();
                ct.setTagId(t.getId());
                ct.setChargeItemId(fee.getId());
                ctmgr.create(ct);
                ret.add(t);
            }
        }
        else {
            String tagIds = new RangeMaker().makeRange(citags, "getTagId");
            ret = new TagMgr(tran_id).retrieveList("id in (" + tagIds + ")", "order by typeId asc");
        }
        
        if (space!=null) {
            String tagIds = new RangeMaker().makeRange(ret, "getId");
            ret = new TagMgr(tran_id).retrieveListX("id in (" + tagIds + ")", "order by typeId asc, id asc", space);
        }

        return ret;
    }

    public String getConnectingHTML(Tag tag)
        throws Exception
    {
        ArrayList<CitemTag> citemtags = mcacitemtagMap.get(tag.getId());
        if (citemtags==null || citemtags.size()==0)
            return "";
        McaFee fee = mcafeeMap.get(citemtags.get(0).getChargeItemId());
        if (fee==null)
            return "";
        if (fee.getStatus()==McaFee.STATUS_DELETED)
            return "";
        if (fee.getTitle().length()>35)
            return fee.getTitle().substring(0,35) + "..";
        return fee.getTitle();
    }

    public String getDeletectedConnectingHTML(Tag tag)
    {
        try {
            ArrayList<CitemTag> citemtags = mcacitemtagMap.get(tag.getId());
            if (citemtags==null || citemtags.size()==0)
                return "";
            McaFee fee = mcafeeMap.get(citemtags.get(0).getChargeItemId());
            if (fee==null)
                return "";
            if (fee.getStatus()==McaFee.STATUS_DELETED) {
                String str = "<font color=lightgrey>(Deleted)";
                if (fee.getTitle().length()>35)
                    str += fee.getTitle().substring(0,28) + "..";
                else
                    str += fee.getTitle();
                return str + "</font>";
            }
        }
        catch (Exception e) {}
        return "";
    }
}
