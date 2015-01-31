package phm.util;

import java.util.*;

public class PArrayList<T> extends ArrayList<T>
{
    public PArrayList() {}

    public PArrayList(ArrayList<T> a) {
        super(a);
    }

    public PArrayList(Vector<T> v) {
        for (int i=0; v!=null&&i<v.size(); i++)
            this.add(v.get(i));
    }

    public PArrayList<T> concate(ArrayList<T> a) {
        for (int i=0; a!=null&&i<a.size(); i++)
            this.add(a.get(i));
        return this;
    }
}
