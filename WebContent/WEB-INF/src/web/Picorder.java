package web;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Picorder extends Object implements java.io.Serializable
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	picorderClassType;
    private int   	picorderClassId;
    private int   	picorderUserId;
    private int   	picorderAlbumId;
    private String   	picorderPicname;
    private int   	picorderStatus;
    private int   	picorderGetway;
    private String   	picorderName;


    public Picorder() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	picorderClassType,
        int	picorderClassId,
        int	picorderUserId,
        int	picorderAlbumId,
        String	picorderPicname,
        int	picorderStatus,
        int	picorderGetway,
        String	picorderName    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.picorderClassType 	 = picorderClassType;
        this.picorderClassId 	 = picorderClassId;
        this.picorderUserId 	 = picorderUserId;
        this.picorderAlbumId 	 = picorderAlbumId;
        this.picorderPicname 	 = picorderPicname;
        this.picorderStatus 	 = picorderStatus;
        this.picorderGetway 	 = picorderGetway;
        this.picorderName 	 = picorderName;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getPicorderClassType   	() { return picorderClassType; }
    public int   	getPicorderClassId   	() { return picorderClassId; }
    public int   	getPicorderUserId   	() { return picorderUserId; }
    public int   	getPicorderAlbumId   	() { return picorderAlbumId; }
    public String   	getPicorderPicname   	() { return picorderPicname; }
    public int   	getPicorderStatus   	() { return picorderStatus; }
    public int   	getPicorderGetway   	() { return picorderGetway; }
    public String   	getPicorderName   	() { return picorderName; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPicorderClassType   	(int picorderClassType) { this.picorderClassType = picorderClassType; }
    public void 	setPicorderClassId   	(int picorderClassId) { this.picorderClassId = picorderClassId; }
    public void 	setPicorderUserId   	(int picorderUserId) { this.picorderUserId = picorderUserId; }
    public void 	setPicorderAlbumId   	(int picorderAlbumId) { this.picorderAlbumId = picorderAlbumId; }
    public void 	setPicorderPicname   	(String picorderPicname) { this.picorderPicname = picorderPicname; }
    public void 	setPicorderStatus   	(int picorderStatus) { this.picorderStatus = picorderStatus; }
    public void 	setPicorderGetway   	(int picorderGetway) { this.picorderGetway = picorderGetway; }
    public void 	setPicorderName   	(String picorderName) { this.picorderName = picorderName; }
}
