<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%!
    public String drawSelect(TagType tt, Map<Integer/*typeId*/, Vector<Tag>> tagv, String[] tagIds, StringBuffer title)
    {
        Vector<Tag> tv = tagv.get(new Integer(tt.getId()));
        if (tv==null)
            return "";
        StringBuffer ret = new StringBuffer();
        ret.append(tt.getName());
        ret.append("：<select name='tag'>");
        ret.append("<option value=-1>全部");
        for (int i=0; i<tv.size(); i++) {
            ret.append("<option value=" + tv.get(i).getId());
            for (int j=0; tagIds!=null&&j<tagIds.length; j++)
                if (tv.get(i).getId()==Integer.parseInt(tagIds[j])) {
                    ret.append(" selected");
                    if (title!=null) {
                        if (title.length()>0) title.append(",");
                        title.append(tv.get(i).getName());
                    }
                }
            ret.append(">" + tv.get(i).getName()); 
        }
        ret.append("</select>");
        return ret.toString();
    }

    public String getTagName(String[] tagIds, String taginfo, ArrayList<Tag> all_tags)
        throws Exception
    {
        if (tagIds==null && taginfo==null)
            return "全部";

        if (taginfo==null) {
            Map<Integer/*tagId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getId");
            StringBuffer sb = new StringBuffer();
            for (int i=0; i<tagIds.length; i++) {
                Vector<Tag> vt = tagMap.get(new Integer(Integer.parseInt(tagIds[i])));
                if (vt==null)
                    continue;
                Tag t = vt.get(0);
                if (sb.length()>0) sb.append("^");
                sb.append(t.getName());
            }
            return sb.toString();
        }
        else {
            String[] pairs = taginfo.split(",");
            StringBuffer names = new StringBuffer();
            for (int i=0; i<pairs.length; i++) {
                String[] tokens = pairs[i].trim().split("#");
                if (names.length()>0) names.append("+");
                names.append(tokens[1]);
            }
            return names.toString();
        }
    }
%>

<script>
function doSelect(ids, isAnd)
{
    if (ids==null || ids.length==0)
        return;
    var tags = ids.split(',');
    var text = '';
    for (var i=0; i<tags.length; i++) {
        var pairs = tags[i].split('#');
        var tagId = pairs[0];
        var tagName = pairs[1];
        if (text.length>0)
            text += ',';
        text += tagName;
    }
    SDIV = document.getElementById("tagselect");
    var htmlx = '搜尋範圍: ' + text + ' 等..(<a href="javascript:switchInput()">修改</a>)<br>(<a href="javascript:restore();">切換為原來選單</a>)';
    if (isAnd)
        htmlx += " <b>AND(交集)</b>";
    htmlx += "<input type=hidden name='_taginfos'>";
    SDIV.innerHTML = htmlx;
    var forms = document.forms;
    for (var i=0; i<forms.length; i++) {
        if (typeof forms[i]._taginfos!='undefined') {
            forms[i]._taginfos.value = ids;
            break;
        }
    }

    var forms = document.forms;
    for (var i=0; i<forms.length; i++) {
        if (typeof forms[i].isAnd!='undefined') {
            forms[i].isAnd.value = (isAnd)?1:0;
            break;
        }
    }
}

function switchInput()
{
    if (typeof parent.tagwin!='undefined' && !parent.tagwin.isClosed)
        parent.tagwin.show();
    else
        openwindow_phm2('tag_selection2.jsp','進階選擇',400,300,'tagwin')
}

function restore()
{
    document.getElementById("tagselect").innerHTML = __html;
}
  
<%
    
    String[] tagIds = request.getParameterValues("tag");
    String _taginfos = request.getParameter("_taginfos");
    String isAnd = request.getParameter("isAnd");
    EzCountingService __ezsvc = EzCountingService.getInstance();
    String studentIds = __ezsvc.getStudentIds(tagIds, _taginfos, isAnd);
    
    if (_taginfos!=null) {
        out.println("var __taginfos = '" + phm.util.TextUtil.escapeJSString(_taginfos) + "';");
        out.println("var __isAnd = "+((isAnd!=null&&isAnd.equals("1"))?"true":"false")+";");
    }
    else {
        out.println("var __taginfos = '';");
        out.println("var __isAnd = false;");
    }
%>

</script>
