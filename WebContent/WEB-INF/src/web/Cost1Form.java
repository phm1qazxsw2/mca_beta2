package web;


import beans.html.*;
import beans.app.*;
import java.text.*;

public class Cost1Form implements ValidatedElement {

    private String error = "";

    private TextElement	sDate	=	new TextElement();
    private TextElement	eDate	=	new TextElement();
    private OptionsElement	bigItem	=	new OptionsElement();


    public String getSDate() { return sDate.getValue(); }
    public String getEDate() { return eDate.getValue(); }
    public String[] getBigItem() { return bigItem.getValue(); }


    public String getBigItemSelectionAttr(String s) { return bigItem.selectionAttr(s); }


    public void setSDate(String s) { sDate.setValue(s); }
    public void setEDate(String s) { eDate.setValue(s); }
    public void setBigItem(String[] s) { bigItem.setValue(s); }


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
// <jsp:useBean id='form' scope='request' class='beans.app.forms.Cost1Form'/>
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
// <%=form.getSDate()%>
// <%=form.getEDate()%>
// <%=form.getBigItemSelectionAttr("")%>
