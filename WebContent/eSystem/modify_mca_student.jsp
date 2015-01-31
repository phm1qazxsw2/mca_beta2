<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    String formatName(String n)
    {
        if (n==null || n.length()==0)
            return n;
        return n.substring(0,1).toUpperCase() + n.substring(1);
    }

    String drawCampus(String campus)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<select name=Campus disabled>");
        sb.append("<option value='Bethany' "+((campus.equals("Bethany"))?"selected":"")+">Bethany");
        sb.append("<option value='Taichung' "+((campus.equals("Taichung"))?"selected":"")+">Taichung");
        sb.append("<option value='Kaohsiung' "+((campus.equals("Kaohsiung"))?"selected":"")+">Kaohsiung");
        sb.append("<option value='Chiayi' "+((campus.equals("Chiayi"))?"selected":"")+">Chiayi");
        sb.append("</select>");
        sb.append(" (current setting, may vary for each fee)");
        return sb.toString();
    }

    String drawGrade(McaStudent ms)
        throws Exception
    {
        McaService msvc = new McaService(0);
        msvc.setupMembrsInfoCurrentFee(ms.getMembrId()+"");
        String grade = msvc.getGrade(ms.getMembrId());

        StringBuffer sb = new StringBuffer();
        sb.append("<select name=Grade disabled>");
        sb.append("<option value=''>");
        sb.append("<option value='K' "+((grade.equals("K"))?"selected":"")+">K");
        sb.append("<option value='1' "+((grade.equals("1"))?"selected":"")+">1");
        sb.append("<option value='2' "+((grade.equals("2"))?"selected":"")+">2");
        sb.append("<option value='3' "+((grade.equals("3"))?"selected":"")+">3");
        sb.append("<option value='4' "+((grade.equals("4"))?"selected":"")+">4");
        sb.append("<option value='5' "+((grade.equals("5"))?"selected":"")+">5");
        sb.append("<option value='6' "+((grade.equals("6"))?"selected":"")+">6");
        sb.append("<option value='7' "+((grade.equals("7"))?"selected":"")+">7");
        sb.append("<option value='8' "+((grade.equals("8"))?"selected":"")+">8");
        sb.append("<option value='9' "+((grade.equals("9"))?"selected":"")+">9");
        sb.append("<option value='10' "+((grade.equals("10"))?"selected":"")+">10");
        sb.append("<option value='11' "+((grade.equals("11"))?"selected":"")+">11");
        sb.append("<option value='12' "+((grade.equals("12"))?"selected":"")+">12");
        sb.append("</select>");
        sb.append(" (current setting, may vary for each fee)");
        return sb.toString();
    }

    String drawAreaSelect(String code, ArrayList<Area> areas, String fieldName)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<select name="+fieldName+">");
        sb.append("<option value=''>");
        for (int i=0; i<areas.size(); i++) {
            Area a = areas.get(i);
            String str = "";
            if (a.getEName().length()>0) {
                str = a.getEName();
                if (a.getCName().length()>0) {
                    str += " (" + a.getCName() + ")";
                }
            }
            sb.append("<option value='"+a.getCode()+"' "+((a.getCode().equals(code))?"selected":"")+">" + str);
        }
        sb.append("</select>");
        return sb.toString();
    }

    String drawGender(String sex)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<select name=Sex>");
        sb.append("<option value='F' "+((sex.equals("F"))?"selected":"")+">Female");
        sb.append("<option value='M' "+((sex.equals("M"))?"selected":"")+">Male");
        sb.append("</select>");
        return sb.toString();
    }

%>

