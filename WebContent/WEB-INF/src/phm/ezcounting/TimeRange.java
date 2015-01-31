package phm.ezcounting;

import java.util.*;

public class TimeRange {
    private Date d1, d2;
    private SchDefMembr sdm = null;

    public TimeRange(Date d1, Date d2, SchDefMembr sdm)
    {
        this.d1 = d1;
        this.d2 = d2;
        this.sdm = sdm;
    }

    public Date getBeginTime() {
        return d1;
    }

    public SchDefMembr getSchDefMembr()
    {
        return sdm;
    }

    public boolean isAffected(Date t1, Date t2)
    {
        if (this.d2.compareTo(t1)<0)
            return false;
        if (this.d1.compareTo(t2)>0)
            return false;
        return true;
    }

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
    public int getAffectedHours(Date t1, Date t2)
    {
        Date lowerBig = (d1.compareTo(t1)>0)?d1:t1;
        Date higherSmall = (d2.compareTo(t2)>0)?t2:d2;
        int diff = (int) (higherSmall.getTime() - lowerBig.getTime());
        return diff/(60*60*1000);
    }
}

