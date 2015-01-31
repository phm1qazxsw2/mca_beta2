package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TfContentMgr extends Manager
{
    private static TfContentMgr _instance = null;

    TfContentMgr() {}

    public synchronized static TfContentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TfContentMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "tfcontent";
    }

    protected Object makeBean()
    {
        return new TfContent();
    }

    protected int getBeanId(Object obj)
    {
        return ((TfContent)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TfContent item = (TfContent) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	tfContentTalentFileId		 = rs.getInt("tfContentTalentFileId");
            String	tfContentTitle		 = rs.getString("tfContentTitle");
            String	tfContentContnet		 = rs.getString("tfContentContnet");
            int	tfContentSendKind		 = rs.getInt("tfContentSendKind");
            int	tfContentSendId		 = rs.getInt("tfContentSendId");
            String	PicFile		 = rs.getString("PicFile");

            item
            .init(id, created, modified
            , tfContentTalentFileId, tfContentTitle, tfContentContnet
            , tfContentSendKind, tfContentSendId, PicFile
            );
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
        TfContent item = (TfContent) obj;

        String ret = "modified=NOW()"
            + ",tfContentTalentFileId=" + item.getTfContentTalentFileId()
            + ",tfContentTitle='" + ServerTool.escapeString(item.getTfContentTitle()) + "'"
            + ",tfContentContnet='" + ServerTool.escapeString(item.getTfContentContnet()) + "'"
            + ",tfContentSendKind=" + item.getTfContentSendKind()
            + ",tfContentSendId=" + item.getTfContentSendId()
            + ",PicFile='" + ServerTool.escapeString(item.getPicFile()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, tfContentTalentFileId, tfContentTitle, tfContentContnet, tfContentSendKind, tfContentSendId, PicFile";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TfContent item = (TfContent) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTfContentTalentFileId()
            + ",'" + ServerTool.escapeString(item.getTfContentTitle()) + "'"
            + ",'" + ServerTool.escapeString(item.getTfContentContnet()) + "'"
            + "," + item.getTfContentSendKind()
            + "," + item.getTfContentSendId()
            + ",'" + ServerTool.escapeString(item.getPicFile()) + "'"
        ;
        return ret;
    }
}
