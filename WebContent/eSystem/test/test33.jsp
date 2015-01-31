<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%><%
    char c = '１';
    char d = '1';
    int diff = (c-d);
    out.println("##" + diff + "##<br>\n");
    for (int i=32; i<256; i++) {
        int full = i+diff;
        out.println("[" + i + "][" + (char)i + "][" + (char)(full) + "][" + full + "]<br>\n");
    }
%>