package phm.ezcounting;

import java.lang.reflect.*;
import java.util.*;

public class RangeMaker<Y,T>
{
    private Map<Y,Y> excludes = null;
    public RangeMaker() {}

    public RangeMaker(Map<Y,Y> excludes) 
    {
        this.excludes = excludes;
    }

    public static final String NOTFOUND = "-9999999";

    // return NOTFOUND if no id is found. the outer program hopefully will not 
    // search anything when idstring is NOTFOUND
    public String makeRange(ArrayList<T> list, String getIdMethod)
        throws Exception
    {
        StringBuffer sb = new StringBuffer();
        if (list.size()==0)
            return NOTFOUND;
        Class c = list.get(0).getClass();
        Class[] paramTypes = {};
        Method m = c.getMethod(getIdMethod, paramTypes);
        HashMap tmp = new HashMap();

        Object[] params = {};
        Iterator<T> iter = list.iterator();
        while (iter.hasNext()) {
            T t = iter.next();
            Y i = (Y) m.invoke(t, params);
            if (tmp.get(i)!=null)
                continue;
            if (excludes!=null && excludes.get(i)!=null)
                continue;
            if (sb.length()>0) sb.append(',');
            sb.append(i);
            tmp.put(i, i);
        }
        if (sb.length()==0)
            return NOTFOUND;
        return sb.toString();
    }

    public String makeRange(Vector<T> list, String getIdMethod)
        throws Exception
    {
        ArrayList<T> al = new ArrayList<T>(list.size());
        for (int i=0; i<list.size(); i++)
            al.add(list.get(i));
        return makeRange(al, getIdMethod);
    }

    public String makeRange(Object[] objs, String getIdMethod)
        throws Exception
    {
        if (objs==null)
            return "";
        ArrayList<T> al = new ArrayList<T>(objs.length);
        for (int i=0; i<objs.length; i++)
            al.add((T)objs[i]);
        return makeRange(al, getIdMethod);
    }
}

