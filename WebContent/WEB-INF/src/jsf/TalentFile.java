package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class TalentFile
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	talentFileStudentId;
    private int   	talentFileTalentdateId;
    private int   	talentFileTalentId;
    private int   	talentFilePresent;
    private String   	talentFileContent;
    private int   	talentFileUserId;
    private int   	talentFileSendStatus;


    public TalentFile() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	talentFileStudentId,
        int	talentFileTalentdateId,
        int	talentFileTalentId,
        int	talentFilePresent,
        String	talentFileContent,
        int	talentFileUserId,
        int	talentFileSendStatus    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.talentFileStudentId 	 = talentFileStudentId;
        this.talentFileTalentdateId 	 = talentFileTalentdateId;
        this.talentFileTalentId 	 = talentFileTalentId;
        this.talentFilePresent 	 = talentFilePresent;
        this.talentFileContent 	 = talentFileContent;
        this.talentFileUserId 	 = talentFileUserId;
        this.talentFileSendStatus 	 = talentFileSendStatus;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTalentFileStudentId   	() { return talentFileStudentId; }
    public int   	getTalentFileTalentdateId   	() { return talentFileTalentdateId; }
    public int   	getTalentFileTalentId   	() { return talentFileTalentId; }
    public int   	getTalentFilePresent   	() { return talentFilePresent; }
    public String   	getTalentFileContent   	() { return talentFileContent; }
    public int   	getTalentFileUserId   	() { return talentFileUserId; }
    public int   	getTalentFileSendStatus   	() { return talentFileSendStatus; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTalentFileStudentId   	(int talentFileStudentId) { this.talentFileStudentId = talentFileStudentId; }
    public void 	setTalentFileTalentdateId   	(int talentFileTalentdateId) { this.talentFileTalentdateId = talentFileTalentdateId; }
    public void 	setTalentFileTalentId   	(int talentFileTalentId) { this.talentFileTalentId = talentFileTalentId; }
    public void 	setTalentFilePresent   	(int talentFilePresent) { this.talentFilePresent = talentFilePresent; }
    public void 	setTalentFileContent   	(String talentFileContent) { this.talentFileContent = talentFileContent; }
    public void 	setTalentFileUserId   	(int talentFileUserId) { this.talentFileUserId = talentFileUserId; }
    public void 	setTalentFileSendStatus   	(int talentFileSendStatus) { this.talentFileSendStatus = talentFileSendStatus; }
}
