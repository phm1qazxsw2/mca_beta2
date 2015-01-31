<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,600))
    {
        response.sendRedirect("authIndex.jsp?code=600");
    }
%>
<%@ include file="leftMenu4.jsp"%>
<%
    TagHelper thelper = TagHelper.getInstance(pZ2, 0, _ws.getSessionBunitId()); // 這里給的 bunit 是 收費有關的
    ArrayList<Tag> tags = thelper.getTags(false, "", _ws.getStudentBunitSpace("bunitId"));

    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(tags).doSort("getTypeId");
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","order by num asc",_ws.getStudentBunitSpace("bunitId"));
    Map<Integer, Vector<TagType>> typeMap = new SortingMap(types).doSort("getId");
    int studentNum = StudentMgr.getInstance().numOfRowsX("studentStatus in (3,4)",_ws.getStudentBunitSpace("bunitId"));
    _ws.setBookmark(ud2, "學生總覽");
    String listUrl = "listStudent.jsp";
%>

<script>
function open_editor(tid) {
    openwindow_phm2('tag_editor.jsp?tid='+tid+"&from=1",'標籤名單編輯',800,600,'tageditorwin');
}
</script>

<br>

<b>&nbsp;&nbsp;&nbsp;
<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>總覽</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<form>
<%
    if(checkAuth(ud2,authHa,601)){
%>
    <a href="addStudent.jsp"><img src="pic/add.gif" border=0 width=12>&nbsp;新增<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%></b></a>  
<%
    }
    if(checkAuth(ud2,authHa,602)){
%>
|
    <a href="studentoverview.jsp"><img src="pic/tagtype2.png" border=0>&nbsp;<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>標籤設定</a>
<%  }   

    if(checkAuth(ud2,authHa,603)){
%>
    | <a href="formIndex.jsp"><img src="pic/excel2.png" border=0>&nbsp;表單中心</a>
<%  }   %>　　
</form>
<div class=es02 align=right>
合計就讀學生:<a href="<%=listUrl%>"><%=studentNum%></a> 人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<table class=es02 border=0 width=88%>

