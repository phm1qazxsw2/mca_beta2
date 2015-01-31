<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%
        String frameWidth=request.getParameter("frameWidth");
%>

<%@ include file="jumpTopExpress.jsp"%>
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

    public Map<Integer/*studentId*/,Vector<Membr>> getMembrMap(Student[] st)
        throws Exception
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<st.length; i++) {
            if (i>0) sb.append(",");
            sb.append(st[i].getId());
        }
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("surrogateId in (" + sb.toString() + ")", "");
        return new SortingMap(membrs).doSort("getSurrogateId");
    }

    ArrayList<Student> findActive(Student[] st, ArrayList<TagMembr> tms)
        throws Exception
    {
        String membrIds = new RangeMaker().makeRange(tms, "getMembrId");
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "order by name asc");
        Map<Integer, Membr> membrMap = new SortingMap(membrs).doSortSingleton("getSurrogateId");
        ArrayList<Student> ret = new ArrayList<Student>();
        for (int i=0; i<st.length; i++) {
            if (membrMap.get(st[i].getId())!=null)
                ret.add(st[i]);
        }
        return ret;
    }
%>
<%@ include file="tag_selection.jsp"%>

<body bgcolor="#f0f0f0">
<%
    String orderQes=request.getParameter("orderNum");
    String pageNum=request.getParameter("pageNum");
    String statusX=request.getParameter("status");

    int tagId = -1;

    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws2.getStudentBunitSpace("bunitId"));
    ArrayList<Tag> all_tags = TagMgr.getInstance().retrieveListX("","", _ws2.getStudentBunitSpace("bunitId"));
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

    String searchWord=request.getParameter("searchWord");

    if(searchWord==null)
        searchWord="";
    else
        searchWord=searchWord.trim();

    int pageNumber=1;
    int orderNum=0;
    int status=-1;

    if(statusX !=null)
        status=Integer.parseInt(statusX);

    if(orderQes!=null)
        orderNum=Integer.parseInt(orderQes);
            
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


    EzCountingService ezsvc = EzCountingService.getInstance();
    String statusStr = ""; // (status>0)?"studentStatus=" + status:"studentStatus in (3,4)";
    Student[] st = ezsvc.searchStudent(searchWord, studentIds, orderNum, statusStr, _ws2.getStudentBunitSpace("bunitId"));
    ArrayList<TagMembr> tms = new McaService(0).getCurrentCampusMembrs(_ws2.getSessionStudentBunitId());
    ArrayList<Student> students = findActive(st, tms);

%>
<script>
    function checkPage(teaId){
        top.checkPage(teaId);
    }

</script>

<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">

<div class=es02>
&nbsp;&nbsp;&nbsp;<b>學生名單</b>
<br>
<br>
<%

    for(int i=0; i<students.size(); i++)
    {
%>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="checkPage('<%=students.get(i).getId()%>');return false"><%=students.get(i).getStudentName()%></a><br>
<%  }   %>
</div>