<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%!
    public String drawSelect(TagType tt, Map<Integer/*typeId*/, Vector<Tag>> tagv, String[] tagIds)
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
                if (tv.get(i).getId()==Integer.parseInt(tagIds[j]))
                    ret.append(" selected");
            ret.append(">" + tv.get(i).getName()); 
        }
        ret.append("</select>");
        return ret.toString();
    }
%>
<%
    int topMenu=4;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">

<style type="text/css">
div.tableContainer {
	width: 95%;		/* table width will be 99% of this*/
	height: 450px; 	/* must be greater than tbody*/
	overflow: auto;
	margin: 0 auto;
	}

.table2 {
	width: 99%;		/*100% of container produces horiz. scroll in Mozilla*/
	border: none;
	background-color: #ffffff;
	}
	
.table2>tbody	{  /* child selector syntax which IE6 and older do not support*/
	overflow: auto; 
	height: 250px;
	overflow-x: hidden;
	}
	
.thead2 tr	{
	position:relative; 
	top: expression(offsetParent.scrollTop); /*IE5+ only*/
	}
	
.thead2 td, thead th {
	text-align: center;
	background-color: f0f0f0;
    font-family: Verdana, Arial, Helvetica, Geneva, 新細明體, mingliu, taipei; 
    font-size: 12px; 
    line-height:120% ; 
    color: #3c3c3c;
	border-top: solid 1px #d8d8d8;
	}	
	
.td2	{
	color: #000;
	padding-right: 2px;
	font-size: 12px;
	text-align: right;
	border-bottom: solid 1px #d8d8d8;
	border-left: solid 1px #d8d8d8;
	}
	
.table2 tfoot tr { /*idea of Renato Cherullo to help IE*/
      position: relative; 
      overflow-x: hidden;
      top: expression(parentNode.parentNode.offsetHeight >= 
	  offsetParent.offsetHeight ? 0 - parentNode.parentNode.offsetHeight + offsetParent.offsetHeight + offsetParent.scrollTop : 0);
      }


.tfoot2 td	{
	text-align: center;
	font-size: 11px;
	font-weight: bold;
	background-color: papayawhip;
	color: steelblue;
	border-top: solid 1px slategray;
	}

.td2:last-child {padding-right: 20px;} /*prevent Mozilla scrollbar from hiding cell content*/

</style>

<%
String modidied=request.getParameter("m");

if(modidied !=null){
%>
<script>
    alert('修改完成!');
</script>

<%
}

String ttIdS=request.getParameter("ttId");

int ttId=0;
if(ttIdS !=null)
    ttId=Integer.parseInt(ttIdS);

String[] tagIds = request.getParameterValues("tag");

JsfAdmin ja=JsfAdmin.getInstance();
ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws.getStudentBunitSpace("bunitId"));
ArrayList<Tag> all_tags = TagMgr.getInstance().retrieveListX("","", _ws.getStudentBunitSpace("bunitId"));
Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

int status=2;
try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception e) {}
%>

<link rel="stylesheet" href="css/ajax-tooltip-student-tag.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}
//  End -->

</script>

</head>


<br>
<div class=es02>
 <b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/redfix.png" border=0>&nbsp;進階<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>標籤設定</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="studentoverview.jsp"><img src="pic/last.gif" border=0>&nbsp回上一頁</a>
</div>
<blockquote>
<form action="modify_student_tag.jsp" method="get">
<div class=es02>
<B>編輯名單:</B> 狀態
    <select name="status">
        <option value="999" <%=(status==999)?"selected":""%>>全部</option>
        <option value="1" <%=(status==1)?"selected":""%>>潛在<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%></option>
        <option value="2" <%=(status==2)?"selected":""%>><%=(pZ2.getCustomerType()==0)?"就讀學生":"合作客戶"%></option>
        <%    if(pZ2.getCustomerType()==0){   %>
        <option value="3" <%=(status==3)?"selected":""%>>離校學生-畢業校友</option>
        <option value="4" <%=(status==4)?"selected":""%>>離校學生-中途離校</option>    
        <option value="5" <%=(status==5)?"selected":""%>>離校學生-未入學</option>    
        <%  }else{  %>
        <option value="4" <%=(status==4)?"selected":""%>>無合作客戶</option>    
        <%  }   %>
    </select>

<%
            Iterator<TagType> ttiter = all_tagtypes.iterator();
            while (ttiter.hasNext()) {
                TagType tt = ttiter.next();
             %><img src="images/spacer.gif" width=10><%=drawSelect(tt, tagMap, tagIds)%><%
            }

    ttiter = all_tagtypes.iterator();
%>
    <br>
    <b>編輯標籤類型:</b>
    <select name="ttId">
        <option value="0" <%=(ttId==0)?"selected":""%>>全部</option>        
<%    
    while (ttiter.hasNext()) {
        TagType tt = ttiter.next();
%>
        <option value="<%=tt.getId()%>" <%=(ttId==tt.getId())?"selected":""%>><%=tt.getName()%></option>
<%
    }
%>
    </select>
	<input type=submit value="查詢">
