<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%!

    void addNumbr(StringBuffer sb,int nowNumber,int range){

        for(int i=1;i<range;i++)
            sb.append("#"+String.valueOf(nowNumber+i));
    }
%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6_sch.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");    
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    
    Date d1=c.getTime();
    Date d2=new Date();
    String d2String=sdf.format(d2);
    d2=sdf.parse(d2String);        

    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}

    c.setTime(d2);
    c.add(Calendar.DATE,2);
    Date nextEndDay = c.getTime();
    String[] mid=pZ2.getCardmachine().split("#");
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;衛星程式補登</b>
</div> 
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
<form name="f1" action="exportCardData.jsp" method="get">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期</a>:<input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8>
    &nbsp;&nbsp;
    <a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至</a>:<input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
    <%  
          if(mid !=null && mid.length>1){
    %>            
        easyID 機器編號:
        <select size=1 name="maId">
            <%
                for(int i=0;i<mid.length;i++){
            %>
                <option value="<%=mid[i]%>"><%=mid[i]%></option>
            <%  }   %>
        </select>
    <%  }else{   %>
            <input type=hidden name="maId" value="<%=mid[0]%>">            
    <%  }   %>  
    &nbsp;&nbsp;    
    <input type=submit value="查詢">
</form>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<%
    String maIdString=request.getParameter("maId");

    if(mid !=null && mid.length ==1)
        maIdString=mid[0];

    if(maIdString ==null){
%>        
    <blockquote>
        <div class=es02>
            請選擇機器號碼.
        </div>
    </blockquote>  
<%
    }else{

        EntryMgr emgr = EntryMgr.getInstance();
        emgr.setDataSourceName("card");
        ArrayList<Entry> entries = null;

        entries = emgr.retrieveList("created>='" + sdf.format(d1) + "' and created<'" +sdf.format(nextEndDay)+"' and machineId='"+maIdString+"'", " order by number asc");

        StringBuffer sb=new StringBuffer("");
        String startNum="";
        if(entries ==null || entries.size()<=1){
%>
        <blockquote>
            <div class=es02>
                本區間沒有刷卡資料.
            </div>
        </blockquote>  
<%
        }else{
            int nowNumber=0;
            int nowNumber2=0;

            startNum="開始流水號: <font color=blue>"+entries.get(0).getNumber()+"</font>  結束流水號:<font color=blue>"+entries.get(entries.size()-1).getNumber()+"</font>";
            for(int i=0;i<entries.size();i++){                                    
                Entry en=entries.get(i);
                nowNumber=en.getNumber();

                if(i < (entries.size()-1)){
                    Entry en2=entries.get((i+1));                    
                    nowNumber2=en2.getNumber();

                    int range=nowNumber2-nowNumber;
                    if(range !=1){
                        addNumbr(sb,nowNumber,range);                        
                    }
                }
            }
        }                
%>
        <blockquote>
        <div class=es02><%=startNum%>  <br><b>需補登的資料:</b></div>
        <textarea rows=10 cols=40><%=sb.toString()%></textarea>
        </blockquote>
<%
    }
%>
<%@ include file="bottom.jsp"%>	
