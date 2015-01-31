<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!AuthAdmin.authPage(ud2,1))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }

    request.setCharacterEncoding("UTF-8");
	String cName=request.getParameter("cName");
	String cAddress=request.getParameter("cAddress");
	String cPhone=request.getParameter("cPhone");
	int limitDate=Integer.parseInt(request.getParameter("limitDate")); 
	String uniteId=request.getParameter("uniteId");
	String bankName=request.getParameter("bankName");
	String bankId=request.getParameter("bankId");
	String first5code=request.getParameter("first5code");
	String BankStoreNickName=request.getParameter("BankStoreNickName");
	String CompanyStoreNickName=request.getParameter("CompanyStoreNickName");
	int showlimitDate=Integer.parseInt(request.getParameter("showlimitDate")); 
	int limitNumber=Integer.parseInt(request.getParameter("limitNumber")); 
	int bankAccountId=Integer.parseInt(request.getParameter("bankAccountId")); 

	int paySystemMessageActive=Integer.parseInt(request.getParameter("paySystemMessageActive")); 
	int paySystemMessageTo=Integer.parseInt(request.getParameter("paySystemMessageTo")); 
	String paySystemMessageURL=request.getParameter("paySystemMessageURL");
	String paySystemMessageUser=request.getParameter("paySystemMessageUser");
	String paySystemMessagePass=request.getParameter("paySystemMessagePass");
	String paySystemMessageText=request.getParameter("paySystemMessageText");

	int paySystemATMActive=Integer.parseInt(request.getParameter("paySystemATMActive")); 
	int paySystemStoreActive=Integer.parseInt(request.getParameter("paySystemStoreActive")); 
	String paySystemReplaceWord=request.getParameter("paySystemReplaceWord");

	int paySystemBirthActive=Integer.parseInt(request.getParameter("paySystemBirthActive")); 
	String paySystemBirthWord=request.getParameter("paySystemBirthWord");

	int paySystemATMAccountId=Integer.parseInt(request.getParameter("paySystemATMAccountId")); 

	int paySystemEmailActive=Integer.parseInt(request.getParameter("paySystemEmailActive")); 
	int paySystemEmailTo=Integer.parseInt(request.getParameter("paySystemEmailTo"));  

	String paySystemEmailText=request.getParameter("paySystemEmailText"); 

	
	String paySystemFixATMAccount=request.getParameter("paySystemFixATMAccount").trim(); 
	int paySystemFixATMNum=Integer.parseInt(request.getParameter("paySystemFixATMNum")); 	
	int paySystemExtendNotpay=Integer.parseInt(request.getParameter("paySystemExtendNotpay")); 
	int banktype=Integer.parseInt(request.getParameter("banktype"));     
	int pagetype=Integer.parseInt(request.getParameter("pagetype"));     
	int workflow=Integer.parseInt(request.getParameter("workflow"));     

    String cardmachine=request.getParameter("cardmachine"); 
	int cardread=Integer.parseInt(request.getParameter("cardread"));     
	int eventAuto=Integer.parseInt(request.getParameter("eventAuto"));     

	int membrService=Integer.parseInt(request.getParameter("membrService"));
    String extraBankInfo = request.getParameter("extraBankInfo");

	PaySystemMgr pma=PaySystemMgr.getInstance();
	PaySystem ps=(PaySystem)pma.find(1);
	ps.setPaySystemCompanyName   	(cName.trim());
	ps.setPaySystemCompanyAddress   	(cAddress.trim());
	ps.setPaySystemCompanyPhone   	(cPhone);
	ps.setPaySystemLimitDate   	(limitDate);
	ps.setPaySystemCompanyUniteId   (uniteId.trim());
	ps.setPaySystemBankName   	(bankName.trim());
	ps.setPaySystemBankId   	(bankId.trim());
	ps.setPaySystemFirst5   	(first5code.trim());
	ps.setPaySystemBankStoreNickName   	(BankStoreNickName.trim());
	ps.setPaySystemCompanyStoreNickName   	(CompanyStoreNickName.trim());
	ps.setPaySystemBeforeLimitDate(showlimitDate);
	ps.setPaySystemLimitMoney(limitNumber); 
	ps.setPaySystemBankAccountId(bankAccountId); 
	
    ps.setPaySystemMessageActive   	(paySystemMessageActive);
    ps.setPaySystemMessageTo   	(paySystemMessageTo);
    //ps.setPaySystemMessageURL   	(paySystemMessageURL);
    //ps.setPaySystemMessageUser   	(paySystemMessageUser);
    //ps.setPaySystemMessagePass   	(paySystemMessagePass);
	ps.setPaySystemMessageText(paySystemMessageText); 
	
	
	ps.setPaySystemATMActive   	(paySystemATMActive);
    ps.setPaySystemStoreActive  (paySystemStoreActive);
    ps.setPaySystemReplaceWord(paySystemReplaceWord);  
	
	ps.setPaySystemBirthActive (paySystemBirthActive);
	ps.setPaySystemBirthWord (paySystemBirthWord); 
	ps.setPaySystemATMAccountId(paySystemATMAccountId); 
	
	ps.setPaySystemEmailActive   	(paySystemEmailActive);
    ps.setPaySystemEmailTo   	(paySystemEmailTo);
    ps.setPaySystemEmailText(paySystemEmailText);   
	
	ps.setPaySystemFixATMAccount(paySystemFixATMAccount);
	ps.setPaySystemFixATMNum(paySystemFixATMNum);

    String topLogoHtml = request.getParameter("topLogoHtml");
    if (topLogoHtml!=null)
        ps.setTopLogoHtml(topLogoHtml);
    String billLogoPath = request.getParameter("billLogoPath");
    if (billLogoPath!=null)
        ps.setBillLogoPath(billLogoPath);
    String billWaterMarkPath = request.getParameter("billWaterMarkPath");
    if (billWaterMarkPath!=null)
        ps.setBillWaterMarkPath(billWaterMarkPath);
    String website = request.getParameter("website");
    if (website!=null)
        ps.setWebsite(website);
    int useChecksum = ps.getUseChecksum();
    try { useChecksum = Integer.parseInt(request.getParameter("useChecksum")); } catch (Exception e) {}
    ps.setUseChecksum(useChecksum);

    int version = ps.getVersion();
    try { version = Integer.parseInt(request.getParameter("version")); } catch (Exception e) {}
    ps.setVersion(version);
    
    int customerType = ps.getCustomerType();
    try { customerType = Integer.parseInt(request.getParameter("customerType")); } catch (Exception e) {}
    ps.setCustomerType(customerType);    
    ps.setPaySystemExtendNotpay(paySystemExtendNotpay);
	
    ps.setBanktype(banktype);
    ps.setPagetype(pagetype);
    ps.setWorkflow(workflow);

    if(cardmachine !=null && cardmachine.length()>0)
        ps.setCardmachine(cardmachine.trim());
    else
        ps.setCardmachine("");

    ps.setCardread(cardread);
    ps.setEventAuto(eventAuto);
    ps.setMembrService(membrService);   
    ps.setExtraBankInfo(extraBankInfo);   
    pma.save(ps);

	response.sendRedirect("modifyPaySystem.jsp?m=y");
%>

