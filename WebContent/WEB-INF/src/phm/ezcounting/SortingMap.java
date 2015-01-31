package phm.ezcounting;

import java.util.*;
import java.lang.reflect.*;

public class SortingMap<Y,T>
{
    ArrayList<T> list;

    public SortingMap(ArrayList<T> list)
    {
        this.list = list;
    }

    public SortingMap(Object[] l)
    {
        this.list = new ArrayList<T>((l==null)?0:l.length);
        for (int i=0; l!=null&&i<l.length; i++)
            this.list.add((T)l[i]);
    }

    public SortingMap(Vector<T> v)
    {
        this.list = new ArrayList<T>();
        for (int i=0; v!=null&&i<v.size(); i++)
            this.list.add(v.get(i));
    }

    public SortingMap()
    {
    }


    public Map<Y, Vector<T>> doSort(Object[] objs, ArrayList<T> l, String methodName)
        throws Exception
    {
        for (int i=0; objs!=null && i<objs.length; i++)
            l.add((T)objs[i]);
        this.list = l;
        return doSort(methodName);
    }

    public Map<Y,T> doSortSingleton(String getIdMethod)
        throws Exception
    {
        Map<Y, Vector<T>> m = doSort(getIdMethod);
        Iterator<Y> iter = m.keySet().iterator();
        Map<Y, T> ret = new LinkedHashMap<Y, T>();
        while (iter.hasNext()) {
            Y y = iter.next();
            Vector<T> vt = m.get(y);
            ret.put(y, (vt!=null)?vt.get(0):null);
        }
        return ret;
    }



    public Map<Y,Vector<T>> doSort(String getIdMethod)
        throws Exception
    {
        Map<Y, Vector<T>> ret = new LinkedHashMap<Y, Vector<T>>();
        doSort(getIdMethod, ret);
        return ret;
    }

    public void doSort(String getIdMethod, Map<Y,Vector<T>> ret)
        throws Exception
    {
        if (list==null || list.size()==0)
            return;
        Class c = ((T)list.get(0)).getClass();
        Class[] paramTypes = {};
        Method m = c.getMethod(getIdMethod, paramTypes);

        Object[] params = {};
        Iterator<T> iter = list.iterator();
        while (iter.hasNext()) {
            T t = iter.next();
            Y r = (Y) m.invoke(t, params);
            Vector<T> v = ret.get(r);
            if (v==null) {
                v = new Vector<T>();
                ret.put(r, v);
            }
            v.add(t);
        }
    }


    public ArrayList<T> descendingBy(String getIdMethod)
        throws Exception
    {
        ArrayList<T> ret = new ArrayList<T>();
        if (list.size()==0)
            return ret;
        IntComparator comp = new IntComparator(getIdMethod);
        Object[] objs = new Object[list.size()];
        Iterator<T> iter = list.iterator();
        int i = 0;
        while (iter.hasNext())
            objs[i++] = iter.next();
        Arrays.sort(objs, comp);
        for (i=objs.length-1; i>=0; i--) {
            T t = (T)objs[i];
            ret.add(t);
        }
        return ret;
    }

    class IntComparator implements Comparator
    {
        String getter = null;
        IntComparator(String getter)
        {
            this.getter = getter;
        }

        public int compare(Object o1, Object o2)
        {
            try {
                Class c = o1.getClass();
                Class[] paramTypes = {};
                Method m = c.getMethod(this.getter, paramTypes);
                
                Object[] params = {};
                T t1 = (T) o1;
                T t2 = (T) o2;
                Integer v1 = (Integer) m.invoke(o1, params);
                Integer v2 = (Integer) m.invoke(o2, params);
                return v1.compareTo(v2);
            }
            catch (Exception e) {}
            return -1;
        }

        public boolean equal(Object o)
        {
            return (compare(this, o)==0);
        }
    }

// ########## ArrayList Version ###########
    public Map<Y,ArrayList<T>> doSortA(String getIdMethod)
        throws Exception
    {
        Map<Y, ArrayList<T>> ret = new LinkedHashMap<Y, ArrayList<T>>();
        doSortA(getIdMethod, ret);
        return ret;
    }

    /*
    // 這個存在沒意義，用 doSortSingleton 就可了
    public Map<Y,T> doSortASingleton(String getIdMethod)
        throws Exception
    {
        Map<Y, T> ret = new LinkedHashMap<Y, T>();
        doSortA(getIdMethod, ret);
        return ret;
    }
    */

    public void doSortSingleton(String getIdMethod, Map<Y, T> ret)
        throws Exception
    {
        Map<Y, ArrayList<T>> m = doSortA(getIdMethod);
        Iterator<Y> iter = m.keySet().iterator();
        while (iter.hasNext()) {
            Y y = iter.next();
            ArrayList<T> a = m.get(y);
            ret.put(y, (a!=null)?a.get(0):null);
        }
    }

    public void doSortA(String getIdMethod, Map<Y, ArrayList<T>> ret)
        throws Exception
    {
        if (list==null || list.size()==0)
            return;
        Class c = ((T)list.get(0)).getClass();
        Class[] paramTypes = {};
        Method m = c.getMethod(getIdMethod, paramTypes);

        Object[] params = {};
        Iterator<T> iter = list.iterator();
        while (iter.hasNext()) {
            T t = iter.next();
            Y r = (Y) m.invoke(t, params);
            ArrayList<T> a = ret.get(r);
            if (a==null) {
                a = new ArrayList<T>();
                ret.put(r, a);
            }
            a.add(t);
        }
    }
}


