<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,phm.ezcounting.*,mca.*,java.lang.reflect.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>	
<%
boolean commit = false;
int tran_id = 0;
try {           
    tran_id = dbo.Manager.startTransaction();

    int id = Integer.parseInt(request.getParameter("id"));
    McaStudentMgr msmgr = new McaStudentMgr(tran_id);
    McaStudent s = msmgr.find("id=" + id);
    Student2Mgr stmgr = new Student2Mgr(tran_id);
    Student2 st = stmgr.find("id=" + s.getStudId());
    
    Class c = s.getClass();
    Method[] methods = c.getDeclaredMethods();
    Map<String, Method> methodMap = new SortingMap(methods).doSortSingleton("getName");
    
    Enumeration names = request.getParameterNames();

    Object[] params = new Object[1];
    while(names.hasMoreElements()) {
        String name=(String)names.nextElement();
        String value = request.getParameter(name);
        if (name.equals("id"))
            continue;
        if (name.equals("StudentID"))
            continue;
        if (name.equals("StudentIDX"))
            continue;
        else if (name.equals("CStreet"))
            name = "ChineseStreetAddress";
        else if (name.equals("EStreet"))
            name = "EnglishStreetAddress";

        String methodName = "set" + name.substring(0,1).toUpperCase() + name.substring(1);
        Method m = methodMap.get(methodName);
        if (name.equals("TDisc")) {
            if (request.getParameter(name)==null)
                continue;
            params[0] = new Double(Double.parseDouble(value));
        }
        else
            params[0] = value;
        Object ret = m.invoke(s, params);
    }

    int sid = Integer.parseInt(request.getParameter("StudentID"));
    //if (sid>0 && sid!=s.getStudentID()) {
    //    if (msmgr.numOfRows("StudentID=" + sid)>0)
    //        throw new Exception("StudentID not unique!");
    if (s.getStudentID()==0 && sid!=0) {
        if (msmgr.numOfRows("StudentID=" + sid)>0)
            throw new Exception("New student but StudentID not unique!");
    }
    s.setStudentID(sid); 
    //}

    String notes = request.getParameter("notes");

    s.setModified(new Date());
    s.setNotes(notes);
    msmgr.save(s);
    McaService mcasvc = new McaService(tran_id);
    ArrayList<McaStudent> tmp = new ArrayList<McaStudent>();
    tmp.add(s);
    mcasvc.updateStudents(tmp);
    
    dbo.Manager.commit(tran_id);
    commit = true;

    if (s.getStudentID()>0 && s.getBirthDate().trim().length()>0)
        McaImEx.exportModifiedStudent(s);
}
catch (Exception e) {
    if (e.getMessage()!=null) {
      e.printStackTrace();
  %><script>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
    } else {
      e.printStackTrace();
  %>@@錯誤發生，設定沒有寫入<%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>

