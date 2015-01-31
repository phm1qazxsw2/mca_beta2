<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    SchDef sd = SchDefMgr.getInstance().find("id=" + id);
    //sd = sd.findNewestCopy();

    ArrayList<sch_content> sca = sd.getSchContent();
    sch_content sc=sca.get(0);
    if(sc ==null)
    {
        out.print("發生錯誤");
        return;
    }
if (sc.flexTime==null)
    System.out.println("## flexTime=null");
else
    System.out.println("## flexTime=" + sc.flexTime.size());

    String name = sd.getName();
    Date startDate = sd.getStartDate();
    Date endDate = sd.getEndDate();
    int type = sd.getType();
    String content = sd.getContent();
    String color = sd.getColor();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    int autoRun=sd.getAutoRun();
    int bunit=sd.getBunitId();
    int membrCount =0;
    ArrayList<SchDefMembr> membrlist = SchDefMembrMgr.getInstance().retrieveList("schdefId=" + sd.getId(), "");
    String membrNames = new RangeMaker().makeRange(membrlist, "getMembrName");
    if (membrNames.equals("-1"))
        membrNames = "(沒有人)";
    else
        membrCount=membrlist.size();

    // SchMembrMgr.getInstance().numOfRows("schdefId=" + sd.getId());

    Date d = new Date();
    boolean cross_day = false;
    if (d.compareTo(sd.getStartDate())>0) {
        cross_day = true;
    } 
%>

<script>
    function showContentInput(typeJS){
    
        if(typeJS==<%=SchDef.TYPE_EVERYDAY%>){
            <%
            if(type==SchDef.TYPE_EVERYDAY){
            %>
                document.f1.content.value="<%=content%>";
            <%  }else{  %>
                document.f1.content.value="0,0900-1800,60,10";
            <%  }   %>

        }else if(typeJS==<%=SchDef.TYPE_DAY_OF_WEEK%>){
            <%
            if(type==SchDef.TYPE_DAY_OF_WEEK){
            %>
                document.f1.content.value="<%=content%>";
            <%  }else{  %>
                document.f1.content.value="1-3-5,0900-1800,60,10";
            <%  }   %>
        }else if(typeJS==<%=SchDef.TYPE_DAY_OF_MONTH%>){
            <%
            if(type==SchDef.TYPE_DAY_OF_MONTH){
            %>
                document.f1.content.value="<%=content%>";
            <%  }else{  %>
                document.f1.content.value="10-20,0900-1800,60,10";
            <%  }   %>
        }
    }

</script>

<form name=f1 action="schedule_modify2.jsp" method="get" onsubmit="return doSubmit();">
<input type=hidden name="id" value="<%=sd.getId()%>">
<%@ include file="schedule_detail_inner.jsp"%>
</form>
<br>
<script>
   var d = document.getElementById("submitbutton");
   d.innerHTML = "<input type=submit name=\"submit\" value=\"修改\">";

   showContentInput('<%=type%>');
</script>