<script src="js/formcheck.js?xyz"></script>
<script src="js/string.js?xyz"></script>
<script>
function check(f) {
    var f = document.f1;
    
    var sid = trim(f.StudentID.value);
    if (sid.length==0 || sid=='0') {
        alert('StudentID is not valid');
        f.StudentID.focus();
        return false;
    }

    if (!IsPositive(sid, true)) {
        alert('StudentID is not valid');
        f.StudentID.focus();
        return false;
    }

    if (trim(f.BirthDate.value).length==0) {
        alert('BirthDate is mandatory');
        f.BirthDate.focus();
        return false;
    }
    return true;
}
</script>
<%
    McaStudent s = McaStudentMgr.getInstance().find("studId=" + request.getParameter("studentId"));
    Student2 st = Student2Mgr.getInstance().find("id=" + s.getStudId());
    Map<Integer, TagMembr> tmsMap = new SortingMap(new McaService(0).
        getCurrentCampusMembrs(_ws2.getSessionStudentBunitId())).doSortSingleton("getMembrId");
    McaService msvc = new McaService(0);
    msvc.setupMembrsInfoCurrentFee(s.getMembrId()+"");
    String mycampus = msvc.getCampus(st.getBunitId());

    boolean leave = (tmsMap.get(s.getMembrId())==null) && (st.getStudentStatus()!=1);
    boolean newstudent = (st.getStudentStatus()==1);
    boolean create = request.getParameter("create")!=null;

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    ArrayList<Area> countries = AreaMgr.getInstance().retrieveList("level=0", "");
    String CountryID = s.getCountryID();
    if (CountryID.trim().length()==0)
        CountryID = "1001"; // 臺灣
    String CountyID = s.getCountyID();
    if (CountyID.trim().length()==0)
        CountyID = "1001";
    String CityID = s.getCityID();
    String DistrictID = s.getDistrictID();
    String PostalCode = s.getPostalCode();
    String CStreet = s.getChineseStreetAddress();
    String EStreet = s.getEnglishStreetAddress();

    String notes = s.getNotes();
    if (notes==null)
        notes = "";
%>

<script src="js/dateformat.js"></script>
<script src="js/string.js"></script>
<script type="text/javascript" src="js/mca_area.js?123"></script>
<script type="text/javascript" src="mca_area_def.jsp"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function do_create()
{
    document.f1.action = "mca_student_testcreate.jsp";
    document.f1.Campus.disabled = false;
    document.f1.Grade.disabled = false;
    document.f1.method = "post";
    document.f1.submit();
}

function do_leave() {
    if (!confirm('The student will not participate in current bills, are you sure?')) {
        return;
    }
    var url = "modify_mca_student_status.jsp?id=<%=s.getId()%>&status=99";
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else {
                    parent.do_reload = true;
                    location.reload();
                }                        
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("查詢服務器時發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function do_delete(msId)
{
    if (!confirm('Are you sure to delete this student?'))
        return;
    location.href= 'mca_delete_student.jsp?id='+msId;

}

function do_back() {
    openwindow_phm2('mca_back_student.jsp?id=<%=s.getId()%>', '回校', 300, 400, 'backwin');
    /*
    if (!confirm('Sure?')) {
        return;
    }
    var url = "modify_mca_student_status.jsp?id=<%=s.getId()%>&status=4";
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else {
                    parent.do_reload = true;
                    location.reload();
                }                        
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("查詢服務器時發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    */
}

function do_transfer()
{
    openwindow_phm2('mca_transfer_student.jsp?id=<%=s.getId()%>', '轉校', 300, 400, 'transferwin');
}

function do_save() {
    if (!check())
        return;

    var url = "modify_mca_student2.jsp";
    var post_params = 'id=<%=s.getId()%>';
    var elements = document.f1.elements;
    for (var i=0; i<elements.length; i++) {
        post_params += '&';
        post_params += (elements[i].name + "=" + myEncodeURI(elements[i].value));
    }
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else {
                    openwindow_inline("<div><br><br><center>saved..</center></div>", "Saved", 10, 10, "statuswin");
                    //parent.do_reload = true;
                    setTimeout("statuswin.hide();", 1000);
                }                        
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("查詢服務器時發生錯誤");
                return;
            }
        }
    };
    req.open('POST', url);
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("Content-length", post_params.length);
    req.setRequestHeader("Connection", "close");
    req.send(post_params);
}

