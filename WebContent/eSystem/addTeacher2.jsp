<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	String teacherFirstName=request.getParameter("teacherFirstName");
 	String teacherLastName=request.getParameter("teacherLastName"); 
	String teacherNickname=request.getParameter("teacherNickname"); 
	String teacherIdNumber=request.getParameter("teacherIdNumber"); 
	String teacherBirth=request.getParameter("teacherBirth"); 
	String teacherSchool=request.getParameter("teacherSchool"); 
	String teacherFather=request.getParameter("teacherFather"); 
	String teacherMother=request.getParameter("teacherMother"); 
	String teacherMobile=request.getParameter("teacherMobile"); 
	String teacherPhone=request.getParameter("teacherPhone"); 
	String teacherAddress=request.getParameter("teacherAddress"); 
	String teacherComeDate=request.getParameter("teacherComeDate"); 
	int teacherStatus=1;
    try { teacherStatus=Integer.parseInt(request.getParameter("teacherStatus")); } catch (Exception e) {}
	int teacherSex=0;
    try { teacherSex=Integer.parseInt(request.getParameter("teacherSex")); } catch (Exception e) {}
	int teacherLevel=0;
    try { teacherLevel=Integer.parseInt(request.getParameter("teacherLevel")); } catch (Exception e) {}
	String teacherEmail=request.getParameter("teacherEmail"); 
	String teacherBank1=request.getParameter("teacherBank1");  
	String teacherAccountNumber1=request.getParameter("teacherAccountNumber1"); 
	String teacherBank2=request.getParameter("teacherBank2");  
	String teacherAccountNumber2=request.getParameter("teacherAccountNumber2"); 
	String teacherPs=request.getParameter("teacherPs"); 


	String teacherMobile2=request.getParameter("teacherMobile2");
	String teacherMobile3=request.getParameter("teacherMobile3");
	String teacherPhone2=request.getParameter("teacherPhone2"); 
	String teacherPhone3=request.getParameter("teacherPhone3"); 
	String teacherZipCode=request.getParameter("teacherZipCode"); 
	String address_county1=request.getParameter("address_county1"); 
	String address_area1=request.getParameter("address_area1"); 
	int teacherDepart=0;
    try { teacherDepart=Integer.parseInt(request.getParameter("teacherDepart")); } catch (Exception e) {}
	int teacherClass=0;
    try { teacherClass=Integer.parseInt(request.getParameter("teacherClass"));  } catch (Exception e) {}
	int teacherPosition=0;
    try { teacherPosition=Integer.parseInt(request.getParameter("teacherPosition"));  } catch (Exception e) {}
	
	String teacherAccountName1=request.getParameter("teacherAccountName1"); 
	String teacherAccountName2=request.getParameter("teacherAccountName2");
	int bankDefault=Integer.parseInt(request.getParameter("bankDefault")); 
	
	int payWay=Integer.parseInt(request.getParameter("payWay")); 
	int teacherParttime=0;
    try { teacherParttime=Integer.parseInt(request.getParameter("teacherParttime")); } catch (Exception e) {}

	int bunitId=0;
    try { bunitId=Integer.parseInt(request.getParameter("bunitId")); } catch (Exception e) {}

	
	JsfTool jt=JsfTool.getInstance();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
	
	//Date teacherBirth2=sdf.parse(teacherBirth);
	//Date teacherComeDate2=jt.ChangeToDate(teacherComeDate);
    
    Date teacherBirth2=jt.ChangeToDate(teacherBirth);
    Date teacherComeDate2=jt.ChangeToDate(teacherComeDate);
	
	String teacherBankName1=request.getParameter("teacherBankName1"); 
	String teacherBankName2=request.getParameter("teacherBankName2");

	Teacher tea=new Teacher();
	tea.setTeacherFirstName   	(teacherFirstName);
	tea.setTeacherLastName   	(teacherLastName);
	tea.setTeacherSex(teacherSex);
	//tea.setTeacherUserId   	(int teacherUserId);
	tea.setTeacherNickname   	(teacherNickname);
	tea.setTeacherEmail   	(teacherEmail);
	tea.setTeacherIdNumber   	(teacherIdNumber);
	tea.setTeacherBirth   	(teacherBirth2);
	tea.setTeacherSchool   	(teacherSchool);
	tea.setTeacherFather   	(teacherFather);
	tea.setTeacherMother   	(teacherMother);
	tea.setTeacherMobile   	(teacherMobile);
	tea.setTeacherPhone   	(teacherPhone);
	tea.setTeacherAddress   	(address_county1+address_area1+teacherAddress);
	tea.setTeacherComeDate   	(teacherComeDate2);
	
	tea.setTeacherBank1   	(teacherBank1);
	tea.setTeacherAccountNumber1   	(teacherAccountNumber1);
	tea.setTeacherBank2   	(teacherBank2);
	tea.setTeacherAccountNumber2   	(teacherAccountNumber2);
	tea.setTeacherPs   	(teacherPs);
	
	tea.setTeacherAccountPayWay(payWay);
	
	
	tea.setTeacherStatus   	(teacherStatus);
	tea.setTeacherDepart(teacherDepart);
	tea.setTeacherPosition(teacherPosition);
	tea.setTeacherClasses(teacherClass);
	tea.setTeacherLevel   	(teacherLevel);
	
	tea.setTeacherMobile2(teacherMobile2);
	tea.setTeacherMobile3(teacherMobile3);
	tea.setTeacherPhone2(teacherPhone2);
	tea.setTeacherPhone3(teacherPhone3);
	tea.setTeacherZipCode(teacherZipCode);
	
	tea.setTeacherAccountDefaut(bankDefault);
		
	tea.setTeacherAccountName1(teacherAccountName1);
	tea.setTeacherAccountName2(teacherAccountName2);
	tea.setTeacherParttime(teacherParttime);
	
    tea.setTeacherBunitId(bunitId);// 和 teacherBunitId 不同


    tea.setTeacherBankName1(teacherBankName1);
	tea.setTeacherBankName2(teacherBankName2);

    tea.setBunitId(_ws.getSessionBunitId());

	TeacherMgr tm=TeacherMgr.getInstance();
	int teaId=tm.createWithIdReturned(tea);

    //## add to connect student and membr
    phm.ezcounting.Membr membr = new phm.ezcounting.Membr();
    membr.setName(tea.getTeacherFirstName()+tea.getTeacherLastName());
    membr.setActive(1);
    membr.setType(phm.ezcounting.Membr.TYPE_TEACHER);
    membr.setSurrogateId(teaId);
    membr.setBirth(tea.getTeacherBirth());
    membr.setBunitId(tea.getBunitId()); // 和 teacherBunitId 不同
    phm.ezcounting.MembrMgr.getInstance().create(membr);

	String rName=request.getParameter("rName");
	
	if(!rName.equals(""))
	{
		
		int rRelation=0;
        try { Integer.parseInt(request.getParameter("rRelation")); } catch (Exception e){}
		String rPhone=request.getParameter("rPhone");
		String rPhone2=request.getParameter("rPhone2");
		String rMobile=request.getParameter("rMobile");
		String rPs=request.getParameter("rPs");
		
		TcontactMgr rm=TcontactMgr.getInstance();
		Tcontact re=new Tcontact();
		re.setTcontactStuId   	(teaId);
		re.setTcontactName   	(rName);
		re.setTcontactReleationId   	(rRelation);
		re.setTcontactPhone1   	(rPhone);
		re.setTcontactPhone2   	(rPhone2);
		re.setTcontactMobile   	(rMobile);
		re.setTcontactPs   	(rPs);
		rm.createWithIdReturned(re);
	}	
%>
<br>
<br> 
<blockquote>
<div class=es02>	
新增成功！ <br><br>

<a href="addTeacher.jsp"><img src="pic/add.gif" border=0 width=15>&nbsp;繼續新增</a> | <a href="listTeacher.jsp">教職員列表</a>


</div>

</blockquote>	
<%@ include file="bottom.jsp"%>