<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    public String getCheckboxes(Vector<Tag> tv, Map<Integer/*tagId*/, Vector<TagMembr>> tm) {
        if (tv==null)
            return "";
        String ret = "<table><tr class=es02>";
        for (int i=0; i<tv.size(); i++) {

            if(i>0 && i%3==0)
                ret+="<tr class=es02>";

            ret += "<td>";    
            ret += "<input type=checkbox name='tagId' value='"+tv.get(i).getId()+"'";
            if (tm.get(tv.get(i).getId())!=null)
                ret += "checked";
            ret += ">" + tv.get(i).getName();
            
            ret += "</td>";

            if(i>0 && i%3==2)
                ret+="</tr>";
        }
        ret += "</table>";
        return ret;
    }
%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
    EzCountingService ezsvc = EzCountingService.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 

    if (stu==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    Membr membr = MembrMgr.getInstance().find("surrogateId=" + stu.getId() + " and type=" + Membr.TYPE_STUDENT);
    Map<Integer/*tagId*/, Vector<TagMembr>> tagmembrMap = new SortingMap(TagMembrMgr.getInstance().
        retrieveList("membrId=" + membr.getId(), "")).doSort("getTagId");
%>	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
&nbsp;&nbsp;&nbsp;<%=(pd2.getCustomerType()==0)?"學　生":"客  戶"%>:<font color=blue><b><%=stu.getStudentName()%></b></font> -<img src="pic/fix.gif" border=0><%=(pd2.getCustomerType()==0)?"就學狀態":"狀態設定"%><br><br>
&nbsp;&nbsp;&nbsp;<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料 |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a> | 
<%=(pd2.getCustomerType()==0)?"就學狀態":"狀態設定"%>|

<%
    if(pd2.getMembrService()==1){
%>
<a href="addClientService.jsp?studentId=<%=stu.getId()%>">新增客服</a>|
<a href="listClientServiceById.jsp?studentId=<%=stu.getId()%>">客服列表</a>|
<%  }   %>

<%  if(pd2.getCustomerType()==0){   %> 
    <a href="studentStuff.jsp?studentId=<%=stu.getId()%>">學用品規格</a> |
    <!-- <a href="studentTadent.jsp?studentId=<%=stu.getId()%>">才藝班紀錄</a> | -->
    <a href="studentSuggest.jsp?studentId=<%=stu.getId()%>">電訪/反應事項</a> |
    <a href="studentVisit.jsp?studentId=<%=stu.getId()%>">入學資訊</a>
<%  }   %>
  <br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<center>

<form action="studentStatus2.jsp" method=post name="xs">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
<%
   if(checkAuth(ud2,authHa,602))
   {
%>
    <tr bgcolor=#ffffff align=left valign=middle><td colspan=3><center><input type=submit onClick="return(confirm('確認修改此筆資料?'))" value="確認修改"></center></td></tr>
<%
    }

    int status=stu.getStudentStatus();
    if(pd2.getCustomerType()==0){
%>

<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02 width=30%>目前狀態</td>
	<td colspan=2 class=es02>
			<table border=0 class=es02>

            <% 

            if(status <3)
            {
			%>
					<tr> 
						<td bgcolor=f0f0f0>
							<font color=blue>潛在學生:</font>
							<input type=radio name="studentStatus" value=1 <%=(status==1)?"checked":""%>>參觀登記/上網登入
							<input type=radio name="studentStatus" value=2 <%=(status==2)?"checked":""%>>報名/等待入學
						</tD>
						<td>
						<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=5',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>
					</tr>
			<%
				}
			%>


				<tr>
						<td bgcolor=f0f0f0><font color=blue>就&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;讀:</font>
							<input type=radio name="studentStatus" value=3  <%=(status==3)?"checked":""%>>試讀
							<input type=radio name="studentStatus" value=4  <%=(status==4)?"checked":""%>>入學
						</td>
						<td>
								<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=6',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>
				</tr>


			<%
				if(status >3)
				{
			%>
				<tr>
						<td bgcolor=f0f0f0><font color=blue>離&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;校:</font>
							<input type=radio name="studentStatus" value=97 <%=(status==97)?"checked":""%>>中途離校
							<input type=radio name="studentStatus" value=99 <%=(status==99)?"checked":""%>>畢業
							<%
								if(status==98)
								{
							%>
								<input type=radio name="studentStatus" value=98 <%=(status==98)?"checked":""%>>未入學
							<%
								}
							%>

						</td>
						<td>
							<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=10',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>
				</tr>

			<%
				}else{
			%>
					<tr>
						<td bgcolor=f0f0f0><font color=blue>離&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;校:</font>
							<input type=radio name="studentStatus" value=98 <%=(status==98)?"checked":""%>>未入學
						</td>
                        <td>
							<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=10',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
						</td>

					</tr>
			<%
				}
			%>
            
            </table>
	</td>
</tr>
<%
    }else{
%>
<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02 width=30%>目前狀態</td>
	<td colspan=2 class=es02>
        <input type=radio name="studentStatus" value=1 <%=(status==1)?"checked":""%>>潛在客戶
        <input type=radio name="studentStatus" value=4 <%=(status==4)?"checked":""%>>正式客戶
        <input type=radio name="studentStatus" value=97 <%=(status==97)?"checked":""%>>無合作
    </td>
</tr>
<%  }   %>

  <%
        ArrayList<TagType> tagtypes = TagTypeMgr.getInstance().retrieveListX("", "", _ws2.getStudentBunitSpace("bunitId"));
        TagHelper th = TagHelper.getInstance(pd2, 0, _ws2.getSessionStudentBunitId());
        ArrayList<Tag> tags = th.getTags(false, "", _ws2.getStudentBunitSpace("bunitId"));
        // tagtype Id
        Map<Integer, Vector<Tag>> tagMap = new SortingMap(tags).doSort("getTypeId");
        
        Iterator<TagType> titer = tagtypes.iterator();
        while (titer.hasNext()) {
            TagType tt = titer.next(); 
  %>
    
        <tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02><%=tt.getName()%></td>
            <td colspan=2 class=es02> 
                    <%
                    Vector<Tag> tv = tagMap.get(tt.getId());
                    out.println(getCheckboxes(tv, tagmembrMap));
                    %>
                <br>
            </td>
        </tr>    
      <%}%>

	    
<tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>未定的標籤</td>
    <td class=es02><% out.println(getCheckboxes(tagMap.get(0), tagmembrMap)); %></td>
</tr>

<input type=hidden name="studentPs" value="<%=stu.getStudentPs()%>">
<input type=hidden name="studentId" value="<%=stu.getId()%>">
<tr bgcolor=#ffffff align=left valign=middle><td colspan=3 class=es02 align=middle>

<%
   if(checkAuth(ud2,authHa,602))
   {
%>
<center><input type=submit onClick="return(confirm('確認修改此筆資料?'))" value="確認修改"></center>

<%
    }else{
%>
            沒有修改權限,系統代碼:602
<%  }   %>

</td></tr>

	</table>
</td></tr></table>	
</form>

</center>

<br>
<br>
<script>
    top.nowpage=3;
</script>


