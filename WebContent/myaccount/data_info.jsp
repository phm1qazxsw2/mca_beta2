<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="../eSystem/style.css" type="text/css">
<%@ include file="topMenuAdvanced.jsp"%>
<%
    int sid =12; 
    String sidS=request.getParameter("sid");
    if(sidS!=null)
        sid=Integer.parseInt(sidS);
%>
 <BR>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;帳單資訊設定</b>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<center>

<table cellpadding=0 cellspacing=0 border=0 width=800 height=700>
<tr>
    <td valign=top>

  <table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>
                            繳費約定帳號 
                        </td>
                        <td class=es02 bgcolor=ffffff>
                            812 (台新銀行) - <br>
                            898989898  

                        </td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>
                            簡訊通知號碼
                        </td>
                        <td class=es02 bgcolor=ffffff>
                            0912-123123 <BR>
                            0920-123123
                        </td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>
                            帳單發佈方式
                        </td>
                        <td class=es02 bgcolor=ffffff>
                           <input type=radio name="pubWay" value="1">紙本作業 <BR>
                           <input type=radio name="pubWay" value="2">email <BR>
                           <input type=radio name="pubWay" value="3">簡訊通知 <BR>
                        </td>
                    </tr>
                    </table>
                </td>
                </tr>
                </table>

            </td>
        </tr>
    </table>

</center>
<%@ include file="bottom.jsp"%>