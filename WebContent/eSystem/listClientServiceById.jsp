<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("MM/dd HH:mm");
	JsfAdmin ja=JsfAdmin.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId); 
	Classes[] cl=ja.getAllActiveClasses();

    int serviceId=0;
    MembrServiceMgr csm=MembrServiceMgr.getInstance();
    Membr mem=MembrMgr.getInstance().find("type='"+Membr.TYPE_STUDENT+"' and surrogateId='"+stu.getId()+"'");
%>	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>

<script>
function check(f)
{
    if (f.studentName.value.length==0) {
        alert("請輸入名字");
        f.studentName.focus();
        return false;
    }
    if (!confirm('確認修改此筆資料?')) {
        return false;
    }
    return true;
}
</script>
&nbsp;&nbsp;&nbsp;<%=(pd2.getCustomerType()==0)?"學　生":"客  戶"%>:<b><font color=blue><%=stu.getStudentName()%></font></b> -客服列表

<br><br>
&nbsp;&nbsp;&nbsp;
<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料</a> |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a> | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>"><%=(pd2.getCustomerType()==0)?"就學狀態":"狀態設定"%></a>|
<%    if(serviceId==0){ %>
    <a href="addClientService.jsp?studentId=<%=stu.getId()%>">新增客服</a> |
<%  }else{  %>
<a href="addClientService.jsp?studentId=<%=stu.getId()%>">新增客服</a> | 編輯客服 |    
<%  }   %> 
        客服列表
  <br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    int orderX=1;
    String orderx=request.getParameter("order");
    if(orderx !=null)
        orderX=Integer.parseInt(orderx);

    ArrayList<MembrService> msa=MembrServiceMgr.getInstance().retrieveList("clientServiceMembrId='"+mem.getId()+"'","order by clientservicedate desc");


    if(msa ==null)
    {
%>
        <blockquote>
            <div class=es02>
                目前沒有客服資料
            </div>
        </blockquote>
<%
        return;
    }
    SimpleDateFormat sdf=new SimpleDateFormat("MM/dd HH:mm");
    UserMgr umm=UserMgr.getInstance();

    MessageTypeMgr mtm=MessageTypeMgr.getInstance();
%>
<br>

<center>
<table width="98%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=f0f0f0 align=left valign=middle>
            <td>
                ID
            </tD>
            <td nowrap>
            <%=(orderX==1)?"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=2\">日期↑</a>":"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=1\">日期↓</a>"%>
            </tD>
            <tD nowrap>
            <%=(orderX==5)?"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=6\">狀態↑</a>":"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=5\">狀態↓</a>"%>
</td><td nowrap>
            <%=(orderX==7)?"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=8\">重要性↑</a>":"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=7\">重要性↓</a>"%>

</td><td nowrap>主旨</td><td nowrap>
<%=(orderX==3)?"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=4\">作業人↑</a>":"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=3\">作業人↓</a>"%>
</td><td nowrap>
<%=(orderX==9)?"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=10\">登入人↑</a>":"<a href=\"listClientServiceById.jsp?studentId="+studentId+"&order=9\">登入人↓</a>"%>
</td><TD></TD>
        </tr>
    <%
        for(int i=0;i<msa.size();i++){

            MembrService cs=msa.get(i);
    %>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02 align=left><b><%=cs.getId()%></b></tD>            
            <td class=es02><%=sdf.format(cs.getClientServiceDate())%></tD>
            <td class=es02>
                <%
                    switch(cs.getClientServiceStatus()){
                        case 1:
                            out.println("新開");
                            break;
                        case 2:
                            out.println("<font color=blue>作業中</font>");
                            break;
                        case 3:
                            out.println("<font color=blue>支援</font>");
                            break;
                        case 9:
                            out.println("結案");
                            break;
                    }
                %>
            <td class=es02>
            <%
                    switch(cs.getClientServiceStar()){
                        case 1:
                            out.println("普通");
                            break;
                        case 2:
                            out.println("重要");
                            break;
                        case 3:
                            out.println("<font color=blue>很重要</font>");
                            break;
                        case 4:
                            out.println("<font color=red>十分緊急</font>");
                            break;
                    }
                %>
            </td>
            <td class=es02 align=left>
                <font color=blue>
                    <%
                    MessageType mt=(MessageType)mtm.find(cs.getClientServiceType());
                    if(mt !=null)
                        out.println(mt.getMessageTypeName());
                    
                    %>
                </font>-<%=cs.getClientServiceTitle()%>
            </td>
            <td class=es02>
            <%
                User uOp=(User)umm.find(cs.getClientServiceUserId());
                if(uOp !=null)
                    out.println(uOp.getUserFullname());
                %>
            </td>
            <td class=es02>
            <%
                User uOp2=(User)umm.find(cs.getClientServiceLogId());
                if(uOp2 !=null)
                    out.println(uOp2.getUserFullname());
                %>
            </td>
            <TD class=es02><a href="addClientService.jsp?studentId=<%=stu.getId()%>&serviceId=<%=cs.getId()%>">編輯</a></TD>
        </tr>
    <%
        }
    %>
    </table>
    </td>
    </tr>
    </table>
    </center>