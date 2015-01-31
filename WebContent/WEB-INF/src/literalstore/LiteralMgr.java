package literalstore;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class LiteralMgr extends dbo.Manager<Literal>
{
    private static LiteralMgr _instance = null;

    LiteralMgr() {}

    public synchronized static LiteralMgr getInstance()
    {
        if (_instance==null) {
            _instance = new LiteralMgr();
        }
        return _instance;
    }

    public LiteralMgr(int tran_id) throws Exception {
        super(tran_id);
    }


    protected Object makeBean()
    {
        return new Literal();
    }

    protected String getIdentifier(Object obj)
    {
        Literal o = (Literal) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Literal item = (Literal) obj;
        try {
            long	id		 = 0;try { id = Long.parseLong(new String(rs.getBytes("id"))); } catch (Exception ee) {}
            item.setId(id);
            String	text		 = rs.getString("text");
            item.setText(text);
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
        Literal item = (Literal) obj;

        String ret = 
            "id=" + item.getId()
            + ",text='" + ServerTool.escapeString(item.getText()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "id,text";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Literal item = (Literal) obj;

        String ret = 
            "" + item.getId()
            + ",'" + ServerTool.escapeString(item.getText()) + "'"

        ;
        return ret;
    }
}
