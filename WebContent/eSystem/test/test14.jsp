<%@ page language="java" 
    import="jsf.*,dbo.*,phm.ezcounting.*,java.util.*,phm.importing.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%
    int bunit=-1;
    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveList("status ='1' and flag='0'","");
%>

<form action="test12.jsp" method="post">

<%
    if(b !=null && b.size()>0){
%>
    班表部門: <select name="bunit" size=1  onChange="javascript:changeAction2(this.value)">
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>跨部門</option>
            </select>

<%
    }
%>
        <br>
        <textarea name="mName" rows=10 cols=20></textarea>


<br>
    <input type=submit value="新增">
<br>
</form>
