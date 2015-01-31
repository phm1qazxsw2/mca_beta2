<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    int eId=Integer.parseInt(request.getParameter("eId"));
    
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");

    Entry en=emgr.find("id="+eId);
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("HH:mm:ss");

    Calendar c = Calendar.getInstance();
    c.setTime(en.getCreated());
    c.add(Calendar.DATE, 1);
    Date nextDay = c.getTime();


    int membrId=Integer.parseInt(request.getParameter("membrId"));
        // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf.format(en.getCreated()) + "' and created<'" + sdf.format(nextDay) + "' and membrId='"+membrId+"'", " order by created");    



%>

<div class=es02><b>&nbsp;&nbsp;&nbsp;刷卡記錄修改</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

    <center>
    <form action="modifyCardReader2.jsp" method="post">
        <table height="" border="0" cellpadding="0" cellspacing="0" width=95%>
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
                <td>刷卡日期</td>
                <td bgcolor=#ffffff>
                    <%=sdf.format(en.getCreated())%>
                    <input type=hidden name="date1" value="<%=sdf.format(en.getCreated())%>">
                </tD>
            </tr>
            <tr bgcolor=#f0f0f0 class=es02>
                <td>刷卡時間</td>
                <td bgcolor=#ffffff>
                    <input type=text name="date2" value="<%=sdf2.format(en.getCreated())%>" size=6>
                    登入人: <%
                    UserMgr um=UserMgr.getInstance();
                    User u=(User)um.find(en.getDatauser());
                    if(u !=null)
                        out.println(u.getUserFullname());%>
                </tD>
            </tr>

        <tr bgcolor=#ffffff class=es02>
            <td bgcolor=#f0f0f0>註記</td>
            <td>
            <%
                if(pss==null || pss.size()<=0){
            %>
                    <textarea name="pssText" rows=3 cols=40></textarea>
                    <input type=hidden name="pssId" value="0">
            <%
                }else{
                    Entryps ps=(Entryps)pss.get(0);
            %>
                    <textarea name="pssText" rows=3 cols=30><%=(ps.getPs()!=null)?ps.getPs():""%></textarea>
                    <br>
                    <%
                        User ux=(User)um.find(ps.getUserId());
                        if(ux != null)
                            out.println(ux.getUserFullname()+"-");
                        else
                            out.println("線上自行登入-");
                            
                        if(ps.getModifyDate()!=null)
                            out.println(sdf.format(ps.getModifyDate()));
                    %>
                    <input type=hidden name="pssId" value="<%=ps.getId()%>">

            <%  }   %>
                    <input type=hidden name="membrId" value="<%=membrId%>">
                    </tD>
                </tr>


            <tr class=es02 bgcolor=ffffff>
                <td colspan=2 align=middle>
                    <input type=hidden name="eId" value="<%=eId%>">
                    <input type=submit value="修改">
                </td>
            </tr>
        </table>
        </td>
        </tr>
        </table>
    </form>
    </center>