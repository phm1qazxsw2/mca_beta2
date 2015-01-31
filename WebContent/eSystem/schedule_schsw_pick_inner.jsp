<%!
    Calendar getCalendarOf(Date month)
    {
        Calendar c = Calendar.getInstance();
        c.setTime(month);
        c.set(Calendar.DAY_OF_MONTH, 1);
        return c;
    }

    String getDayLabel(Calendar c)
    {
        String d = null;
        switch (c.get(Calendar.DAY_OF_WEEK)) {
            case 1: d = "日"; break;
            case 2: d = "一"; break;
            case 3: d = "二"; break;
            case 4: d = "三"; break;
            case 5: d = "四"; break;
            case 6: d = "五"; break;
            case 7: d = "六"; break;
        }

        return c.get(Calendar.DAY_OF_MONTH) + "<br>" + d;
    }
%>
<script>
function inColor()
{
    var divId = this.id;
    var d = document.getElementById(divId);
    d.style.background = "black";
}
function isTarget1(divId)
{
    return (divId.charAt(0)=='0');
}
function outColor()
{
    var divId = this.id;
    var d = document.getElementById(divId);
    d.style.background = (a[divId]==1)?d.targetColor:d.orgColor;
}
function doSelect()
{
    var divId = this.id;
    var d = document.getElementById(divId);
    if (a[divId]==0) {
        d.style.background = d.targetColor;
        a[divId]=1;
    }
    else {
        d.style.background = d.orgColor;
        a[divId]=0;
    }

    var count_0 = 0;
    var count_1 = 0;
    for (var i in a) {
        if (a[i]==1) {
            if (isTarget1(i)) {
                count_1 ++;
                count_0 --;
            }
            else {
                count_0 ++;
                count_1 --;
            }
        }
    }
    d = document.getElementById("count_0");
    d.innerHTML = count_0;
    d = document.getElementById("count_1");
    d.innerHTML = count_1;
}

function doSubmit()
{
    var r = '';
    for (var i in a) {
        if (a[i]==1) {
            if (r.length>0)
                r += ",";
            r += i;
        }
    }

    if (r.length==0) {
        alert("沒有任何更動");
        return;
    }

    var count_0 = 0;
    var count_1 = 0;
    for (var i in a) {
        if (a[i]==1) {
            if (isTarget1(i)) {
                count_1 ++;
                count_0 --;
            }
            else {
                count_0 ++;
                count_1 --;
            }
        }
    }
    if (count_0!=0 && count_1!=0) {
        if (!confirm("班表對換數目不同，確定？"))
            return;
    }

    document.f1.sw.value = r;
    document.f1.submit();
}

var a = new Array;
var h = new Array;
</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/addchangeschedule.png" border=0>&nbsp;換班
</font>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<center>

<br>
    <input type=hidden name="membrId1" value="<%=m1.getId()%>">
    <input type=hidden name="membrId2" value="<%=m2.getId()%>">
    <input type=hidden name="month" value="<%=sdf.format(month)%>">
    <input type=hidden name="sw">
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="white">
<%
    SchDefInfo sdfInfo = new SchDefInfo(schdefs);
    StringBuffer sbxx=new StringBuffer();

    // Making display labels A,B,C...
    Map<String, Integer> m = new LinkedHashMap<String, Integer> ();    
    Iterator<Integer> iterx = sdfInfo.getRootIterator();
    int ii=0;
    while (iterx.hasNext()) {
        Integer schdefRootId = iterx.next();
        StringBuffer sb = new StringBuffer();
        sb.append((char)(((int)'A')+ii));
        String name = sdfInfo.getName(schdefRootId);
        sbxx.append("<b>"+sb.toString() + "</b>:" + name + "&nbsp;");
        m.put(sb.toString(), schdefRootId);
        ii++;
    }
%>
        <div class=es02><%=sbxx.toString()%></div>
            <br>
        </td>
        </tr>
        <tr align=left valign=top>
        <td bgcolor="white">
            <table><tr class=es02>
<%
        for (int i=0; i<membrs.size(); i++) {
            Membr membr = membrs.get(i); 
          %> <td height=20><%=membr.getName()%></td><td width=20 height=20 id="membrcolor_<%=i%>"></td><td width=60><span id="count_<%=i%>">0</span></td><%
        }
%>
            <td><span id="submitbutton"></span></td>
          </tr></table> 
        </td>
        </tr>
<%
        for (int i=0; i<membrs.size(); i++) {
            Membr membr = membrs.get(i);
%>
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">
            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=center valign=middle>
                    <td colspan=2><%=(month.getMonth()+1)%><br>月</td>
<%
                c = getCalendarOf(month);
                while (c.get(Calendar.MONTH)==thisMonth) {
%>
                    <td><%=getDayLabel(c)%></td>
<%
                    c.add(Calendar.DATE, 1);
                }
%>
                </tr>              
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td rowspan=<%=schdefs.size()%>>
                        <%=membr.getName()%>                        
                    </td>
<%
            Iterator<String> iter2 = m.keySet().iterator();
            int j = 0;
            while (iter2.hasNext()) {
                String label = iter2.next();
                Integer schdefRootId = m.get(label); // 同一 root 的 schdef
                int which = 0;
                if (j>0) {
              %><tr bgcolor=#ffffff class=es02 align=left valign=middle><%
                }
%>
                    <td>
                        <%=label%>
                    </td>
<%
                c = getCalendarOf(month);
                while (c.get(Calendar.MONTH)==thisMonth) { 
                    SchDef d = sdfInfo.findApplied(schdefRootId, c.getTime());
                    String divId = "";
                    if (d!=null)
                        divId = i + "_" + d.getId()+"_"+c.get(Calendar.DAY_OF_MONTH);
                  %>
                    <td id="<%=divId%>" style="background:white">
                       <img src="images/spacer.gif" width=15>
                    </td>
<%                  c.add(Calendar.DATE, 1);
                }
%>              </tr>
<%              j ++;
            } %>
            </table>
        </td>
        </tr>
        <tr>
        <td height=30></td>
        </tr>
<%      } %>
    </table>

    </form>
</center>
</body>

