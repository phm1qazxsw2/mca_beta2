<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%!
    public String drawHeader(ArrayList<Tag> alltags)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("    <td align=middle width=60>");
        sb.append("        學生姓名");
        sb.append("    </td>");
        sb.append("    <td align=middle>");
        sb.append("        狀態設定");
        sb.append("    </td>");

        Iterator<Tag> iter = alltags.iterator();
        int k = 0;
        while (iter.hasNext()) {
            if ((k%10)==9)
                sb.append("<td></td>");
            k ++;

            Tag tag = iter.next();
            sb.append("    <td align=middle width=50>");
            sb.append(tag.getName());
            sb.append("    </td>");

        }
		sb.append("</tr>");
        return sb.toString();
    }

    public String drawFooter(ArrayList<Tag> alltags)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("    <td align=middle width=60>");
        sb.append("    </td>");
        sb.append("    <td align=middle>");
        sb.append("    </td>");

        Iterator<Tag> iter = alltags.iterator();
        int k = 0;
        while (iter.hasNext()) {
            if ((k%10)==9)
                sb.append("<td></td>");
            k ++;

            Tag tag = iter.next();
            sb.append("    <td align=middle width=50>全選");
            sb.append("<input type=checkbox onclick=\"do_all(this,"+tag.getId()+")\"");
            sb.append("    </td>");

        }
		sb.append("</tr>");
        return sb.toString();
    }

%>
<%
    int topMenu=4;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
if(!checkAuth(ud2,authHa,602))
{
    response.sendRedirect("authIndex.jsp?code=602");
}
%>
<%@ include file="leftMenu4.jsp"%>
<%@ include file="tag_selection.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%


String modidied=request.getParameter("m");

if(modidied !=null){
%>
<script>
    alert('修改完成!');
</script>

<%
}

String ttIdS=request.getParameter("ttId");

int ttId=0;
try { ttId = Integer.parseInt(ttIdS); } catch (Exception e) {}

JsfAdmin ja=JsfAdmin.getInstance();

ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws.getStudentBunitSpace("bunitId"));
TagHelper thelper = TagHelper.getInstance(pZ2, 0, _ws.getSessionStudentBunitId());
ArrayList<Tag> all_tags = thelper.getTags(false, "", _ws.getStudentBunitSpace("bunitId"));

Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

int status=2;
try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception e) {}
%>

<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}
//  End -->

</script>
<script>
    function do_all(ch, tagId)
    {
        for (var i=0; i<document.f1.elements.length; i++)
        {
            var e = document.f1.elements[i];
            if (e.name.indexOf("tm_")>=0 && e.value==tagId)
                e.checked = ch.checked;
        }
    }
</script>
</head>


<br>
<div class=es02>
 <b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/tagtype.png" border=0>&nbsp;進階<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>標籤設定</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="studentoverview.jsp"><img src="pic/last.gif" border=0>&nbsp回上一頁</a>
</div>
<blockquote>
<form action="modify_student_tag.jsp" method="get">
<div class=es02>
    <% // ############# 搜尋選單 ############### %>
    <table border=0 cellpadding=0 cellspacing=0><tr><td nowrap>

    <B>編輯名單:</B> 狀態
    <select name="status">
        <option value="999" <%=(status==999)?"selected":""%>>全部</option>
        <option value="1" <%=(status==1)?"selected":""%>>潛在<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%></option>
        <option value="2" <%=(status==2)?"selected":""%>><%=(pZ2.getCustomerType()==0)?"就讀學生":"合作客戶"%></option>
        <%    if(pZ2.getCustomerType()==0){   %>
        <option value="3" <%=(status==3)?"selected":""%>>離校學生-畢業校友</option>
        <option value="4" <%=(status==4)?"selected":""%>>離校學生-中途離校</option>    
        <option value="5" <%=(status==5)?"selected":""%>>離校學生-未入學</option>    
        <%  }else{  %>
        <option value="4" <%=(status==4)?"selected":""%>>無合作客戶</option>    
        <%  }   %>
    </select>
<%
    Iterator<TagType> ttiter2 = all_tagtypes.iterator();
%>
    <br>
    <b>編輯標籤類型:</b>
    <select name="ttId">
        <option value="0" <%=(ttId==0)?"selected":""%>>全部</option>        
<%    
    while (ttiter2.hasNext()) {
        TagType tt = ttiter2.next();
%>
        <option value="<%=tt.getId()%>" <%=(ttId==tt.getId())?"selected":""%>><%=tt.getName()%></option>
<%
    }
%>
    </select>
	<input type=submit value="查詢">

    </td>
    <td><img src="images/spacer.gif" width=20></td>
    <td valign=top nowrap>
        <%@ include file="tag_selection_body.jsp"%>
    </td></tr></table>
    <% // ###################################### %>
