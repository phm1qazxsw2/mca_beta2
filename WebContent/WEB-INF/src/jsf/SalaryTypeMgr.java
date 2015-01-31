package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryTypeMgr extends Manager
{
    private static SalaryTypeMgr _instance = null;

    SalaryTypeMgr() {}

    public synchronized static SalaryTypeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryTypeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "salarytype";
    }

    protected Object makeBean()
    {
        return new SalaryType();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryType)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryType item = (SalaryType) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	salaryType		 = rs.getInt("salaryType");
            String	salaryTypeName		 = rs.getString("salaryTypeName");
            String	salaryTypeFullName		 = rs.getString("salaryTypeFullName");
            int	salaryTypeActive		 = rs.getInt("salaryTypeActive");
            String	salaryTypePs		 = rs.getString("salaryTypePs");
            int	salaryTypeContinue		 = rs.getInt("salaryTypeContinue");
            int	salaryTypeContinueActive		 = rs.getInt("salaryTypeContinueActive");
            int	salaryTypeVerufyNeed		 = rs.getInt("salaryTypeVerufyNeed");
            int	salaryTypeFixNumber		 = rs.getInt("salaryTypeFixNumber");

            item
            .init(id, created, modified
            , salaryType, salaryTypeName, salaryTypeFullName
            , salaryTypeActive, salaryTypePs, salaryTypeContinue
            , salaryTypeContinueActive, salaryTypeVerufyNeed, salaryTypeFixNumber
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
        SalaryType item = (SalaryType) obj;

        String ret = "modified=NOW()"
            + ",salaryType=" + item.getSalaryType()
            + ",salaryTypeName='" + ServerTool.escapeString(item.getSalaryTypeName()) + "'"
            + ",salaryTypeFullName='" + ServerTool.escapeString(item.getSalaryTypeFullName()) + "'"
            + ",salaryTypeActive=" + item.getSalaryTypeActive()
            + ",salaryTypePs='" + ServerTool.escapeString(item.getSalaryTypePs()) + "'"
            + ",salaryTypeContinue=" + item.getSalaryTypeContinue()
            + ",salaryTypeContinueActive=" + item.getSalaryTypeContinueActive()
            + ",salaryTypeVerufyNeed=" + item.getSalaryTypeVerufyNeed()
            + ",salaryTypeFixNumber=" + item.getSalaryTypeFixNumber()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryType, salaryTypeName, salaryTypeFullName, salaryTypeActive, salaryTypePs, salaryTypeContinue, salaryTypeContinueActive, salaryTypeVerufyNeed, salaryTypeFixNumber";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryType item = (SalaryType) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getSalaryType()
            + ",'" + ServerTool.escapeString(item.getSalaryTypeName()) + "'"
            + ",'" + ServerTool.escapeString(item.getSalaryTypeFullName()) + "'"
            + "," + item.getSalaryTypeActive()
            + ",'" + ServerTool.escapeString(item.getSalaryTypePs()) + "'"
            + "," + item.getSalaryTypeContinue()
            + "," + item.getSalaryTypeContinueActive()
            + "," + item.getSalaryTypeVerufyNeed()
            + "," + item.getSalaryTypeFixNumber()
        ;
        return ret;
    }
}
