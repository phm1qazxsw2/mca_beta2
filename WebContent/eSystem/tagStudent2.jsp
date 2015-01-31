<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>

<link rel="stylesheet" href="style.css" type="text/css">
<%
        String[] stuIds=request.getParameterValues("stuId");
        String tagContent=request.getParameter("tagContent");
        int grid=Integer.parseInt(request.getParameter("grid"));

        int heiEach=Integer.parseInt(request.getParameter("heiEach"));
        int weiEach=Integer.parseInt(request.getParameter("weiEach"));
        int topWidth=Integer.parseInt(request.getParameter("topWidth"));
        int bottomWidth=Integer.parseInt(request.getParameter("bottomWidth"));
        int leftWidth=Integer.parseInt(request.getParameter("leftWidth"));
        int rightWidth=Integer.parseInt(request.getParameter("rightWidth"));
        int fsize=Integer.parseInt(request.getParameter("fsize"));

        if(stuIds ==null || stuIds.length <=0)
        {
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/pdf.gif" border=0>&nbsp;<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>貼標製作</b> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="formIndex.jsp"><img src="pic/last.gif" border=0>&nbsp;回表單中心</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

            <br>
            <br>
            <blockquote>
                <div class=es20>        
                尚未選擇名單.<BR><BR>  <a href="#" onClick="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上頁</a>
                </div>    
            </blockquote>

            <%@ include file="bottom.jsp"%>
<%
            return;      
        }

        int[] marge={leftWidth,rightWidth,topWidth,bottomWidth};

        StringBuffer sb = new StringBuffer();
        for (int i=0; i<stuIds.length; i++) {
            if (i>0) sb.append(",");
            sb.append(stuIds[i]);
        }

        String[] runContent=new String[stuIds.length];
        ArrayList<Student2> students = Student2Mgr.getInstance().retrieveList("id in (" + sb.toString() + ")", "");
        ArrayList<TagStudent> tagstudents = TagStudentMgr.getInstance().retrieveList("student.id in (" + sb.toString() + ")", "");
        Map<Integer/*studentId*/, Vector<TagStudent>> studentTagMap = new SortingMap(tagstudents).doSort("getStudentId");
        ArrayList<Tag> alltags = TagMgr.getInstance().retrieveListX("","",_ws.getStudentBunitSpace("bunitId"));
        Map<Integer/*studentId*/, Vector<Tag>> tagMap = new SortingMap(alltags).doSort("getId");
       
        Iterator<Student2> iter = students.iterator();
        ArrayList<TagType> tt = TagTypeMgr.getInstance().retrieveListX("", "", _ws.getStudentBunitSpace("bunitId"));
        

        int xx=0;
        while (iter.hasNext()) {
            String nowContent="";
            Student2 stu=iter.next();
            nowContent=tagContent.replaceAll("#name#",stu.getStudentName());
            nowContent=nowContent.replaceAll("#post#",stu.getStudentZipCode());
            nowContent=nowContent.replaceAll("#address#",stu.getStudentAddress());
            nowContent=nowContent.replaceAll("#client1#",stu.getStudentFather());
            nowContent=nowContent.replaceAll("#client2#",stu.getStudentMother());

            Iterator<TagType> titer = tt.iterator();
            while (titer.hasNext()) { 
                    String tagString="";
                    TagType tp = titer.next();                    
                    String xtag="#tag"+tp.getId()+"#";
                    
                    Vector tagStu=(Vector)studentTagMap.get((Integer)stu.getId());                           
                    for(int k=0;tagStu !=null && k< tagStu.size();k++)
                    {
                        TagStudent ts=(TagStudent)tagStu.get(k);

                        if(tp.getId()==ts.getTypeId())
                        {
                            Vector tagx=(Vector)tagMap.get((Integer)ts.getTagId()); 

                            for(int j=0; tagx !=null && j<tagx.size(); j++)
                            {
                                Tag xtag2=(Tag)tagx.get(j);
                                tagString+=" "+xtag2.getName();
                            }  
                            //out.println(stu.getStudentName()+" "+tagString+"<br>");
                        }
                    }
                
                nowContent=nowContent.replaceAll("#tag"+tp.getId()+"#",tagString);
            }

            runContent[xx]=nowContent;
            xx++;
        }

        String path=application.getRealPath("/")+"eSystem/pdf_example/";
        PdfMaker pm=PdfMaker.getInstance();
        
        String xFile=String.valueOf((new Date()).getTime());
        int x=pm.makeTagPage(path,runContent,weiEach,heiEach,grid,marge,xFile,fsize);
%>
<br>


 <b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/pdf.gif" border=0>&nbsp;<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>貼標製作</b> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<br>
    <blockquote>
        <div class=es02>
            檔案已產生!<br><br>
            <a href="pdf_example/tag/<%=xFile%>.pdf"><img src="pic/pdf.gif" border=0>下載檔案</a>
        </div>
    </blockquote>

<%@ include file="bottom.jsp"%>