<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,104)){
%>
        <blockquote>
            <div class=es02>                
            權限不足,授權代號為 104
            </div>
        </blockquote>
<%        
        return;
    }

String backurl2="pay_info.jsp?"+request.getQueryString();
%>
<%@ include file="pay_info_detail.jsp"%>