</div>
</form>
</blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm('membrtag_add.jsp','建立新的標籤',300,300,true);"><img src="pic/add.gif" border=0>&nbsp;建立新的標籤</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
 <%

    EzCountingService ezsvc = EzCountingService.getInstance();
    String statusStr ="";
    switch(status){
        case 1:
            statusStr="studentStatus in (1,2)"; 
            break;
        case 2:
            statusStr="studentStatus in (3,4)"; 
            break;
        case 3:
            statusStr="studentStatus in (97,98,99)"; 
            break;
    }

    Student[] st = ezsvc.searchStudent("", tagIds, 1, statusStr, _ws.getStudentBunitSpace("bunitId"));
	if(st==null)
	{
%>
    <br>
    <blockquote>

        <div class=es02>開始查詢!</font>

    </blockquote>

<br>
<%@ include file="bottom.jsp"%>	
<%	
	return;
}

    String query="";
    if(ttId !=0 )
        query="typeId='"+ttId+"'";

    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().retrieveList("studentStatus in (3,4)","");
    Map<Integer,Vector<TagMembrStudent>> m = new SortingMap(tagstudents).doSort("getTagId");
    ArrayList<Tag> alltags = TagMgr.getInstance().retrieveList(query,"order by typeId asc");
    Iterator<Tag> iter = alltags.iterator();    
    String tagString="";
    for(int k=0;tagIds !=null && k<tagIds.length;k++){
        if(k!=0)
           tagString+="##";

        tagString+=tagIds[k];
    }
%>


<center>
<form action="modify_student_tag2.jsp" method="post" name="xform">
<center>
        <input type=hidden name="tagString" value="<%=tagString%>">
        <input type=hidden name="statusStr" value="<%=statusStr%>">
        <input type=submit value="確認儲存">
&nbsp;&nbsp;






<div class="tableContainer">
    <table width="100%" class="table2">
        <thead class="thead2">

          <tr class="tr2">
			<td align=middle width=60>
                學生姓名
            </td>
            <td align=middle>
                狀態設定
            </td>
            <%
            Hashtable ha=new Hashtable();
            while (iter.hasNext()) {
                Tag tag = iter.next();
                Vector<TagMembrStudent> v = m.get(new Integer(tag.getId()));
                
                for(int i=0;v!=null && i<v.size();i++)
                {
                    TagMembrStudent stm=(TagMembrStudent)v.get(i);
                    String xword=String.valueOf(stm.getStudentId())+"##"+String.valueOf(stm.getTagId());
                    ha.put((String)xword,(TagMembrStudent)stm);
                }    

                //int size = (v==null)?0:v.size();
            %>
                <td align=middle width=50>
                <%=tag.getName()%>
                </td>
            <%
            }
            %>
		</tr>	
        </thead>
        <tbody>
<%
for(int i=0;i<st.length;i++)
{

    Membr mem = MembrMgr.getInstance().find("type=" + Membr.TYPE_STUDENT + " and surrogateId="+ st[i].getId());
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td width=60 class=es02>
                <a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a>
            </td>
            <td class=es02 nowrap>
            <% 
            int status2=st[i].getStudentStatus();
            if(status2 <=3)
            {
			%>
                <input type=radio name="status<%=st[i].getId()%>" value=1 <%=(status2==1)?"checked":""%>>參觀登記/上網登入
				<input type=radio name="status<%=st[i].getId()%>" value=2 <%=(status2==2)?"checked":""%>>報名/等待入學<br>
                <input type=radio name="status<%=st[i].getId()%>" value=3  <%=(status2==3)?"checked":""%>>試讀

            <%  }   
            %>
                <input type=radio name="status<%=st[i].getId()%>" value=4  <%=(status2==4)?"checked":""%>>入學
            <%
				if(status2 >=4)
				{
			%>
                <input type=radio name="status<%=st[i].getId()%>" value="99" <%=(status2==99)?"checked":""%>>畢業    
                <input type=radio name="status<%=st[i].getId()%>" value=97 <%=(status2==97)?"checked":""%>>離校
            <%  }   %>

            <%
				if(status2 <=2)
				{
			%>
                <input type=radio name="status<%=st[i].getId()%>" value=98 <%=(status2==98)?"checked":""%>>未入學    
            <%  }   %>

            </td>
            <%
            iter = alltags.iterator();    

            //Iterator<Tag>   iter2 = alltags.iterator();   
            while (iter.hasNext()) {
                Tag tag = iter.next();  
                String search=String.valueOf(st[i].getId())+"##"+String.valueOf(tag.getId());
                TagMembrStudent tm=(TagMembrStudent)ha.get(search);
                String tooltipURL = "show_student_tag.jsp?m=" + mem.getName() + "&n=" + tag.getName();
        %>
                <td align=middle class=es02>
            <%                
                if(tm !=null){
            %>
                    <input type=checkbox name="nowtag" value="<%=mem.getId()%>##<%=tag.getId()%>" checked>
            <%  
                }else{
            %>
                    <input type=checkbox name="nowtag" value="<%=mem.getId()%>##<%=tag.getId()%>">
            <%
                }
            %>
            </td>
            <%   
            }
            %>
        </tr>
<%
}
%>
    </tbody>
    </table>
    </div>

<center>
        <input type=hidden name="ttId" value="<%=ttId%>">
        <input type=submit value="確認儲存">
        </form>
    </center>
    <br>
    <br>
<%@ include file="bottom.jsp"%>