<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%!
    public String getTagURI(String[] tagIds)
    {
        if (tagIds==null)
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<tagIds.length; i++) {
            sb.append("&tag=");
            sb.append(tagIds[i]);
        }
        return sb.toString();
    }

    public void getMembrMap(ArrayList<Student> st, Map<Integer, Membr> membrMap,
        Map<Integer, TagMembrInfo> maintagMap )
        throws Exception
    {
        String studentIds = new RangeMaker().makeRange(st, "getId");
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("membr.type=1 and membr.surrogateId in (" 
            + studentIds + ")", "");
        new SortingMap(membrs).doSortSingleton("getSurrogateId", membrMap);

        ArrayList<TagType> tt = TagTypeMgr.getInstance().retrieveList("main=1", "");
        String typeIds = new RangeMaker().makeRange(tt, "getId");
        String membrIds = new RangeMaker().makeRange(membrs, "getId");
        ArrayList<TagMembrInfo> tagmembrs = TagMembrInfoMgr.getInstance().retrieveList("membrId in (" +
            membrIds + ") and tag.status=" + Tag.STATUS_CURRENT + " and typeId in (" + typeIds + ")", "");
        new SortingMap(tagmembrs).doSortSingleton("getMembrId", maintagMap);
    }

    ArrayList<Student> findActive(Student[] st, ArrayList<TagMembr> tms)
        throws Exception
    {
        String membrIds = new RangeMaker().makeRange(tms, "getMembrId");
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
        Map<Integer, Membr> membrMap = new SortingMap(membrs).doSortSingleton("getSurrogateId");
        ArrayList<Student> ret = new ArrayList<Student>();
        for (int i=0; st!=null&&i<st.length; i++) {
            if (membrMap.get(st[i].getId())!=null)
                ret.add(st[i]);
        }
        return ret;
    }
%>
<%
    int topMenu=4;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="tag_selection.jsp"%>
<%	
    String orderQes=request.getParameter("orderNum");
    String pageNum=request.getParameter("pageNum");
    String statusX=request.getParameter("status");

    int tagId = -1;

    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("", "order by num ", _ws.getStudentBunitSpace("bunitId"));
    TagHelper th = TagHelper.getInstance(pZ2, 0, _ws.getSessionStudentBunitId());
    ArrayList<Tag> all_tags = th.getTags(false, "", _ws.getStudentBunitSpace("bunitId"));
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

    String searchWord=request.getParameter("searchWord");

    if(searchWord==null)
        searchWord="";
    else
        searchWord=searchWord.trim();

    boolean sortbyid = false;
    try { sortbyid = (request.getParameter("sortbyid").equals("1")); } catch (Exception e) {}

    int pageNumber=1;
    int orderNum=0;
    int status=-1;

    if(statusX !=null)
        status=Integer.parseInt(statusX);
            
    if(pageNum!=null)
        pageNumber=Integer.parseInt(pageNum);


    if(status==-1 && searchWord.length()==8)
    {
        try{
            int xbill=Integer.parseInt(searchWord);
            response.sendRedirect("search_single_bill.jsp?ticketId="+xbill);
        }catch(Exception ex2){}
    }

    JsfAdmin ja=JsfAdmin.getInstance();
    JsfTool jt=JsfTool.getInstance();
    JsfPay jp=JsfPay.getInstance();

    String modify_student_page = "modifyStudent.jsp";
    if (pZ2.getPagetype()==7) // 馬禮遜
        modify_student_page = "modify_mca_student.jsp";

    if(!checkAuth(ud2,authHa,600))
    {
        response.sendRedirect("authIndex.jsp?code=600");
    }
%>

<%@ include file="leftMenu4.jsp"%>

