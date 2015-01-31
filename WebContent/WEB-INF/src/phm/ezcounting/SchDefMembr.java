package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchDefMembr extends SchDef
{

    private int   	membrId;
    private int   	schdefId;
    private String   	note_;
    private String   	membrName;


    public SchDefMembr() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getSchdefId   	() { return schdefId; }
    public String   	getNote_   	() { return note_; }
    public String   	getMembrName   	() { return membrName; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setSchdefId   	(int schdefId) { this.schdefId = schdefId; }
    public void 	setNote_   	(String note_) { this.note_ = note_; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }


    public String getMyNote()
    {
        if (this.getNote_()!=null && this.getNote_().length()>0)
            return this.getNote_();
        return this.getNote();
    }

/*    
    private Calendar c1 = null, c2 = null;
    private void  _fillDates(int day, Date d1, Date d2)
	throws Exception
    {
        if (c1==null)
        {
            c1 = Calendar.getInstance();
            c1.setTime(this.getMonth());
            int hr = Integer.parseInt(this.getStartHr().substring(0,2));
            int mm = Integer.parseInt(this.getStartHr().substring(2));
            c1.set(Calendar.HOUR_OF_DAY, hr);
            c1.set(Calendar.MINUTE, mm);

            c2 = Calendar.getInstance();
            c2.setTime(this.getMonth());
            hr = Integer.parseInt(this.getEndHr().substring(0,2));
            mm = Integer.parseInt(this.getEndHr().substring(2));
            c2.set(Calendar.HOUR_OF_DAY, hr);
            c2.set(Calendar.MINUTE, mm);
        }

        c1.set(Calendar.DAY_OF_MONTH, day);
        // startHR
        d1.setTime(c1.getTime().getTime());
        // endHr
        c2.set(Calendar.DAY_OF_MONTH, day);
        d2.setTime(c2.getTime().getTime());
        if (d2.compareTo(d1)<0) { // 如果跨日
            c2.add(Calendar.DATE, 1);
            d2.setTime(c2.getTime().getTime());
        }
    }
*/

}
