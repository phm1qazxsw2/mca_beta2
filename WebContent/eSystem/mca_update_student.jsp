<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*,mca.*,java.lang.reflect.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    //##v2
    int id = Integer.parseInt(request.getParameter("id"));

    boolean commit = false;
    int tran_id = 0;
    try { 
        tran_id = Manager.startTransaction();
    
        McaService mcasvc = new McaService(tran_id);
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        McaStudent ms = msmgr.find("id=" + id);
        String name = request.getParameter("n");
        String value = request.getParameter("v");
        Class c = ms.getClass();
        Method[] methods = c.getDeclaredMethods();
        Map<String, Method> methodMap = new SortingMap(methods).doSortSingleton("getName");
        Method m = methodMap.get("set" + name);
        if (name.equals("TDisc")) {
            double tdisc = Double.parseDouble(value);
            ms.setTDisc(tdisc);
        }
        else {
            Object[] params = { value };
            Object ret = m.invoke(ms, params);
        }
        msmgr.save(ms);
        ArrayList<McaStudent> tmp = new ArrayList<McaStudent>();
        tmp.add(ms);
        mcasvc.updateStudents(tmp);
            
        commit = true;
        Manager.commit(tran_id);

        McaImEx.exportModifiedStudent();
    }
    catch (NumberFormatException e) {
      %>@@number format error, nothing saved<%
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@unknow error, nothing saved!<%
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>