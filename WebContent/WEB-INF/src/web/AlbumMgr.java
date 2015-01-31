package web;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AlbumMgr extends Manager
{
    private static AlbumMgr _instance = null;

    AlbumMgr() {}

    public synchronized static AlbumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AlbumMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "album";
    }

    protected Object makeBean()
    {
        return new Album();
    }

    protected int getBeanId(Object obj)
    {
        return ((Album)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Album item = (Album) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	albumName		 = rs.getString("albumName");
            String	albumWord		 = rs.getString("albumWord");
            int	albumPhotos		 = rs.getInt("albumPhotos");
            int	albumStatus		 = rs.getInt("albumStatus");
            int	albumActive		 = rs.getInt("albumActive");
            int	albumClasstype		 = rs.getInt("albumClasstype");
            int	albumClassId		 = rs.getInt("albumClassId");
            int	albumXid		 = rs.getInt("albumXid");
            int	albumTypeId		 = rs.getInt("albumTypeId");
            int	albumCatelogId		 = rs.getInt("albumCatelogId");

            item
            .init(id, created, modified
            , albumName, albumWord, albumPhotos
            , albumStatus, albumActive, albumClasstype
            , albumClassId, albumXid, albumTypeId
            , albumCatelogId);
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
        Album item = (Album) obj;

        String ret = "modified=NOW()"
            + ",albumName='" + ServerTool.escapeString(item.getAlbumName()) + "'"
            + ",albumWord='" + ServerTool.escapeString(item.getAlbumWord()) + "'"
            + ",albumPhotos=" + item.getAlbumPhotos()
            + ",albumStatus=" + item.getAlbumStatus()
            + ",albumActive=" + item.getAlbumActive()
            + ",albumClasstype=" + item.getAlbumClasstype()
            + ",albumClassId=" + item.getAlbumClassId()
            + ",albumXid=" + item.getAlbumXid()
            + ",albumTypeId=" + item.getAlbumTypeId()
            + ",albumCatelogId=" + item.getAlbumCatelogId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, albumName, albumWord, albumPhotos, albumStatus, albumActive, albumClasstype, albumClassId, albumXid, albumTypeId, albumCatelogId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Album item = (Album) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getAlbumName()) + "'"
            + ",'" + ServerTool.escapeString(item.getAlbumWord()) + "'"
            + "," + item.getAlbumPhotos()
            + "," + item.getAlbumStatus()
            + "," + item.getAlbumActive()
            + "," + item.getAlbumClasstype()
            + "," + item.getAlbumClassId()
            + "," + item.getAlbumXid()
            + "," + item.getAlbumTypeId()
            + "," + item.getAlbumCatelogId()
        ;
        return ret;
    }
}