<%
    DecimalFormat nf = new DecimalFormat("###,##0.00");
    Iterator<TagType> iter = types.iterator();

    boolean runTag=false;
    
    while (iter.hasNext()) {

        runTag=true;
        TagType type = iter.next();
        Vector<Tag> tags2 = tagMap.get(new Integer(type.getId()));
        if (tags2==null)
            continue;
%>
        <tr class=es02 height=20>
            <td align=left valign=middle>

                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b><%=type.getName()%></b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
<%  /* 不用這種編輯了
    if(checkAuth(ud2,authHa,602)){
%>
                        <a href="modify_student_tag.jsp?status=2&ttId=<%=type.getId()%>">
                            &nbsp;<font color=white>編輯標籤名單</font>
                        </a>
<%  } */  %>  
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
<%
        StringBuffer sb=new StringBuffer();
        int totalNum=0;
        String chlStringa="";
        String tStringa="";
        String tagIds = new RangeMaker().makeRange(tags2, "getId");
        ArrayList<TagStudent> students = TagStudentMgr.getInstance().retrieveListX(
            "tag.id in (" + tagIds + ") and studentStatus in (3,4)", "", _ws.getStudentBunitSpace("student.bunitId"));
        Map<Integer/*tagId*/, Vector<TagStudent>> tagstudentMap = new SortingMap(students).doSort("getTagId");
        Map<Integer/*studentId*/, Vector<TagStudent>> studentTagMap = new SortingMap(students).doSort("getStudentId");
        for (int i=0; i<tags2.size(); i++) {
            Tag tag = tags2.get(i);
            Vector<TagStudent> v = tagstudentMap.get(new Integer(tag.getId()));  
            if(v !=null)         
                totalNum+=v.size();           
        }

        int startChara=64;
        sb.append("<table width=\"95%\" height=\"\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr align=left valign=top><td bgcolor=\"#e9e3de\"><table width=\"100%\" border=0 cellpadding=4 cellspacing=1><tr bgcolor=#f0f0f0 class=es02><td align=middle nowrap>標籤名稱</td><td align=middle>人數</td><td></td></tr>");


       
        for (int i=0; i<tags2.size(); i++){

            int tagname=i+1;
            
            if(tagname>7)
                tagname=tagname%7;
    
            Tag tag = tags2.get(i);
            startChara++;
            Vector<TagStudent> v = tagstudentMap.get(new Integer(tag.getId()));           
            if(startChara !=65)
            {
                chlStringa+="|";
                tStringa+=",";
            }
            
            float fPercent=(float)0.0;
            if(v !=null)
                fPercent=((float)v.size()/(float)totalNum)*100;
            String percentX=nf.format(fPercent);

            tStringa+=String.valueOf((int)fPercent);
            chlStringa+=(char)startChara;

            int xsize=0;
            if(v !=null)
                xsize=v.size();
                sb.append("<tr bgcolor=ffffff class=es02><td><table width=100% border=0><tr class=es02><td width=80%  nowrap> <img src=pic/tag"+tagname+".png border=0>&nbsp;"+(char)startChara+": <a href=\"javascript:openwindow_phm2('tag_version.jsp?tid="+tag.getId()+"','標籤版本',800,400);\">"+tag.getName()+"</a></td><td width=20% align=right></td></tr></table></td><td align=right><a href=\"javascript:open_editor("+tag.getId()+")\">"+xsize+"</a></td><tD align=middle><a target=_blank href=\""+listUrl+"?status=-1&tag=" + tag.getId()+ "&searchWord=\">詳細名單</a></td></tr>");
        }
        sb.append("</table></td></tr></table>");

        //<a href=\"studentFrame.jsp?status=-1&tag="+tag.getId()+"&searchWord=\" target=\"_blank\"><img src=\"pic/littleE.png\" border=0>快速編輯</a>
%>
        <table width=100% border=0>
            <tr>
                <td width=40%>
<% 
    Esystem esys=(Esystem) ObjectService.find("jsf.Esystem", "id=1");
    if (esys.getEsystemShowCash()==1) { %>
<a href="<%=listUrl%>?status=-1">
 <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tStringa%>&chs=300x100&chl=<%=chlStringa%>" border=0>
</a>
<%  } %>
                </td>
                <td width=60%>
                    <%=sb.toString()%>
                </td>
            </tr>
        </table>

            </td>
        </tr>
        <tr bgcolor="#f0f0f0" class=es02>

            <td align=right>
            <b><% //sdf.format(month)%> </b>

            &nbsp;<b>標籤加總人數:</b>  <%=totalNum%> 人&nbsp;&nbsp;&nbsp;  <B>實際總人數:</B> <%=studentTagMap.size()%> 人&nbsp;&nbsp;&nbsp;
            </td>
            <!--<td align=right></td>-->
        </tr>
    <%
    }

    ArrayList<TagMembrStudent> students = TagMembrStudentMgr.getInstance().retrieveListX(
        "(tag.id=0 or tag.id is NULL) and studentStatus in (3,4)", "", _ws.getStudentBunitSpace("student.bunitId"));
    int xsize2=0;
    if(students.size()>0) {
        //Map<Integer/*tagId*/, Vector<TagStudent>> tagstudentMap = new SortingMap(students).doSort("getTagId");
        //Map<Integer/*studentId*/, Vector<TagStudent>> studentTagMap = new SortingMap(students).doSort("getStudentId");
    %>
    
        <tr class=es02 height=20>
            <td align=left valign=middle>

                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>未定標籤</b></font>
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
<%  

            StringBuffer sb2=new StringBuffer();
        
            sb2.append("<table width=\"95%\" height=\"\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr align=left valign=top><td bgcolor=\"#e9e3de\"><table width=\"100%\" border=0 cellpadding=4 cellspacing=1><tr bgcolor=#f0f0f0 class=es02><td align=middle>標籤名稱</td><td align=middle>人數</td><td></td></tr>");       


            sb2.append("<tr bgcolor=ffffff class=es02><td><table width=100% border=0><tr class=es02><td width=80% >未加入標籤</td><td width=20% align=right></td></tr></table></td><td align=right>"+students.size()+"</td><tD align=middle>");

            if(!runTag)
                sb2.append("<a href="+listUrl+">詳細名單</a> | ");       

            sb2.append("<a href=membr_student_detail.jsp?tid=0>編輯標籤</a> | ");

            if(runTag)
                sb2.append("<a href=\"javascript:openwindow_phm('sendGroupMessage.jsp?tagId=0','發送標籤簡訊',650,400,true);\">發送簡訊</a></td></tr>");
     
            sb2.append("</table></td></tr></table>");
%>
        <table width=100% border=0>
            <tr>
                <td width=40%>

                </td>
                <td width=60%>
                    <%=sb2.toString()%>
                </td>
            </tr>
        </table>

            </td>
        </tr>
        <tr bgcolor="#f0f0f0" class=es02>

            <td align=right>
            <b><% //sdf.format(month)%> </b>

            &nbsp;<B>實際總人數:</B> <%=students.size()%>人&nbsp;&nbsp;&nbsp;
            </td>
            <!--<td align=right></td>-->
        </tr>
<%
        }
%>

    </table>            
</blockquote>
</ul>
<br>
<br>
<br>

<%@ include file="bottom.jsp"%>