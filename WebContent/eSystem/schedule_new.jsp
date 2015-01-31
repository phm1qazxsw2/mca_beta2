<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String name = "";

    Calendar c=Calendar.getInstance();
    c.setTime(new Date());
    c.add(Calendar.DATE, 1);
    Date startDate=c.getTime();

    Date endDate = null;
    /*
    c.add(Calendar.MONTH,1);        
    c.set(Calendar.DATE,1);
    c.add(Calendar.DATE,-1);
    endDate=c.getTime();
    */

    int type = SchDef.TYPE_DAY_OF_WEEK;
    String content = "";
    String color = "";
    int membrCount = -1;
    String membrNames="";
    int id = -1;

    int autoRun=pd2.getCardread();

    int bunit=0;

    boolean cross_day = false;

    SchDef sd=null;
%>
<script>
    function showContentInput(type){
    
        if(type==<%=SchDef.TYPE_EVERYDAY%>){
            document.f1.content.value="0,0900-1800,60,10";
        }else if(type==<%=SchDef.TYPE_DAY_OF_WEEK%>){
            document.f1.content.value="1-2-3-4-5,0900-1800,60,10";
        }else if(type==<%=SchDef.TYPE_DAY_OF_MONTH%>){
            document.f1.content.value="10-20,0900-1800,60,10";
        }else if(type==<%=SchDef.TYPE_FLEXABLE%>){
            document.f1.content.value="1-2-3-4-5,(0700-1600 or 0800-1700 or 0900-1800),60,10";
        }
    }
</script>

<form name=f1 id="f1" action="schedule_new2.jsp" method=post onsubmit="return doSubmit();">
<%@ include file="schedule_detail_inner.jsp"%>
</form>
<script>
    showContentInput(<%=SchDef.TYPE_DAY_OF_WEEK%>);

   var d = document.getElementById("submitbutton");
   d.innerHTML = "<input type=submit name=\"submit\" value=\"新增\">";
</script>