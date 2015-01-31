package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PaySystem2Mgr extends dbo.Manager<PaySystem2>
{
    private static PaySystem2Mgr _instance = null;

    PaySystem2Mgr() {}

    public synchronized static PaySystem2Mgr getInstance()
    {
        if (_instance==null) {
            _instance = new PaySystem2Mgr();
        }
        return _instance;
    }

    public PaySystem2Mgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "paysystem";
    }

    protected Object makeBean()
    {
        return new PaySystem2();
    }

    protected String getIdentifier(Object obj)
    {
        PaySystem2 o = (PaySystem2) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PaySystem2 item = (PaySystem2) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            String	paySystemCompanyName		 = rs.getString("paySystemCompanyName");
            item.setPaySystemCompanyName(paySystemCompanyName);
            String	paySystemCompanyAddress		 = rs.getString("paySystemCompanyAddress");
            item.setPaySystemCompanyAddress(paySystemCompanyAddress);
            String	paySystemCompanyPhone		 = rs.getString("paySystemCompanyPhone");
            item.setPaySystemCompanyPhone(paySystemCompanyPhone);
            int	paySystemLimitDate		 = rs.getInt("paySystemLimitDate");
            item.setPaySystemLimitDate(paySystemLimitDate);
            String	paySystemCompanyUniteId		 = rs.getString("paySystemCompanyUniteId");
            item.setPaySystemCompanyUniteId(paySystemCompanyUniteId);
            String	paySystemBankName		 = rs.getString("paySystemBankName");
            item.setPaySystemBankName(paySystemBankName);
            String	paySystemBankId		 = rs.getString("paySystemBankId");
            item.setPaySystemBankId(paySystemBankId);
            String	paySystemFirst5		 = rs.getString("paySystemFirst5");
            item.setPaySystemFirst5(paySystemFirst5);
            String	paySystemBankStoreNickName		 = rs.getString("paySystemBankStoreNickName");
            item.setPaySystemBankStoreNickName(paySystemBankStoreNickName);
            String	paySystemCompanyStoreNickName		 = rs.getString("paySystemCompanyStoreNickName");
            item.setPaySystemCompanyStoreNickName(paySystemCompanyStoreNickName);
            int	paySystemBeforeLimitDate		 = rs.getInt("paySystemBeforeLimitDate");
            item.setPaySystemBeforeLimitDate(paySystemBeforeLimitDate);
            int	paySystemLimitMoney		 = rs.getInt("paySystemLimitMoney");
            item.setPaySystemLimitMoney(paySystemLimitMoney);
            int	paySystemBankAccountId		 = rs.getInt("paySystemBankAccountId");
            item.setPaySystemBankAccountId(paySystemBankAccountId);
            int	paySystemMessageActive		 = rs.getInt("paySystemMessageActive");
            item.setPaySystemMessageActive(paySystemMessageActive);
            int	paySystemMessageTo		 = rs.getInt("paySystemMessageTo");
            item.setPaySystemMessageTo(paySystemMessageTo);
            String	paySystemMessageURL		 = rs.getString("paySystemMessageURL");
            item.setPaySystemMessageURL(paySystemMessageURL);
            String	paySystemMessageUser		 = rs.getString("paySystemMessageUser");
            item.setPaySystemMessageUser(paySystemMessageUser);
            String	paySystemMessagePass		 = rs.getString("paySystemMessagePass");
            item.setPaySystemMessagePass(paySystemMessagePass);
            String	paySystemMessageText		 = rs.getString("paySystemMessageText");
            item.setPaySystemMessageText(paySystemMessageText);
            int	paySystemATMActive		 = rs.getInt("paySystemATMActive");
            item.setPaySystemATMActive(paySystemATMActive);
            int	paySystemStoreActive		 = rs.getInt("paySystemStoreActive");
            item.setPaySystemStoreActive(paySystemStoreActive);
            String	paySystemReplaceWord		 = rs.getString("paySystemReplaceWord");
            item.setPaySystemReplaceWord(paySystemReplaceWord);
            int	paySystemBirthActive		 = rs.getInt("paySystemBirthActive");
            item.setPaySystemBirthActive(paySystemBirthActive);
            String	paySystemBirthWord		 = rs.getString("paySystemBirthWord");
            item.setPaySystemBirthWord(paySystemBirthWord);
            int	paySystemATMAccountId		 = rs.getInt("paySystemATMAccountId");
            item.setPaySystemATMAccountId(paySystemATMAccountId);
            int	paySystemEmailActive		 = rs.getInt("paySystemEmailActive");
            item.setPaySystemEmailActive(paySystemEmailActive);
            int	paySystemEmailTo		 = rs.getInt("paySystemEmailTo");
            item.setPaySystemEmailTo(paySystemEmailTo);
            String	paySystemEmailText		 = rs.getString("paySystemEmailText");
            item.setPaySystemEmailText(paySystemEmailText);
            int	paySystemNoticeEmailTo		 = rs.getInt("paySystemNoticeEmailTo");
            item.setPaySystemNoticeEmailTo(paySystemNoticeEmailTo);
            int	paySystemNoticeEmailType		 = rs.getInt("paySystemNoticeEmailType");
            item.setPaySystemNoticeEmailType(paySystemNoticeEmailType);
            String	paySystemNoticeEmailTitle		 = rs.getString("paySystemNoticeEmailTitle");
            item.setPaySystemNoticeEmailTitle(paySystemNoticeEmailTitle);
            String	paySystemNoticeEmailText		 = rs.getString("paySystemNoticeEmailText");
            item.setPaySystemNoticeEmailText(paySystemNoticeEmailText);
            int	paySystemNoticeMessageTo		 = rs.getInt("paySystemNoticeMessageTo");
            item.setPaySystemNoticeMessageTo(paySystemNoticeMessageTo);
            String	paySystemNoticeMessageTest		 = rs.getString("paySystemNoticeMessageTest");
            item.setPaySystemNoticeMessageTest(paySystemNoticeMessageTest);
            String	paySystemEmailServer		 = rs.getString("paySystemEmailServer");
            item.setPaySystemEmailServer(paySystemEmailServer);
            String	paySystemEmailSender		 = rs.getString("paySystemEmailSender");
            item.setPaySystemEmailSender(paySystemEmailSender);
            String	paySystemEmailSenderAddress		 = rs.getString("paySystemEmailSenderAddress");
            item.setPaySystemEmailSenderAddress(paySystemEmailSenderAddress);
            String	paySystemEmailCode		 = rs.getString("paySystemEmailCode");
            item.setPaySystemEmailCode(paySystemEmailCode);
            String	paySystemFixATMAccount		 = rs.getString("paySystemFixATMAccount");
            item.setPaySystemFixATMAccount(paySystemFixATMAccount);
            int	paySystemFixATMNum		 = rs.getInt("paySystemFixATMNum");
            item.setPaySystemFixATMNum(paySystemFixATMNum);
            int	paySystemExtendNotpay		 = rs.getInt("paySystemExtendNotpay");
            item.setPaySystemExtendNotpay(paySystemExtendNotpay);
            String	topLogoHtml		 = rs.getString("topLogoHtml");
            item.setTopLogoHtml(topLogoHtml);
            String	billLogoPath		 = rs.getString("billLogoPath");
            item.setBillLogoPath(billLogoPath);
            String	billWaterMarkPath		 = rs.getString("billWaterMarkPath");
            item.setBillWaterMarkPath(billWaterMarkPath);
            int	useChecksum		 = rs.getInt("useChecksum");
            item.setUseChecksum(useChecksum);
            int	version		 = rs.getInt("version");
            item.setVersion(version);
            int	customerType		 = rs.getInt("customerType");
            item.setCustomerType(customerType);
            String	website		 = rs.getString("website");
            item.setWebsite(website);
            int	banktype		 = rs.getInt("banktype");
            item.setBanktype(banktype);
            int	pagetype		 = rs.getInt("pagetype");
            item.setPagetype(pagetype);
            int	workflow		 = rs.getInt("workflow");
            item.setWorkflow(workflow);
            int	cardread		 = rs.getInt("cardread");
            item.setCardread(cardread);
            String	cardmachine		 = rs.getString("cardmachine");
            item.setCardmachine(cardmachine);
            int	eventAuto		 = rs.getInt("eventAuto");
            item.setEventAuto(eventAuto);
            int	membrService		 = rs.getInt("membrService");
            item.setMembrService(membrService);
            String	extraBankInfo		 = rs.getString("extraBankInfo");
            item.setExtraBankInfo(extraBankInfo);
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
        PaySystem2 item = (PaySystem2) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
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
         return  "created,modified,paySystemCompanyName,paySystemCompanyAddress,paySystemCompanyPhone,paySystemLimitDate,paySystemCompanyUniteId,paySystemBankName,paySystemBankId,paySystemFirst5,paySystemBankStoreNickName,paySystemCompanyStoreNickName,paySystemBeforeLimitDate,paySystemLimitMoney,paySystemBankAccountId,paySystemMessageActive,paySystemMessageTo,paySystemMessageURL,paySystemMessageUser,paySystemMessagePass,paySystemMessageText,paySystemATMActive,paySystemStoreActive,paySystemReplaceWord,paySystemBirthActive,paySystemBirthWord,paySystemATMAccountId,paySystemEmailActive,paySystemEmailTo,paySystemEmailText,paySystemNoticeEmailTo,paySystemNoticeEmailType,paySystemNoticeEmailTitle,paySystemNoticeEmailText,paySystemNoticeMessageTo,paySystemNoticeMessageTest,paySystemEmailServer,paySystemEmailSender,paySystemEmailSenderAddress,paySystemEmailCode,paySystemFixATMAccount,paySystemFixATMNum,paySystemExtendNotpay,topLogoHtml,billLogoPath,billWaterMarkPath,useChecksum,version,customerType,website,banktype,pagetype,workflow,cardread,cardmachine,eventAuto,membrService,extraBankInfo";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        PaySystem2 item = (PaySystem2) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
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
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        PaySystem2 o = (PaySystem2) obj;
        o.setId(auto_id);
    }
}
