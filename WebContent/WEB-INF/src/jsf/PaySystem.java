package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class PaySystem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	paySystemCompanyName;
    private String   	paySystemCompanyAddress;
    private String   	paySystemCompanyPhone;
    private int   	paySystemLimitDate;
    private String   	paySystemCompanyUniteId;
    private String   	paySystemBankName;
    private String   	paySystemBankId;
    private String   	paySystemFirst5;
    private String   	paySystemBankStoreNickName;
    private String   	paySystemCompanyStoreNickName;
    private int   	paySystemBeforeLimitDate;
    private int   	paySystemLimitMoney;
    private int   	paySystemBankAccountId;
    private int   	paySystemMessageActive;
    private int   	paySystemMessageTo;
    private String   	paySystemMessageURL;
    private String   	paySystemMessageUser;
    private String   	paySystemMessagePass;
    private String   	paySystemMessageText;
    private int   	paySystemATMActive;
    private int   	paySystemStoreActive;
    private String   	paySystemReplaceWord;
    private int   	paySystemBirthActive;
    private String   	paySystemBirthWord;
    private int   	paySystemATMAccountId;
    private int   	paySystemEmailActive;
    private int   	paySystemEmailTo;
    private String   	paySystemEmailText;
    private int   	paySystemNoticeEmailTo;
    private int   	paySystemNoticeEmailType;
    private String   	paySystemNoticeEmailTitle;
    private String   	paySystemNoticeEmailText;
    private int   	paySystemNoticeMessageTo;
    private String   	paySystemNoticeMessageTest;
    private String   	paySystemEmailServer;
    private String   	paySystemEmailSender;
    private String   	paySystemEmailSenderAddress;
    private String   	paySystemEmailCode;
    private String   	paySystemFixATMAccount;
    private int   	paySystemFixATMNum;
    private int   	paySystemExtendNotpay;
    private String   	topLogoHtml;
    private String   	billLogoPath;
    private String   	billWaterMarkPath;
    private int   	useChecksum;
    private int   	version;
    private int   	customerType;
    private String   	website;
    private int   	banktype;
    private int   	pagetype;
    private int   	workflow;
    private int   	cardread;
    private String   	cardmachine;
    private int   	eventAuto;
    private int   	membrService;
    private String   	extraBankInfo;


    public PaySystem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	paySystemCompanyName,
        String	paySystemCompanyAddress,
        String	paySystemCompanyPhone,
        int	paySystemLimitDate,
        String	paySystemCompanyUniteId,
        String	paySystemBankName,
        String	paySystemBankId,
        String	paySystemFirst5,
        String	paySystemBankStoreNickName,
        String	paySystemCompanyStoreNickName,
        int	paySystemBeforeLimitDate,
        int	paySystemLimitMoney,
        int	paySystemBankAccountId,
        int	paySystemMessageActive,
        int	paySystemMessageTo,
        String	paySystemMessageURL,
        String	paySystemMessageUser,
        String	paySystemMessagePass,
        String	paySystemMessageText,
        int	paySystemATMActive,
        int	paySystemStoreActive,
        String	paySystemReplaceWord,
        int	paySystemBirthActive,
        String	paySystemBirthWord,
        int	paySystemATMAccountId,
        int	paySystemEmailActive,
        int	paySystemEmailTo,
        String	paySystemEmailText,
        int	paySystemNoticeEmailTo,
        int	paySystemNoticeEmailType,
        String	paySystemNoticeEmailTitle,
        String	paySystemNoticeEmailText,
        int	paySystemNoticeMessageTo,
        String	paySystemNoticeMessageTest,
        String	paySystemEmailServer,
        String	paySystemEmailSender,
        String	paySystemEmailSenderAddress,
        String	paySystemEmailCode,
        String	paySystemFixATMAccount,
        int	paySystemFixATMNum,
        int	paySystemExtendNotpay,
        String	topLogoHtml,
        String	billLogoPath,
        String	billWaterMarkPath,
        int	useChecksum,
        int	version,
        int	customerType,
        String	website,
        int	banktype,
        int	pagetype,
        int	workflow,
        int	cardread,
        String	cardmachine,
        int	eventAuto,
        int	membrService,
        String	extraBankInfo    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.paySystemCompanyName 	 = paySystemCompanyName;
        this.paySystemCompanyAddress 	 = paySystemCompanyAddress;
        this.paySystemCompanyPhone 	 = paySystemCompanyPhone;
        this.paySystemLimitDate 	 = paySystemLimitDate;
        this.paySystemCompanyUniteId 	 = paySystemCompanyUniteId;
        this.paySystemBankName 	 = paySystemBankName;
        this.paySystemBankId 	 = paySystemBankId;
        this.paySystemFirst5 	 = paySystemFirst5;
        this.paySystemBankStoreNickName 	 = paySystemBankStoreNickName;
        this.paySystemCompanyStoreNickName 	 = paySystemCompanyStoreNickName;
        this.paySystemBeforeLimitDate 	 = paySystemBeforeLimitDate;
        this.paySystemLimitMoney 	 = paySystemLimitMoney;
        this.paySystemBankAccountId 	 = paySystemBankAccountId;
        this.paySystemMessageActive 	 = paySystemMessageActive;
        this.paySystemMessageTo 	 = paySystemMessageTo;
        this.paySystemMessageURL 	 = paySystemMessageURL;
        this.paySystemMessageUser 	 = paySystemMessageUser;
        this.paySystemMessagePass 	 = paySystemMessagePass;
        this.paySystemMessageText 	 = paySystemMessageText;
        this.paySystemATMActive 	 = paySystemATMActive;
        this.paySystemStoreActive 	 = paySystemStoreActive;
        this.paySystemReplaceWord 	 = paySystemReplaceWord;
        this.paySystemBirthActive 	 = paySystemBirthActive;
        this.paySystemBirthWord 	 = paySystemBirthWord;
        this.paySystemATMAccountId 	 = paySystemATMAccountId;
        this.paySystemEmailActive 	 = paySystemEmailActive;
        this.paySystemEmailTo 	 = paySystemEmailTo;
        this.paySystemEmailText 	 = paySystemEmailText;
        this.paySystemNoticeEmailTo 	 = paySystemNoticeEmailTo;
        this.paySystemNoticeEmailType 	 = paySystemNoticeEmailType;
        this.paySystemNoticeEmailTitle 	 = paySystemNoticeEmailTitle;
        this.paySystemNoticeEmailText 	 = paySystemNoticeEmailText;
        this.paySystemNoticeMessageTo 	 = paySystemNoticeMessageTo;
        this.paySystemNoticeMessageTest 	 = paySystemNoticeMessageTest;
        this.paySystemEmailServer 	 = paySystemEmailServer;
        this.paySystemEmailSender 	 = paySystemEmailSender;
        this.paySystemEmailSenderAddress 	 = paySystemEmailSenderAddress;
        this.paySystemEmailCode 	 = paySystemEmailCode;
        this.paySystemFixATMAccount 	 = paySystemFixATMAccount;
        this.paySystemFixATMNum 	 = paySystemFixATMNum;
        this.paySystemExtendNotpay 	 = paySystemExtendNotpay;
        this.topLogoHtml 	 = topLogoHtml;
        this.billLogoPath 	 = billLogoPath;
        this.billWaterMarkPath 	 = billWaterMarkPath;
        this.useChecksum 	 = useChecksum;
        this.version 	 = version;
        this.customerType 	 = customerType;
        this.website 	 = website;
        this.banktype 	 = banktype;
        this.pagetype 	 = pagetype;
        this.workflow 	 = workflow;
        this.cardread 	 = cardread;
        this.cardmachine 	 = cardmachine;
        this.eventAuto 	 = eventAuto;
        this.membrService 	 = membrService;
        this.extraBankInfo 	 = extraBankInfo;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getPaySystemCompanyName   	() { return paySystemCompanyName; }
    public String   	getPaySystemCompanyAddress   	() { return paySystemCompanyAddress; }
    public String   	getPaySystemCompanyPhone   	() { return paySystemCompanyPhone; }
    public int   	getPaySystemLimitDate   	() { return paySystemLimitDate; }
    public String   	getPaySystemCompanyUniteId   	() { return paySystemCompanyUniteId; }
    public String   	getPaySystemBankName   	() { return paySystemBankName; }
    public String   	getPaySystemBankId   	() { return paySystemBankId; }
    public String   	getPaySystemFirst5   	() { return paySystemFirst5; }
    public String   	getPaySystemBankStoreNickName   	() { return paySystemBankStoreNickName; }
    public String   	getPaySystemCompanyStoreNickName   	() { return paySystemCompanyStoreNickName; }
    public int   	getPaySystemBeforeLimitDate   	() { return paySystemBeforeLimitDate; }
    public int   	getPaySystemLimitMoney   	() { return paySystemLimitMoney; }
    public int   	getPaySystemBankAccountId   	() { return paySystemBankAccountId; }
    public int   	getPaySystemMessageActive   	() { return paySystemMessageActive; }
    public int   	getPaySystemMessageTo   	() { return paySystemMessageTo; }
    public String   	getPaySystemMessageURL   	() { return paySystemMessageURL; }
    public String   	getPaySystemMessageUser   	() { return paySystemMessageUser; }
    public String   	getPaySystemMessagePass   	() { return paySystemMessagePass; }
    public String   	getPaySystemMessageText   	() { return paySystemMessageText; }
    public int   	getPaySystemATMActive   	() { return paySystemATMActive; }
    public int   	getPaySystemStoreActive   	() { return paySystemStoreActive; }
    public String   	getPaySystemReplaceWord   	() { return paySystemReplaceWord; }
    public int   	getPaySystemBirthActive   	() { return paySystemBirthActive; }
    public String   	getPaySystemBirthWord   	() { return paySystemBirthWord; }
    public int   	getPaySystemATMAccountId   	() { return paySystemATMAccountId; }
    public int   	getPaySystemEmailActive   	() { return paySystemEmailActive; }
    public int   	getPaySystemEmailTo   	() { return paySystemEmailTo; }
    public String   	getPaySystemEmailText   	() { return paySystemEmailText; }
    public int   	getPaySystemNoticeEmailTo   	() { return paySystemNoticeEmailTo; }
    public int   	getPaySystemNoticeEmailType   	() { return paySystemNoticeEmailType; }
    public String   	getPaySystemNoticeEmailTitle   	() { return paySystemNoticeEmailTitle; }
    public String   	getPaySystemNoticeEmailText   	() { return paySystemNoticeEmailText; }
    public int   	getPaySystemNoticeMessageTo   	() { return paySystemNoticeMessageTo; }
    public String   	getPaySystemNoticeMessageTest   	() { return paySystemNoticeMessageTest; }
    public String   	getPaySystemEmailServer   	() { return paySystemEmailServer; }
    public String   	getPaySystemEmailSender   	() { return paySystemEmailSender; }
    public String   	getPaySystemEmailSenderAddress   	() { return paySystemEmailSenderAddress; }
    public String   	getPaySystemEmailCode   	() { return paySystemEmailCode; }
    public String   	getPaySystemFixATMAccount   	() { return paySystemFixATMAccount; }
    public int   	getPaySystemFixATMNum   	() { return paySystemFixATMNum; }
    public int   	getPaySystemExtendNotpay   	() { return paySystemExtendNotpay; }
    public String   	getTopLogoHtml   	() { return topLogoHtml; }
    public String   	getBillLogoPath   	() { return billLogoPath; }
    public String   	getBillWaterMarkPath   	() { return billWaterMarkPath; }
    public int   	getUseChecksum   	() { return useChecksum; }
    public int   	getVersion   	() { return version; }
    public int   	getCustomerType   	() { return customerType; }
    public String   	getWebsite   	() { return website; }
    public int   	getBanktype   	() { return banktype; }
    public int   	getPagetype   	() { return pagetype; }
    public int   	getWorkflow   	() { return workflow; }
    public int   	getCardread   	() { return cardread; }
    public String   	getCardmachine   	() { return cardmachine; }
    public int   	getEventAuto   	() { return eventAuto; }
    public int   	getMembrService   	() { return membrService; }
    public String   	getExtraBankInfo   	() { return extraBankInfo; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPaySystemCompanyName   	(String paySystemCompanyName) { this.paySystemCompanyName = paySystemCompanyName; }
    public void 	setPaySystemCompanyAddress   	(String paySystemCompanyAddress) { this.paySystemCompanyAddress = paySystemCompanyAddress; }
    public void 	setPaySystemCompanyPhone   	(String paySystemCompanyPhone) { this.paySystemCompanyPhone = paySystemCompanyPhone; }
    public void 	setPaySystemLimitDate   	(int paySystemLimitDate) { this.paySystemLimitDate = paySystemLimitDate; }
    public void 	setPaySystemCompanyUniteId   	(String paySystemCompanyUniteId) { this.paySystemCompanyUniteId = paySystemCompanyUniteId; }
    public void 	setPaySystemBankName   	(String paySystemBankName) { this.paySystemBankName = paySystemBankName; }
    public void 	setPaySystemBankId   	(String paySystemBankId) { this.paySystemBankId = paySystemBankId; }
    public void 	setPaySystemFirst5   	(String paySystemFirst5) { this.paySystemFirst5 = paySystemFirst5; }
    public void 	setPaySystemBankStoreNickName   	(String paySystemBankStoreNickName) { this.paySystemBankStoreNickName = paySystemBankStoreNickName; }
    public void 	setPaySystemCompanyStoreNickName   	(String paySystemCompanyStoreNickName) { this.paySystemCompanyStoreNickName = paySystemCompanyStoreNickName; }
    public void 	setPaySystemBeforeLimitDate   	(int paySystemBeforeLimitDate) { this.paySystemBeforeLimitDate = paySystemBeforeLimitDate; }
    public void 	setPaySystemLimitMoney   	(int paySystemLimitMoney) { this.paySystemLimitMoney = paySystemLimitMoney; }
    public void 	setPaySystemBankAccountId   	(int paySystemBankAccountId) { this.paySystemBankAccountId = paySystemBankAccountId; }
    public void 	setPaySystemMessageActive   	(int paySystemMessageActive) { this.paySystemMessageActive = paySystemMessageActive; }
    public void 	setPaySystemMessageTo   	(int paySystemMessageTo) { this.paySystemMessageTo = paySystemMessageTo; }
    public void 	setPaySystemMessageURL   	(String paySystemMessageURL) { this.paySystemMessageURL = paySystemMessageURL; }
    public void 	setPaySystemMessageUser   	(String paySystemMessageUser) { this.paySystemMessageUser = paySystemMessageUser; }
    public void 	setPaySystemMessagePass   	(String paySystemMessagePass) { this.paySystemMessagePass = paySystemMessagePass; }
    public void 	setPaySystemMessageText   	(String paySystemMessageText) { this.paySystemMessageText = paySystemMessageText; }
    public void 	setPaySystemATMActive   	(int paySystemATMActive) { this.paySystemATMActive = paySystemATMActive; }
    public void 	setPaySystemStoreActive   	(int paySystemStoreActive) { this.paySystemStoreActive = paySystemStoreActive; }
    public void 	setPaySystemReplaceWord   	(String paySystemReplaceWord) { this.paySystemReplaceWord = paySystemReplaceWord; }
    public void 	setPaySystemBirthActive   	(int paySystemBirthActive) { this.paySystemBirthActive = paySystemBirthActive; }
    public void 	setPaySystemBirthWord   	(String paySystemBirthWord) { this.paySystemBirthWord = paySystemBirthWord; }
    public void 	setPaySystemATMAccountId   	(int paySystemATMAccountId) { this.paySystemATMAccountId = paySystemATMAccountId; }
    public void 	setPaySystemEmailActive   	(int paySystemEmailActive) { this.paySystemEmailActive = paySystemEmailActive; }
    public void 	setPaySystemEmailTo   	(int paySystemEmailTo) { this.paySystemEmailTo = paySystemEmailTo; }
    public void 	setPaySystemEmailText   	(String paySystemEmailText) { this.paySystemEmailText = paySystemEmailText; }
    public void 	setPaySystemNoticeEmailTo   	(int paySystemNoticeEmailTo) { this.paySystemNoticeEmailTo = paySystemNoticeEmailTo; }
    public void 	setPaySystemNoticeEmailType   	(int paySystemNoticeEmailType) { this.paySystemNoticeEmailType = paySystemNoticeEmailType; }
    public void 	setPaySystemNoticeEmailTitle   	(String paySystemNoticeEmailTitle) { this.paySystemNoticeEmailTitle = paySystemNoticeEmailTitle; }
    public void 	setPaySystemNoticeEmailText   	(String paySystemNoticeEmailText) { this.paySystemNoticeEmailText = paySystemNoticeEmailText; }
    public void 	setPaySystemNoticeMessageTo   	(int paySystemNoticeMessageTo) { this.paySystemNoticeMessageTo = paySystemNoticeMessageTo; }
    public void 	setPaySystemNoticeMessageTest   	(String paySystemNoticeMessageTest) { this.paySystemNoticeMessageTest = paySystemNoticeMessageTest; }
    public void 	setPaySystemEmailServer   	(String paySystemEmailServer) { this.paySystemEmailServer = paySystemEmailServer; }
    public void 	setPaySystemEmailSender   	(String paySystemEmailSender) { this.paySystemEmailSender = paySystemEmailSender; }
    public void 	setPaySystemEmailSenderAddress   	(String paySystemEmailSenderAddress) { this.paySystemEmailSenderAddress = paySystemEmailSenderAddress; }
    public void 	setPaySystemEmailCode   	(String paySystemEmailCode) { this.paySystemEmailCode = paySystemEmailCode; }
    public void 	setPaySystemFixATMAccount   	(String paySystemFixATMAccount) { this.paySystemFixATMAccount = paySystemFixATMAccount; }
    public void 	setPaySystemFixATMNum   	(int paySystemFixATMNum) { this.paySystemFixATMNum = paySystemFixATMNum; }
    public void 	setPaySystemExtendNotpay   	(int paySystemExtendNotpay) { this.paySystemExtendNotpay = paySystemExtendNotpay; }
    public void 	setTopLogoHtml   	(String topLogoHtml) { this.topLogoHtml = topLogoHtml; }
    public void 	setBillLogoPath   	(String billLogoPath) { this.billLogoPath = billLogoPath; }
    public void 	setBillWaterMarkPath   	(String billWaterMarkPath) { this.billWaterMarkPath = billWaterMarkPath; }
    public void 	setUseChecksum   	(int useChecksum) { this.useChecksum = useChecksum; }
    public void 	setVersion   	(int version) { this.version = version; }
    public void 	setCustomerType   	(int customerType) { this.customerType = customerType; }
    public void 	setWebsite   	(String website) { this.website = website; }
    public void 	setBanktype   	(int banktype) { this.banktype = banktype; }
    public void 	setPagetype   	(int pagetype) { this.pagetype = pagetype; }
    public void 	setWorkflow   	(int workflow) { this.workflow = workflow; }
    public void 	setCardread   	(int cardread) { this.cardread = cardread; }
    public void 	setCardmachine   	(String cardmachine) { this.cardmachine = cardmachine; }
    public void 	setEventAuto   	(int eventAuto) { this.eventAuto = eventAuto; }
    public void 	setMembrService   	(int membrService) { this.membrService = membrService; }
    public void 	setExtraBankInfo   	(String extraBankInfo) { this.extraBankInfo = extraBankInfo; }
}
