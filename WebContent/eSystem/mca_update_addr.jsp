<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script type="text/javascript" charset="UTF-8" src="js/mca_area.js?<%=new Date().getTime()%>"></script>
<script type="text/javascript" src="mca_area_def.jsp"></script>
<%
    int mid = Integer.parseInt(request.getParameter("mid"));
    McaStudent ms = McaStudentMgr.getInstance().find("id=" + mid);
    boolean isHomeAddr = request.getParameter("type").equals("1");

    String CountryID = (isHomeAddr)?ms.getCountryID():ms.getBillCountryID();
    if (CountryID.trim().length()==0)
        CountryID = "1001"; // 臺灣
    String CountyID = (isHomeAddr)?ms.getCountyID():ms.getBillCountyID();
    if (CountyID.trim().length()==0)
        CountyID = "1001";
    String CityID = (isHomeAddr)?ms.getCityID():ms.getBillCityID();
    String DistrictID = (isHomeAddr)?ms.getDistrictID():ms.getBillDistrictID();
    String PostalCode = (isHomeAddr)?ms.getPostalCode():ms.getBillPostalCode();
    String CStreet = (isHomeAddr)?ms.getChineseStreetAddress():ms.getBillChineseStreetAddress();
    String EStreet = (isHomeAddr)?ms.getEnglishStreetAddress():ms.getBillEnglishStreetAddress();
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
    function do_save()
    {
        var url = "mca_update_addr2.jsp";
        var post_params = 'mid=<%=mid%>&type=<%=request.getParameter("type")%>';
        var elements = document.f1.elements;
        for (var i=0; i<elements.length; i++) {
            post_params += '&';
            post_params += (elements[i].name + "=" + encodeURI(elements[i].value));
        }
        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var t = req.responseText.indexOf("@@");
                    if (t>0)
                        alert(req.responseText.substring(t+2));
                    else {
                        openwindow_inline("<div><br><br><center>saved..</center></div>", "Saved", 10, 10, "statuswin");
                        parent.update_addr(<%=request.getParameter("type")%>, <%=mid%>, req.responseText);
                        setTimeout("statuswin.hide();", 1000);
                    }                        
                }
                else if (req.readyState == 4 && req.status == 500) {
                    alert("查詢服務器時發生錯誤");
                    return;
                }
            }
        };
        req.open('POST', url);
        req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        req.setRequestHeader("Content-length", post_params.length);
        req.setRequestHeader("Connection", "close");
        req.send(post_params);
    }

    function do_ditto()
    {
        if (!confirm('This will clean the billing address, sure?'))
            return;

        var url = "mca_update_addr3.jsp?mid=<%=mid%>";

        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var t = req.responseText.indexOf("@@");
                    if (t>0)
                        alert(req.responseText.substring(t+2));
                    else {
                        openwindow_inline("<div><br><br><center>saved..</center></div>", "Saved", 10, 10, "statuswin");
                        parent.update_addr(3, <%=mid%>, null);
                        setTimeout("statuswin.hide(); parent.addrwin.hide();", 1000);
                    }                        
                }
                else if (req.readyState == 4 && req.status == 500) {
                    alert("查詢服務器時發生錯誤");
                    return;
                }
            }
        };
        req.open('GET', url);
        req.send(null);
    }

    function init() {
        var ad = new addr('<%=CountryID%>', '<%=CountyID%>', '<%=CityID%>', '<%=DistrictID%>', '<%=PostalCode%>', 
            '<%=phm.util.TextUtil.escapeJSString(CStreet)%>', '<%=phm.util.TextUtil.escapeJSString(EStreet)%>');
        var d1 = document.getElementById("d1");
        var d2 = document.getElementById("d2");
        var d3 = document.getElementById("d3");
        var d4 = document.getElementById("d4");
        var d5 = document.getElementById("d5");
        var d6 = document.getElementById("d6");
        var d7 = document.getElementById("d7");
        ad.draw(d1, d2, d3, d4, d5, d6, d7);
    }
</script>
<body onload="init()">
<center>
<b><%=(isHomeAddr)?"Home":"Billing"%> Address</b>
<form name=f1 action="mca_update_addr2.jsp">
  <table height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    <table>
                    <tr>
                      <td> Country </td>
                      <td><span id="d1"></span></td>
                    </tr>
                    <tr>
                      <td> County </td>
                      <td><span id="d2"></span></td>
                    </tr>
                    <tr>
                      <td> City </td>
                      <td><span id="d3"></span></td>
                    </tr>
                    <tr>
                      <td> District </td>
                      <td><span id="d4"></span></td>
                    </tr>
                    <tr>
                      <td> Chinese Street </td>
                      <td><span id="d5"></span></td>
                    </tr>
                    <tr>
                      <td> Eng. Street </td>
                      <td><span id="d6"></span></td>
                    </tr>
                    <tr>
                      <td> PostCode </td>
                      <td><span id="d7"></span></td>
                    </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=button value="儲存" onclick="do_save()">
<% if (!isHomeAddr) { %>
                <input type=button value="Same as Home Address" onclick="do_ditto()">
<% } %>
                </td>
            </tr>
        </table>
    </td>
    </tr>
</table>
</form>
</center>