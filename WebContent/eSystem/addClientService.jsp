<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*,java.text.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId); 
	Classes[] cl=ja.getAllActiveClasses();

    int serviceId=0;
    MembrServiceMgr csm=MembrServiceMgr.getInstance();
    MembrService cs=null;
    String serviceIdS=request.getParameter("serviceId");
    
    if(serviceIdS!=null)
    {
            serviceId=Integer.parseInt(serviceIdS);
            cs=(MembrService)csm.find("id='"+serviceId+"'");
    }
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
&nbsp;&nbsp;&nbsp;<%=(pd2.getCustomerType()==0)?"學　生":"客  戶"%>:<b><font color=blue><%=stu.getStudentName()%></font></b> -
<%    if(serviceId==0){ %>
    新增客服
<%  }else{  %>
    <img src="pic/fix.gif" border=0>&nbsp;編輯客服
<%  }   %>
<br><br>
&nbsp;&nbsp;&nbsp;
<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料</a> |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a> | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>"><%=(pd2.getCustomerType()==0)?"就學狀態":"狀態設定"%></a>|
<%    if(serviceId==0){ %>
    新增客服 |
<%  }else{  %>
<a href="addClientService.jsp?studentId=<%=stu.getId()%>">新增客服</a> | 編輯客服 |    
<%  }   %> 
<a href="listClientServiceById.jsp?studentId=<%=stu.getId()%>">客服列表</a>|
  <br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    Membr mem=MembrMgr.getInstance().find("type='"+Membr.TYPE_STUDENT+"' and surrogateId='"+stu.getId()+"'");
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    User[] u2=ja.getAllRunUsers(_ws2.getBunitSpace("userBunitAccounting"));
%>
<center>

<form action="addClientService2.jsp" method="post">
<div class=es02 align=right>
<a href="bill_detail2.jsp?sid=<%=mem.getId()%>&poId=-1&backurl=<%=URLEncoder.encode("serviceRecord.jsp")%>" >帳單資訊</a> 
<%
    if(stu.getStudentWeb() !=null && stu.getStudentWeb().length()>0){
%>
    | <a href="<%=stu.getStudentWeb()%>">客服連結</a>
<%  }   %>
&nbsp;&nbsp;&nbsp;
</div>

<table width="98%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>
       ID 
    </td>
        <TD class=es02>
        <b><%=(serviceId==0)?"尚未產生":serviceId%></b>&nbsp;&nbsp;
    狀態:
    <input type=radio name="clientServiceStatus" value=1 
<%=((cs!=null && cs.getClientServiceStatus()==1))?"checked":""%>>新開
            <input type=radio name="clientServiceStatus" value=2 
<%=(serviceId==0 || cs!=null && cs.getClientServiceStatus()==2)?"checked":""%>>作業中
            <input type=radio name="clientServiceStatus" value=3 <%=(cs!=null &&
cs.getClientServiceStatus()==3)?"checked":""%>>支援
            <input type=radio name="clientServiceStatus" value=9 <%=(cs!=null &&
cs.getClientServiceStatus()==9)?"checked":""%>>結案

        </TD>
    </tr>
<tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>作業資訊</td>
    <td class=es02>
            時間: <input type=text name="clientServiceDate" value="<%=(cs ==null)?sdf.format(new Date()):sdf.format(cs.getClientServiceDate())%>" size=15>
            人員:
        <%
            if(u2 ==null)
            {
        %>      
                尚未新增使用者
        <%
                return;
            }

            int defaultUserId=ud2.getId();
            
            if(cs !=null)
                defaultUserId=cs.getClientServiceUserId();
        %>
            <select name="clientServiceUserId">
                <option value=0 <%=(defaultUserId==0)?"selected":""%>>尚未決定</option>
            <%      
                for(int i=0;i<u2.length;i++)
                {
            %>
                    <option value="<%=u2[i].getId()%>" <%=(defaultUserId==u2[i].getId())?"selected":""%>><%=u2[i].getUserFullname()%></option>
            <%
                }
            %> 
            </select>

        </TD>
    </tr>
<tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>重要性</td>
        <TD class=es02>
            <input type=radio name="clientServiceStar" value="1" <%=(cs!=null &&
cs.getClientServiceStatus()==1)?"checked":""%>>普通
            <input type=radio name="clientServiceStar" value="2" <%=(serviceId==0 || (cs!=null && cs.getClientServiceStatus()==2))?"checked":""%>>重要
            <input type=radio name="clientServiceStar" value="3" <%=(cs!=null &&
cs.getClientServiceStatus()==3)?"checked":""%>>很重要
            <input type=radio name="clientServiceStar" value="4" <%=(cs!=null &&
cs.getClientServiceStatus()==4)?"checked":""%>>十分緊急
        </TD>
    </tr>
<tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>客服主旨</td>
        <Td>
        <%
            MessageType[] pla=ja.getActiveMessageType(_ws2.getBunitSpace("bunitId"));

            if(pla ==null){
        %>
                <input type=hidden name="serviceType" value="0">
        <%  }else{  %>
            <select name="serviceType">
        <%
                for(int j=0;j<pla.length;j++){
        %>
                <option value="<%=pla[j].getId()%>"><%=pla[j].getMessageTypeName()%>
        <%  
                }
        %>
            </select>
    
        <% }   %>
        <input type=text name="clientServiceTitle" size=65 value="<%=(cs !=null)?cs.getClientServiceTitle():""%>"></Td>
    </tr>
    <tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>客服內容</td>
        <Td>
            <textarea name="clientServiceContent" rows=8 cols=65><%=(cs !=null)?cs.getClientServiceContent():""%></textarea>
        </Td>
    </tr>
    
    <tr bgcolor=#ffffff align=left valign=middle>
    <td  bgcolor=#f0f0f0  class=es02>提醒</td>
        <Td>
            
        </Td>
    </tr>

    <tr bgcolor=#ffffff align=left valign=middle>
        <td  bgcolor=#ffffff  class=es02  colspan=2 align=middle>
            <input type=hidden name="stuId" value="<%=studentId%>">
            <input type=hidden name="membrServiceId" value="<%=serviceId%>">
            <input type=hidden name="memId" value="<%=mem.getId()%>">
            <input type=submit value="確認">
        </Td>
    </tr>
    </table>
        </td>
        </tr>
        </table>
</center>
<%  if(serviceId!=0){ 

        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int port = request.getServerPort(); 
        String url = scheme + "://" + serverName;
        if (scheme.equals("http") && port!=80)
            url += ":" + port;
        else if (scheme.equals("https")&&port!=443)
            url += ":" + port;
        url += request.getRequestURI();
        int urlLength=url.length();
        url=url.substring(0,(urlLength-20));
        /*
        String querystr = request.getQueryString();
        if (querystr!=null&&querystr.length()>0)
            url += "?" + querystr;
        */
%>
    &nbsp;&nbsp;&nbsp;客服編號:<%=serviceId%> &nbsp;連結網址: <%=url%>serviceIndex.jsp?sid=<%=serviceId%>
<%  }   %>
    </form>


