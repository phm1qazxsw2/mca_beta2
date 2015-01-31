<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,700))
	{ 
       response.sendRedirect("authIndex.jsp?code=700");
	}
%>
<%@ include file="leftMenu6.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
	String orderString=request.getParameter("order");
	
	int order=0;	
	if(orderString !=null)
		order=Integer.parseInt(orderString);

	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
    Teacher2Mgr tm=Teacher2Mgr.getInstance(); 

    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 
       
    String query="(teacherStatus ='2' or teacherStatus ='1') ";

    if(bunit !=-1)
        query +=" and teacherBunitId='"+bunit+"'";

    ArrayList<Teacher2> teaArray = tm.retrieveListX(query,"", _ws.getBunitSpace("bunitId"));  
	
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));
    Map<Integer,Vector<Teacher2>> bnuitMap = new SortingMap(teaArray).doSort("getTeacherBunitId");

%>
<script type="text/javascript" src="openWindow.js"></script>
<script>
	function goReload(){
		window.location.reload();
	}
</script>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;在職<%=(pZ2.getCustomerType()==0)?"教師":"員工"%>列表</b>
<%
    if(b !=null && b.size()>0){
%>
<blockquote>
    <form action="listTeacher.jsp" method="get">        
        依部門查詢: <select name="bunit">
            <option value="-1" <%=(bunit==-1)?"selected":""%>>全部部門</option>
<%          
            for(int j=0;j<b.size();j++){    
                Bunit bb=b.get(j);
%>
                <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
<%          }   %>
            <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
        </select>
        <input type=submit value="查詢">
    </form>        
</blockquote>
<%
    }
%>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<%
	JsfPay jp=JsfPay.getInstance();
	if(teaArray==null || teaArray.size()<=0)
	{
%>
        <br>
        <blockquote>
        <div class=es02>    
            目前沒有資料.
            <br>
            <br>
            <a href="addTeacher.jsp">新增教職員</a>
        </div>
        <%@ include file="bottom.jsp"%>
<%
		return;
	}

%>
<center>
<div class=es02 align=right>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
共計: <font color=blue><%=teaArray.size()%></font> 筆資料 | 
<a target="_blank" href="teacherFrame.jsp?<%=request.getQueryString()%>"><img src="pic/littleE.png" border=0>&nbsp;快速編輯</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
</center>

<%
    int nowMonth=new Date().getMonth();
    for(int j=0;b !=null && j<(b.size()+1);j++){

        Bunit bb=null;
        Vector teaV=null;
        
        boolean lastOne=(j==b.size())?true:false;

        if(lastOne){
            if(bnuitMap !=null && bnuitMap.size()>0)
                teaV=bnuitMap.get(new Integer(0));        
        }else{

            bb=b.get(j);        
            if(bnuitMap !=null && bnuitMap.size()>0){
                teaV=bnuitMap.get(new Integer(bb.getId()));
            }
        }

        if(teaV==null || teaV.size()<=0){
            continue;        
        }
%>
    <br>
    <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;部 門:&nbsp;<b><%=(lastOne)?"未定":bb.getLabel()%></b></div><br>
    <center>
    <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
    
			<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
            <td class=es02 align=middle>姓 名</td>
            <td class=es02 align=middle>家中電話</td>
            <td class=es02 align=middle>手 機</td>
            <td class=es02 align=middle>
                狀 態
            </td>
            <td class=es02 align=middle>
                生 日
            </td>
            <td class=es02 align=middle>
                到 職 日
            </td>
            <td></td>
        </tr>
<%
	for(int i=0;teaV !=null && i<teaV.size();i++)
	{        
        Teacher2 tea=(Teacher2)teaV.get(i);
%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02>

            <a href="javascript:openwindow_phm('modifyTeacher.jsp?teacherId=<%=tea.getId()%>','教職員基本資料',800,550,true);">
            <%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%>
            </a>
<%
    if(tea.getTeacherAddress()!=null && tea.getTeacherAddress().length()>0){
%>
&nbsp;&nbsp;<a href="javascript:openwindow_phm('addressAPI.jsp?q=<%=tea.getTeacherAddress()%>','地圖-<%=tea.getTeacherAddress()%>',600,500,false);"><img src="pic/map.png" border=0 alt="顯示地圖" width=12></a>
<%
    }   
%>
        </td> 
		<td class=es02><%=tea.getTeacherPhone()%></tD>
		
        <td class=es02>
        <%
        if(tea.getTeacherMobile()!=null && jp.checkMobile(tea.getTeacherMobile()))
		{     			
        %>
<a href="#" onClick="javascript:openwindow62('<%=tea.getId()%>','<%=tea.getTeacherMobile()%>','2');return false"><img src="pic/mobile.gif" border=0>&nbsp;<%=tea.getTeacherMobile()%> </a> 
        <%  }   %>
		</tD>
		<td class=es02>
		<%
			int statusx=tea.getTeacherStatus();
			
			switch(statusx)
			{
				case 1:out.println("在職");
					break;
				case 2:out.println("試用");
					break;
				case 3:out.println("面試");
					break;
				case 0:out.println("離職");
					break;
				default:out.println("未定");
					break;
			}
		
            Date brth = tea.getTeacherBirth();
            int birthMonth = -1;
            if (brth!=null)
                birthMonth = brth.getMonth();
		%>
		</td>
        <td class=es02>
        <%
            if(birthMonth==nowMonth){
        %>
            <img src="pic/star2.png" border=0 alt="本月壽星">
        <%        
            }else{
        %>
            &nbsp;&nbsp;&nbsp;
        <%  }   %>

		<%=(tea.getTeacherBirth()!=null)?sdf2.format(tea.getTeacherBirth()):""%>
		</td>
        <td class=es02>
		
            <%=(tea.getTeacherComeDate()!=null)?sdf2.format(tea.getTeacherComeDate()):""%>
		</td>
		
		<td class=es02>

            <a href="javascript:openwindow_phm('modifyTeacher.jsp?teacherId=<%=tea.getId()%>','教職員基本資料',800,550,true);">詳細資料</a>
		</td>
	</tr>
<%
	}
%>
    </table>	
    </td></tr></table>
    </center>
<%
    }
%>
<br>
<%@ include file="bottom.jsp"%>	