<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<br>
<b>&nbsp;&nbsp;&nbsp;<%=(pZ2.getCustomerType()==0)?"就讀生名單":"客戶名單"%></b>
<br>
<div style="position:relative;left:10px;overflow:auto">
<form name="xs2" id="xs2" action="listStudent.jsp" method=get>
	<table border=0 class=es02>
		<tr valign=top>	
        <%
        if(pZ2.getCustomerType()==0){
        %>				
			<td nowrap>
                入學狀態：
            </td>
			<td nowrap>
                <select name="status" size=1>
                    <option value=-1 <%=(status==-1)?"selected":""%>>全部</option>
                    <option value=3 <%=(status==3)?"selected":""%>>試讀</option>
                    <option value=4 <%=(status==4)?"selected":""%>>在學</option>
                </select>
			</td>
        <%  }else{  %>
                <input type=hidden name="status" value="-1">
        <%  }   %>  

            <td align=left nowrap>

            <%@ include file="tag_selection_body.jsp"%>

            </td>
            </tr>
            <tr>
            <td>
                關鍵字:                
            </td>
            <td nowrap colspan=2 align=left>
                <input type=text name="searchWord" size=10 value="<%=searchWord%>">					
                <input type=submit value="查詢">
                <a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=9',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
                &nbsp;
                <input type="checkbox" name="sortbyid" value="1" <%=(sortbyid)?"checked":""%>> Sort by Created Time (Descending)
            </td>
            </tr>
            </table>
	</form>	
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div style="position:relative;left:10px;width:800px" align=right class=es02>	
<%
    _ws.setBookmark(ud2, "就讀生 " + _title.toString());   
    EzCountingService ezsvc = EzCountingService.getInstance();
    String statusStr = ""; // (status>0)?"studentStatus=" + status:"studentStatus in (3,4)";
    if (sortbyid)
        orderNum = 100;
    Student[] st = ezsvc.searchStudent(searchWord, studentIds, orderNum, statusStr, _ws.getStudentBunitSpace("bunitId"));
    ArrayList<TagMembr> tms = new McaService(0).getCurrentCampusMembrs(_ws.getSessionStudentBunitId());
    ArrayList<Student> students = findActive(st, tms);

	if(students.size()==0)
	{
		out.println("<center><div class=es02>沒有相關資料!</div></center>");
%>
        <%@ include file="bottom.jsp"%>	
<%
		return;
	}	

    Map<Integer, Membr> membrMap = new LinkedHashMap<Integer, Membr>();
    Map<Integer, TagMembrInfo> maintagMap = new LinkedHashMap<Integer, TagMembrInfo>();
    getMembrMap(students, membrMap, maintagMap);

	int studentLength=students.size();
    int pageContent = 50;
    
	int pageTotal=1;
	pageTotal=studentLength/pageContent;
	
	if(studentLength%pageContent!=0)
		pageTotal+=1;

	if(pageNumber !=1)
	{
		int lastPage=pageNumber-1;
		out.println("<a href=\"listStudent.jsp?pageNum="+lastPage+"&orderNum="+orderNum+"&searchWord="+URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)+"\">上一頁</a>");
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
			out.println("<a href=\"listStudent.jsp?pageNum="+jx+"&orderNum="+orderNum+"&searchWord="+URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)+"\">"+jx+"</a>");
		}
	}
	if(pageNumber !=pageTotal)
	{
		int lastPage=pageNumber+1;
		out.println("<a href=\"listStudent.jsp?pageNum="+lastPage+"&orderNum="+orderNum+"&searchWord="+URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)+"\">下一頁</a>");
	}
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
共計: <font color=blue><%=studentLength%></font> 筆資料 | 
<a target="_blank" href="mca_export_student.jsp?<%=request.getQueryString()%>"><img src="pic/littleE.png" border=0>&nbsp;匯出</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>

<div style="position:relative;left:10px;width:800px" align=right class=es02>	
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr  bgcolor=#f0f0f0  class=es02 cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
<td width="70" align=middle><%=(pZ2.getCustomerType()==0)?"學生姓名":"客戶名稱"%></td>
<%
if(pZ2.getCustomerType()==0){
%>

    <td nowrap align=middle>
    <%
    if(orderNum==1)
    {
    %>
    <a href="listStudent.jsp?pageNum=<%=pageNumber%>&orderNum=2&searchWord=<%=URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)%>">性別<img src="images/Upicon2.gif" border=0></a>
    <%
    }else{
    %>
    <a href="listStudent.jsp?pageNum=<%=pageNumber%>&orderNum=1&searchWord=<%=URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)%>">性別<img src="images/Downicon2.gif" border=0></a>
    <%
    }
    %>
    </td>
    <td align=middle>
    <%
    if(orderNum==9)
    {
    %>
    <a href="listStudent.jsp?pageNum=<%=pageNumber%>&orderNum=10&searchWord=<%=URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)%>">生日<img src="images/Upicon2.gif" border=0></a>
    <%
    }else{
    %>
    <a href="listStudent.jsp?pageNum=<%=pageNumber%>&orderNum=9&searchWord=<%=URLEncoder.encode(searchWord,"UTF-8")+getTagURI(tagIds)%>">生日<img src="images/Downicon2.gif" border=0></a>
    <%
    }
    %>
    </td>
<%
    }else{
%>
    <td align=middle width=100>統一編號</td>
<%
    }
