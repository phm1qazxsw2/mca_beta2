package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchDefMembrMgr extends dbo.Manager<SchDefMembr>
{
    private static SchDefMembrMgr _instance = null;

    SchDefMembrMgr() {}

    public synchronized static SchDefMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchDefMembrMgr();
        }
        return _instance;
    }

    public SchDefMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schmembr";
    }

    protected Object makeBean()
    {
        return new SchDefMembr();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchDefMembr item = (SchDefMembr) obj;
        try {
            int	id		 = rs.getInt("schdef.id");
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
            String	note		 = rs.getString("schdef.note");
            item.setNote(note);
            String	color		 = rs.getString("color");
            item.setColor(color);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	schdefId		 = rs.getInt("schdef.id");
            item.setSchdefId(schdefId);
            String	note_		 = rs.getString("schmembr.note");
            item.setNote_(note_);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
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
        SchDefMembr item = (SchDefMembr) obj;

        String ret = 
            "id=" + item.getId()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",startDate=" + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endDate=" + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",type=" + item.getType()
            + ",content='" + ServerTool.escapeString(item.getContent()) + "'"
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",color='" + ServerTool.escapeString(item.getColor()) + "'"
            + ",membrId=" + item.getMembrId()
            + ",schdefId=" + item.getSchdefId()
            + ",note_='" + ServerTool.escapeString(item.getNote_()) + "'"
            + ",membrName='" + ServerTool.escapeString(item.getMembrName()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "id,name,startDate,endDate,type,content,note,color,membrId,schdefId,note_,membrName";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchDefMembr item = (SchDefMembr) obj;

        String ret = 
            "" + item.getId()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getType()
            + ",'" + ServerTool.escapeString(item.getContent()) + "'"
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + ",'" + ServerTool.escapeString(item.getColor()) + "'"
            + "," + item.getMembrId()
            + "," + item.getSchdefId()
            + ",'" + ServerTool.escapeString(item.getNote_()) + "'"
            + ",'" + ServerTool.escapeString(item.getMembrName()) + "'"

        ;
        return ret;
    }
    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (schdef) ON schdef.id=schmembr.schdefId ";
        ret += "LEFT JOIN (membr) ON membr.id=schmembr.membrId ";
        return ret;
    }
}
