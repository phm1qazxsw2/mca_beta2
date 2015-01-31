<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<html>
<%
 request.setCharacterEncoding("UTF-8");
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);

%>
<head>
<title><%=pd2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css>
<script type="text/javascript" src="openWindow.js"></script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r><%=pd2.getPaySystemCompanyName()%></td>
</tr>
</table>
<!--- end 水平列書籤式按鈕 01 ---> 

<%
 	request.setCharacterEncoding("UTF-8");
 	String studentName=request.getParameter("studentName");
 	String studentNickname=request.getParameter("studentNickname"); 
 	String studentIDNumber=request.getParameter("studentIDNumber");
 	int studentSex=Integer.parseInt(request.getParameter("studentSex")); 
 	String studentBirth=request.getParameter("studentBirth");
 	int studentBrother=Integer.parseInt(request.getParameter("studentBrother")); 
 	int studentBigSister=Integer.parseInt(request.getParameter("studentBigSister")); 
 	int studentYoungBrother=Integer.parseInt(request.getParameter("studentYoungBrother")); 
 	int studentYoungSister=Integer.parseInt(request.getParameter("studentYoungSister")); 
 	
	String studentFather=request.getParameter("studentFather"); 
	String studentFathJob=request.getParameter("studentFathJob");
	int studentFatherDegree=Integer.parseInt(request.getParameter("studentFatherDegree")); 
	String studentFatherEmail=request.getParameter("studentFatherEmail"); 
	String studentFatherMobile=request.getParameter("studentFatherMobile"); 
	String studentFatherMobile2=request.getParameter("studentFatherMobile2");
	
	
	String studentMother=request.getParameter("studentMother"); 
	String studentMothJob=request.getParameter("studentMothJob");
	int studentMothDegree=Integer.parseInt(request.getParameter("studentMothDegree")); 
	String studentMotherEmail=request.getParameter("studentMotherEmail"); 
	String studentMotherMobile=request.getParameter("studentMotherMobile"); 
	String studentMotherMobile2=request.getParameter("studentMotherMobile2");
	String studentZipCode=request.getParameter("studentZipCode");
	String address_county1=request.getParameter("address_county1");
	String address_area1=request.getParameter("address_area1");
	String studentAddress=request.getParameter("studentAddress"); 
	String studentPhone=request.getParameter("studentPhone"); 
	String studentPhone2=request.getParameter("studentPhone2");
	String studentPhone3=request.getParameter("studentPhone3");
	int studentGohome=Integer.parseInt(request.getParameter("studentGohome")); 
	int studentSchool=Integer.parseInt(request.getParameter("studentSchool")); 
	String studentSpecial=request.getParameter("studentSpecial");  
	String studentVisitDate=request.getParameter("studentVisitDate");  
	studentAddress=address_county1+address_area1+studentAddress;
	
	int emailDefault=Integer.parseInt(request.getParameter("emailDefault")); 	
	int mobileDefault=Integer.parseInt(request.getParameter("mobileDefault")); 	
	int skypeDefault=Integer.parseInt(request.getParameter("skypeDefault")); 
	int phoneDefault=Integer.parseInt(request.getParameter("phoneDefault")); 
	String fatherSkype=request.getParameter("fatherSkype");  
	String motheSkype=request.getParameter("motheSkype");  			
	
	
	int studentStatus=Integer.parseInt(request.getParameter("studentStatus")); 	
	
	JsfTool jt=JsfTool.getInstance();
	Date studentBirth2=jt.ChangeToDate(studentBirth);
	Date visitDate=new Date();
	if(!studentVisitDate.equals(""))
		visitDate=jt.ChangeToDate(studentVisitDate);

	
	Student st=new Student();
	st.setStudentIDNumber(studentIDNumber.toUpperCase());
	st.setStudentMobileDefault(mobileDefault);
	st.setStudentEmailDefault(emailDefault);
	st.setStudentPhoneDefault(phoneDefault);
	st.setStudentSkypeDefault(skypeDefault);
	st.setStudentFatherSkype(fatherSkype);
	st.setStudentMotherSkype(motheSkype);
	st.setStudentName(studentName);
	st.setStudentNickname(studentNickname);
	st.setStudentSex(studentSex);
	st.setStudentBirth(studentBirth2);
	st.setStudentBrother(studentBrother);
	st.setStudentBigSister(studentBigSister);
	st.setStudentYoungBrother(studentYoungBrother);
	st.setStudentYoungSister(studentYoungSister);
	st.setStudentFather   	(studentFather);
	st.setStudentFathJob(studentFathJob);
	st.setStudebtFatherDegree(studentFatherDegree);
	st.setStudentFatherEmail(studentFatherEmail);
	st.setStudentFatherMobile   	(studentFatherMobile);
	st.setStudentFatherMobile2(studentFatherMobile2);
	
	st.setStudentMother   	(studentMother);
	st.setStudentMothJob(studentMothJob);	
	st.setStudentMothDegree(studentMothDegree);
	st.setStudentMotherEmail(studentMotherEmail);
	st.setStudentMotherMobile   	(studentMotherMobile);
	st.setStudentMotherMobile2(studentMotherMobile2);
	
	st.setStudentZipCode(studentZipCode);
	st.setStudentAddress   	(studentAddress);
	
	st.setStudentPhone   	(studentPhone);
	st.setStudentPhone2(studentPhone2);
	st.setStudentPhone3(studentPhone3);
	st.setStudentGohome(studentGohome);
	st.setStudentSchool(studentSchool);
	st.setStudentSpecial(studentSpecial);
	
	
	st.setStudentStatus   	(studentStatus);
	
	
	if(!studentVisitDate.equals(""))
		st.setStudentVisitDate(visitDate);
	
    st.setBunitId(_ws2.getSessionBunitId());		
	
	StudentMgr sm=StudentMgr.getInstance();
	int stuId=sm.createWithIdReturned(st);

    //## add to connect student and membr
    phm.ezcounting.Membr membr = new phm.ezcounting.Membr();
    membr.setName(st.getStudentName());
    membr.setActive(1);
    membr.setType(phm.ezcounting.Membr.TYPE_STUDENT);
    membr.setSurrogateId(stuId);
    membr.setBirth(st.getStudentBirth());
    membr.setBunitId(st.getBunitId());
    phm.ezcounting.MembrMgr.getInstance().create(membr);

	String rName=request.getParameter("rName");
	
	if(!rName.equals(""))
	{
		
		int rRelation=Integer.parseInt(request.getParameter("rRelation")); 	
		String rPhone=request.getParameter("rPhone");
		String rPhone2=request.getParameter("rPhone2");
		String rMobile=request.getParameter("rMobile");
		String rPs=request.getParameter("rPs");
		
		
		
		ContactMgr rm=ContactMgr.getInstance();
		Contact re=new Contact();
		re.setContactStuId   	(stuId);
		re.setContactName   	(rName);
		re.setContactReleationId   	(rRelation);
		re.setContactPhone1   	(rPhone);
		re.setContactPhone2   	(rPhone2);
		re.setContactMobile   	(rMobile);
		re.setContactPs   	(rPs);
		rm.createWithIdReturned(re);
	
	}
	
	
	
%>

<blockquote>

<br>

<br>

新增完成,<b><%=pd2.getPaySystemCompanyName()%></b>歡迎你的加入！！

</blockquote>

