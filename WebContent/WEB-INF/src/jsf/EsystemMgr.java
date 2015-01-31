package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class EsystemMgr extends Manager
{
    private static EsystemMgr _instance = null;

    EsystemMgr() {}

    public synchronized static EsystemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new EsystemMgr();
        }
        return _instance;
    }

    public EsystemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "esystem";
    }

    protected Object makeBean()
    {
        return new Esystem();
    }

    protected int getBeanId(Object obj)
    {
        return ((Esystem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Esystem item = (Esystem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	esystemIncomeVerufy		 = rs.getInt("esystemIncomeVerufy");
            int	esystemCostVerufy		 = rs.getInt("esystemCostVerufy");
            int	esystemIncomePage		 = rs.getInt("esystemIncomePage");
            int	esystemCostPage		 = rs.getInt("esystemCostPage");
            int	esystemStupage		 = rs.getInt("esystemStupage");
            int	esystemTeapage		 = rs.getInt("esystemTeapage");
            String	esystemMySqlfile		 = rs.getString("esystemMySqlfile");
            String	esystemMysqlName		 = rs.getString("esystemMysqlName");
            String	esystemMysqlBinary		 = rs.getString("esystemMysqlBinary");
            String	esystemDBfile		 = rs.getString("esystemDBfile");
            int	esystemShowCash		 = rs.getInt("esystemShowCash");
            int	esystemDateType		 = rs.getInt("esystemDateType");
            int	esystemLogMins		 = rs.getInt("esystemLogMins");
            String	esystememailTitle		 = rs.getString("esystememailTitle");
            String	esystemEmailContent		 = rs.getString("esystemEmailContent");
            int	esystemEmailType		 = rs.getInt("esystemEmailType");

            item
            .init(id, created, modified
            , esystemIncomeVerufy, esystemCostVerufy, esystemIncomePage
            , esystemCostPage, esystemStupage, esystemTeapage
            , esystemMySqlfile, esystemMysqlName, esystemMysqlBinary
            , esystemDBfile, esystemShowCash, esystemDateType
            , esystemLogMins, esystememailTitle, esystemEmailContent
            , esystemEmailType);
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
        Esystem item = (Esystem) obj;

        String ret = "modified=NOW()"
            + ",esystemIncomeVerufy=" + item.getEsystemIncomeVerufy()
            + ",esystemCostVerufy=" + item.getEsystemCostVerufy()
            + ",esystemIncomePage=" + item.getEsystemIncomePage()
            + ",esystemCostPage=" + item.getEsystemCostPage()
            + ",esystemStupage=" + item.getEsystemStupage()
            + ",esystemTeapage=" + item.getEsystemTeapage()
            + ",esystemMySqlfile='" + ServerTool.escapeString(item.getEsystemMySqlfile()) + "'"
            + ",esystemMysqlName='" + ServerTool.escapeString(item.getEsystemMysqlName()) + "'"
            + ",esystemMysqlBinary='" + ServerTool.escapeString(item.getEsystemMysqlBinary()) + "'"
            + ",esystemDBfile='" + ServerTool.escapeString(item.getEsystemDBfile()) + "'"
            + ",esystemShowCash=" + item.getEsystemShowCash()
            + ",esystemDateType=" + item.getEsystemDateType()
            + ",esystemLogMins=" + item.getEsystemLogMins()
            + ",esystememailTitle='" + ServerTool.escapeString(item.getEsystememailTitle()) + "'"
            + ",esystemEmailContent='" + ServerTool.escapeString(item.getEsystemEmailContent()) + "'"
            + ",esystemEmailType=" + item.getEsystemEmailType()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, esystemIncomeVerufy, esystemCostVerufy, esystemIncomePage, esystemCostPage, esystemStupage, esystemTeapage, esystemMySqlfile, esystemMysqlName, esystemMysqlBinary, esystemDBfile, esystemShowCash, esystemDateType, esystemLogMins, esystememailTitle, esystemEmailContent, esystemEmailType";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Esystem item = (Esystem) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getEsystemIncomeVerufy()
            + "," + item.getEsystemCostVerufy()
            + "," + item.getEsystemIncomePage()
            + "," + item.getEsystemCostPage()
            + "," + item.getEsystemStupage()
            + "," + item.getEsystemTeapage()
            + ",'" + ServerTool.escapeString(item.getEsystemMySqlfile()) + "'"
            + ",'" + ServerTool.escapeString(item.getEsystemMysqlName()) + "'"
            + ",'" + ServerTool.escapeString(item.getEsystemMysqlBinary()) + "'"
            + ",'" + ServerTool.escapeString(item.getEsystemDBfile()) + "'"
            + "," + item.getEsystemShowCash()
            + "," + item.getEsystemDateType()
            + "," + item.getEsystemLogMins()
            + ",'" + ServerTool.escapeString(item.getEsystememailTitle()) + "'"
            + ",'" + ServerTool.escapeString(item.getEsystemEmailContent()) + "'"
            + "," + item.getEsystemEmailType()
        ;
        return ret;
    }
}
