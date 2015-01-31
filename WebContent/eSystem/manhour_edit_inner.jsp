<script src="js/dateformat.js"></script>
<script src="js/formcheck.js"></script>
<script src="js/string.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function calcPrice(f)
{
    if (typeof f.charge=='undefined')
        return;
    if (!IsNumeric(trim(f.quant.value)))
        return;
    var s = f.charge;
    var str = s.options[s.selectedIndex].value;
    var tokens = str.split("_");
    eval("var p = tokens[3];");
    eval("f.total.value = p * f.quant.value;");
}

function setChargeItemId(id)
{
    if (id!=null) {
        document.f1.chargeItemId.value = id;
    }
    else if (typeof document.f1.charge!='undefined') {
        var s = document.f1.charge;
        var tokens = s.options[s.selectedIndex].value;
        document.f1.chargeItemId.value = tokens[2];
    }
}

function get_source_membr()
{
    if (typeof document.f1.executeMembrId=='undefined')
        return -1;
    else
        return document.f1.executeMembrId.value;
}

function set_month(mon)
{
    var m = document.f1.month;
    for (var i=0; i<m.options.length; i++) {
        if (m.options[i].value == mon) {
            m.selectedIndex = i;
            break;
        }
    }
}

function check_chargeitems(s)
{
    var month = s.options[s.selectedIndex].value;
    if (month.length==0)
        return;
    var url ="manhour_find_charge.jsp?d=" + encodeURI(month) + "&r=" + new Date().getTime();
    var req = new XMLHttpRequest();


    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var lines = trim(req.responseText).split("\n");
                var d = document.getElementById("charge");
                var stext = "<select name='charge' onchange='setChargeItemId();'>";
                stext += "<option value=''>-- 請選擇收費項目 --";
                for (var i=0; i<lines.length; i++) {
                    var tokens = lines[i].split(",");
                    // billitemId,billrecordId,chargeitemId,amount,name
                    stext += "<option value='" + tokens[0] + "_" + tokens[1] + "_" + tokens[2] + "_" + tokens[3] + "'>" + tokens[4]; // + " (" + tokens[3] + "元)";
                }
                stext += "</select>";
                d.innerHTML = stext;

                // see if need to point to some option
                s = document.f1.charge;
                for (var i=0; i<s.options.length; i++) {
                    var tokens = s.options[i].value.split("_");
                    if (tokens[2]==document.f1.chargeItemId.value) {
                        s.selectedIndex = i;
                        break;
                    }
                }                
                //calcPrice(document.f1);
            }
        }
    };
    req.open('GET', url);
    req.send(null);        
}

function doCheck(f)
{
    if (typeof f.executeMembrId=='undefined' || typeof f.executeMembrId.value=='undefined' || f.executeMembrId.value.length==0) {
        alert("尚未選擇上課人員");
        return false;
    }
    if (typeof f.target=='undefined' || typeof f.target.value=='undefined' || f.target.value.length==0) {
        alert("尚未選擇客戶");
        return false;
    }
    if (!isDate(f.occurDate.value, "yyyy/MM/dd")) {
        alert("請輸入正確的上課日期");
        f.occurDate.focus();
        return false;
    }

    var m = f.month;
    if (m.options[m.selectedIndex].value.length==0) {
        alert("請選擇入帳月費");
        return false;
    }

    var s = f.charge;
    if (typeof s=='undefined' || trim(s.options[s.selectedIndex].value).length==0) {
        alert("尚未選擇收費項目");
        return false;
    }

    var positive = true;
    if (!IsNumeric(f.quant.value, positive)) {
        alert("請輸入正確的數量");
        f.quant.focus();
        return false;
    }

    return true;
}

</script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK><SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<input type=hidden name="chargeItemId">

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr bgcolor=#ffffff align=left valign=middle> 
        <td valign=top width=30 align=middle>
        </td>            
        <td valign=top width=120 align=middle>
            <img src="img/abill.gif" border=0>
        </td>
        <td>
    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
<% if (ud2.getUserRole()<6) { %>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    上課人員
                    </td>
                    <td>
                        <% 
                            String field = "executeMembrId"; 
                            String extra = "";
                        %>
                        <%@ include file="manhour_source_setup.jsp"%>
                    </td>
                </tr>
<% } else { 
        MembrUser mu =  MembrUserMgr.getInstance().find("userId=" + ud2.getId());                       
%>
                <input type=hidden name="executeMembrId" value="<%=mu.getMembrId()%>">
<% } %>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    客戶
                    </td>
                    <td>
                        <% 
                            String field = "target"; 
                            String extra = "";
                        %>
                        <%@ include file="manhour_target_setup.jsp"%>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle> 
                    <td bgcolor=#f0f0f0 nowrap>
                    上課日期<br>
                    </td>
                    <td>
                        <br>
                        <input type=text name="occurDate" size=7>
                        <a href="#" onclick="displayCalendar(document.f1.occurDate,'yyyy/mm/dd',this);return false">選擇</a>
                        <br><br>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle> 
                    <td bgcolor=#f0f0f0 nowrap>
                    入帳月份<br>
                    </td>
                    <td>
                        <select name="month" onchange="check_chargeitems(this)">
                           <option value="">--請選擇--
                        <%
                           SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                           SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM");
                           Date now = sdf.parse(sdf.format(new Date()));
                           Calendar c = Calendar.getInstance();
                           c.setTime(now);
                           c.set(Calendar.DAY_OF_MONTH, 1);
                           c.add(Calendar.MONTH, -3);
                           for (int i=0; i<12; i++) {
                               Date d = c.getTime();
                               out.println("<option value='"+sdf.format(d)+"'>" + sdf2.format(d));
                               c.add(Calendar.MONTH, 1);
                           }
                        %>
                        </select>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    收費項目
                    </td>
                    <td>
                        <div id="charge"></div>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    數量
                    </td>
                    <td>
                        <input type=text name="quant" size=3> <!--<input type=text name="total" size=4 disabled> 元-->
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    備註
                    </td>
                    <td>
                        <textarea name="note" cols=30 rows=4><%=note%></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle>    
                        <div id="submit"></div>
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>

        </td>
    </tr>
</table>

</body>