%>
<td align=middle nowrap><%=(pZ2.getCustomerType()==0)?"家中預設電話":"室內電話"%></td>
<%  if(pZ2.getCustomerType()==1){   %>
<td align=middle>傳 真</td>
<%  }   %>


<td align=middle nowrap><%=(pZ2.getCustomerType()==0)?"父親":"負責人"%></td>
<td align=middle>手機</td>
<td align=middle nowrap><%=(pZ2.getCustomerType()==0)?"母親":"聯絡人"%></td>
<td align=middle>手機</td>
<td></td></tr>	
<%
int startRow=(pageNumber-1)*pageContent;
int endRow=startRow+pageContent;
if(endRow > studentLength)
	endRow=studentLength;

int nowMonth=new Date().getMonth();

EsystemMgr em=EsystemMgr.getInstance();
Esystem exx=(Esystem)em.find(1);

for(int i=startRow;i<endRow;i++)
{
    //students.get(i).getStudentAddress()
    int birthMonth=13;

    if(students.get(i).getStudentBirth() !=null)
        birthMonth=students.get(i).getStudentBirth().getMonth();

    String name=(pZ2.getCustomerType()==1 && students.get(i).getStudentShortName()!=null && students.get(i).getStudentShortName().length()>0)?students.get(i).getStudentShortName():students.get(i).getStudentName(); // 公司的才用

    if(name !=null && name.length()>5){
        if (name.charAt(0)>'Z') // 不是英文
            name=name.substring(0,5)+"..";
    }
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02 nowrap>
        <a href="javascript:openwindow_phm2('<%=modify_student_page%>?studentId=<%=students.get(i).getId()%>','基本資料',700,700,'mcastudentwin');">
            <%=name%> 
            <% 
                Membr m = membrMap.get(students.get(i).getId());
                TagMembrInfo tm = maintagMap.get(m.getId());
                if (tm!=null&&tm.getTagName()!=null && tm.getTagName().length()>0)
                    out.println("("+tm.getTagName()+")");
            %>
        </a>

        <a href="bill_detail2.jsp?sid=<%=m.getId()%>&poId=-1&backurl=<%=URLEncoder.encode("listStudent.jsp?status=-1"+getTagURI(tagIds))%>"><img src="img/billlink.png" height=14 border=0></a>

<%
    if(students.get(i).getStudentAddress()!=null && students.get(i).getStudentAddress().length()>0){
%>

&nbsp;&nbsp;<a href="javascript:openwindow_phm('addressAPI.jsp?q=<%=students.get(i).getStudentAddress()%>','地圖-<%=students.get(i).getStudentAddress()%>',600,500,false);"><img src="pic/map.png" border=0 alt="顯示地圖">
<%
    }   
%>
</td>
<%
if(pZ2.getCustomerType()==0){
%>
	<td class=es02 align=middle>
	<%=(students.get(i).getStudentSex()==1)?"男":"女"%>
	</td>
	<td class=es02 nowrap valign=middle>
        <%
            if(birthMonth==nowMonth){
        %>
                <font color=red>*</font>
        <%        
            }else{
        %>
            &nbsp;
        <%  }   %>
        <%=jt.showDate(students.get(i).getStudentBirth(),exx)%>
    </td>
<%
}else{
%>
    <td class=es02><%=students.get(i).getStudentIDNumber()%></td>

<%
}
%>
    <td class=es02 align=middle nowrap>	     
<%
        switch(students.get(i).getStudentPhoneDefault()){
            
            case 0:
                out.println(students.get(i).getStudentPhone());
                break;
            case 1:
                out.println(students.get(i).getStudentPhone());
                break;
            case 2:
                out.println(students.get(i).getStudentPhone2());
                break;
            case 3:
                out.println(students.get(i).getStudentPhone3());
                break;
        }
%>
    </td>
<%  if(pZ2.getCustomerType()==1){   %>
    <td class=es02  align=middle>
        <%=students.get(i).getStudentPhone3()%>
    </td>        
<%  }   %>

<%
    if(students.get(i).getStudentEmailDefault()!=0){
%>

        <td class=es02 nowrap>
            <%
            if(students.get(i).getStudentEmailDefault()==1 && students.get(i).getStudentFather()!=null && students.get(i).getStudentFather().length()>0){ 
                
            %>
                <font color=red>*</font>
            <%  }else{ out.println("&nbsp;"); }   %>
            <%=students.get(i).getStudentFather()%>
        </td>
        <td class=es02 nowrap align=middle>
        <%
	    if(students.get(i).getStudentFatherMobile()!=null && jp.checkMobile(students.get(i).getStudentFatherMobile()))
		{
        %> 

		<a href="#" onClick="javascript:openwindow62('<%=students.get(i).getId()%>','<%=students.get(i).getStudentFatherMobile()%>','1');return false"><%=students.get(i).getStudentFatherMobile()%></a>

        <%  }else{   %>
                <%=students.get(i).getStudentFatherMobile()%>
        <%  }   %>
        </td>
        <td class=es02 nowrap align=left>
            <%
            if(students.get(i).getStudentEmailDefault()==2  && students.get(i).getStudentMother()!=null && students.get(i).getStudentMother().length()>0){
            %>
                <font color=red>*</font>
            <%  }else{ out.println("&nbsp;"); }   %>
            <%=students.get(i).getStudentMother()%>
        </td>
        <td class=es02 nowrap align=middle>
        <%
	    if(students.get(i).getStudentMotherMobile()!=null && jp.checkMobile(students.get(i).getStudentMotherMobile()))
		{
        %> 
		<a href="#" onClick="javascript:openwindow62('<%=students.get(i).getId()%>','<%=students.get(i).getStudentMotherMobile()%>','1');return false"><%=students.get(i).getStudentMotherMobile()%></a>

        <%  }else{   %>
                <%=students.get(i).getStudentMotherMobile()%>
        <%  }   %>
        </td>
<%
    }else{  
%>
        <td class=es02 colspan=4 nowrap align=left>
                <font color=red>*</font>
        <%
                Contact[] cons=ja.getAllContact(students.get(i).getId());
                
                if(cons !=null)
                {
                    int raId=cons[0].getContactReleationId();
                    RelationMgr rm=RelationMgr.getInstance();
                    Relation ra=(Relation)rm.find(raId);
          %>
                <%=ra.getRelationName()%>:<%=cons[0].getContactName()%> 電話:<%=cons[0].getContactPhone1()%> 手機:
                <%
                    if(cons[0].getContactMobile()!=null && jp.checkMobile(cons[0].getContactMobile()))
                    {
                    %> 
		<a href="#" onClick="javascript:openwindow62('<%=students.get(i).getId()%>','<%=cons[0].getContactMobile()%>','1');return false"><%=cons[0].getContactMobile()%></a>
        <%
                    }else{
        %>
                        <%=cons[0].getContactMobile()%>
        <%            
                    }
                }
        %>
        </td>

<%  }   

/*
        String c1="";
        String c2="";
        String c3="";
        switch(students.get(i).getStudentEmailDefault())
        {
            case 0:
                c1="其他";	
                Contact[] cons=ja.getAllContact(students.get(i).getId());
                
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
                c2=students.get(i).getStudentFather();
                c3=students.get(i).getStudentFatherMobile();
                break;
            case 2:
                c1="母";								
                c2=students.get(i).getStudentMother();
                c3=students.get(i).getStudentMotherMobile();
                break;	
        }

*/
/*
%>			
	</tD>
	<td class=es02 nowrap align=middle>
		<%
		if(c3!=null && jp.checkMobile(c3))
		{ 
	%>		
		<a href="#" onClick="javascript:openwindow62('<%=students.get(i).getId()%>','<%=c3%>','1');return false"><img src="pic/mobile.gif" border=0><%=c3%></a>
		
	<%
		}else{
			out.println("[無效號碼]");		
		}
	%>					
	</td>    
<%
    */
%>	

	<td class=es02 align=middle nowrap>
        <a href="javascript:openwindow_phm('<%=modify_student_page%>?studentId=<%=students.get(i).getId()%>','基本資料',700,700,true);">基本資料</a>
        
        <%
        if(checkAuth(ud2,authHa,101))
        {
        %>

        | <a href="bill_detail2.jsp?sid=<%=m.getId()%>&poId=-1&backurl=<%=URLEncoder.encode("listStudent.jsp?status=-1"+getTagURI(tagIds))%>">帳單資訊</a>
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
	
<br>
<br>

</div>
<%@ include file="bottom.jsp"%>	


