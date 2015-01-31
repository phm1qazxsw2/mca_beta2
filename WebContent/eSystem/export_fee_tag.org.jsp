﻿<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%

    TagHelper thelper = TagHelper.getInstance(pd2, 0, _ws2.getSessionBunitId());
    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("feeId"));

    String filename = fee.getTitle().replace(" ","_");

   	response.setHeader("Content-disposition","inline; filename="+filename+"_tags.xls");
	response.setHeader("Content-disposition","attachment; filename="+filename+"_tags.xls"); 

    ArrayList<Tag> tags = ((McaTagHelper)thelper).getFeeTags(fee, _ws2.getStudentBunitSpace("bunitId"));
    ArrayList<TagType> types = new TagTypeMgr(0).retrieveListX("", "order by num asc", _ws2.getStudentBunitSpace("bunitId"));

    String tagIds = new RangeMaker().makeRange(tags, "getId");
    ArrayList<TagMembr> tms = new TagMembrMgr(0).retrieveList("tagId in (" + tagIds + ")", "");
    String membrIds = new RangeMaker().makeRange(tms, "getMembrId");
    ArrayList<McaStudent> mts = new McaStudentMgr(0).retrieveList("membrId in (" + membrIds + ")", "");

    Map<Integer, Tag> tagMap = new SortingMap(tags).doSortSingleton("getId");
    Map<Integer, ArrayList<TagMembr>> membrtagMap = new SortingMap(tms).doSortA("getMembrId");
%>
<html><body>
<table border=1 cellpadding=0 cellspacing=1>
<tr align=center bgcolor="#EEEEEE">
    <td>Student Name</td>
<%
    for (int i=0; i<types.size(); i++) {
        TagType tt = types.get(i);
%>
    <td><%=tt.getName()%></td>
<%
    }
%>
</tr>

<%
    for (int i=0; i<mts.size(); i++) {
        McaStudent ms = mts.get(i);
        tms = membrtagMap.get(ms.getMembrId());
%>
<tr>
    <td><%=ms.getFullName()%></td>
<%
        for (int j=0; j<types.size(); j++) {
            int typeId = types.get(j).getId();
            StringBuffer sb = new StringBuffer();
            for (int k=0; tms!=null && k<tms.size(); k++) {
                Tag t = tagMap.get(tms.get(k).getTagId());
                if (t.getTypeId()==typeId) {
                    if (sb.length()>0)
                        sb.append(",");
                    sb.append(t.getName());
                }
                
            }
%>
    <td nowrap><%=sb.toString()%>&nbsp;</td>
<%
        }
%>
</tr>
<%
    }
%>
</table>
</body></html>

