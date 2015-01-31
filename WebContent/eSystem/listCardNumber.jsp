<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6_sch.jsp"%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="images/rfidx.png" border=0>&nbsp;刷卡資料查詢</b>
<br>
<%
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    
    int order=1;

    String orderS=request.getParameter("order");
    if(orderS !=null)
        order=Integer.parseInt(orderS);

    Date d1=new Date();
    Calendar c = Calendar.getInstance();
    c.setTime(d1);
    c.add(Calendar.YEAR, 1);
    c.add(Calendar.DATE, -1); 
    Date d2 =new Date();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();
%>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
<form action="listCardNumber.jsp" name='f1' id='f1' method="get" onsubmit="return doSubmit(this)">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
    <input type=submit value="查詢">
</form>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<%
    // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
    ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("created<'"+sdf.format(nextEndDay)+"'", " order by created desc");
    Map<String, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getCardId");

    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");

    String readerId=SchEventInfo.getMachineId();
    ArrayList<Entry> entries = null;

    String orderString="";

    switch(order){
        
        case 1:
            orderString=" order by created asc";
            break;
        case 2:
            orderString=" order by created desc";
            break;
        case 5:
            orderString=" order by cardId asc";
            break;
        case 6:
            orderString=" order by cardId desc";
            break;
    }

    entries = emgr.retrieveList("created>='" + sdf1.format(d1) + "' and created<'" + sdf1.format(nextEndDay)+"' "+readerId, orderString);

    if(entries ==null){

        out.println("<blockquote><div class=es02>沒有資料</div></blockquote>");
%>        
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));

%>
<table width="60%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 class=es02>
        <tD align=middle>
            筆數
        </td>
        <tD align=middle>
            <%  if(order ==2){   %>
            <a href="listCardNumber.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&order=1">日期 ↓</a>
            <%  }else{  %>
            <a href="listCardNumber.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&order=2">日期 ↑</a>
            <%  }   %>
            
        </td><td align=middle>時間</tD>

        <td align=middle>
            刷卡機
        </td>
        <td align=middle>
            <%  if(order ==3){   %>
            <a href="listCardNumber.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&order=4">流水號 ↓</a>
            <%  }else{  %>
            <a href="listCardNumber.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&order=3">流水號 ↑</a>
            <%  }   %>
        </td>
        <td align=middle>
            登入方式
        </td>
        <td align=middle>
            <%  if(order ==5){   %>
            <a href="listCardNumber.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&order=6">卡號 ↓</a>
            <%  }else{  %>
            <a href="listCardNumber.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&order=5">卡號 ↑</a>
            <%  }   %>
        </td><td align=middle>刷卡人</td>
    </tR>
<%
    MembrMgr mmx=MembrMgr.getInstance();
    for(int i=0;i<entries.size();i++)
    {
        Entry en=entries.get(i);
        CardMembr cm=membrcardMap.get(en.getCardId());

        String name="";
        if(cm !=null){
            Membr m=mmx.find(" id='"+cm.getMembrId()+"'");

            if(m !=null)
                name=m.getName();
        }
%>
    <tr bgcolor=ffffff class=es02>
        <td align=left><%=i+1%>.</tD>
        <td><%=sdf.format(en.getCreated())%></td>
        <td><%=sdf2.format(en.getCreated())%></td>
        <td align=middle><%=en.getMachineId()%></tD>
        <td align=left><%=(en.getNumber()!=0)?en.getNumber():""%></tD>
        <td align=middle>
            <%=(en.getDatatype()==0)?"系統":"人工"%>
        </tD>
        <td><%=en.getCardId()%></td>
        <td align=left><%=name%></td>
    </tr>
<%
    }
%>
</table>
    </td>
    </tr>
    </table>
</blockquote>

<%@ include file="bottom.jsp"%>