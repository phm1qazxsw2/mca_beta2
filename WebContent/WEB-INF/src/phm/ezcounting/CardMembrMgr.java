package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CardMembrMgr extends dbo.Manager<CardMembr>
{
    private static CardMembrMgr _instance = null;

    CardMembrMgr() {}

    public synchronized static CardMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CardMembrMgr();
        }
        return _instance;
    }

    public CardMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cardmembr";
    }

    protected Object makeBean()
    {
        return new CardMembr();
    }

    protected String getIdentifier(Object obj)
    {
        CardMembr o = (CardMembr) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CardMembr item = (CardMembr) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            String	cardId		 = rs.getString("cardId");
            item.setCardId(cardId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	active2		 = rs.getInt("active2");
            item.setActive2(active2);
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
        CardMembr item = (CardMembr) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",cardId='" + ServerTool.escapeString(item.getCardId()) + "'"
            + ",membrId=" + item.getMembrId()
            + ",active2=" + item.getActive2()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,cardId,membrId,active2";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        CardMembr item = (CardMembr) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getCardId()) + "'"
            + "," + item.getMembrId()
            + "," + item.getActive2()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        CardMembr o = (CardMembr) obj;
        o.setId(auto_id);
    }
}
