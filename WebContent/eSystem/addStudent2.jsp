<%@ page language="java"  buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<%
boolean commit = false;
int tran_id = 0;
try {           

 	request.setCharacterEncoding("UTF-8");
    tran_id = Manager.startTransaction();

    String studentName=request.getParameter("studentName").trim();
 	String studentNickname=request.getParameter("studentNickname").trim(); 
	String studentFather=request.getParameter("studentFather").trim(); 
	String studentFatherMobile=request.getParameter("studentFatherMobile").trim(); 
	String studentMother=request.getParameter("studentMother").trim(); 
	String studentMotherMobile=request.getParameter("studentMotherMobile").trim(); 
	String studentPhone=request.getParameter("studentPhone").trim(); 
	String studentAddress=request.getParameter("studentAddress").trim(); 
	
	String studentFathJob=request.getParameter("studentFathJob").trim(); 
	String studentMothJob=request.getParameter("studentMothJob").trim(); 


	int studentSex=Integer.parseInt(request.getParameter("studentSex")); 

	int studentLevel=0;
    
    String studentLevelSS=request.getParameter("studentLevel");

    if(studentLevelSS !=null)
        studentLevel=Integer.parseInt(studentLevelSS); 

	String studentFatherEmail=request.getParameter("studentFatherEmail").trim(); 
	String studentMotherEmail=request.getParameter("studentMotherEmail").trim(); 
	
	String studentBank1=request.getParameter("studentBank1").trim();  
	String studentAccountNumber1=request.getParameter("studentAccountNumber1").trim(); 
	String studentBank2=request.getParameter("studentBank2").trim();  
	String studentAccountNumber2=request.getParameter("studentAccountNumber2").trim(); 
	String studentPs=request.getParameter("studentPs").trim(); 
    String[] tags=request.getParameterValues("tags");



    int tag=1;
    if(tags !=null)
        tag=Integer.parseInt(tags[0]);
	String studentBirth=request.getParameter("studentBirth");
	int studentStatus=Integer.parseInt(request.getParameter("studentStatus")); 
	String strudentClassIdstr = request.getParameter("studentClassId");

	int studentClassId=0, studentGroupId=0;

    if(strudentClassIdstr !=null)
    {
        int cut = strudentClassIdstr.indexOf("#");
        if (cut<0) {
            studentClassId = Integer.parseInt(strudentClassIdstr);
            studentGroupId = 0;
        }else {
            studentClassId = Integer.parseInt(strudentClassIdstr.substring(0, cut));
            studentGroupId = Integer.parseInt(strudentClassIdstr.substring(cut+1));
        }
    }							
	String studentIDNumber=request.getParameter("studentIDNumber").trim();
	String studentMotherMobile2=request.getParameter("studentMotherMobile2").trim();
	String studentFatherMobile2=request.getParameter("studentFatherMobile2").trim();
	String studentPhone2=request.getParameter("studentPhone2").trim();
	String studentPhone3=request.getParameter("studentPhone3").trim();
	String studentZipCode=request.getParameter("studentZipCode");

    String studentDepartSS=request.getParameter("studentDepart");

	int studentDepart=0;
    if(studentDepartSS !=null)
        studentDepart=Integer.parseInt(studentDepartSS); 


	String address_county1=request.getParameter("address_county1");
	String address_area1=request.getParameter("address_area1");

	int phoneDefault=Integer.parseInt(request.getParameter("phoneDefault")); 
	
	int emailDefault=Integer.parseInt(request.getParameter("emailDefault")); 		
	int mobileDefault=0;  //Integer.parseInt(request.getParameter("mobileDefault")); 	
	int skypeDefault=0;  //Integer.parseInt(request.getParameter("skypeDefault")); 

	String studentNumber=request.getParameter("studentNumber"); 
	String studentShortName=request.getParameter("studentShortName"); 

    String bloodType=request.getParameter("bloodType");	


	JsfTool jt=JsfTool.getInstance();
	Date studentBirth2=null;

    if(tag ==0 && studentBirth !=null){        
        studentBirth2=JsfTool.saveDate(studentBirth);


    }

	Student stuOld=jt.checkStudentId(studentIDNumber);
	if(stuOld !=null)
	{ 
%>	
		<script type="text/javascript" src="openWindow.js"></script>
		<br>
		<br>
		<blockquote>
		Error:<font color=red>此身份證字號已存在:</font> <%=studentIDNumber%>
		
		學生姓名: <%=stuOld.getStudentName()%>
			<a href="#" onClick="javascript:openwindow15('<%=stuOld.getId()%>');return false">[詳細資料]</a>
		</blockquote>

		<%@ include file="bottom.jsp"%>		
<%
 
	 } 

	Student2 st=new Student2();
    st.setStudentNumber(studentNumber);
    st.setStudentShortName(studentShortName);
    st.setStudentFathJob(studentFathJob);
    st.setStudentMothJob(studentMothJob);
	st.setStudentMobileDefault(mobileDefault);
	st.setStudentEmailDefault(emailDefault);
	st.setStudentSkypeDefault(skypeDefault);
	st.setStudentPhoneDefault(phoneDefault);	
	st.setStudentIDNumber(studentIDNumber.toUpperCase());
	st.setStudentSex(studentSex);
	st.setStudentFatherMobile2(studentFatherMobile2);
	st.setStudentMotherMobile2(studentMotherMobile2);
	st.setStudentPhone2(studentPhone2);
	st.setStudentPhone3(studentPhone3);
	st.setStudentZipCode(studentZipCode);
	st.setStudentDepart(studentDepart);
	st.setStudentName(studentName.trim());
	st.setStudentNickname   	(studentNickname.trim());
	st.setStudentFather   	(studentFather.trim());
	st.setStudentMother   	(studentMother.trim());
	st.setStudentFatherMobile   	(studentFatherMobile.trim());
	st.setStudentMotherMobile   	(studentMotherMobile.trim());
	st.setStudentPhone   	(studentPhone);

    if(studentAddress!=null && studentAddress.length()>0)
    {
	    st.setStudentAddress   	(address_county1+address_area1+studentAddress);
	}else{
        st.setStudentAddress   	("");
    }


    st.setStudentBirth(studentBirth2);
	st.setStudentStatus   	(studentStatus);
	st.setStudentClassId   	(studentClassId);
	st.setStudentGroupId   	(studentGroupId);
	st.setStudentBank1   	(studentBank1);
	st.setStudentAccountNumber1   	(studentAccountNumber1);
	st.setStudentBank2   	(studentBank2);
	st.setStudentAccountNumber2   	(studentAccountNumber2);
	st.setStudentPs   	(studentPs);
	
	st.setStudentFatherEmail(studentFatherEmail);
	st.setStudentMotherEmail(studentMotherEmail);
	st.setStudentLevel(studentLevel);
    st.setBunitId(_ws.getSessionStudentBunitId());
    st.setBloodType(bloodType);    
    
	Student2Mgr sm = new Student2Mgr(tran_id);
    sm.create(st);
	int stuId = st.getId();

    //## add to connect student and membr
    Membr membr = new Membr();
    membr.setName(st.getStudentName());
    membr.setActive(1);
    membr.setType(Membr.TYPE_STUDENT);
    membr.setSurrogateId(stuId);
    membr.setBirth(st.getStudentBirth());

    membr.setBunitId(st.getBunitId());
    new MembrMgr(tran_id).create(membr);

	//response.sendRedirect("listStudent.jsp");


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

    TagHelper th = TagHelper.getInstance(pZ2, tran_id, _ws.getSessionStudentBunitId());
    String[] tagIds = request.getParameterValues("tagId");

    if (tagIds!=null) {
        for (int i=0; i<tagIds.length; i++) {
            String k = "addc_" + tagIds[i];
            boolean addCharge = (request.getParameter(k)!=null && request.getParameter(k).equals("1"));
            int tagId = Integer.parseInt(tagIds[i]);
            th.addMembrToChain(tran_id, tagId, membr.getId(), addCharge, ud2);
        }
    }
 
  //########

 	response.sendRedirect("addStudent3.jsp?stuId="+stuId);
    Manager.commit(tran_id);
    commit = true;
}
catch (Exception e) {
    e.printStackTrace();
  %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
}    
finally {
    if (!commit)
        try { Manager.rollback(tran_id); } catch (Exception e2) {}  
}
%>


