<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!

    String printHrMin(int min)
    {
        if (min==0) return "";
        if (min<60)
            return min + "分";
        int hr = 0;
        hr = min/60;
        min = min%60;

        StringBuffer sb = new StringBuffer();
        if (hr>0)
            sb.append(hr+"時");
        if (min>0)
            sb.append(min+"分");
        return sb.toString();
    }
%>
<%

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");    
    SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm");
    
    String d1=request.getParameter("d1");    
    String d2=request.getParameter("d2");    
    String membrId=request.getParameter("membrId");    

    ArrayList<Overtime> overtimeArray = OvertimeMgr.getInstance().retrieveList("startDate>='" + d1 + "' and startDate<'" + d2 + "'", "");

    Map<Integer,Vector<Overtime>> overtimeMap=new SortingMap(overtimeArray).doSort("getConfirmType");
    Vector<Overtime> o=overtimeMap.get(new Integer(0));

    UserMgr um=UserMgr.getInstance();

    if(o !=null && o.size()>0){
%>
    <div class=es02>
    <b>&nbsp;&nbsp;&nbsp;補休的加班</b>
    </div>
    <blockquote>
    <table height="" border="0" cellpadding="0" cellspacing="0" width="85%">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor="#f0f0f0" class=es02>
            <td>日期</td>
            <td>時間</td>
            <td>轉換倍率</td>
            <td>轉換時間</td>
            <td>登入註記</td>
            <td>登入人</td>
            <td>覆核人</td>
            <td>覆核註記</td>
        </tr>
<%
    int totalConfirm=0;

    for(int i=0;i<o.size();i++){      

          Overtime ot=o.get(i);
%>
        <tr bgcolor="#ffffff" class=es02>
            <td><%=sdf.format(ot.getStartDate())%></td>
            <td><%=sdf2.format(ot.getStartDate())%>-<%=sdf2.format(ot.getEndDate())%></td>
            <td align=middle>
                <%
                    switch(ot.getConfirmType()){
                        case 0:
                            out.println("1.0");
                            break;
                        case 1:
                            out.println("1.2");
                            break;
                        case 2:
                            out.println("1.5");
                            break;
                    }
                %>
            </td>
            <%
                totalConfirm+=ot.getConfirmMins();
            %>
            <td align=right><%=printHrMin(ot.getConfirmMins())%></td>
            <td><%=ot.getPs()%></td>
            <td>
            <%
                if(ot.getEditUser()==0){
                    out.println("線上申請");
                }else{

                    User u=(User)um.find(ot.getEditUser());
                    if(u !=null)
                        out.println(u.getUserFullname());
                }
            %>

            </td>
            <td><%=ot.getConfirmPs()%></td>
            <td>
            <%
            User u2=(User)um.find(ot.getUserId());
            if(u2 !=null)
                out.println(u2.getUserFullname());
            %>
            </td>
        </tr>

<%
    }
%>
    <tr class=es02>
        <td colspan=3 align=middle class=es02> 小 計:</td>
        <td align=right><%=printHrMin(totalConfirm)%></td>
        <td colspan=4></td>
    </tr>
    </table>
    </td>
    </tr>
    </table>
    </blockquote>
<%  }   

    o=overtimeMap.get(new Integer(1));

    if(o !=null && o.size()>0){
%>
    <div class=es02>
    <b>&nbsp;&nbsp;&nbsp;轉換薪資的加班</b>
    </div>
    <blockquote>
    <table height="" border="0" cellpadding="0" cellspacing="0" width="85%">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor="#f0f0f0" class=es02>
            <td>日期</td>
            <td>時間</td>
            <td>轉換倍率</td>
            <td>轉換時間</td>
            <td>登入註記</td>
            <td>登入人</td>
            <td>覆核人</td>
            <td>覆核註記</td>
        </tr>
<%
    for(int i=0;i<o.size();i++){      

          Overtime ot=o.get(i);
%>
        <tr bgcolor="#ffffff" class=es02>
            <td><%=sdf.format(ot.getStartDate())%></td>
            <td><%=sdf2.format(ot.getStartDate())%>-<%=sdf2.format(ot.getEndDate())%></td>
            <td>
                <%
                    switch(ot.getConfirmType()){
                        case 0:
                            out.println("1.0");
                            break;
                        case 1:
                            out.println("1.2");
                            break;
                        case 2:
                            out.println("1.5");
                            break;
                    }
                %>
            </td>
            <td><%=ot.getConfirmMins()%> 分鐘</td>
            <td><%=ot.getPs()%></td>
            <td>
            <%
                if(ot.getEditUser()==0){
                    out.println("線上申請");
                }else{

                    User u=(User)um.find(ot.getEditUser());
                    if(u !=null)
                        out.println(u.getUserFullname());
                }
            %>

            </td>
            <td><%=ot.getConfirmPs()%></td>
            <td>
            <%
            User u2=(User)um.find(ot.getUserId());
            if(u2 !=null)
                out.println(u2.getUserFullname());
            %>
            </td>
        </tr>

<%
    }
%>
    </table>
    </td>
    </tr>
    </table>
    </blockquote>
<%  }   %>
