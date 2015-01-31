<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<%@ include file="tag_selection.jsp"%>
<jsp:useBean id='form' scope='request' class='web.Student2Form'/>
<jsp:setProperty name='form' property='*'/>
<link rel="stylesheet" href="style.css" type="text/css">

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<br>

<b>&nbsp;&nbsp;&nbsp;離校生名單</b>
	<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=12',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
<br>
<%
    String orderQes=request.getParameter("orderNum");
    String pageNum=request.getParameter("pageNum");
    String status2=request.getParameter("status");

    String[] tags=request.getParameterValues("tagId");

    int tagId = -1;
    try { tagId = Integer.parseInt(request.getParameter("tagId")); } catch (Exception e) {}

    JsfAdmin ja=JsfAdmin.getInstance();
    JsfTool jt=JsfTool.getInstance();
    JsfPay jp=JsfPay.getInstance();
    _ws.setBookmark(ud2, "離校學生");
    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws.getStudentBunitSpace("bunitId"));
    ArrayList<Tag> all_tags = TagMgr.getInstance().retrieveListX("","", _ws.getStudentBunitSpace("bunitId"));
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

%>
<script type="text/javascript" src="openWindow.js"></script>

<blockquote>
<form action=listLevelStudent.jsp method=get>
<table>
    <tr class=es02>
    <td>

        <% // ############# 搜尋選單 ############### %>
        <table border=0 cellpadding=0 cellspacing=0><tr><td nowrap>
        狀態:
        <select name="status" size=1>
            <option value=0 <%=form.getStatusSelectionAttr("0")%>>全部</option>
            <option value=99 <%=form.getStatusSelectionAttr("99")%>>畢業校友</option>
            <option value=97 <%=form.getStatusSelectionAttr("97")%>>中途離校</option>
            <option value=98 <%=form.getStatusSelectionAttr("98")%>>未入學</option>
            
        </select>
        <br>
        <input type=submit value="查詢">
        </td>
        <td><img src="images/spacer.gif" width=20></td>
        <td valign=top nowrap>
            <%@ include file="tag_selection_body.jsp"%>
        </td></tr></table>
        <% // ###################################### %>

    
    </td>
    <td>
        <div align=right><a href="reportLevelStudent.jsp" class=an01><font color=blue>離校學生統計</font></a></div>
    </tD>
    </tr>
    </table>
</form>   
</blockquote>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
 <br>
<%
    int status=0;
    try { status=Integer.parseInt(status2); } catch (Exception e) {}
    int pageNumber=1;
    int orderNum=0;
    if(orderQes!=null)
        orderNum=Integer.parseInt(orderQes);
    
    String statusStr = (status>0)?"studentStatus=" + status:"studentStatus > 89 and studentStatus < 100 ";
    EzCountingService ezsvc = EzCountingService.getInstance();
    Student[] st = ezsvc.searchStudent(null, studentIds, orderNum, statusStr, _ws.getStudentBunitSpace("bunitId"));

if(st==null)
{
	out.println("目前沒有資料!!"); 
%>

	<%@ include file="bottom.jsp"%>	
<%	
	return;
}	

%>
	<center>
<%

	int studentLength=st.length;


	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
	//int pageContent=e.getEsystemStupage();
    int pageContent=50;
	
	if(pageNum!=null)
		pageNumber=Integer.parseInt(pageNum);
	
	int pageTotal=1;
	pageTotal=studentLength/pageContent;
	
	if(studentLength%pageContent!=0)
		pageTotal+=1;

	if(pageNumber !=1)
	{
		int lastPage=pageNumber-1;
		out.println("<a href=\"listLevelStudent.jsp?status="+status+"&tagId="+tagId+
			"&pageNum="+lastPage+"&orderNum="+orderNum+"\">上一頁</a>");
	}
	for(int j=0;j<pageTotal;j++)
	{
		int jx=j+1;
		
		if(pageNumber==jx)
		{
			out.println("<b>"+jx+"</b>");
		
		}
		else
		{
			out.println("<a href=\"listLevelStudent.jsp?status="+status+"&tagId="+tagId+"&pageNum="+jx+"&orderNum="+orderNum+"\">"+jx+"</a>");
		}
	}
	if(pageNumber !=pageTotal)
	{
		int lastPage=pageNumber+1;
		out.println("<a href=\"listLevelStudent.jsp?status="+status+"&tagId="+tagId+"&pageNum="+lastPage+"&orderNum="+orderNum+"\">下一頁</a>");
	}

	
%>
<div align=right>共計: <font color=blue><b><%=studentLength%></b></font> 筆資料</div>


	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>

<td>學生姓名</td>
<td>
<%
if(orderNum==7)
{
%>
<a href="listLevelStudent.jsp?status=<%=status%>&tagId=<%=tagId%>&pageNum=<%=pageNumber%>&orderNum=8">就學狀態<img src="images/Upicon2.gif" border=0></a>
<%
}else{
%>
<a href="listLevelStudent.jsp?status=<%=status%>&tagId=<%=tagId%>&pageNum=<%=pageNumber%>&orderNum=7">就學狀態<img src="images/Downicon2.gif" border=0></a>
<%
}
%>


</td>

<td>
<%
if(orderNum==1)
{
%>
<a href="listLevelStudent.jsp?status=<%=status%>&tagId=<%=tagId%>&pageNum=<%=pageNumber%>&orderNum=2">性別<img src="images/Upicon2.gif" border=0></a>
<%
}else{
%>
<a href="listLevelStudent.jsp?status=<%=status%>&tagId=<%=tagId%>&pageNum=<%=pageNumber%>&orderNum=1">性別<img src="images/Downicon2.gif" border=0></a>
<%
}
%>
</td>


<td>預設聯絡人</td>

<td>手機1</td>
<td colspan=3></td></tr>	
<%
    int startRow=(pageNumber-1)*pageContent;
    int endRow=startRow+pageContent;
    if(endRow > studentLength)
        endRow=studentLength;
    for(int i=startRow;i<endRow;i++)
    {
%>
<tr bgcolor=#ffffff class=es02>

<td><a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a></td>
	<td><%
		int statusx=st[i].getStudentStatus();
		
		switch(statusx)
		{
			case 99: out.println("畢業");
				break;
			case 98: out.println("未入學");
				break;
			case 97: out.println("中途離校");
				break;
			default:out.println("未定");
				break;
		}
	     %></td>
	<td>
	<%=(st[i].getStudentSex()==1)?"男":"女"%>
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
	</td>
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
    <td>
	<a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false">詳細資料</a> |
	
	
	<%
		if(statusx!=98) 
		{ 
	 %> 
	<a href="#" onClick="javascript:openwindow68('<%=st[i].getId()%>');return false">離校資訊</a>
	<%
		}
	%>
	</td>
	</tr>	
<%
}
%>
</table>
</td></tr></table>
</center>


<br>
<br>
<%@ include file="bottom.jsp"%>	