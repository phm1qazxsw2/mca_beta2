<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%!
    Tag transformNewVersion(int tran_id, Tag tag)
        throws Exception
    {
        TagMgr tmgr = new TagMgr(tran_id);
        tag.setRootTag(tag.getId());
        tmgr.save(tag);

        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        TagMembrStudentMgr tmsmgr = new TagMembrStudentMgr(tran_id);
        // 找出畢業的人從 group 里刪掉
        ArrayList<TagMembrStudent> tms = tmsmgr.retrieveList("tagId=" + tag.getId() + " and (not studentStatus in (3,4))", "");
        for (int i=0; i<tms.size(); i++) {
            tmmgr.executeSQL("delete from tagmembr where tagId=" + tag.getId() + " and membrId=" + tms.get(i).getMembrId());
        }
        return tag;
    }

    int getMembrSize(int tran_id, Tag tag)
        throws Exception
    {
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        return tmmgr.numOfRows("tagId=" + tag.getId());
    }

    ArrayList<ChargeItem> findChargeItemForTag(int tran_id, Tag t)
        throws Exception
    {
        ArrayList<ChargeItem> ret = new ArrayList<ChargeItem>();
        ArrayList<Charge> charges = new ChargeMgr(tran_id).retrieveList("tagId=" + t.getId(), "");
        if (charges.size()==0)
            return ret;
        // 先找出所有的不同的 chargeItem
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        ArrayList<ChargeItem> citems = new ChargeItemMgr(tran_id).retrieveList("id in (" + chargeItemIds + ")",
            "order by id desc");
        // 同樣 billitemId 的我們只要最新的
        Map<Integer, ArrayList<ChargeItem>> citemsMap = new SortingMap(citems).doSortA("getBillItemId");
        // return 最新的
        Iterator<Integer> iter = citemsMap.keySet().iterator();
        while (iter.hasNext()) {
            ArrayList<ChargeItem> tmp = citemsMap.get(iter.next());
            ret.add(tmp.get(0)); // 最前的 id 最大 最新
        }
        return ret;
    }
%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        
        CitemTagMgr ctmgr = new CitemTagMgr(tran_id);
        TagHelper th = new TagHelper();

        ArrayList<Tag> tags = new TagMgr(tran_id).retrieveList("", "");

        for (int i=0; i<tags.size(); i++) {
            Tag t = tags.get(i);
            if (t.getRootTag()>0)
                continue; // 處理過了
            ArrayList<ChargeItem> myitems = findChargeItemForTag(tran_id, t);
            Tag prevTag = transformNewVersion(tran_id, t);
            if (myitems.size()==0)
                continue; // 沒有對應任何收費
            Tag curTag = th.branchTag(tran_id, prevTag); // 做好這一期後(因為人數一定不對) 直接就 branch 下一期
            System.out.println("prevTag=" + getMembrSize(tran_id, prevTag) + " curTag=" + getMembrSize(tran_id, curTag));
            for (int j=0; j<myitems.size(); j++) {
                ChargeItem ci = myitems.get(j);
                CitemTag ct = new CitemTag();
                ct.setChargeItemId(ci.getId());
                ct.setTagId(prevTag.getId());
                ctmgr.create(ct);
            }
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!