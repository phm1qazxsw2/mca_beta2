<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=602");
    }
%>
<%@ include file="leftMenu4.jsp"%>
<%
    //##v2
    String mm=request.getParameter("m");
    if(mm !=null)
    {
%>
    <script>
        alert('修改成功!');
        window.location="studentoverview.jsp";
    </script>

<%
    }
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveListX("","order by typeId asc", _ws.getStudentBunitSpace("bunitId"));
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","", _ws.getStudentBunitSpace("bunitId"));
    Map<Integer, Vector<TagType>> typeMap = new SortingMap(types).doSort("getId");
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveListX("studentStatus in (3,4)","", _ws.getStudentBunitSpace("membr.bunitId"));
    Map<Integer,Vector<TagMembrStudent>> m = new SortingMap(tagstudents).doSort("getTagId");
%>
<br>
<script>
function addtag()
{
    while (true) {
        var name = prompt("請輸入新的標籤名稱");
        if (name==null) {
            return;
        }
        else if (name.length>0) {
            location.href = "add_membr_tag.jsp?n=" + encodeURI(name);
            break;
        }
        else if (name.length==0) {
            alert("您沒有輸入名稱!");
        }
    }
}
</script>
&nbsp;&nbsp;&nbsp;
<img src="pic/tagtype.png" border=0>&nbsp; 
<b>學生家長來電</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

<table>
<tr>
<td valign=top>

    <b>本次來電：</b>
    <table height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    時間
                </td>
                <td>
                    2009/03/10 09:20
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    來電號碼
                </td>
                <td>
                    0921123456 (父親手機)
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    學生
                </td>
                <td>
                    李大同
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    種類
                </td>
                <td>
                    <select>
                      <option>生病來電請假
                      <option>繳費問題
                      <option>-- 新增 --
                    </select>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    內容
                </td>
                <td>
                    <textarea rows=5 cols=30></textarea>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    處理人員
                </td>
                <td>
                    <select>
                      <option>林美芳
                    </select>
                </td>
            </tr>

            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="儲存">
                </td>
            </tr>
        </table>
    </td>
    </tr>
    </table>

</td>
<td width=30></td>
<td valign=top>

    <b>歷史記錄：</b>
    <table height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    時間
                </td>
                <td nowrap>
                    來電號碼
                </td>
                <td>
                    種類
                </td>
                <td>
                    處理人
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td rowspan=2 align=center>
                    2009/02/10<br> 15:30
                </td>
                <td nowrap>
                    02 23683566(家)
                </td>
                <td nowrap>
                    生病請假
                </td>
                <td>
                    賴美芬
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=3>
                    媽媽來電說發燒要請假    
                </td>
            </tr>

            <tr class=es02 bgcolor=f0f0f0>
                <td colspan=4 style="position:relative;height:2px;"></td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td rowspan=2 align=center>
                    2008/10/10<br> 08:30
                </td>
                <td nowrap>
                    0937888123 (媽媽手機)
                </td>
                <td nowrap>
                    生病請假
                </td>
                <td>
                    賴美芬
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=3>
                    拔牙
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

<!--- end 主內容 --->
<%@ include file="bottom.jsp"%>	