<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    String[] urls = {
        /*
        "http://218.32.77.180:8080/demo/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.180:8080/ezcounting_beta/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/bowjinn/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/ccg1168/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/daniel/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/hawsheng/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/hoho/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/internal/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/jsdaycare/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/jsfch/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/jsftc/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/jsftn/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/jsftp/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/karen/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/kjfsr/eSystem/test/fix_teacher.jsp",
        //"http://218.32.77.178/korrnell/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/neil/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/nwdatun/eSystem/test/fix_teacher.jsp",
        //"http://218.32.77.178/phm_website/eSystem/test/fix_teacher.jsp",
        //"http://218.32.77.178/phmcrm/eSystem/test/fix_teacher.jsp",
        */
        "http://218.32.77.178/renoir/eSystem/test/fix_teacher.jsp",
        //"http://218.32.77.178/robrita/eSystem/test/fix_teacher.jsp",
        //"http://218.32.77.178/showme/eSystem/test/fix_teacher.jsp",
        //"http://218.32.77.178/starlight/eSystem/test/fix_teacher.jsp",
        "http://218.32.77.178/wekids/eSystem/test/fix_teacher.jsp"
    };

    for (int i=0; i<urls.length; i++) {
        try {
            out.println(phm.util.URLConnector.getContent(urls[i], 8000, "UTF-8") + "<br>");
        }
        catch (Exception e) {
            e.printStackTrace();
            out.println("Error:" + urls[i] + ":" + e.getMessage());
        }
    }
%>