</div>
</form>
</blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm('membrtag_add.jsp','建立新的標籤',300,300,true);"><img src="pic/add.gif" border=0>&nbsp;建立新的標籤</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
 <%

    EzCountingService ezsvc = EzCountingService.getInstance();
    String statusStr ="";
    switch(status){
        case 1:
            statusStr="studentStatus in (1,2)"; 
            break;
        case 2:
            statusStr="studentStatus in (3,4)"; 
            break;
        case 3:
            statusStr="studentStatus in (99)"; 
            break;
        case 4:
            statusStr="studentStatus in (97)"; 
            break;
        case 5:
            statusStr="studentStatus in (98)"; 
            break;
    }

    Student[] st = ezsvc.searchStudent("", studentIds, 1, statusStr, _ws.getStudentBunitSpace("bunitId"));
	if(st==null)
	{
%>
    <br>
    <blockquote>

        <div class=es02>開始查詢!</font>

    </blockquote>

<br>
<%@ include file="bottom.jsp"%>	
<%	
	return;
}
    String query="";
    if(ttId !=0 )
        query="typeId='"+ttId+"'";

    // 全部的 tagmembrstudent 入學沒入學的都抓出來
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().retrieveListX("","", _ws.getStudentBunitSpace("membr.bunitId"));
    Map<String,Vector<TagMembrStudent>> membrtagMap = new SortingMap(tagstudents).doSort("getMembrTagKey");
    ArrayList<Tag> alltags = thelper.getTags(false, query, _ws.getStudentBunitSpace("bunitId"));
    Map<Integer, Vector<Membr>> studentMap = new SortingMap(MembrMgr.getInstance(). 
        retrieveListX("","",_ws.getStudentBunitSpace("bunitId"))).doSort("getSurrogateId");
    Iterator<Tag> iter = alltags.iterator();
%>


<center>
<form action="modify_student_tag2.jsp" method="post" name="f1">
<center>
        <input type=hidden name="status" value="<%=status%>">
        <input type=hidden name="ttId" value="<%=ttIdS%>">
<%
    for (int i=0; tagIds!=null && i<tagIds.length; i++) {
      %><input type=hidden name="tag" value="<%=tagIds[i]%>"><%
    }
    if (_taginfos!=null) {
      %><input type=hidden name="_taginfos" value="<%=phm.util.TextUtil.encodeHtml(_taginfos)%>"><%
    }
%>
        <input type=submit value="確認儲存">
&nbsp;&nbsp;<table width="" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
		<table width="100%" border=0 cellpadding=4 cellspacing=1>        
<%
for(int i=0;i<st.length;i++)
{
System.out.println("## 1");
    Membr membr = studentMap.get(new Integer(st[i].getId())).get(0);
System.out.println("## 2");
  %><input type=hidden name="mid" value="<%=membr.getId()%>"><%
    if ((i%7)==0)
        out.println(drawHeader(alltags));
%>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td width=60 class=es02>
                <a href="javascript:openwindow15('<%=st[i].getId()%>');"><%=st[i].getStudentName()%></a>
            </td>
            <td class=es02 nowrap>
            <% 
            int status2=st[i].getStudentStatus();
            if(status2 <=3)
            {
			%>
                <input type=radio name="status_<%=membr.getId()%>" value=1 <%=(status2==1)?"checked":""%>>參觀登記/上網登入
				<input type=radio name="status_<%=membr.getId()%>" value=2 <%=(status2==2)?"checked":""%>>報名/等待入學<br>
                <input type=radio name="status_<%=membr.getId()%>" value=3  <%=(status2==3)?"checked":""%>>試讀

            <%  }   
            %>
                <input type=radio name="status_<%=membr.getId()%>" value=4  <%=(status2==4)?"checked":""%>><%=(pZ2.getCustomerType()==0)?"就學":"合作"%>
            <%
				if(status2 >=4)
				{
                    if(pZ2.getCustomerType()==0){
			%>
                <input type=radio name="status_<%=membr.getId()%>" value="99" <%=(status2==99)?"checked":""%>>畢業    
                <input type=radio name="status_<%=membr.getId()%>" value=97 <%=(status2==97)?"checked":""%>>離校
            <%
                    }else{
            %>
                <input type=radio name="status_<%=membr.getId()%>" value=97 <%=(status2==97)?"checked":""%>>無合作
            <%                        
                    }

                }   %>

            <%
				if(status2==98)
				{
			%>
                <input type=radio name="status_<%=membr.getId()%>" value=98 <%=(status2==98)?"checked":""%>>未入學    
            <%  }   %>

            </td>
            <%
            iter = alltags.iterator();    
            int k = 0;
            while (iter.hasNext()) {
                if ((k%10)==9)
                    out.println("<td>" + st[i].getStudentName() + "</td>");
                k ++;
                Tag tag = iter.next(); 
                Vector<TagMembrStudent> vt = membrtagMap.get(membr.getId()+"#"+tag.getId());
        %>
                <td align=middle class=es02>
                <input type=hidden name="key_<%=membr.getId()%>#<%=tag.getId()%>" value="1">
                <% if (vt!=null) { %>
                    <input type=checkbox name="tm_<%=membr.getId()%>" value="<%=tag.getId()%>" checked>
                <% } else { %>
                    <input type=checkbox name="tm_<%=membr.getId()%>" value="<%=tag.getId()%>">
                <% } %>
                </td>
            <%   
            }
            %>
        </tr>
<%
}
        out.println(drawFooter(alltags));

%>
        </table>
 
	</td>
	</tr>
	</table>

<center>
        <input type=hidden name="ttId" value="<%=ttId%>">
        <input type=submit value="確認儲存">
        </form>
    </center>
    <br>
    <br>

<%@ include file="bottom.jsp"%>