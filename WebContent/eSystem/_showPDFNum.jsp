<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    String r=request.getParameter("r");
    PdfMaker pm=PdfMaker.getInstance();

    if(pm.getTotalNumPDF() ==0)
    {   
%>
        <BR>
        <BR>
        <blockquote>
        <div class=es02><font color=red>Error:</font>沒有符合的帳單</div>
        </blockquote>
<%
    }else if(pm.getRunNow()==pm.getTotalNumPDF()){
%>
    <center>
        <table width="88%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#ffffff align=left valign=middle  class=es02>
                <td bgcolor=#f0f0f0>狀態</td>    
                <td>檔案已產生</tD> 
            </tr>
            <tr bgcolor=#ffffff align=left valign=middle  class=es02>
                <td bgcolor=#f0f0f0>注意事項</td>    
                <td><font color=blue>下載畫面將開啟新的視窗,請確認已取消瀏覽器(browser)的攔截視窗.</font></tD> 
            </tr>
            <tr bgcolor=#ffffff align=left valign=middle class=es02>    
                <td colspan=2 align=middle>
                    <a href="showPDFFile.jsp?pdffile=<%=pm.getPDFFileString()%>" target="_blank">
                    <img src="pic/pdf.gif" border=0>下載繳費單</a>
                </tD> 
            </tr>
        </table>
        </td>
        </tr>
        </table>
    </center>
<%
    }else{
%>
        
        <br>
        <br>
        <blockquote>    
        <div class=es02>
            目前進度:<font color=blue><%=pm.getRunNow()%></font>/<%=pm.getTotalNumPDF()%>
        </div>
        </blockquote>
<%
    }
%>

