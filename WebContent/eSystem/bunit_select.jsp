<%
    ArrayList<Bunit> bunits_ = BunitMgr.getInstance().retrieveList("flag=" + Bunit.FLAG_BIZ + 
        " and status=" + Bunit.STATUS_ACTIVE, "");
%>
<% if (bunits_.size()>0) { %>

<%=(bunit_filter)?"部門":""%>
<select name="bunit" <%=(bunit_filter)?"onchange=\"this.form.submit()\"":""%>>
    <option value="0">全部
<%    
    for (int i=0; i<bunits_.size(); i++) 
        out.println("<option value=\""+bunits_.get(i).getId()+"\" "+
            ((bunits_.get(i).getId()==buId)?"selected":"")+">" + bunits_.get(i).getLabel());
%>
</select>　　
<% } %>
