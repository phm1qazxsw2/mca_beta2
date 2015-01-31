<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,java.lang.reflect.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        McaStudent ms = new McaStudent();

        Class c = ms.getClass();
        Method[] methods = c.getDeclaredMethods();
        Map<String, Method> methodMap = new SortingMap(methods).doSortSingleton("getName");

        Enumeration names = request.getParameterNames();
        Object[] params = new Object[1];
        while(names.hasMoreElements()) {
            String name=(String)names.nextElement();
            if (name.equals("id") || name.equals("TDisc"))
                continue;
            else if (name.equals("CStreet"))
                name = "ChineseStreetAddress";
            else if (name.equals("EStreet"))
                name = "EnglishStreetAddress";

            String methodName = "set" + name.substring(0,1).toUpperCase() + name.substring(1);
            Method m = methodMap.get(methodName);            
            params[0] = request.getParameter(name);
            Object ret = m.invoke(ms, params);
        }

        try { ms.setTDisc(Double.parseDouble(request.getParameter("TDisc"))); } catch (Exception e) {}
        Bunit bu = new BunitMgr(tran_id).find("id=" + _ws2.getSessionBunitId());
        new McaStudentMgr(tran_id).create(ms);

        ArrayList<McaStudent> sa = new ArrayList<McaStudent>();
        sa.add(ms);
        McaService mcasvc = new McaService(tran_id);
        mcasvc.updateStudents(sa);

        // make it flash in new admission
        new Student2Mgr(tran_id).executeSQL("update student set studentStatus=1 where id=" + ms.getStudId());

        dbo.Manager.commit(tran_id);
        commit = true;  
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
          e.printStackTrace();
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        } else {
          e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<body>
<blockquote>
產生成功！
</blockquote>
</body>
