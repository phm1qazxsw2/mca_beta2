<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,mca.*" contentType="text/javascript;charset=UTF-8"%>

function area(code, cname, ename, level, parentcode)
{
    this.code = code;
    this.cname = cname;
    this.ename = ename;
    this.level = level;
    this.parentcode = parentcode;
}

function draw_country(code)
{
    var r = '<select name="CountryID" onchange="">';
    for (var i=0; i<countries.length; i++) {
        r += '<option value='+countries[i].code+'>' + countries[i].cname;
    }
    r += '</select>';
    return r;
}

function addr(cId, tId, yId, rId, pCode, cSt, eSt)
{
    this.cId = cId;
    this.tId = tId;
    this.yId = yId;
    this.rId = rId;
    this.pCode = pCode;
    this.cSt = cSt;
    this.eSt = eSt;
    this.draw = function(d1, d2, d2, d4, d5, d6, d7) {
        d1.innerHTML = draw_country(this.cId);
        //d2.innerHTML = draw_county(this.tId);
        //d3.innerHTML = draw_city(this.yId);
        //d4.innerHTML = draw_district(this.rId);
        //d5.innerHTML = draw_cstreet(this.pCode);
        //d6.innerHTML = draw_estreet(this.cSt);
        //d7.innerHTML = draw_postcode(this.eSt);
    }
}
var countries = new Array;
var counties = new Array;
var cities = new Array;
var districts = new Array;
<%
    Map<Integer, ArrayList<Area>> areaMap = new SortingMap(AreaMgr.getInstance().retrieveList("", "")).
        doSortA("getLevel");

    ArrayList<Area> countries = areaMap.get(0);
    ArrayList<Area> counties = areaMap.get(1);
    ArrayList<Area> cities = areaMap.get(2);
    ArrayList<Area> districts = areaMap.get(3);

    for (int i=0; i<countries.size(); i++) {
        Area a = countries.get(i);
%>countries[countries.length] = new area('<%=a.getCode()%>','<%=phm.util.TextUtil.escapeJSString(a.getCName())%>', '<%=phm.util.TextUtil.escapeJSString(a.getEName())%>', <%=a.getLevel()%>, '<%=a.getParentCode()%>');
<%
    }

    for (int i=0; i<counties.size(); i++) {
        Area a = counties.get(i);
%>counties[counties.length] = new area('<%=a.getCode()%>','<%=phm.util.TextUtil.escapeJSString(a.getCName())%>', '<%=phm.util.TextUtil.escapeJSString(a.getEName())%>', <%=a.getLevel()%>, '<%=a.getParentCode()%>');
<%
    }

    for (int i=0; i<cities.size(); i++) {
        Area a = cities.get(i);
%>cities[cities.length] = new area('<%=a.getCode()%>','<%=phm.util.TextUtil.escapeJSString(a.getCName())%>', '<%=phm.util.TextUtil.escapeJSString(a.getEName())%>', <%=a.getLevel()%>, '<%=a.getParentCode()%>');
<%
    }

    for (int i=0; i<districts.size(); i++) {
        Area a = districts.get(i);
%>districts[districts.length] = new area('<%=a.getCode()%>','<%=phm.util.TextUtil.escapeJSString(a.getCName())%>', '<%=phm.util.TextUtil.escapeJSString(a.getEName())%>', <%=a.getLevel()%>, '<%=a.getParentCode()%>');
<%
    }
%>
