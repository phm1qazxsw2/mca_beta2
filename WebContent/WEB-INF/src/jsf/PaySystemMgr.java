package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PaySystemMgr extends Manager
{
    private static PaySystemMgr _instance = null;

    PaySystemMgr() {}

    public synchronized static PaySystemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PaySystemMgr();
        }
        return _instance;
    }

    public PaySystemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "paysystem";
    }

    protected Object makeBean()
    {
        return new PaySystem();
    }

    protected int getBeanId(Object obj)
    {
        return ((PaySystem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PaySystem item = (PaySystem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	paySystemCompanyName		 = rs.getString("paySystemCompanyName");
            String	paySystemCompanyAddress		 = rs.getString("paySystemCompanyAddress");
            String	paySystemCompanyPhone		 = rs.getString("paySystemCompanyPhone");
            int	paySystemLimitDate		 = rs.getInt("paySystemLimitDate");
            String	paySystemCompanyUniteId		 = rs.getString("paySystemCompanyUniteId");
            String	paySystemBankName		 = rs.getString("paySystemBankName");
            String	paySystemBankId		 = rs.getString("paySystemBankId");
            String	paySystemFirst5		 = rs.getString("paySystemFirst5");
            String	paySystemBankStoreNickName		 = rs.getString("paySystemBankStoreNickName");
            String	paySystemCompanyStoreNickName		 = rs.getString("paySystemCompanyStoreNickName");
            int	paySystemBeforeLimitDate		 = rs.getInt("paySystemBeforeLimitDate");
            int	paySystemLimitMoney		 = rs.getInt("paySystemLimitMoney");
            int	paySystemBankAccountId		 = rs.getInt("paySystemBankAccountId");
            int	paySystemMessageActive		 = rs.getInt("paySystemMessageActive");
            int	paySystemMessageTo		 = rs.getInt("paySystemMessageTo");
            String	paySystemMessageURL		 = rs.getString("paySystemMessageURL");
            String	paySystemMessageUser		 = rs.getString("paySystemMessageUser");
            String	paySystemMessagePass		 = rs.getString("paySystemMessagePass");
            String	paySystemMessageText		 = rs.getString("paySystemMessageText");
            int	paySystemATMActive		 = rs.getInt("paySystemATMActive");
            int	paySystemStoreActive		 = rs.getInt("paySystemStoreActive");
            String	paySystemReplaceWord		 = rs.getString("paySystemReplaceWord");
            int	paySystemBirthActive		 = rs.getInt("paySystemBirthActive");
            String	paySystemBirthWord		 = rs.getString("paySystemBirthWord");
            int	paySystemATMAccountId		 = rs.getInt("paySystemATMAccountId");
            int	paySystemEmailActive		 = rs.getInt("paySystemEmailActive");
            int	paySystemEmailTo		 = rs.getInt("paySystemEmailTo");
            String	paySystemEmailText		 = rs.getString("paySystemEmailText");
            int	paySystemNoticeEmailTo		 = rs.getInt("paySystemNoticeEmailTo");
            int	paySystemNoticeEmailType		 = rs.getInt("paySystemNoticeEmailType");
            String	paySystemNoticeEmailTitle		 = rs.getString("paySystemNoticeEmailTitle");
            String	paySystemNoticeEmailText		 = rs.getString("paySystemNoticeEmailText");
            int	paySystemNoticeMessageTo		 = rs.getInt("paySystemNoticeMessageTo");
            String	paySystemNoticeMessageTest		 = rs.getString("paySystemNoticeMessageTest");
            String	paySystemEmailServer		 = rs.getString("paySystemEmailServer");
            String	paySystemEmailSender		 = rs.getString("paySystemEmailSender");
            String	paySystemEmailSenderAddress		 = rs.getString("paySystemEmailSenderAddress");
            String	paySystemEmailCode		 = rs.getString("paySystemEmailCode");
            String	paySystemFixATMAccount		 = rs.getString("paySystemFixATMAccount");
            int	paySystemFixATMNum		 = rs.getInt("paySystemFixATMNum");
            int	paySystemExtendNotpay		 = rs.getInt("paySystemExtendNotpay");
            String	topLogoHtml		 = rs.getString("topLogoHtml");
            String	billLogoPath		 = rs.getString("billLogoPath");
            String	billWaterMarkPath		 = rs.getString("billWaterMarkPath");
            int	useChecksum		 = rs.getInt("useChecksum");
            int	version		 = rs.getInt("version");
            int	customerType		 = rs.getInt("customerType");
            String	website		 = rs.getString("website");
            int	banktype		 = rs.getInt("banktype");
            int	pagetype		 = rs.getInt("pagetype");
            int	workflow		 = rs.getInt("workflow");
            int	cardread		 = rs.getInt("cardread");
            String	cardmachine		 = rs.getString("cardmachine");
            int	eventAuto		 = rs.getInt("eventAuto");
            int	membrService		 = rs.getInt("membrService");
            String	extraBankInfo		 = rs.getString("extraBankInfo");

            item
            .init(id, created, modified
            , paySystemCompanyName, paySystemCompanyAddress, paySystemCompanyPhone
            , paySystemLimitDate, paySystemCompanyUniteId, paySystemBankName
            , paySystemBankId, paySystemFirst5, paySystemBankStoreNickName
            , paySystemCompanyStoreNickName, paySystemBeforeLimitDate, paySystemLimitMoney
            , paySystemBankAccountId, paySystemMessageActive, paySystemMessageTo
            , paySystemMessageURL, paySystemMessageUser, paySystemMessagePass
            , paySystemMessageText, paySystemATMActive, paySystemStoreActive
            , paySystemReplaceWord, paySystemBirthActive, paySystemBirthWord
            , paySystemATMAccountId, paySystemEmailActive, paySystemEmailTo
            , paySystemEmailText, paySystemNoticeEmailTo, paySystemNoticeEmailType
            , paySystemNoticeEmailTitle, paySystemNoticeEmailText, paySystemNoticeMessageTo
            , paySystemNoticeMessageTest, paySystemEmailServer, paySystemEmailSender
            , paySystemEmailSenderAddress, paySystemEmailCode, paySystemFixATMAccount
            , paySystemFixATMNum, paySystemExtendNotpay, topLogoHtml
            , billLogoPath, billWaterMarkPath, useChecksum
            , version, customerType, website
            , banktype, pagetype, workflow
            , cardread, cardmachine, eventAuto
            , membrService, extraBankInfo);
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
        PaySystem item = (PaySystem) obj;

        String ret = "modified=NOW()"
            + ",paySystemCompanyName='" + ServerTool.escapeString(item.getPaySystemCompanyName()) + "'"
            + ",paySystemCompanyAddress='" + ServerTool.escapeString(item.getPaySystemCompanyAddress()) + "'"
            + ",paySystemCompanyPhone='" + ServerTool.escapeString(item.getPaySystemCompanyPhone()) + "'"
            + ",paySystemLimitDate=" + item.getPaySystemLimitDate()
            + ",paySystemCompanyUniteId='" + ServerTool.escapeString(item.getPaySystemCompanyUniteId()) + "'"
            + ",paySystemBankName='" + ServerTool.escapeString(item.getPaySystemBankName()) + "'"
            + ",paySystemBankId='" + ServerTool.escapeString(item.getPaySystemBankId()) + "'"
            + ",paySystemFirst5='" + ServerTool.escapeString(item.getPaySystemFirst5()) + "'"
            + ",paySystemBankStoreNickName='" + ServerTool.escapeString(item.getPaySystemBankStoreNickName()) + "'"
            + ",paySystemCompanyStoreNickName='" + ServerTool.escapeString(item.getPaySystemCompanyStoreNickName()) + "'"
            + ",paySystemBeforeLimitDate=" + item.getPaySystemBeforeLimitDate()
            + ",paySystemLimitMoney=" + item.getPaySystemLimitMoney()
            + ",paySystemBankAccountId=" + item.getPaySystemBankAccountId()
            + ",paySystemMessageActive=" + item.getPaySystemMessageActive()
            + ",paySystemMessageTo=" + item.getPaySystemMessageTo()
            + ",paySystemMessageURL='" + ServerTool.escapeString(item.getPaySystemMessageURL()) + "'"
            + ",paySystemMessageUser='" + ServerTool.escapeString(item.getPaySystemMessageUser()) + "'"
            + ",paySystemMessagePass='" + ServerTool.escapeString(item.getPaySystemMessagePass()) + "'"
            + ",paySystemMessageText='" + ServerTool.escapeString(item.getPaySystemMessageText()) + "'"
            + ",paySystemATMActive=" + item.getPaySystemATMActive()
            + ",paySystemStoreActive=" + item.getPaySystemStoreActive()
            + ",paySystemReplaceWord='" + ServerTool.escapeString(item.getPaySystemReplaceWord()) + "'"
            + ",paySystemBirthActive=" + item.getPaySystemBirthActive()
            + ",paySystemBirthWord='" + ServerTool.escapeString(item.getPaySystemBirthWord()) + "'"
            + ",paySystemATMAccountId=" + item.getPaySystemATMAccountId()
            + ",paySystemEmailActive=" + item.getPaySystemEmailActive()
            + ",paySystemEmailTo=" + item.getPaySystemEmailTo()
            + ",paySystemEmailText='" + ServerTool.escapeString(item.getPaySystemEmailText()) + "'"
            + ",paySystemNoticeEmailTo=" + item.getPaySystemNoticeEmailTo()
            + ",paySystemNoticeEmailType=" + item.getPaySystemNoticeEmailType()
            + ",paySystemNoticeEmailTitle='" + ServerTool.escapeString(item.getPaySystemNoticeEmailTitle()) + "'"
            + ",paySystemNoticeEmailText='" + ServerTool.escapeString(item.getPaySystemNoticeEmailText()) + "'"
            + ",paySystemNoticeMessageTo=" + item.getPaySystemNoticeMessageTo()
            + ",paySystemNoticeMessageTest='" + ServerTool.escapeString(item.getPaySystemNoticeMessageTest()) + "'"
            + ",paySystemEmailServer='" + ServerTool.escapeString(item.getPaySystemEmailServer()) + "'"
            + ",paySystemEmailSender='" + ServerTool.escapeString(item.getPaySystemEmailSender()) + "'"
            + ",paySystemEmailSenderAddress='" + ServerTool.escapeString(item.getPaySystemEmailSenderAddress()) + "'"
            + ",paySystemEmailCode='" + ServerTool.escapeString(item.getPaySystemEmailCode()) + "'"
            + ",paySystemFixATMAccount='" + ServerTool.escapeString(item.getPaySystemFixATMAccount()) + "'"
            + ",paySystemFixATMNum=" + item.getPaySystemFixATMNum()
            + ",paySystemExtendNotpay=" + item.getPaySystemExtendNotpay()
            + ",topLogoHtml='" + ServerTool.escapeString(item.getTopLogoHtml()) + "'"
            + ",billLogoPath='" + ServerTool.escapeString(item.getBillLogoPath()) + "'"
            + ",billWaterMarkPath='" + ServerTool.escapeString(item.getBillWaterMarkPath()) + "'"
            + ",useChecksum=" + item.getUseChecksum()
            + ",version=" + item.getVersion()
            + ",customerType=" + item.getCustomerType()
            + ",website='" + ServerTool.escapeString(item.getWebsite()) + "'"
            + ",banktype=" + item.getBanktype()
            + ",pagetype=" + item.getPagetype()
            + ",workflow=" + item.getWorkflow()
            + ",cardread=" + item.getCardread()
            + ",cardmachine='" + ServerTool.escapeString(item.getCardmachine()) + "'"
            + ",eventAuto=" + item.getEventAuto()
            + ",membrService=" + item.getMembrService()
            + ",extraBankInfo='" + ServerTool.escapeString(item.getExtraBankInfo()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, paySystemCompanyName, paySystemCompanyAddress, paySystemCompanyPhone, paySystemLimitDate, paySystemCompanyUniteId, paySystemBankName, paySystemBankId, paySystemFirst5, paySystemBankStoreNickName, paySystemCompanyStoreNickName, paySystemBeforeLimitDate, paySystemLimitMoney, paySystemBankAccountId, paySystemMessageActive, paySystemMessageTo, paySystemMessageURL, paySystemMessageUser, paySystemMessagePass, paySystemMessageText, paySystemATMActive, paySystemStoreActive, paySystemReplaceWord, paySystemBirthActive, paySystemBirthWord, paySystemATMAccountId, paySystemEmailActive, paySystemEmailTo, paySystemEmailText, paySystemNoticeEmailTo, paySystemNoticeEmailType, paySystemNoticeEmailTitle, paySystemNoticeEmailText, paySystemNoticeMessageTo, paySystemNoticeMessageTest, paySystemEmailServer, paySystemEmailSender, paySystemEmailSenderAddress, paySystemEmailCode, paySystemFixATMAccount, paySystemFixATMNum, paySystemExtendNotpay, topLogoHtml, billLogoPath, billWaterMarkPath, useChecksum, version, customerType, website, banktype, pagetype, workflow, cardread, cardmachine, eventAuto, membrService, extraBankInfo";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        PaySystem item = (PaySystem) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getPaySystemCompanyName()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemCompanyAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemCompanyPhone()) + "'"
            + "," + item.getPaySystemLimitDate()
            + ",'" + ServerTool.escapeString(item.getPaySystemCompanyUniteId()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemBankName()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemBankId()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemFirst5()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemBankStoreNickName()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemCompanyStoreNickName()) + "'"
            + "," + item.getPaySystemBeforeLimitDate()
            + "," + item.getPaySystemLimitMoney()
            + "," + item.getPaySystemBankAccountId()
            + "," + item.getPaySystemMessageActive()
            + "," + item.getPaySystemMessageTo()
            + ",'" + ServerTool.escapeString(item.getPaySystemMessageURL()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemMessageUser()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemMessagePass()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemMessageText()) + "'"
            + "," + item.getPaySystemATMActive()
            + "," + item.getPaySystemStoreActive()
            + ",'" + ServerTool.escapeString(item.getPaySystemReplaceWord()) + "'"
            + "," + item.getPaySystemBirthActive()
            + ",'" + ServerTool.escapeString(item.getPaySystemBirthWord()) + "'"
            + "," + item.getPaySystemATMAccountId()
            + "," + item.getPaySystemEmailActive()
            + "," + item.getPaySystemEmailTo()
            + ",'" + ServerTool.escapeString(item.getPaySystemEmailText()) + "'"
            + "," + item.getPaySystemNoticeEmailTo()
            + "," + item.getPaySystemNoticeEmailType()
            + ",'" + ServerTool.escapeString(item.getPaySystemNoticeEmailTitle()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemNoticeEmailText()) + "'"
            + "," + item.getPaySystemNoticeMessageTo()
            + ",'" + ServerTool.escapeString(item.getPaySystemNoticeMessageTest()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemEmailServer()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemEmailSender()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemEmailSenderAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemEmailCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getPaySystemFixATMAccount()) + "'"
            + "," + item.getPaySystemFixATMNum()
            + "," + item.getPaySystemExtendNotpay()
            + ",'" + ServerTool.escapeString(item.getTopLogoHtml()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillLogoPath()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillWaterMarkPath()) + "'"
            + "," + item.getUseChecksum()
            + "," + item.getVersion()
            + "," + item.getCustomerType()
            + ",'" + ServerTool.escapeString(item.getWebsite()) + "'"
            + "," + item.getBanktype()
            + "," + item.getPagetype()
            + "," + item.getWorkflow()
            + "," + item.getCardread()
            + ",'" + ServerTool.escapeString(item.getCardmachine()) + "'"
            + "," + item.getEventAuto()
            + "," + item.getMembrService()
            + ",'" + ServerTool.escapeString(item.getExtraBankInfo()) + "'"
        ;
        return ret;
    }
}
