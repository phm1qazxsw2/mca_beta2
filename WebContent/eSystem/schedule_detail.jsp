<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    SchDef sd = SchDefMgr.getInstance().find("id=" + id);
    String name = sd.getName();
    Date startDate = sd.getStartDate();
    Date endDate = sd.getEndDate();
    int type = sd.getType();
    String content = sd.getContent();
    String color = sd.getColor();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<SchDefMembr> membrlist = SchDefMembrMgr.getInstance().retrieveList("schdefId=" + sd.getId(), "");
    String membrNames = new RangeMaker().makeRange(membrlist, "getMembrName");

    String m=request.getParameter("m");

    if(m !=null && m.equals("1")){
%>
    <script>
        alert('複製成功.');
    </script>
<%
    }

    if(m !=null && m.equals("2")){
%>
    <script>
        alert('新增成功.');
    </script>
<%
    }


    if (membrNames.equals("-1"))
        membrNames = "(沒有人)";
%>

<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;
<b><img src="pic/schedule.png" border=0>&nbsp;<%=sd.getName()%>-基本資料</b>
</div><br>

        <div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;基本資料 |  <a href="schedule_detail_copy.jsp?id=<%=id%>">複製此班表</a> | <a href="listScheventByDefId.jsp?id=<%=sd.getId()%>">缺勤紀錄</a>
        </div>  

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
            <center>
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de" nowrap>
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    班表名稱
                    </td>
                    <td>
                        <%   
                        if(sd.getBunitId()!=0){

                            Bunit bb=BunitMgr.getInstance().find(" id='"+sd.getBunitId()+"'");
                            if(bb !=null)
                                out.println(bb.getLabel()+"-");
                        }
                        %>
                        <%=name%>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    有效區間
                    </td>
                    <td>
                    <%=sdf.format(startDate)%>
                    至 
                    <%=sdf.format(endDate)%>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    設定類型
                    </td>
                    <td class=es02>
                        <%  switch(sd.getType()){
                                case SchDef.TYPE_EVERYDAY:
                                    out.println("有效區間的每一天");
                                    break;
                                case SchDef.TYPE_DAY_OF_WEEK:
                                    out.println("每周的某幾天");
                                    break;
                                case SchDef.TYPE_DAY_OF_MONTH:
                                    out.println("每月的某幾天");
                                    break;
                            }    

                        %>                            
                    </tD>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    時間
                    </td>
                    <td class=es02>
                        <b><%=content%></b>
                        <br><br>
                    格式說明:&nbsp;&nbsp;<font color=blue>日期</font> ,&nbsp;&nbsp;<font color=blue>開始時分</font>-<font color=blue>結束時分</font>,<font color=blue>休息分鐘</font>,<font color=blue>遲到緩衝分鐘</font><br>

                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                        班表模式
                    </td>
                    <td class=es02>
                        <%
                            switch(sd.getAutoRun()){
                                case 0:
                                    out.println("加班 (出勤時間對比)");
                                    break;
                                case 1:
                                    out.println("正常班 (缺勤主動比對)");
                                    break;
                            } 
                        %>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    顏色
                    </td>
                    <td>
                    <script src="201a.js" type="text/javascript"></script>
                    <input type="text" ID="sample_1" size="1" value="">
                    <script>document.getElementById("sample_1").style.background = '<%=color%>';</script>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    名單
                    </td>
                    <td>
                    <%=membrNames%>
                    </td>
                </tr>
                <tr>
                    <form action="schedule_modify.jsp" method="get">
                    <td colspan=2 align=middle class=es02 bgcolor=ffffff class=es02>
            <%  
                Date d = new Date();

                if (sd.getAutoRun()==0 || d.compareTo(sd.getEndDate())<0) {                 
          %>
                    <input type=hidden name="id" value="<%=id%>">    
                    <input type=submit value="修改此班表及名單">      
                    <%
                    if (d.compareTo(sd.getStartDate())>0) { %> 
                        <br>
                        <b>**修改後的起始日會從明天開始生效，今天和之前的不會改變.</b>
                    <%
                    }
                }else {
          %>            
                        <br>
                        <div class=es02>
                        <b>班表已到期,無法修改</b>  <br><br>
                        <%
                        if(sd.getNewestId() !=0){
                        %>                            
                        <a href="schedule_detail.jsp?id=<%=sd.getNewestId()%>">前往最新的子班表</a>
                        <%  }   %>
                        </div>
            <%
                }
            %>
                    </tD>
                    </form>
                </tr>
            </table>
            </td>
            </tr>
            </table>
            </center>

<%
        if (d.compareTo(sd.getEndDate())<0) {                 
            if(membrlist==null || membrlist.size()<=0){
%>
        <div class=es02 align=right>            
         <a href="deleteSchDef.jsp?id=<%=id%>" onClick="return(confirm('確認刪除此班表?'))"><img src="pic/no2.gif" border=0> 刪除此班表</a>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
<%
            }
        }
%>