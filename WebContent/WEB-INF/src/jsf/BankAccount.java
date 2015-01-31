package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class BankAccount
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	bankAccountName;
    private String   	bankAccountId;
    private String   	bankAccountAccount;
    private String   	bankAccountAccountName;
    private int   	bankAccountLogUseId;
    private Date   	bankAccountLogDate;
    private String   	bankAccountLogPs;
    private int   	bankAccountNumber;
    private int   	bankAccountActive;
    private String   	bankAccount2client;
    private String   	bankAccountPayDate;
    private String   	bankAccountWebAddress;
    private String   	bankAccountWeb1;
    private String   	bankAccountWeb2;
    private String   	bankAccountWeb3;
    private int   	bankAccountATMActive;
    private String   	bankAccountRealName;
    private String   	bankAccountBranchName;
    private int   	bunitId;


    public BankAccount() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	bankAccountName,
        String	bankAccountId,
        String	bankAccountAccount,
        String	bankAccountAccountName,
        int	bankAccountLogUseId,
        Date	bankAccountLogDate,
        String	bankAccountLogPs,
        int	bankAccountNumber,
        int	bankAccountActive,
        String	bankAccount2client,
        String	bankAccountPayDate,
        String	bankAccountWebAddress,
        String	bankAccountWeb1,
        String	bankAccountWeb2,
        String	bankAccountWeb3,
        int	bankAccountATMActive,
        String	bankAccountRealName,
        String	bankAccountBranchName,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.bankAccountName 	 = bankAccountName;
        this.bankAccountId 	 = bankAccountId;
        this.bankAccountAccount 	 = bankAccountAccount;
        this.bankAccountAccountName 	 = bankAccountAccountName;
        this.bankAccountLogUseId 	 = bankAccountLogUseId;
        this.bankAccountLogDate 	 = bankAccountLogDate;
        this.bankAccountLogPs 	 = bankAccountLogPs;
        this.bankAccountNumber 	 = bankAccountNumber;
        this.bankAccountActive 	 = bankAccountActive;
        this.bankAccount2client 	 = bankAccount2client;
        this.bankAccountPayDate 	 = bankAccountPayDate;
        this.bankAccountWebAddress 	 = bankAccountWebAddress;
        this.bankAccountWeb1 	 = bankAccountWeb1;
        this.bankAccountWeb2 	 = bankAccountWeb2;
        this.bankAccountWeb3 	 = bankAccountWeb3;
        this.bankAccountATMActive 	 = bankAccountATMActive;
        this.bankAccountRealName 	 = bankAccountRealName;
        this.bankAccountBranchName 	 = bankAccountBranchName;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getBankAccountName   	() { return bankAccountName; }
    public String   	getBankAccountId   	() { return bankAccountId; }
    public String   	getBankAccountAccount   	() { return bankAccountAccount; }
    public String   	getBankAccountAccountName   	() { return bankAccountAccountName; }
    public int   	getBankAccountLogUseId   	() { return bankAccountLogUseId; }
    public Date   	getBankAccountLogDate   	() { return bankAccountLogDate; }
    public String   	getBankAccountLogPs   	() { return bankAccountLogPs; }
    public int   	getBankAccountNumber   	() { return bankAccountNumber; }
    public int   	getBankAccountActive   	() { return bankAccountActive; }
    public String   	getBankAccount2client   	() { return bankAccount2client; }
    public String   	getBankAccountPayDate   	() { return bankAccountPayDate; }
    public String   	getBankAccountWebAddress   	() { return bankAccountWebAddress; }
    public String   	getBankAccountWeb1   	() { return bankAccountWeb1; }
    public String   	getBankAccountWeb2   	() { return bankAccountWeb2; }
    public String   	getBankAccountWeb3   	() { return bankAccountWeb3; }
    public int   	getBankAccountATMActive   	() { return bankAccountATMActive; }
    public String   	getBankAccountRealName   	() { return bankAccountRealName; }
    public String   	getBankAccountBranchName   	() { return bankAccountBranchName; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setBankAccountName   	(String bankAccountName) { this.bankAccountName = bankAccountName; }
    public void 	setBankAccountId   	(String bankAccountId) { this.bankAccountId = bankAccountId; }
    public void 	setBankAccountAccount   	(String bankAccountAccount) { this.bankAccountAccount = bankAccountAccount; }
    public void 	setBankAccountAccountName   	(String bankAccountAccountName) { this.bankAccountAccountName = bankAccountAccountName; }
    public void 	setBankAccountLogUseId   	(int bankAccountLogUseId) { this.bankAccountLogUseId = bankAccountLogUseId; }
    public void 	setBankAccountLogDate   	(Date bankAccountLogDate) { this.bankAccountLogDate = bankAccountLogDate; }
    public void 	setBankAccountLogPs   	(String bankAccountLogPs) { this.bankAccountLogPs = bankAccountLogPs; }
    public void 	setBankAccountNumber   	(int bankAccountNumber) { this.bankAccountNumber = bankAccountNumber; }
    public void 	setBankAccountActive   	(int bankAccountActive) { this.bankAccountActive = bankAccountActive; }
    public void 	setBankAccount2client   	(String bankAccount2client) { this.bankAccount2client = bankAccount2client; }
    public void 	setBankAccountPayDate   	(String bankAccountPayDate) { this.bankAccountPayDate = bankAccountPayDate; }
    public void 	setBankAccountWebAddress   	(String bankAccountWebAddress) { this.bankAccountWebAddress = bankAccountWebAddress; }
    public void 	setBankAccountWeb1   	(String bankAccountWeb1) { this.bankAccountWeb1 = bankAccountWeb1; }
    public void 	setBankAccountWeb2   	(String bankAccountWeb2) { this.bankAccountWeb2 = bankAccountWeb2; }
    public void 	setBankAccountWeb3   	(String bankAccountWeb3) { this.bankAccountWeb3 = bankAccountWeb3; }
    public void 	setBankAccountATMActive   	(int bankAccountATMActive) { this.bankAccountATMActive = bankAccountATMActive; }
    public void 	setBankAccountRealName   	(String bankAccountRealName) { this.bankAccountRealName = bankAccountRealName; }
    public void 	setBankAccountBranchName   	(String bankAccountBranchName) { this.bankAccountBranchName = bankAccountBranchName; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
