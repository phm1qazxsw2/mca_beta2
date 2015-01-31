<%@ page language="java"  import="java.io.*" contentType="text/html;charset=BIG5"%>
<%
    response.setCharacterEncoding("Big5");
    BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream("ascii2big5.txt"), "Big5"));
    String line = br.readLine();
    for (int i=0; i<line.length(); i+=2) {
        out.println(line.charAt(i) + ":" + line.charAt(i+1));
    }
%>