package mca;

import phm.ezcounting.*;
import java.util.*;
import java.text.*;
import jsf.User;

public class MainTagHelper 
{
    private Map<Integer, TagMembr> tmsMap = null;
    private Map<Integer, Tag> tagMap = null;
    public MainTagHelper(String membrIds, int bunitId) 
        throws Exception
    {
        BunitHelper bh = new BunitHelper();
        String studentspace = bh.getStudentSpace("bunitId", bunitId);
        /*
        TagType tt = TagTypeMgr.getInstance().findX("main=1", studentspace);
        if (tt==null)
            return;
        ArrayList<Tag> tags = TagMgr.getInstance().retrieveListX("typeId=" + tt.getId() + 
            " and status=" + Tag.STATUS_CURRENT, "", studentspace);
        if (tt==null)
            return;
        */
        ArrayList<TagType> tt = TagTypeMgr.getInstance().retrieveList("main=1","");
        String typeIds = new RangeMaker().makeRange(tt, "getId");
        ArrayList<Tag> tags = TagMgr.getInstance().retrieveList("typeId in (" + typeIds + 
            ") and status=" + Tag.STATUS_CURRENT, "");

        String tagIds = new RangeMaker().makeRange(tags, "getId");
        ArrayList<TagMembr> tms = TagMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + 
            ") and tagId in (" + tagIds + ")", "");
        tmsMap = new SortingMap(tms).doSortSingleton("getMembrId");
        tagMap = new SortingMap(tags).doSortSingleton("getId");
    }

    public String getMainTagName(int membrId)
        throws Exception
    {
        TagMembr tm = tmsMap.get(membrId);
        if (tm==null)
            return "其他";
        return tagMap.get(tm.getTagId()).getName();
    }
}
