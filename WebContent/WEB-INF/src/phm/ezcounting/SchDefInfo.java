package phm.ezcounting;

import java.util.*;
import java.text.*;

public class SchDefInfo {
    Map<Integer, ArrayList<SchDef>> schdefMap = new LinkedHashMap<Integer, ArrayList<SchDef>>();

    public SchDefInfo(ArrayList<SchDef> schdefs)
        throws Exception
    {
        schdefMap = new SortingMap(schdefs).doSortA("getMyRootId");
    }

    public Iterator<Integer> getRootIterator()
    {
        return schdefMap.keySet().iterator();
    }

    public String getName(Integer rootId)
    {
        ArrayList<SchDef> list = schdefMap.get(rootId);
        return list.get(list.size()-1).getName();
    }

    public SchDef findApplied(Integer schdefRootId, Date d)
        throws Exception
    {
        ArrayList<SchDef> list = schdefMap.get(schdefRootId);
        int cur = 0;
        while (cur<list.size() && !list.get(cur).inDateRange(d))
            cur ++;
        if (cur>=list.size())
            return null;
        return list.get(cur);
    }
}
