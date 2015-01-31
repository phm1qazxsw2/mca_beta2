package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMgr extends dbo.Manager<Tag>
{
    private static TagMgr _instance = null;

    TagMgr() {}

    public synchronized static TagMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMgr();
        }
        return _instance;
    }

    public TagMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tag";
    }

    protected Object makeBean()
    {
        return new Tag();
    }

    protected String getIdentifier(Object obj)
    {
        Tag o = (Tag) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Tag item = (Tag) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            int	typeId		 = rs.getInt("typeId");
            item.setTypeId(typeId);
            String	name		 = rs.getString("name");
            item.setName(name);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            int	branchTag		 = rs.getInt("branchTag");
            item.setBranchTag(branchTag);
            java.util.Date	branchTime		 = rs.getTimestamp("branchTime");
            item.setBranchTime(branchTime);
            int	rootTag		 = rs.getInt("rootTag");
            item.setRootTag(rootTag);
            int	branchVer		 = rs.getInt("branchVer");
            item.setBranchVer(branchVer);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            int	progId		 = rs.getInt("progId");
            item.setProgId(progId);
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
        Tag item = (Tag) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",typeId=" + item.getTypeId()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",status=" + item.getStatus()
            + ",branchTag=" + item.getBranchTag()
            + ",branchTime=" + (((d=item.getBranchTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",rootTag=" + item.getRootTag()
            + ",branchVer=" + item.getBranchVer()
            + ",bunitId=" + item.getBunitId()
            + ",progId=" + item.getProgId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,modified,typeId,name,status,branchTag,branchTime,rootTag,branchVer,bunitId,progId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Tag item = (Tag) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getTypeId()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getStatus()
            + "," + item.getBranchTag()
            + "," + (((d=item.getBranchTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getRootTag()
            + "," + item.getBranchVer()
            + "," + item.getBunitId()
            + "," + item.getProgId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Tag o = (Tag) obj;
        o.setId(auto_id);
    }
}
