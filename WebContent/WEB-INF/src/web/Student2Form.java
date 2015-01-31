package web;


import beans.html.*;
import beans.app.*;
import java.text.*;

public class Student2Form implements ValidatedElement {

    private String error = "";

    private OptionsElement	status	=	new OptionsElement();
    private OptionsElement	depart	=	new OptionsElement();
    private OptionsElement	classx	=	new OptionsElement();
    private OptionsElement	level	=	new OptionsElement();


    public String[] getStatus() { return status.getValue(); }
    public String[] getDepart() { return depart.getValue(); }
    public String[] getClassx() { return classx.getValue(); }
    public String[] getLevel() { return level.getValue(); }


    public String getStatusSelectionAttr(String s) { return status.selectionAttr(s); }
    public String getDepartSelectionAttr(String s) { return depart.selectionAttr(s); }
    public String getClassxSelectionAttr(String s) { return classx.selectionAttr(s); }
    public String getLevelSelectionAttr(String s) { return level.selectionAttr(s); }


    public void setStatus(String[] s) { status.setValue(s); }
    public void setDepart(String[] s) { depart.setValue(s); }
    public void setClassx(String[] s) { classx.setValue(s); }
    public void setLevel(String[] s) { level.setValue(s); }


    public boolean validate() {
        error = "";

        return error == "";
    }


    public String getValidationError() {
        return error;
    }

    /*
    public void copyFrom(Object item)
    {
        XXX i = (XXX) item;

            SimpleDateFormat df = 
            new SimpleDateFormat("MM/dd/yyyy");

    }
    */
}


// ================================== 
// Insert the following code in jsp   
// ================================== 
// <jsp:useBean id='form' scope='request' class='beans.app.forms.Student2Form'/>
// <jsp:setProperty name='form' property='*'/>

//<% String error = (String)request.getAttribute("error-message");
//   if(error != null) { %>
//      <font size='4' color='error'>
//      <%= error %></p></font>
//<%    request.removeAttribute("error-message");
//   } %>

// ================================== 
// Insert the following code in jsp   
// ================================== 
// <%=form.getStatusSelectionAttr("")%>
// <%=form.getDepartSelectionAttr("")%>
// <%=form.getClassxSelectionAttr("")%>
// <%=form.getLevelSelectionAttr("")%>
