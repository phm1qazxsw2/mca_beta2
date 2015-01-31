<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    SchDef sd = SchDefMgr.getInstance().find("id=" + id);
    String name = sd.getName();
    Date startDate = sd.getStartDate();
    Date endDate = sd.getEndDate();

    Calendar c=Calendar.getInstance();
    c.setTime(endDate);
    c.add(Calendar.DATE,1);
    Date endDate2=c.getTime();

    int type = sd.getType();
    String content = sd.getContent();
    String color = sd.getColor();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<SchDefMembr> membrlist = SchDefMembrMgr.getInstance().retrieveList("schdefId=" + sd.getId(), "");
    String membrNames = new RangeMaker().makeRange(membrlist, "getMembrName");
    if (membrNames.equals("-1"))
        membrNames = "(沒有人)";

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws2.getBunitSpace("buId"));

    int bunit=sd.getBunitId();

%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;
<b><img src="pic/schedule.png" border=0>&nbsp;<%=sd.getName()%>-複製此班表</b>
</div><br>

        <div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="schedule_detail.jsp?id=<%=id%>">基本資料</a> | 複製此班表 | <a href="listScheventByDefId.jsp?id=<%=id%>">缺勤紀錄</a>
        </div>  

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<form action="schedule_detail_copy2.jsp" method="post" name="f1" id="f1"  onsubmit="return doSubmit();">
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr bgcolor=#ffffff align=left valign=middle> 
        <td valign=top width=30 align=middle>
        </td>            
        <td>
    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de" nowrap>
                <table width="100%" border=0 cellpadding=4 cellspacing=1>

                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    班表
                    </td>
                    <td>
<%
    if(b !=null && b.size()>=0){
%>
    部門: <select name="bunit" size=1>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>跨部門</option>
            </select>
<%
    }else{
%>
        <input type=hidden name="bunit" value="0">
<%  }   %>
                    名稱:<input type=text name="name" value="<%=phm.util.TextUtil.encodeHtml(name)%>">
                    &nbsp;&nbsp;
       </td>
        </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0 nowrap>
                    有效區間
                    </td>
                    <td>
                    <a href="#" onclick="displayCalendar(document.f1.startDate,'yyyy/mm/dd',this);return false">起始日:</a>
                    <input type=text name="startDate" value="<%=sdf.format(endDate2)%>" size=7> 
                    <a href="#" onclick="displayCalendar(document.f1.endDate,'yyyy/mm/dd',this);return false">至 : </a> 
                    <input type=text name="endDate" value="" size=7>
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
                    <td>
                        <%=(sd.getAutoRun()==1)?"正常班 (缺勤主動比對)":"加班 (出勤時間對比)"%>
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
                    <td colspan=2 align=middle class=es02 bgcolor=ffffff class=es02>
                    <input type=hidden name="id" value="<%=id%>">    
                    <input type=submit value="複製">      
                    </tD>
                    </form>
                </tr>
            </table>
            </td>
            </tr>
            </table>
            <br>

<script src="js/dateformat.js"></script>
<script>

    function doSubmit()
    {
        if (!isDate(document.f1.startDate.value, 'yyyy/MM/dd')) {
            alert("請輸入正確的起始日期");
            document.f1.startDate.focus();
            return false;
        }
        if (!isDate(document.f1.endDate.value, 'yyyy/MM/dd')) {
            alert("請輸入正確的結束日期");
            document.f1.endDate.focus();
            return false;
        }
        
        if (document.f1.endDate.value<=document.f1.startDate.value) {
            alert("結束日期不可小於起始日期");
            document.f1.endDate.focus();
            return false;
        }

        return true
    }

</script>
