package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CardMembrInfoMgr extends dbo.Manager<CardMembrInfo>
{
    private static CardMembrInfoMgr _instance = null;

    CardMembrInfoMgr() {}

    public synchronized static CardMembrInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CardMembrInfoMgr();
        }
        return _instance;
    }

    public CardMembrInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cardmembr join membr";
    }

    protected Object makeBean()
    {
        return new CardMembrInfo();
    }

    protected String JoinSpace()
    {
         return "membrId=membr.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CardMembrInfo item = (CardMembrInfo) obj;
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
            String	name		 = rs.getString("name");
            item.setName(name);
            int	active		 = rs.getInt("active");
            item.setActive(active);
            int	type		 = rs.getInt("type");
            item.setType(type);
            int	surrogateId		 = rs.getInt("surrogateId");
            item.setSurrogateId(surrogateId);
            java.util.Date	birth		 = rs.getTimestamp("birth");
            item.setBirth(birth);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
