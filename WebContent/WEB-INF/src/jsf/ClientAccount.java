package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class ClientAccount
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	clientAccountBankOwner;
    private String   	clientAccountBankName;
    private String   	clientAccountBankBranchName;
    private String   	clientAccountBankNum;
    private String   	clientAccountAccountNum;
    private String   	clientAccountAccountName;
    private String   	clientAccountBankIdPs;
    private int   	clientAccountActive;
    private int   	clientAccountCosttrade;
    private int   	bunitId;


    public ClientAccount() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	clientAccountBankOwner,
        String	clientAccountBankName,
        String	clientAccountBankBranchName,
        String	clientAccountBankNum,
        String	clientAccountAccountNum,
        String	clientAccountAccountName,
        String	clientAccountBankIdPs,
        int	clientAccountActive,
        int	clientAccountCosttrade,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.clientAccountBankOwner 	 = clientAccountBankOwner;
        this.clientAccountBankName 	 = clientAccountBankName;
        this.clientAccountBankBranchName 	 = clientAccountBankBranchName;
        this.clientAccountBankNum 	 = clientAccountBankNum;
        this.clientAccountAccountNum 	 = clientAccountAccountNum;
        this.clientAccountAccountName 	 = clientAccountAccountName;
        this.clientAccountBankIdPs 	 = clientAccountBankIdPs;
        this.clientAccountActive 	 = clientAccountActive;
        this.clientAccountCosttrade 	 = clientAccountCosttrade;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getClientAccountBankOwner   	() { return clientAccountBankOwner; }
    public String   	getClientAccountBankName   	() { return clientAccountBankName; }
    public String   	getClientAccountBankBranchName   	() { return clientAccountBankBranchName; }
    public String   	getClientAccountBankNum   	() { return clientAccountBankNum; }
    public String   	getClientAccountAccountNum   	() { return clientAccountAccountNum; }
    public String   	getClientAccountAccountName   	() { return clientAccountAccountName; }
    public String   	getClientAccountBankIdPs   	() { return clientAccountBankIdPs; }
    public int   	getClientAccountActive   	() { return clientAccountActive; }
    public int   	getClientAccountCosttrade   	() { return clientAccountCosttrade; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClientAccountBankOwner   	(String clientAccountBankOwner) { this.clientAccountBankOwner = clientAccountBankOwner; }
    public void 	setClientAccountBankName   	(String clientAccountBankName) { this.clientAccountBankName = clientAccountBankName; }
    public void 	setClientAccountBankBranchName   	(String clientAccountBankBranchName) { this.clientAccountBankBranchName = clientAccountBankBranchName; }
    public void 	setClientAccountBankNum   	(String clientAccountBankNum) { this.clientAccountBankNum = clientAccountBankNum; }
    public void 	setClientAccountAccountNum   	(String clientAccountAccountNum) { this.clientAccountAccountNum = clientAccountAccountNum; }
    public void 	setClientAccountAccountName   	(String clientAccountAccountName) { this.clientAccountAccountName = clientAccountAccountName; }
    public void 	setClientAccountBankIdPs   	(String clientAccountBankIdPs) { this.clientAccountBankIdPs = clientAccountBankIdPs; }
    public void 	setClientAccountActive   	(int clientAccountActive) { this.clientAccountActive = clientAccountActive; }
    public void 	setClientAccountCosttrade   	(int clientAccountCosttrade) { this.clientAccountCosttrade = clientAccountCosttrade; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
