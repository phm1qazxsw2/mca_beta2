package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaExportMgr extends dbo.Manager<McaExport>
{
    private static McaExportMgr _instance = null;

    McaExportMgr() {}

    public synchronized static McaExportMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaExportMgr();
        }
        return _instance;
    }

    public McaExportMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_export";
    }

    protected Object makeBean()
    {
        return new McaExport();
    }

    protected String getIdentifier(Object obj)
    {
        McaExport o = (McaExport) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaExport item = (McaExport) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	exportTime		 = rs.getTimestamp("exportTime");
            item.setExportTime(exportTime);
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
        McaExport item = (McaExport) obj;

        String ret = 
            "exportTime=" + (((d=item.getExportTime())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "exportTime";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaExport item = (McaExport) obj;

        String ret = 
            "" + (((d=item.getExportTime())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        McaExport o = (McaExport) obj;
        o.setId(auto_id);
    }
}
