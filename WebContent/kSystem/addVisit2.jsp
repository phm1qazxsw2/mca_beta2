<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");

	String rand = (String)session.getAttribute("rand");
	String input = request.getParameter("rand");
	
  	if (!rand.equals(input)) 
  	{
		out.println("<br><br><blockquote>驗證碼錯誤</blockquote>");
		return;
 	}
 	
 	
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
	
	SimpleDateFormat sdfX=new SimpleDateFormat("yyyy/MM/dd");

	Date studentBirth2= new Date();
	Date visitDate=new Date();
	
	if(studentBirth!=null)
		studentBirth2=sdfX.parse(studentBirth);
	
	if(studentVisitDate !=null) 
		visitDate=sdfX.parse(studentVisitDate);


	SimpleDateFormat sdfH=new SimpleDateFormat("yyyy/MM/dd HH:mm");
	
	String outPs="";
	
	if(studentSpecial !=null) 
		outPs+=	studentSpecial +"\n";
			
	outPs +="系統資訊:"+sdfH.format(new Date())+" 於網路報名";
	

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
	
	st.setStudentSpecial(outPs);
	st.setStudentStatus   	(studentStatus);
	
	if(!studentVisitDate.equals(""))
		st.setStudentVisitDate(visitDate);
		
    st.setBunitId(_ws.getSessionBunitId());		
	
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

	PaySystemMgr pmx2=PaySystemMgr.getInstance();
	PaySystem pd2=(PaySystem)pmx2.find(1);
	JsfPay jp=JsfPay.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();

	User[] u2=ja.getAllUsers(_ws2.getBunitSpace("userBunitAccounting"));
	
	String outWord="";
	if(u2 !=null) 
	{     
		String mobileNum="";
		if(st.getStudentMobileDefault()==1)
		{ 	
			mobileNum =st.getStudentFatherMobile();
		}else{
			mobileNum =st.getStudentMotherMobile();
		}
	String content=pd2.getPaySystemCompanyName()+" 新生: "+studentName+"於網路完成報名,電話:"+studentPhone+" 手機:"+mobileNum+" 生日:"+studentBirth;
		for(int i=0;i<u2.length;i++) 
		{ 
			if(u2[i].getUserRole()==2 || u2[i].getUserRole()==4)	
			{

 				outWord=jp.sendMobileMessage(pd2,u2[i].getUserPhone(),content);
			}
		}
	} 


%> 
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
 

<title><%=pd2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">

</head> 

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onunload="henrytest()">
<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>
<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right><%=pd2.getPaySystemCompanyName()%></td>
</tr>
</table>

<br>
<br>
<blockquote>

<br> 
<div class=es02>
歡迎加入<font color=blue><%=pd2.getPaySystemCompanyName()%></font>這個大家庭,期待我們不久的見面. 
<br>
<br>  
<% 

	if(outWord.length()>2)
	{
%>
	為了確保我們的服務品質,我們將於24小時以內,與你初步聯絡,謝謝!
<%
	}
%>	

</div>
<br>
</blockquote> 

