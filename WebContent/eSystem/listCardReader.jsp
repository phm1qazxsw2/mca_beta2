<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    //Entry en=emgr.find("id="+eId);

    String cardId=request.getParameter("cardId");
    String d1S=request.getParameter("d1");
    String sdIds=request.getParameter("sdIds");
    String membrId=request.getParameter("membrId");

    Membr mem=MembrMgr.getInstance().find("id='"+membrId+"'");

    ArrayList<CardMembrInfo> cni=CardMembrInfoMgr.getInstance().retrieveList("cardId='"+cardId+"'","");
    String name="";
    CardMembrInfo cmix=null;
    if(cni !=null && cni.size()>0)
    {
        cmix=cni.get(0);
        name=cmix.getName();
    }

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2x=new SimpleDateFormat("yyyyMMddHHmm");

    Date d1=sdf.parse(d1S);

    String d2S=request.getParameter("d2");
    Date d2=sdf.parse(d1S);
    if(d2S !=null)
        d2=sdf.parse(d2S);

    Calendar c=Calendar.getInstance();
    c.setTime(d2);
    c.add(Calendar.DATE,1);
    Date nextday=c.getTime();

%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02><b>&nbsp;&nbsp;&nbsp;<%=name%>&nbsp;刷卡記錄查詢</b>
<center>
<form action="listCardReader.jsp" method=post id=f1 name=f1>
<a href="#" onclick="displayCalendar(document.f1.d1,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="d1" value="<%=sdf.format(d1)%>" size=8>
        &nbsp;
<a href="#" onclick="displayCalendar(document.f1.d2,'yyyy/mm/dd',this);return false">至</a><input type=text name="d2" value="<%=sdf.format(d2)%>" size=8>

<input type=hidden name="cardId" value="<%=cardId%>">
<input type=hidden name="membrId" value="<%=membrId%>">
<input type=submit value="查詢">
</form>
</center>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<%
    String readerId=SchEventInfo.getMachineId();
    Hashtable ha=CardMembr.getCardDate(d1,d2,mem);

    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    
    UserMgr um=UserMgr.getInstance();
	int duringDate=(int)((d2.getTime()-d1.getTime())/(long)(1000*60*60*24));

	c.setTime(d1);
    for(int j=0;j<(duringDate+1);j++){

        Date nowDate=c.getTime();		
		c.add(Calendar.DATE,1);
        Date nextDay=c.getTime();

        String dateString=sdf.format(nowDate);    
        String cardIdX=(String)ha.get(dateString);

        if(cardIdX==null)
            continue;

        ArrayList<Entry> ens=emgr.retrieveList("cardId='"+cardIdX+"' and '"+sdf.format(nowDate)+"' <=created and created<'"+sdf.format(nextDay)+"'"+readerId,"order by created asc");
        
        if(ens !=null && ens.size()>0){
%>
<br>
<font class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><%=sdf.format(nowDate)%> 刷卡記錄 :</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onClick="javascript:openwindow_phm('addCardReader.jsp?membrId=<%=membrId%>&d=<%=sdf2x.format(nowDate)%>&sdIds=<%=sdIds%>&cardId=<%=cardIdX%>', '補登刷卡', 600, 400, 'addevent');return false">補登刷卡</a>

</font>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
            <td align=middle>次數</tD><td align=middle>刷卡時間</td>
            <td>讀卡機</tD>
            <td>登入者</tD>
            <td></td>
        </tr>
<%
    
        for(int i=0;i<ens.size();i++){
            Entry nen=(Entry)ens.get(i);
            int k=i+1;

            User u=null;
            if(nen.getDatauser()!=0)
                u=(User)um.find(nen.getDatauser());
%>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
                <td class=es02><%=k%></tD>
                <td class=es02><%=sdf2.format(nen.getCreated())%></td>
                <td class=es02 align=left><%=nen.getMachineId()%></td>
                <td class=es02 align=middle><%=(u==null)?"系統":u.getUserFullname()%></td>
                <td align=middle class=es02>
                <%
                if(u !=null){
                %>
                <a href="#" onClick="javascript:openwindow_phm('modifyCardReader.jsp?eId=<%=nen.getId()%>', '補登刷卡', 400, 300, 'addevent');return false">修改</a>
                <%  }   %>
                </td>
            </tr>
<%      }   %>
        
    </table>
    </td>
    </tr>
    </table>
    </center>
    <br>

<%  
    }else{   %>

<blockquote>
<font class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><%=sdf.format(nowDate)%> 沒有刷卡記錄 :</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onClick="javascript:openwindow_phm('addCardReader.jsp?membrId=<%=membrId%>&d=<%=sdf2x.format(nowDate)%>&sdIds=<%=sdIds%>&cardId=<%=cardIdX%>', '補登刷卡', 600, 400, 'addevent');return false">補登刷卡</a>
</blockquote>

<%  
    }  


    } 
%>