<span id="tagselect">
<%
    StringBuffer _title = new StringBuffer();
    Iterator<TagType> ttiter = all_tagtypes.iterator();
    int __i=0;
    while (ttiter.hasNext()) {
        if ((__i%6)==5)
            out.println("<br>");
        TagType tt = ttiter.next();
     %><%=drawSelect(tt, tagMap, tagIds, _title)%> <%
        __i++;
    }
%>
&nbsp;&nbsp;<a href="javascript:switchInput()">進階選擇</a>
</span>
<input type=hidden name="isAnd" value="0">

<script>
var __html = document.getElementById("tagselect").innerHTML;
doSelect(__taginfos, __isAnd);
</script>