function init() {
    var ad = new addr('<%=CountryID%>', '<%=CountyID%>', '<%=CityID%>', 
        '<%=DistrictID%>', '<%=PostalCode%>', '<%=phm.util.TextUtil.escapeJSString(CStreet)%>', '<%=phm.util.TextUtil.escapeJSString(EStreet)%>');
    var d1 = document.getElementById("d1");
    var d2 = document.getElementById("d2");
    var d3 = document.getElementById("d3");
    var d4 = document.getElementById("d4");
    var d5 = document.getElementById("d5");
    var d6 = document.getElementById("d6");
    var d7 = document.getElementById("d7");
    ad.draw(d1, d2, d3, d4, d5, d6, d7);
}

</script>

<body <%=(leave)?"style='background-color:#f0f0f0'":""%> onload="init()">
<blockquote>
<b><%=(leave)?"離校學生":(newstudent)?"新生":""%></b>
<form name=f1>
<input type="hidden" name="id" value="<%=s.getId()%>">
  <table width="500" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    StudentID
                </td>
                <td>
<%
    if (s.getStudentID()>0) { 
%>
                    <input type=text size=8 name="StudentIDX" value="<%=s.getStudentID()%>" disabled> (chancery id)
                    <input type=hidden name="StudentID" value="<%=s.getStudentID()%>">
<%
    }
    else {
%>
                    <input type=text size=8 name="StudentID" value=""> (chancery id)
<%
    }
