 <%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%!
    public boolean checkAuth(User ud2,Hashtable ha,int num){

        if(ud2.getUserRole()<=2){
            return true;
        }
        else if (ud2.getUserRole()<=5) {
            if(ha !=null && ha.get((Integer)num)!=null)
                return true;
            else
                return false;        
        }
        else // 6 is 派遣
            return false;
    }
%>