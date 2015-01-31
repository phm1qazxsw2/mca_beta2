<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String field = request.getParameter("field");

    int bunit=-1;
    try{
        bunit=Integer.parseInt(request.getParameter("bunit"));        
    }catch(Exception ex){}
%>
<script>
function doSelect(id, name) {
    parent.setTarget_<%=field%>(id, name);
    parent.settarget<%=field%>.hide();
}

function doCancel() {
    parent.settarget<%=field%>.hide();
}
</script>
<%!
    public String getLink(MembrTeacher t) {
        if (t==null)
            return "";
        String ret = "<a href=\"javascript:doSelect("+t.getMembrId()+",'"+phm.util.TextUtil.escapeJSString(t.getName())+"')\">" + t.getName() + "</a><br>";
        return ret;
    }
%>
<%
    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws2.getBunitSpace("buId"));
%>

<div class=es02>
&nbsp;&nbsp;
<%
    if(b !=null && b.size()>0){
%>
    部門: <select name="bunit" size=1  onChange="window.location='schedule_find_target.jsp?bunit='+this.value+'&field=<%=field%>'">
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
            </select>
<%
    }
%>

</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

<form name="f1">
<%
    String query="teacherStatus!=0 ";

    if(bunit !=-1)
        query+=" and teacherBunitId='"+bunit+"'";

    Iterator<MembrTeacher> iter = MembrTeacherMgr.getInstance().retrieveList(query, "").iterator();
    while (iter.hasNext()) {
        MembrTeacher t = iter.next();
      %><%=getLink(t)%><%
    }
%>
<br>
</form>
<br>

<br>
</blockquote>

