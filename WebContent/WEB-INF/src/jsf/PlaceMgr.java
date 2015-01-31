package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PlaceMgr extends Manager
{
    private static PlaceMgr _instance = null;

    PlaceMgr() {}

    public synchronized static PlaceMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PlaceMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "place";
    }

    protected Object makeBean()
    {
        return new Place();
    }

    protected int getBeanId(Object obj)
    {
        return ((Place)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Place item = (Place) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	placeName		 = rs.getString("placeName");
            int	placeActive		 = rs.getInt("placeActive");

            item
            .init(id, created, modified
            , placeName, placeActive);
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
        Place item = (Place) obj;

        String ret = "modified=NOW()"
            + ",placeName='" + ServerTool.escapeString(item.getPlaceName()) + "'"
            + ",placeActive=" + item.getPlaceActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, placeName, placeActive";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Place item = (Place) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getPlaceName()) + "'"
            + "," + item.getPlaceActive()
        ;
        return ret;
    }
}
