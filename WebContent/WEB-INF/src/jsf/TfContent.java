package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class TfContent
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	tfContentTalentFileId;
    private String   	tfContentTitle;
    private String   	tfContentContnet;
    private int   	tfContentSendKind;
    private int   	tfContentSendId;
    private String   	PicFile;


    public TfContent() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	tfContentTalentFileId,
        String	tfContentTitle,
        String	tfContentContnet,
        int	tfContentSendKind,
        int	tfContentSendId,
        String	PicFile    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.tfContentTalentFileId 	 = tfContentTalentFileId;
        this.tfContentTitle 	 = tfContentTitle;
        this.tfContentContnet 	 = tfContentContnet;
        this.tfContentSendKind 	 = tfContentSendKind;
        this.tfContentSendId 	 = tfContentSendId;
        this.PicFile 	 = PicFile;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTfContentTalentFileId   	() { return tfContentTalentFileId; }
    public String   	getTfContentTitle   	() { return tfContentTitle; }
    public String   	getTfContentContnet   	() { return tfContentContnet; }
    public int   	getTfContentSendKind   	() { return tfContentSendKind; }
    public int   	getTfContentSendId   	() { return tfContentSendId; }
    public String   	getPicFile   	() { return PicFile; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTfContentTalentFileId   	(int tfContentTalentFileId) { this.tfContentTalentFileId = tfContentTalentFileId; }
    public void 	setTfContentTitle   	(String tfContentTitle) { this.tfContentTitle = tfContentTitle; }
    public void 	setTfContentContnet   	(String tfContentContnet) { this.tfContentContnet = tfContentContnet; }
    public void 	setTfContentSendKind   	(int tfContentSendKind) { this.tfContentSendKind = tfContentSendKind; }
    public void 	setTfContentSendId   	(int tfContentSendId) { this.tfContentSendId = tfContentSendId; }
    public void 	setPicFile   	(String PicFile) { this.PicFile = PicFile; }
}
