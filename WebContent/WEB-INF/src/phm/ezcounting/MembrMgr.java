package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrMgr extends dbo.Manager<Membr>
{
    private static MembrMgr _instance = null;

    MembrMgr() {}

    public synchronized static MembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrMgr();
        }
        return _instance;
    }

    public MembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr";
    }

    protected Object makeBean()
    {
        return new Membr();
    }

    protected String getIdentifier(Object obj)
    {
        Membr o = (Membr) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Membr item = (Membr) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
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
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        Membr item = (Membr) obj;

        String ret = 
            "name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",active=" + item.getActive()
            + ",type=" + item.getType()
            + ",surrogateId=" + item.getSurrogateId()
            + ",birth=" + (((d=item.getBirth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name,active,type,surrogateId,birth,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Membr item = (Membr) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getActive()
            + "," + item.getType()
            + "," + item.getSurrogateId()
            + "," + (((d=item.getBirth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getBunitId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Membr o = (Membr) obj;
        o.setId(auto_id);
    }
}
