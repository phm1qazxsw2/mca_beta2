<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,603))
    {
        response.sendRedirect("authIndex.jsp?code=600");
    }
%>
<%@ include file="leftMenu4.jsp"%>
<%
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveList("","order by typeId asc");
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(tags).doSort("getTypeId");
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","order by num asc",_ws.getStudentBunitSpace("bunitId"));
    Map<Integer, Vector<TagType>> typeMap = new SortingMap(types).doSort("getId");
    int studentNum = StudentMgr.getInstance().numOfRows("studentStatus in (3,4)");
    _ws.setBookmark(ud2, "表單中心");
%>
<br>
<b>&nbsp;&nbsp;&nbsp;表單中心</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<table class=es02 border=0 width=88%>
<%
    DecimalFormat nf = new DecimalFormat("###,##0.00");
%>
        <tr class=es02 height=20>
            <td align=left valign=middle>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>萬用表單</b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
                </table>
            </tD>
        </tr>
        <tr class=es02  height=10>
            <td align=left valign=middle>
            </tD>
        </tr>

        <tr>
            <tD width=95%>
                <table width=100% border=0>
                    <tr>
                        <td width=30%>
                            <img src="pic/form1.png" border=0>
                        </td>
                        <td width=70% align=middle>
                                <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
                                <tr align=left valign=top>
                                <td bgcolor="#e9e3de">
                                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                                    <tr bgcolor=#f0f0f0 class=es02>
                                        <td align=middle width=80%>相關應用</td>
                                        <td></td>
                                    </tr>
                                    <tr bgcolor=#ffffff class=es02>
                                        <td>
                                            <li><b>學生保險資料表:</b> 學生姓名 /出生日期 / 身份証字號
                                            <li><b>通訊錄:</b> 學生姓名 / 家長姓名 / 聯絡電話 /地址
                                            <li><b>學童乘車名單:</b> 學生姓名 / 聯絡電話 /地址
                                        </td>
                                        <td align=middle>
                                            <a href="exlStudent.jsp"><img src="pic/edit2.png" border=0>&nbsp;編輯表單</a>
                                        </td>
                                    </tr>
                                </table>
                                </td>
                                </tr>
                                </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>


     <tr class=es02 height=20>
            <td align=left valign=middle>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>點名表</b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
                </table>
            </tD>
        </tr>
        <tr class=es02  height=10>
            <td align=left valign=middle>
            </tD>
        </tr>

        <tr>
            <tD width=95%>
                <table width=100% border=0>
                    <tr>
                        <td width=30%>
                            <img src="pic/form3.png" border=0>
                        </td>
                        <td width=70% align=middle>
                                <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
                                <tr align=left valign=top>
                                <td bgcolor="#e9e3de">
                                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                                    <tr bgcolor=#f0f0f0 class=es02>
                                        <td align=middle width=80%>相關應用</td>
                                        <td></td>
                                    </tr>
                                    <tr bgcolor=#ffffff class=es02>
                                        <td>
                                            <li><b>才藝班點名:</b> 學生姓名 /日期
                                            <li><b>交通車名單:</b> 學生姓名 /日期
                                        </td>
                                        <td align=middle>
                                            <a href="callIndex.jsp"><img src="pic/edit2.png" border=0>&nbsp;編輯表單</a>
                                        </td>
                                    </tr>
                                </table>
                                </td>
                                </tr>
                                </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>


 <tr class=es02 height=20>
            <td align=left valign=middle>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>貼紙標籤</b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
                </table>
            </tD>
        </tr>
        <tr class=es02  height=10>
            <td align=left valign=middle>
            </tD>
        </tr>

        <tr>
            <tD width=95%>
                <table width=100% border=0>
                    <tr>
                        <td width=30%>
                            <img src="pic/form2.png" border=0>
                        </td>
                        <td width=70% align=middle>
                                <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
                                <tr align=left valign=top>
                                <td bgcolor="#e9e3de">
                                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                                    <tr bgcolor=#f0f0f0 class=es02>
                                        <td align=middle width=80%>相關應用</td>
                                        <td></td>
                                    </tr>
                                    <tr bgcolor=#ffffff class=es02>
                                        <td>
                                            <li><b>姓名貼:</b> 班級 / 學生姓名 
                                            <li><b>郵寄地址貼:</b> 郵遞區號 / 地址 / 家長姓名 
                                            <li><b>學生名牌:</b> 班級 / 學生姓名
                                        </td>
                                        <td align=middle>
                                            <a href="tagStudent.jsp"><img src="pic/edit2.png" border=0>&nbsp;編輯表單</a>
                                        </td>
                                    </tr>
                                </table>
                                </td>
                                </tr>
                                </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

 <tr class=es02 height=20>
            <td align=left valign=middle>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>壽星名單</b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
                </table>
            </tD>
        </tr>
        <tr class=es02  height=10>
            <td align=left valign=middle>
            </tD>
        </tr>

        <tr>
            <tD width=95%>
                <table width=100% border=0>
                    <tr>
                        <td width=30%>
                            <img src="pic/form4.png" border=0>
                        </td>
                        <td width=70% align=middle>
                                <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
                                <tr align=left valign=top>
                                <td bgcolor="#e9e3de">
                                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                                    <tr bgcolor=#f0f0f0 class=es02>
                                        <td align=middle width=80%>相關應用</td>
                                        <td></td>
                                    </tr>
                                    <tr bgcolor=#ffffff class=es02>
                                        <td>
                                            <li><b>壽星名單:</b> 學生姓名 /出生日期 / 年齡                                        </td>
                                        <td align=middle>
                                            <a href="birthIndex.jsp"><img src="pic/edit2.png" border=0>&nbsp;編輯表單</a>
                                        </td>
                                    </tr>
                                </table>
                                </td>
                                </tr>
                                </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>            
</blockquote>
</ul>
<br>
<br>
<br>

<%@ include file="bottom.jsp"%>