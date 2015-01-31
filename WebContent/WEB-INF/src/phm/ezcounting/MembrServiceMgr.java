package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrServiceMgr extends dbo.Manager<MembrService>
{
    private static MembrServiceMgr _instance = null;

    MembrServiceMgr() {}

    public synchronized static MembrServiceMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrServiceMgr();
        }
        return _instance;
    }

    public MembrServiceMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "clientservice";
    }

    protected Object makeBean()
    {
        return new MembrService();
    }

    protected String getIdentifier(Object obj)
    {
        MembrService o = (MembrService) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrService item = (MembrService) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	clientServiceDate		 = rs.getTimestamp("clientServiceDate");
            item.setClientServiceDate(clientServiceDate);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            int	clientServiceMembrId		 = rs.getInt("clientServiceMembrId");
            item.setClientServiceMembrId(clientServiceMembrId);
            int	clientServiceUserId		 = rs.getInt("clientServiceUserId");
            item.setClientServiceUserId(clientServiceUserId);
            int	clientServiceStatus		 = rs.getInt("clientServiceStatus");
            item.setClientServiceStatus(clientServiceStatus);
            int	clientServiceStar		 = rs.getInt("clientServiceStar");
            item.setClientServiceStar(clientServiceStar);
            int	clientServiceProcess		 = rs.getInt("clientServiceProcess");
            item.setClientServiceProcess(clientServiceProcess);
            int	clientServiceType		 = rs.getInt("clientServiceType");
            item.setClientServiceType(clientServiceType);
            String	clientServiceTitle		 = rs.getString("clientServiceTitle");
            item.setClientServiceTitle(clientServiceTitle);
            String	clientServiceContent		 = rs.getString("clientServiceContent");
            item.setClientServiceContent(clientServiceContent);
            int	clientServiceLogId		 = rs.getInt("clientServiceLogId");
            item.setClientServiceLogId(clientServiceLogId);
            java.util.Date	clientServiceWarningDate		 = rs.getTimestamp("clientServiceWarningDate");
            item.setClientServiceWarningDate(clientServiceWarningDate);
            int	clientServiceWarningStatus		 = rs.getInt("clientServiceWarningStatus");
            item.setClientServiceWarningStatus(clientServiceWarningStatus);
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
        MembrService item = (MembrService) obj;

        String ret = 
            "clientServiceDate=" + (((d=item.getClientServiceDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",clientServiceMembrId=" + item.getClientServiceMembrId()
            + ",clientServiceUserId=" + item.getClientServiceUserId()
            + ",clientServiceStatus=" + item.getClientServiceStatus()
            + ",clientServiceStar=" + item.getClientServiceStar()
            + ",clientServiceProcess=" + item.getClientServiceProcess()
            + ",clientServiceType=" + item.getClientServiceType()
            + ",clientServiceTitle='" + ServerTool.escapeString(item.getClientServiceTitle()) + "'"
            + ",clientServiceContent='" + ServerTool.escapeString(item.getClientServiceContent()) + "'"
            + ",clientServiceLogId=" + item.getClientServiceLogId()
            + ",clientServiceWarningDate=" + (((d=item.getClientServiceWarningDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",clientServiceWarningStatus=" + item.getClientServiceWarningStatus()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "clientServiceDate,modified,clientServiceMembrId,clientServiceUserId,clientServiceStatus,clientServiceStar,clientServiceProcess,clientServiceType,clientServiceTitle,clientServiceContent,clientServiceLogId,clientServiceWarningDate,clientServiceWarningStatus";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MembrService item = (MembrService) obj;

        String ret = 
            "" + (((d=item.getClientServiceDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClientServiceMembrId()
            + "," + item.getClientServiceUserId()
            + "," + item.getClientServiceStatus()
            + "," + item.getClientServiceStar()
            + "," + item.getClientServiceProcess()
            + "," + item.getClientServiceType()
            + ",'" + ServerTool.escapeString(item.getClientServiceTitle()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientServiceContent()) + "'"
            + "," + item.getClientServiceLogId()
            + "," + (((d=item.getClientServiceWarningDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClientServiceWarningStatus()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        MembrService o = (MembrService) obj;
        o.setId(auto_id);
    }
}
