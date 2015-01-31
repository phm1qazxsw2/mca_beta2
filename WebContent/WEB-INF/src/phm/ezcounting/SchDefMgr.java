package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchDefMgr extends dbo.Manager<SchDef>
{
    private static SchDefMgr _instance = null;

    SchDefMgr() {}

    public synchronized static SchDefMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchDefMgr();
        }
        return _instance;
    }

    public SchDefMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schdef";
    }

    protected Object makeBean()
    {
        return new SchDef();
    }

    protected String getIdentifier(Object obj)
    {
        SchDef o = (SchDef) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchDef item = (SchDef) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	name		 = rs.getString("name");
            item.setName(name);
            java.util.Date	startDate		 = rs.getTimestamp("startDate");
            item.setStartDate(startDate);
            java.util.Date	endDate		 = rs.getTimestamp("endDate");
            item.setEndDate(endDate);
            int	type		 = rs.getInt("type");
            item.setType(type);
            String	content		 = rs.getString("content");
            item.setContent(content);
            String	note		 = rs.getString("note");
            item.setNote(note);
            String	color		 = rs.getString("color");
            item.setColor(color);
            int	rootId		 = rs.getInt("rootId");
            item.setRootId(rootId);
            int	newestId		 = rs.getInt("newestId");
            item.setNewestId(newestId);
            int	autoRun		 = rs.getInt("autoRun");
            item.setAutoRun(autoRun);
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
        SchDef item = (SchDef) obj;

        String ret = 
            "name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",startDate=" + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endDate=" + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",type=" + item.getType()
            + ",content='" + ServerTool.escapeString(item.getContent()) + "'"
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",color='" + ServerTool.escapeString(item.getColor()) + "'"
            + ",rootId=" + item.getRootId()
            + ",newestId=" + item.getNewestId()
            + ",autoRun=" + item.getAutoRun()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name,startDate,endDate,type,content,note,color,rootId,newestId,autoRun,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchDef item = (SchDef) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getType()
            + ",'" + ServerTool.escapeString(item.getContent()) + "'"
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + ",'" + ServerTool.escapeString(item.getColor()) + "'"
            + "," + item.getRootId()
            + "," + item.getNewestId()
            + "," + item.getAutoRun()
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
        SchDef o = (SchDef) obj;
        o.setId(auto_id);
    }
}
