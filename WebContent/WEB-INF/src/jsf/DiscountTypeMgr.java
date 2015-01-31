package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DiscountTypeMgr extends Manager
{
    private static DiscountTypeMgr _instance = null;

    DiscountTypeMgr() {}

    public synchronized static DiscountTypeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DiscountTypeMgr();
        }
        return _instance;
    }

    public DiscountTypeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "discounttype";
    }

    protected Object makeBean()
    {
        return new DiscountType();
    }

    protected int getBeanId(Object obj)
    {
        return ((DiscountType)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        DiscountType item = (DiscountType) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	discountTypeName		 = rs.getString("discountTypeName");
            int	discountTypeActive		 = rs.getInt("discountTypeActive");
            String	discountTypePs		 = rs.getString("discountTypePs");
            String	acctcode		 = rs.getString("acctcode");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , discountTypeName, discountTypeActive, discountTypePs
            , acctcode, bunitId);
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
        DiscountType item = (DiscountType) obj;

        String ret = "modified=NOW()"
            + ",discountTypeName='" + ServerTool.escapeString(item.getDiscountTypeName()) + "'"
            + ",discountTypeActive=" + item.getDiscountTypeActive()
            + ",discountTypePs='" + ServerTool.escapeString(item.getDiscountTypePs()) + "'"
            + ",acctcode='" + ServerTool.escapeString(item.getAcctcode()) + "'"
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, discountTypeName, discountTypeActive, discountTypePs, acctcode, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        DiscountType item = (DiscountType) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getDiscountTypeName()) + "'"
            + "," + item.getDiscountTypeActive()
            + ",'" + ServerTool.escapeString(item.getDiscountTypePs()) + "'"
            + ",'" + ServerTool.escapeString(item.getAcctcode()) + "'"
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
