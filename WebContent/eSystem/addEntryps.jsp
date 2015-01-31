<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMddHHmm");

    String dString=request.getParameter("d");
    Date d=sdf3.parse(dString);

    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE, 1);
    Date nextDay = c.getTime();

    if(pd2.getPaySystemCompanyUniteId()==null || pd2.getPaySystemCompanyUniteId().length()<=0){
%>
        <script>
            alert('登入失敗: 系統需設立辨識ID,請洽客服人員.');
        </script>
<%
        return;
    }

    int membrId=Integer.parseInt(request.getParameter("membrId"));

    // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf.format(d) + "' and created<'" + sdf.format(nextDay) + "' and membrId='"+membrId+"'", " order by created");

    Membr sm=MembrMgr.getInstance().find("id="+membrId);
%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<%=(sm !=null)?sm.getName():""%>-註記</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<form action="addEntryps2.jsp" method="post">
<center>
    <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de" nowrap>
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#ffffff class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0 width=30%>日期</td>
            <td>
                <%=sdf.format(d)%>
                <input type=hidden name="createdx" value="<%=sdf.format(d)%>">
            </tD>
    </tr>
    <tr bgcolor=#ffffff class=es02>
        <td bgcolor=#f0f0f0>註記</td>
        <td>
<%
    if(pss==null || pss.size()<=0){
%>
        <textarea name="pssText" rows=3 cols=30></textarea>
        <input type=hidden name="pssId" value="0">
<%
    }else{
        Entryps ps=(Entryps)pss.get(0);
%>
        <textarea name="pssText" rows=3 cols=30><%=(ps.getPs()!=null)?ps.getPs():""%></textarea>
        <br>
        <%
            UserMgr um=UserMgr.getInstance();
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
        </tD>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td colspan=2 align=middle>
            <input type=hidden name="membrId" value="<%=membrId%>">
            <input type=submit value="確認新增">
        </td>
    </tr>
</table>
</td>
    </tr>
    </table>    
</form>
</center>