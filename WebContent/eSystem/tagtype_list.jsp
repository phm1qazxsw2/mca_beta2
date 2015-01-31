<%@ page language="java"  import="web.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
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
 
    TagTypeMgr ttmgr = TagTypeMgr.getInstance();
    Object[] objs = ttmgr.retrieveX("", "order by num asc", _ws.getStudentBunitSpace("bunitId"));
    // 第一次可能 num 沒有設
    if (objs!=null && objs.length>0 && ((TagType)objs[0]).getNum()==0) {
        for (int i=0; objs!=null && i<objs.length; i++)
        {
            TagType tt = (TagType) objs[i];
            tt.setNum(i+1);
            ttmgr.save(tt);
        }
    }
    // 第一次可能 main 沒有設
    boolean hasMain = false;
    for (int i=0; objs!=null&& i<objs.length; i++)
        if (((TagType)objs[i]).getMain()!=0)
            hasMain = true;
    if (!hasMain && objs!=null && objs.length>0)
    {        
        TagType tt = (TagType) objs[0];
        tt.setMain(1);
        ttmgr.save(tt);
    }
%>
<script>
function do_delete(f)
{
    if (!confirm("此類型相關的標籤不會被刪除，確定刪除類型？"))
        return false;
    f.action = "tagtype_delete.jsp";
    f.submit();
}
function set_main(f)
{
    f.action = "tagtype_setmain.jsp";
    f.submit();
}
</script>

<br> 
<br> 
<blockquote>
<fieldset width=150>
<legend><img src="pic/add.gif" border=0>&nbsp;新增標籤類型&nbsp;&nbsp;&nbsp;</legend>
	<form action="tagtype_add2.jsp" method=post>
    <input type=hidden name="backurl" value="tagtype_list.jsp">
	<input type=text name=name size=20>
	<input type=submit value="新增">
	</form>
</fieldset>
</blockquote>

<div class=es02>

<b>&nbsp;&nbsp;&nbsp;標籤類型列表</b> 
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<%	

	if(objs==null)
	{
		out.println("尚無資料<br><br>");
		return;
	}
%>
	<table width="40%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
            <td align=middle>預設</td>
            <td align=middle>類型名稱</td>
            <td>上移</td>
            <td>下移</td>
            <td align=middle></td>
            <td align=middle></td>
            <td align=middle></td>
	    </tr>
<%	
	for (int i=0; objs!=null&&i<objs.length; i++) {
        TagType tp = (TagType) objs[i]; %>

        <tr class="normal"  bgcolor=ffffff onmouseover="this.className='highlight'" onmouseout="this.className='normal'">	
		<form action="tagtype_modify2.jsp">
        <input type=hidden name="id" value="<%=tp.getId()%>">
        <input type=hidden name="backurl" value="tagtype_list.jsp">	
        <td class=es02 bgcolor=ffffff>		
			<% if (tp.getMain()==1) { %><img src="img/flag2.png"><% } %>
		</td>
        <td class=es02 bgcolor=ffffff>		
			<input type=text name="name" value="<%=tp.getName()%>" size=10>
		</td>
		<td class=es02 bgcolor=ffffff> 
            <% if (i>0) { %>
			<a href="tagtype_move.jsp?id=<%=tp.getId()%>&switch=<%=((TagType)objs[i-1]).getId()%>"><img src=images/Upicon2.gif border=0></a>
            <% } %>
		</td>	
		<td class=es02 bgcolor=ffffff> 			
            <% if (i<objs.length-1) { %>
			<a href="tagtype_move.jsp?id=<%=tp.getId()%>&switch=<%=((TagType)objs[i+1]).getId()%>"><img src=images/Downicon2.gif border=0></a>
            <% } %>
		</td>		
<% // if (pZ2.getPagetype()!=7) { %>
		<td class=es02 bgcolor=ffffff> 			
			<input type=submit value="修改">
		</td>		
		<td class=es02 bgcolor=ffffff> 			
			<input type=button value="刪除" onclick="do_delete(this.form)";>
		</td>		
		<td class=es02 bgcolor=ffffff> 			
			<input type=button value="設為預設" onclick="set_main(this.form)";>
		</td>		
<% // } %>
        </form>
	</tr>

<%		
	}
%>
</table>
</td></tr></table>


</blockquote> 

<%@ include file="bottom.jsp"%>	