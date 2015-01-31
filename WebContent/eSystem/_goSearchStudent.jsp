<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
	String searchWord=request.getParameter("xId");

	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	JsfPay jp=JsfPay.getInstance();

	if(searchWord ==null || searchWord.length()<=1)
	{
		out.println("");
		return;
	}


	Student[] st=ja.searchStudent(searchWord);

	if(st ==null)
	{
%>
		<div class=es02>沒有相關資料.</div>
<%
		return;
	}
%>

<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr  bgcolor=#f0f0f0  class=es02 cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
<td><b>學生姓名</b></td>
<td><b>性別</b></td>
<td>單位</td>
<td><b>班級</b></td>
<td><b>年級</b></td>
<td><b>生日</b></td>
<td>家中預設電話</td>
<td>預設聯絡人</td>
<td>手機1</td>
<td colspan=3></td></tr>	
<%
	ClassesMgr cm=ClassesMgr.getInstance();
	DepartMgr dm=DepartMgr.getInstance();
	LevelMgr lm=LevelMgr.getInstance();
	
	for(int i=0;i<st.length;i++)
	{
%>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02><a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a></td>
	<td class=es02>
	<%=(st[i].getStudentSex()==1)?"男":"女"%>
	</td>
	<td class=es02>
	<%
		int departIdx=st[i].getStudentDepart();
		if(departIdx==0)
		{
			out.println("未定");
		}
		else
		{
			Depart dex=(Depart)dm.find(departIdx);
			out.println(dex.getDepartName());
		}
		
	%>
	</td>
	<td class=es02><%
		int cid=st[i].getStudentClassId(); 
		if(cid==0)
		{
			out.println("未定");
		}
		else
		{
			Classes cla=(Classes)cm.find(cid);
			out.println(cla.getClassesName());
		}	
	  
	     %></td>
	<td class=es02><%
		int levelx=st[i].getStudentLevel(); 
		if(levelx==0)
		{
			out.println("未定");
		}
		else
		{
			Level leve=(Level)lm.find(levelx);
			out.println(leve.getLevelName());
		}
	     %></td>
	<td class=es02>
	     <%=jt.ChangeDateToString(st[i].getStudentBirth())%>	     
	</td>
	 <td class=es02>
	     
		<%
			switch(st[i].getStudentPhoneDefault()){
				case 1:
					out.println(st[i].getStudentPhone());
					break;
				case 2:
					out.println(st[i].getStudentPhone2());
					break;
				case 3:
					out.println(st[i].getStudentPhone3());
					break;
			}
		%>
	 </td>
	<td class=es02>
	<%
		String c1="";
		String c2="";
		String c3="";
		switch(st[i].getStudentEmailDefault())
		{
			case 0:
				c1="其他";	
				Contact[] cons=ja.getAllContact(st[i].getId());
				
				if(cons !=null)
				{
					int raId=cons[0].getContactReleationId();
					RelationMgr rm=RelationMgr.getInstance();
					Relation ra=(Relation)rm.find(raId);
					c1=ra.getRelationName();
					c2=cons[0].getContactName();
					c3=cons[0].getContactMobile();
				}
				break;
			case 1:								
				c1="父";
				c2=st[i].getStudentFather();
				c3=st[i].getStudentFatherMobile();
				break;
			case 2:
				c1="母";								
				c2=st[i].getStudentMother();
				c3=st[i].getStudentMotherMobile();
				break;	
		}

		out.println(c1+"-"+c2);

	%>				
	</tD>
	<td class=es02>
		<%
		if(c3!=null && jp.checkMobile(c3))
		{ 
	%>		
		<a href="#" onClick="javascript:openwindow62('<%=st[i].getId()%>','<%=c2%>','1');return false"><img src="pic/mobile.gif" border=0><%=st[i].getStudentFatherMobile()%></a>
		
	<%
		}else{
			out.println("[無效號碼]");		
		}
	%>					
	</td>    
	
	<td class=es02>
		<a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false">基本資料</a>
 |  
		<a href="#" onClick="javascript:openwindow27('<%=st[i].getId()%>');return false">繳費資訊</a>
	</td>
	</tr>	
	

<%
	}
%>
</table>
</td>
</tr>
</table>