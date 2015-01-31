package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClassesChargeMgr extends Manager
{
    private static ClassesChargeMgr _instance = null;

    ClassesChargeMgr() {}

    public synchronized static ClassesChargeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClassesChargeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "classescharge";
    }

    protected Object makeBean()
    {
        return new ClassesCharge();
    }

    protected int getBeanId(Object obj)
    {
        return ((ClassesCharge)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ClassesCharge item = (ClassesCharge) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	classesChargeCMId		 = rs.getInt("classesChargeCMId");
            java.util.Date	classesChargeMonth		 = rs.getTimestamp("classesChargeMonth");
            int	classesChargeCategory		 = rs.getInt("classesChargeCategory");
            int	classesChargexId		 = rs.getInt("classesChargexId");
            int	classesChargeYId		 = rs.getInt("classesChargeYId");
            int	classesChargeActive		 = rs.getInt("classesChargeActive");
            int	classesChargeMoneyNumber		 = rs.getInt("classesChargeMoneyNumber");
            String	classesChargePs		 = rs.getString("classesChargePs");

            item
            .init(id, created, modified
            , classesChargeCMId, classesChargeMonth, classesChargeCategory
            , classesChargexId, classesChargeYId, classesChargeActive
            , classesChargeMoneyNumber, classesChargePs);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getSaveString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ClassesCharge item = (ClassesCharge) obj;

        String ret = "modified=NOW()"
            + ",classesChargeCMId=" + item.getClassesChargeCMId()
            + ",classesChargeMonth=" + (((d=item.getClassesChargeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",classesChargeCategory=" + item.getClassesChargeCategory()
            + ",classesChargexId=" + item.getClassesChargexId()
            + ",classesChargeYId=" + item.getClassesChargeYId()
            + ",classesChargeActive=" + item.getClassesChargeActive()
            + ",classesChargeMoneyNumber=" + item.getClassesChargeMoneyNumber()
            + ",classesChargePs='" + ServerTool.escapeString(item.getClassesChargePs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, classesChargeCMId, classesChargeMonth, classesChargeCategory, classesChargexId, classesChargeYId, classesChargeActive, classesChargeMoneyNumber, classesChargePs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ClassesCharge item = (ClassesCharge) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getClassesChargeCMId()
            + "," + (((d=item.getClassesChargeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClassesChargeCategory()
            + "," + item.getClassesChargexId()
            + "," + item.getClassesChargeYId()
            + "," + item.getClassesChargeActive()
            + "," + item.getClassesChargeMoneyNumber()
            + ",'" + ServerTool.escapeString(item.getClassesChargePs()) + "'"
        ;
        return ret;
    }
}
