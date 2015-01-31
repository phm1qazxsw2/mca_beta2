package web;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PicorderMgr extends Manager
{
    private static PicorderMgr _instance = null;

    PicorderMgr() {}

    public synchronized static PicorderMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PicorderMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "picorder";
    }

    protected Object makeBean()
    {
        return new Picorder();
    }

    protected int getBeanId(Object obj)
    {
        return ((Picorder)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Picorder item = (Picorder) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	picorderClassType		 = rs.getInt("picorderClassType");
            int	picorderClassId		 = rs.getInt("picorderClassId");
            int	picorderUserId		 = rs.getInt("picorderUserId");
            int	picorderAlbumId		 = rs.getInt("picorderAlbumId");
            String	picorderPicname		 = rs.getString("picorderPicname");
            int	picorderStatus		 = rs.getInt("picorderStatus");
            int	picorderGetway		 = rs.getInt("picorderGetway");
            String	picorderName		 = rs.getString("picorderName");

            item
            .init(id, created, modified
            , picorderClassType, picorderClassId, picorderUserId
            , picorderAlbumId, picorderPicname, picorderStatus
            , picorderGetway, picorderName);
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
        Picorder item = (Picorder) obj;

        String ret = "modified=NOW()"
            + ",picorderClassType=" + item.getPicorderClassType()
            + ",picorderClassId=" + item.getPicorderClassId()
            + ",picorderUserId=" + item.getPicorderUserId()
            + ",picorderAlbumId=" + item.getPicorderAlbumId()
            + ",picorderPicname='" + ServerTool.escapeString(item.getPicorderPicname()) + "'"
            + ",picorderStatus=" + item.getPicorderStatus()
            + ",picorderGetway=" + item.getPicorderGetway()
            + ",picorderName='" + ServerTool.escapeString(item.getPicorderName()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, picorderClassType, picorderClassId, picorderUserId, picorderAlbumId, picorderPicname, picorderStatus, picorderGetway, picorderName";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Picorder item = (Picorder) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getPicorderClassType()
            + "," + item.getPicorderClassId()
            + "," + item.getPicorderUserId()
            + "," + item.getPicorderAlbumId()
            + ",'" + ServerTool.escapeString(item.getPicorderPicname()) + "'"
            + "," + item.getPicorderStatus()
            + "," + item.getPicorderGetway()
            + ",'" + ServerTool.escapeString(item.getPicorderName()) + "'"
        ;
        return ret;
    }
}
