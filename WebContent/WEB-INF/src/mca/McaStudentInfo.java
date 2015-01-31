package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaStudentInfo extends McaStudent
{

    private int   	membrId;
    private int   	studId;


    public McaStudentInfo() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getStudId   	() { return studId; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setStudId   	(int studId) { this.studId = studId; }

    public String getFullName() {
        String f = this.getStudentFirstName();
        String l = this.getStudentSurname();
        StringBuffer sb = new StringBuffer();
        if (l!=null && l.length()>0) {
            sb.append(l.substring(0,1).toUpperCase());
            sb.append(l.substring(1));
        }
        if (f!=null && f.length()>0) {
            if (sb.length()>0)
                sb.append(", ");
            sb.append(f.substring(0,1).toUpperCase());
            sb.append(f.substring(1));
        }
        return sb.toString();
    }

    public String getFatherName()
    {
        String f = this.getFatherFirstName();
        String l = this.getFatherSurname();
        StringBuffer sb = new StringBuffer();
        if (l!=null && l.length()>0) {
            sb.append(l.substring(0,1).toUpperCase());
            sb.append(l.substring(1));
        }
        if (f!=null && f.length()>0) {
            if (sb.length()>0)
                sb.append(", ");
            sb.append(f.substring(0,1).toUpperCase());
            sb.append(f.substring(1));
        }
        return sb.toString();
    }

    public String getMotherName()
    {
        String f = this.getMotherFirstName();
        String l = this.getMotherSurname();
        StringBuffer sb = new StringBuffer();
        if (l!=null && l.length()>0) {
            sb.append(l.substring(0,1).toUpperCase());
            sb.append(l.substring(1));
        }
        if (f!=null && f.length()>0) {
            if (sb.length()>0)
                sb.append(", ");
            sb.append(f.substring(0,1).toUpperCase());
            sb.append(f.substring(1));
        }
        return sb.toString();
    }

    private static java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd");
    public Date getMyBirthday()
    {
        try {
            return sdf.parse(getBirthDate());
        }
        catch (Exception e) {        
        }
        return null;
    }


    public final static int IDENTITY_BK = 0;
    public final static int IDENTITY_M0 = 1;
    public final static int IDENTITY_M1 = 2;
    public final static int IDENTITY_M2 = 3;
    public final static int IDENTITY_CW = 4;


}