%>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Student Name
                </td>
                <td>
                    LN:
                    <input type=text size=10 name="StudentSurname" value="<%=s.getStudentSurname()%>">
                    FN:
                    <input type=text size=15 name="StudentFirstName" value="<%=s.getStudentFirstName()%>">
                    CN:
                    <input type=text size=10 name="StudentChineseName" value="<%=s.getStudentChineseName()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Campus
                </td>
                <td>
                    <%=drawCampus(mycampus)%>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Grade
                </td>
                <td>
                    <%=drawGrade(s)%>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff align=left>
                <td bgcolor=f0f0f0>
                    CoopAcct#: 
                </td>
                <td>
                    <input type=text name="CoopID" value="<%=s.getCoopID()%>" size=7>
                    &nbsp;&nbsp;&nbsp;TDisc: <input type=text name="TDisc" value="<%=s.getTDisc()%>" size=3>
                    &nbsp;&nbsp;&nbsp;ArcID: <input type=text name="ArcID" value="<%=s.getArcID()%>" size=10>&nbsp;&nbsp;
                </td>
            </tr>


            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    <font color=red>*</font>BirthDate
                </td>
                <td>
                    <input type=text size=10 name="BirthDate" value="<%=s.getBirthDate()%>">
                    ex: 2000/08/25
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    Passport
                </td>
                <td>
                    <table>
                    <tr>
                      <td> Number </td>
                      <td> <input type=text size=10 name="PassportNumber" value="<%=s.getPassportNumber()%>"> </td>
                    </tr>
                    <tr>
                      <td> Country </td>
                      <td> <input type=text size=10 name="PassportCountry" value="<%=s.getPassportCountry()%>"> </td>
                    </tr>
                    </table>
                
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Gender
                </td>
                <td>
                    <%=drawGender(s.getSex())%>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    差會
                </td>
                <td>
                    <input type=text size=10 name="sponser" value="<%=(s.getSponser()==null)?"":s.getSponser()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    BillTo
                </td>
                <td>
                    <input type=text size=10 name="BillTo" value="<%=(s.getBillTo()==null)?"":s.getBillTo()%>">

                    BillAttention
                    <input type=text size=10 name="BillAttention" value="<%=(s.getBillAttention()==null)?"":s.getBillAttention()%>">
                </td>
            </tr>


            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    HomePhone
                </td>
                <td nowrap>
                    <input type=text size=8 name="HomePhone" value="<%=s.getHomePhone()%>">
                    &nbsp;&nbsp;
                    Fax:
                    <input type=text size=8 name="Fax" value="<%=s.getFax()%>">
                    OfficePhone:
                    <input type=text size=8 name="OfficePhone" value="<%=s.getOfficePhone()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap rowspan=3>
                    Father
                </td>
                <td nowrap>
                    LN:
                    <input type=text size=10 name="FatherSurname" value="<%=s.getFatherSurname()%>">
                    FN:
                    <input type=text size=15 name="FatherFirstName" value="<%=s.getFatherFirstName()%>">
                    CN: 
                    <input type=text size=10 name="FatherChineseName" value="<%=s.getFatherChineseName()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Phone:
                    <input type=text size=10 name="FatherPhone" value="<%=s.getFatherPhone()%>">
                    Cell:
                    <input type=text size=15 name="FatherCell" value="<%=s.getFatherCell()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Email: 
                    <input type=text size=30 name="FatherEmail" value="<%=s.getFatherEmail()%>">
                </td>
            </tr>


            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap rowspan=3>
                    Mother
                </td>
                <td nowrap>
                    LN:
                    <input type=text size=10 name="MotherSurname" value="<%=s.getMotherSurname()%>">
                    FN:
                    <input type=text size=15 name="MotherFirstName" value="<%=s.getMotherFirstName()%>">
                    CN: 
                    <input type=text size=10 name="MotherChineseName" value="<%=s.getMotherChineseName()%>">
                </td>
            </tr>


            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Phone:
                    <input type=text size=10 name="MotherPhone" value="<%=s.getMotherPhone()%>">
                    Cell:
                    <input type=text size=15 name="MotherCell" value="<%=s.getMotherCell()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Email: 
                    <input type=text size=30 name="MotherEmail" value="<%=s.getMotherEmail()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    Home Address
                </td>
                <td nowrap>
                    <table>
                    <tr>
                      <td> Country </td>
                      <td><span id="d1"></span></td>
                    </tr>
                    <tr>
                      <td> County </td>
                      <td><span id="d2"></span></td>
                    </tr>
                    <tr>
                      <td> City </td>
                      <td><span id="d3"></span></td>
                    </tr>
                    <tr>
                      <td> District </td>
                      <td><span id="d4"></span></td>
                    </tr>
                    <tr>
                      <td> Eng. Street </td>
                      <td><span id="d6"></span></td>
                    </tr>
                    <tr>
                      <td> Chinese Street </td>
                      <td><span id="d5"></span></td>
                    </tr>
                    <tr>
                      <td> PostalCode </td>
                      <td><span id="d7"></span></td>
                    </tr>
                    </table>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    Notes
                </td>
                <td nowrap>
                    <textarea name="notes" rows=4 cols=40><%=notes%></textarea>
                </td>
            </tr>

            <tr>
                <td colspan=2 bgcolor="#FFFFFF">
                    <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width=90% bgcolor=ffffff valign=bottom align=middle>
<%
    if (!create) { %>
                            <input type=button value="儲存" onclick="do_save();">
<%  } else { %>
                            <input type=button value="新增" onclick="do_create();">
<%  } %>
                        </td>
                        <td width=10% nowrap>
<%
    if (s.getStudentID()>0) {
        if (!create) {
            if (!leave && !newstudent) { %>
                            <input type=button value="離校" onclick="do_leave();">
<%          } else { %>
                            <input type=button value="<%=(newstudent)?"入校":"回校"%>" onclick="do_back();">
<%          }  %>
        <input type=button value="轉校" onclick="do_transfer();">
<%
        }
    }

    if (newstudent) {
                        %> <input type=button value="刪除" onclick="do_delete(<%=s.getId()%>);"><%
    }
%>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
    </tr>
</table>
</form>
</blockquote>
</body>