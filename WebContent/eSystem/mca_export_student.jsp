<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%!
    String doCapital(String str)
    {
        if (str==null || str.length()==0)
            return "";
        return str.substring(0,1).toUpperCase() + str.substring(1);
    }

    String formatAddr(McaStudent s) throws Exception {
        return McaService.formatAddr(s.getCountryID(), s.getCountyID(), s.getCityID(), s.getDistrictID(), 
            s.getChineseStreetAddress(), s.getPostalCode());
    }

    String formatBillingAddr(McaStudent s) throws Exception  {
        return McaService.formatAddr(s.getBillCountryID(), s.getBillCountyID(), s.getBillCityID(), s.getBillDistrictID(), 
            s.getBillChineseStreetAddress(), s.getBillPostalCode());
    }

    private static Map<String, Area> areaMap = null;
    String formatEnglishAddr(McaStudent s) throws Exception  {
        if (areaMap==null) {
            areaMap = new SortingMap(AreaMgr.getInstance().retrieveList("", "")).doSortSingleton("getMyKey");
        }
        Area country = areaMap.get("0#" + s.getCountryID());
        Area county = areaMap.get("1#" + s.getCountyID());
        Area city = areaMap.get("2#" + s.getCityID());
        Area district = areaMap.get("3#" + s.getDistrictID());

        String street = s.getEnglishStreetAddress();
        String postCode = s.getPostalCode();

        if (street==null || street.length()==0 || (city==null && county==null))
            return ""; // 不完全就不要
        
        StringBuffer sb = new StringBuffer();
        if (street!=null)
            sb.append(street);
        if (district!=null)
            sb.append("," + district.getEName());
        if (sb.length()>0)
            sb.append("\n");
        if (city!=null)
            sb.append(city.getEName() + ", ");
        if (county!=null)
            sb.append(county.getEName());
        if (postCode!=null)
            sb.append(" " + postCode);
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
        for (int i=0; i<st.length; i++) {
            if (membrMap.get(st[i].getId())!=null)
                ret.add(st[i]);
        }
        return ret;
    }
%>
<%@ include file="tag_selection.jsp"%>
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
    String studIds = new RangeMaker().makeRange(students, "getId");
    ArrayList<McaStudent> mstudents = McaStudentMgr.getInstance().retrieveList("studId in (" + studIds + ")", 
        "order by StudentSurname asc, StudentFirstName asc");

    Map<Integer, Membr> membrMap = new LinkedHashMap<Integer, Membr>();
    Map<Integer, TagMembrInfo> maintagMap = new LinkedHashMap<Integer, TagMembrInfo>();
    getMembrMap(students, membrMap, maintagMap);
%>
<table border=1>
    <tr>
        <th nowrap></th>
        <th nowrap>StudentID</th>
        <th nowrap>CoopID</th>
        <th nowrap>ArcID</th>
        <th nowrap>TDisc</th>
        <th nowrap>Grade</th>
        <th nowrap>StudentFirstName</th>
        <th nowrap>StudentSurname</th>
        <th nowrap>StudentChineseName</th>
        <th nowrap>BirthDate</th>
        <th nowrap>PassportNumber</th>
        <th nowrap>PassportCountry</th>
        <th nowrap>Sex</th>
        <th nowrap>Sponser</th>
        <th nowrap>HomePhone</th>
        <th nowrap>OfficePhone</th>
        <th nowrap>Fax</th>
        <th nowrap>FatherFirstName</th>
        <th nowrap>FatherSurname</th>
        <th nowrap>FatherChineseName</th>
        <th nowrap>FatherPhone</th>
        <th nowrap>FatherCell</th>
        <th nowrap>FatherEmail</th>
        <th nowrap>MotherFirstName</th>
        <th nowrap>MotherSurname</th>
        <th nowrap>MotherChineseName</th>
        <th nowrap>MotherPhone</th>
        <th nowrap>MotherCell</th>
        <th nowrap>MotherEmail</th>
        <th nowrap>Mailing Address</th>
        <th nowrap>Billing Address</th>
        <th nowrap>English Address</th>
        <th nowrap>Notes</th>
    </tr>
<%
    McaService msvc = new McaService(0);
    String membrIds = new RangeMaker().makeRange(mstudents, "getMembrId");
    msvc.setupMembrsInfoCurrentFee(membrIds);

    for(int i=0; i<mstudents.size(); i++)
    {
        McaStudent s = mstudents.get(i);
        String grade = msvc.getGrade(s.getMembrId());
%>
    <tr>
        <td nowrap><%=(i+1)%></td>
        <td nowrap><%=s.getStudentID()%></td>
        <td nowrap><%=s.getCoopID()%></td>
        <td nowrap><%=s.getArcID()%></td>
        <td nowrap><%=s.getTDisc()%></td>
        <td nowrap><%=grade%></td>
        <td nowrap><%=s.getStudentFirstName()%></td>
        <td nowrap><%=s.getStudentSurname()%></td>
        <td nowrap><%=s.getStudentChineseName()%></td>
        <td nowrap><%=s.getBirthDate()%></td>
        <td nowrap><%=s.getPassportNumber()%></td>
        <td nowrap><%=s.getPassportCountry()%></td>
        <td nowrap><%=s.getSex()%></td>
        <td nowrap><%=s.getSponser()%></td>
        <td nowrap><%=s.getHomePhone()%></td>
        <td nowrap><%=s.getOfficePhone()%></td>
        <td nowrap><%=s.getFax()%></td>
        <td nowrap><%=s.getFatherFirstName()%></td>
        <td nowrap><%=s.getFatherSurname()%></td>
        <td nowrap><%=s.getFatherChineseName()%></td>
        <td nowrap><%=s.getFatherPhone()%></td>
        <td nowrap><%=s.getFatherCell()%></td>
        <td nowrap><%=s.getFatherEmail()%></td>
        <td nowrap><%=s.getMotherFirstName()%></td>
        <td nowrap><%=s.getMotherSurname()%></td>
        <td nowrap><%=s.getMotherChineseName()%></td>
        <td nowrap><%=s.getMotherPhone()%></td>
        <td nowrap><%=s.getMotherCell()%></td>
        <td nowrap><%=s.getMotherEmail()%></td>
        <td nowrap><%=formatAddr(s)%></td>
        <td nowrap><%=formatBillingAddr(s)%></td>
        <td nowrap><%=formatEnglishAddr(s)%></td>
        <td nowrap><%=s.getNotes()%></td>
    </tr>
<%  }   %>
</table>