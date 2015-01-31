<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        McaFee fee30 = new McaFeeMgr(tran_id).find("id=30");
        McaFee fee34 = new McaFeeMgr(tran_id).find("id=34");
        // 把 30 的 TagMembr 設的和 34 一樣
        McaTagHelper th = new McaTagHelper(tran_id);
        ArrayList<Tag> feetags30 = th.getFeeTags(fee30);
        ArrayList<Tag> feetags34 = th.getFeeTags(fee34);

        String tagIds = new RangeMaker().makeRange(feetags30, "getId");
        ArrayList<Tag> tags30 = new TagMgr(tran_id).retrieveList("id in (" + tagIds + ")", "");
        ArrayList<TagMembr> tms30 = new TagMembrMgr(tran_id).retrieveList("tagId in (" + tagIds + ")", "");
        Map<Integer, ArrayList<TagMembr>> tms30Map = new SortingMap(tms30).doSortA("getTagId");
        tagIds =  new RangeMaker().makeRange(feetags34, "getId");
        ArrayList<Tag> tags34 = new TagMgr(tran_id).retrieveList("id in (" + tagIds + ")", "");
        ArrayList<TagMembr> tms34 = new TagMembrMgr(tran_id).retrieveList("tagId in (" + tagIds + ")", "");
        Map<Integer, ArrayList<TagMembr>> tms34Map = new SortingMap(tms34).doSortA("getTagId");

        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        Map<Integer, Tag> roottag30Map = new SortingMap(tags30).doSortSingleton("getRootTag");
        for (int i=0; i<tags34.size(); i++) {
            Tag t34 = tags34.get(i);
            Tag t30 = roottag30Map.get(t34.getRootTag());
            // 把 t30 的 tms 弄成 跟 t34 一樣
            ArrayList<TagMembr> t30tms = tms30Map.get(t30.getId());
            ArrayList<TagMembr> t34tms = tms34Map.get(t34.getId());
            Map<Integer, TagMembr> t30tmsMap = new SortingMap(t30tms).doSortSingleton("getMembrId");

            for (int j=0; t34tms!=null&&j<t34tms.size(); j++) {
                TagMembr tm = t34tms.get(j);
                if (t30tmsMap.get(tm.getMembrId())==null) {
                    tm.setTagId(t30.getId());
                    tmmgr.create(tm);
                    out.println("add " + tm.getMembrId() + " tagId=" + tm.getTagId() + "<br>");
                }
                else {
                    t30tmsMap.remove(tm.getMembrId());
                }
            }
            Iterator<Integer> iter = t30tmsMap.keySet().iterator();
            while (iter.hasNext()) {
                TagMembr tm = t30tmsMap.get(iter.next());
                out.println("delete " + tm.getMembrId() + " tagId=" + tm.getTagId() + "<br>");
                tmmgr.executeSQL("delete from tagmembr where tagId=" + tm.getTagId() + " and membrId=" + tm.getMembrId());
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