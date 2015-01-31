package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DiscountInfoMgr extends dbo.Manager<DiscountInfo>
{
    private static DiscountInfoMgr _instance = null;

    DiscountInfoMgr() {}

    public synchronized static DiscountInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DiscountInfoMgr();
        }
        return _instance;
    }

    public DiscountInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "discount join membr join discounttype";
    }

    protected Object makeBean()
    {
        return new DiscountInfo();
    }

    protected String JoinSpace()
    {
         return "discount.type=discounttype.id and discount.membrId=membr.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        DiscountInfo item = (DiscountInfo) obj;
        try {
            int	id		 = rs.getInt("discount.id");
            item.setId(id);
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
            int	type		 = rs.getInt("type");
            item.setType(type);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	copy		 = rs.getInt("copy");
            item.setCopy(copy);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
            String	discountTypeName		 = rs.getString("discountTypeName");
            item.setDiscountTypeName(discountTypeName);
            String	userLoginId		 = rs.getString("userLoginId");
            item.setUserLoginId(userLoginId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (user) ON discount.userId=user.id ";
        return ret;
    }
}
