<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,603))
    {
        response.sendRedirect("authIndex.jsp?code=603");
    } 
%>
<%@ include file="leftMenu4.jsp"%>
<%@ include file="tag_selection.jsp"%>
<%
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveListX("","order by typeId asc", _ws.getStudentBunitSpace("bunitId"));

    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveList("studentStatus in (3,4)","");
    Map<Integer,Vector<TagMembrStudent>> m = new SortingMap(tagstudents).doSort("getTagId");
    Iterator<Tag> iter = tags.iterator();    

    int tagId=-1;
    String tagIdS=request.getParameter("tagId");
    if(tagIdS !=null)
    {
        try{  tagId=Integer.parseInt(tagIdS); }catch(Exception ex){}
    }    
    
    EzCountingService ezsvc = EzCountingService.getInstance();
    String statusStr ="studentStatus in (3,4)";

    String[] tags2=request.getParameterValues("tagId");
    Student[] stall = ezsvc.searchStudent("", studentIds, 0,statusStr, _ws.getStudentBunitSpace("bunitId"));

%>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/mobile.gif" border=0>&nbsp;<b>發送簡訊：</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=ffffff class=es02>
            <td bgcolor=f0f0f0 width=100>
                搜尋標籤:
            </td>
            <td>
                <select name="tagId" size=1 onChange="goCheck(this.value)">
                <option value="-1" <%=(tagId==-1)?"selected":""%>>請選擇標籤</option>
                <%  if(stall !=null){ %>
                <option value="-2" <%=(tagId==-2)?"selected":""%>>全部名單-<%=stall.length%>筆</option>    
            <%
                }
                while (iter.hasNext()) {
                    Tag tag = iter.next();
                    Vector<TagMembrStudent> v = m.get(new Integer(tag.getId()));
                    int size = (v==null)?0:v.size();
                %>
                    <option value="<%=tag.getId()%>" <%=(tagId==tag.getId())?"selected":""%>><%=tag.getName()%>-<%=size%>筆</option> 
                <%
                }
                Vector<TagMembrStudent> v3 = m.get(new Integer(0));
                if(v3 !=null && v3.size()>0){
                %>
                    <option value="0" <%=(tagId==0)?"selected":""%>>未定標籤-<%=v3.size()%>筆</option>      

                <%  }   %>
                </select>
            </tD>
        </tr>
<form name="f2" action="sendGroupMessage2.jsp" onsubmit="return check();">
        <tr bgcolor=ffffff class=es02>
            <td bgcolor=f0f0f0 valign=middle>發送名單
               
                <%  if(tagId!=-1){  %> <br><br>
                <input type=checkbox name="checkall" onclick="check_all(this)"> 全選
                <%  }   %>
            </td>
            <td>
                <%
                if(tagId==-1)
                {
                    out.println("請點選上面的群組");
                }else if(tagId==-2){
                    
                    if(stall==null){
                        out.println("本標籤沒有名單");
                    }else{
                        int j = 0;
                        int k=0;            
                        out.println("<table>");
                        for(int i=0;i<stall.length;i++)
                        {
                            if ((j%6)==0)
                            {
                                k++;
                                if((k%2)==1)
                                    out.println("<tr bgcolor=#f2f2f2>");
                                else
                                    out.println("<tr bgcolor=#ffffff>");    
                            }
                            out.println("<td width='16%'>");
                            out.println("<input type=checkbox name='target' value='" + stall[i].getId() + "'>");
                            out.println(stall[i].getStudentName() + "</td>");
                            if ((j%6)==5)
                                out.println("</tr>");
                            j++;
                        }
                        out.println("</table>");

                    }
                }else{
                    Vector<TagMembrStudent> v2 = m.get(new Integer(tagId));
                    if(v2==null){
                        out.println("本標籤沒有名單");
                    }else{
                        int j = 0;
                        int k=0;            
                        out.println("<table>");
                        for(int i=0;i<v2.size();i++)
                        {
                            TagMembrStudent s=(TagMembrStudent)v2.get(i);
                             if ((j%6)==0)
                            {
                                k++;
                                if((k%2)==1)
                                    out.println("<tr bgcolor=#f2f2f2 class=es02>");
                                else
                                    out.println("<tr bgcolor=#ffffff class=es02>");    
                            }
                            out.println("<td width='16%'>");
                            out.println("<input type=checkbox name='target' value='" + s.getStudentId() + "'>");
                            out.println(s.getMembrName() + "</td>");
                            if ((j%6)==5)
                                out.println("</tr>");
                            j++;
                        }
                        out.println("</table>");
                    }
                }
                %>
            </td>
        </tr>
<%    
    if(tagId!=-1)
    {
%>  
      <tr bgcolor=ffffff class=es02>
            <td bgcolor=f0f0f0>發送對象</td>
            <td>
                <input type=radio name="snedTo" value="1">預設聯絡人
                <input type=radio name="snedTo" value="2" checked><%=(pZ2.getCustomerType()==0)?"雙 親":"負責人及聯絡人"%>
            </td>
        </tr>
        <tr bgcolor=ffffff class=es02>
            <td bgcolor=f0f0f0>發送內容</td>
            <td>
                <textarea rows=3 cols=40 name="sendContent"></textarea>
                <br>
                說明1: 請以 xxx 代替學生姓名,系統將自動轉換. <BR>
                說明2:一則簡訊的中文字數限制為70字.
            </td>
        </tr>
        <tr>
            <td colspan=2 align=middle>
                <input type=submit value="預覽發送名單">
            </td>
        </tr>
<%  }   %>
    </table>
    </td>
    </tr>
    </table>
</form>
    </center>

<script>
function check()
{
    if (typeof document.f2.target=='undefined') {
        alert("沒有選則任何項目");
        return false;
    }
    if (typeof document.f2.target.length=='undefined') {
     if (!document.f2.target.checked) {
            alert("沒有選則任何項目");
            return false;
        }
    }
    else {
        for (var i=0; i<document.f2.target.length; i++) {
            if (document.f2.target[i].checked)
                return true;
        }
        alert("沒有選則任何項目");
        return false;
    }
}

function check_all(c) {
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined')
            target.checked = c.checked;
        else {
            for (var i=0; i<target.length; i++) {
                target[i].checked = c.checked;
            }
        }
    }
}
    function goCheck(tagId)
    {
        window.location="sendGroupMessage.jsp?tagId="+tagId;
    }
</script>

<%@ include file="bottom.jsp"%>