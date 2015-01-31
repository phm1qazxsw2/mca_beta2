package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClassesMoneyMgr extends Manager
{
    private static ClassesMoneyMgr _instance = null;

    ClassesMoneyMgr() {}

    public synchronized static ClassesMoneyMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClassesMoneyMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "classesmoney";
    }

    protected Object makeBean()
    {
        return new ClassesMoney();
    }

    protected int getBeanId(Object obj)
    {
        return ((ClassesMoney)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ClassesMoney item = (ClassesMoney) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	classesMoneyName		 = rs.getString("classesMoneyName");
            String	classesMoneyFullName		 = rs.getString("classesMoneyFullName");
            int	classesMoneyActive		 = rs.getInt("classesMoneyActive");
            String	classesMoneyPs		 = rs.getString("classesMoneyPs");
            int	classesMoneyNumber		 = rs.getInt("classesMoneyNumber");
            int	classesMoneyIncomeItem		 = rs.getInt("classesMoneyIncomeItem");
            int	classesMoneyContinue		 = rs.getInt("classesMoneyContinue");
            int	classesMoneyContinueActive		 = rs.getInt("classesMoneyContinueActive");
            java.util.Date	classesMoneyContinueDate		 = rs.getTimestamp("classesMoneyContinueDate");
            int	classesMoneyCategory		 = rs.getInt("classesMoneyCategory");
            int	classesMoneyNewFeenumber		 = rs.getInt("classesMoneyNewFeenumber");
            int	classesMoneyNewFeenumberCMId		 = rs.getInt("classesMoneyNewFeenumberCMId");

            item
            .init(id, created, modified
            , classesMoneyName, classesMoneyFullName, classesMoneyActive
            , classesMoneyPs, classesMoneyNumber, classesMoneyIncomeItem
            , classesMoneyContinue, classesMoneyContinueActive, classesMoneyContinueDate
            , classesMoneyCategory, classesMoneyNewFeenumber, classesMoneyNewFeenumberCMId
            );
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
        ClassesMoney item = (ClassesMoney) obj;

        String ret = "modified=NOW()"
            + ",classesMoneyName='" + ServerTool.escapeString(item.getClassesMoneyName()) + "'"
            + ",classesMoneyFullName='" + ServerTool.escapeString(item.getClassesMoneyFullName()) + "'"
            + ",classesMoneyActive=" + item.getClassesMoneyActive()
            + ",classesMoneyPs='" + ServerTool.escapeString(item.getClassesMoneyPs()) + "'"
            + ",classesMoneyNumber=" + item.getClassesMoneyNumber()
            + ",classesMoneyIncomeItem=" + item.getClassesMoneyIncomeItem()
            + ",classesMoneyContinue=" + item.getClassesMoneyContinue()
            + ",classesMoneyContinueActive=" + item.getClassesMoneyContinueActive()
            + ",classesMoneyContinueDate=" + (((d=item.getClassesMoneyContinueDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",classesMoneyCategory=" + item.getClassesMoneyCategory()
            + ",classesMoneyNewFeenumber=" + item.getClassesMoneyNewFeenumber()
            + ",classesMoneyNewFeenumberCMId=" + item.getClassesMoneyNewFeenumberCMId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, classesMoneyName, classesMoneyFullName, classesMoneyActive, classesMoneyPs, classesMoneyNumber, classesMoneyIncomeItem, classesMoneyContinue, classesMoneyContinueActive, classesMoneyContinueDate, classesMoneyCategory, classesMoneyNewFeenumber, classesMoneyNewFeenumberCMId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ClassesMoney item = (ClassesMoney) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getClassesMoneyName()) + "'"
            + ",'" + ServerTool.escapeString(item.getClassesMoneyFullName()) + "'"
            + "," + item.getClassesMoneyActive()
            + ",'" + ServerTool.escapeString(item.getClassesMoneyPs()) + "'"
            + "," + item.getClassesMoneyNumber()
            + "," + item.getClassesMoneyIncomeItem()
            + "," + item.getClassesMoneyContinue()
            + "," + item.getClassesMoneyContinueActive()
            + "," + (((d=item.getClassesMoneyContinueDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClassesMoneyCategory()
            + "," + item.getClassesMoneyNewFeenumber()
            + "," + item.getClassesMoneyNewFeenumberCMId()
        ;
        return ret;
    }
}
