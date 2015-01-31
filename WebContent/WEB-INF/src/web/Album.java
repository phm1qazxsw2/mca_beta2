package web;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Album extends Object implements java.io.Serializable
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	albumName;
    private String   	albumWord;
    private int   	albumPhotos;
    private int   	albumStatus;
    private int   	albumActive;
    private int   	albumClasstype;
    private int   	albumClassId;
    private int   	albumXid;
    private int   	albumTypeId;
    private int   	albumCatelogId;


    public Album() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	albumName,
        String	albumWord,
        int	albumPhotos,
        int	albumStatus,
        int	albumActive,
        int	albumClasstype,
        int	albumClassId,
        int	albumXid,
        int	albumTypeId,
        int	albumCatelogId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.albumName 	 = albumName;
        this.albumWord 	 = albumWord;
        this.albumPhotos 	 = albumPhotos;
        this.albumStatus 	 = albumStatus;
        this.albumActive 	 = albumActive;
        this.albumClasstype 	 = albumClasstype;
        this.albumClassId 	 = albumClassId;
        this.albumXid 	 = albumXid;
        this.albumTypeId 	 = albumTypeId;
        this.albumCatelogId 	 = albumCatelogId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getAlbumName   	() { return albumName; }
    public String   	getAlbumWord   	() { return albumWord; }
    public int   	getAlbumPhotos   	() { return albumPhotos; }
    public int   	getAlbumStatus   	() { return albumStatus; }
    public int   	getAlbumActive   	() { return albumActive; }
    public int   	getAlbumClasstype   	() { return albumClasstype; }
    public int   	getAlbumClassId   	() { return albumClassId; }
    public int   	getAlbumXid   	() { return albumXid; }
    public int   	getAlbumTypeId   	() { return albumTypeId; }
    public int   	getAlbumCatelogId   	() { return albumCatelogId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAlbumName   	(String albumName) { this.albumName = albumName; }
    public void 	setAlbumWord   	(String albumWord) { this.albumWord = albumWord; }
    public void 	setAlbumPhotos   	(int albumPhotos) { this.albumPhotos = albumPhotos; }
    public void 	setAlbumStatus   	(int albumStatus) { this.albumStatus = albumStatus; }
    public void 	setAlbumActive   	(int albumActive) { this.albumActive = albumActive; }
    public void 	setAlbumClasstype   	(int albumClasstype) { this.albumClasstype = albumClasstype; }
    public void 	setAlbumClassId   	(int albumClassId) { this.albumClassId = albumClassId; }
    public void 	setAlbumXid   	(int albumXid) { this.albumXid = albumXid; }
    public void 	setAlbumTypeId   	(int albumTypeId) { this.albumTypeId = albumTypeId; }
    public void 	setAlbumCatelogId   	(int albumCatelogId) { this.albumCatelogId = albumCatelogId; }
}
