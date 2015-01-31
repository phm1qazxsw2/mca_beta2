<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%@ include file="leftMenu1.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=7");
    }

%>

<br>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>新增開徵項目</b>
<br>
<BR>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<table border=0 width=100%>
<tr width=100%>
    <td width=58% align=middle valign=top>             
<%

	String mo=request.getParameter("mo");
	Date d=new Date();
	
	int nowYear=d.getYear()+1900;
	int nowMonth=d.getMonth();
	
	String sMonth="";
	if(nowMonth<10)
		sMonth="0"+nowMonth;
	else
		sMonth=nowMonth+"";	
		
	JsfAdmin ja=JsfAdmin.getInstance();	
	
	IncomeSmallItem[] si=ja.getActiveIncomeSmallItemByBID(1);

	Classes[] cla=ja.getAllClasses();
	Talent[] tal=ja.getActiveTalent();


	String classesMoneyNameS=request.getParameter("classesMoneyName");
	String classesMoneyNumberS=request.getParameter("classesMoneyNumber"); 
	String categoryS=request.getParameter("category");
 	String tals=request.getParameter("tal");  
  
   	int talId=0;
   	
   	if(tals !=null) 
   	  	talId=Integer.parseInt(tals);	
 	
    
    int cate=1; 	
 	if(categoryS  !=null)
  	{
  		cate=Integer.parseInt(categoryS);
  	}
 	
%>
<%
	if(mo !=null) 
		out.println("<font color=red><b>修改已完成!!</b></font> <br>");
%>

<form action="addClassesMoney2.jsp" method="post">

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>開徵名稱</td>
		<td class=es02>
            <input type=text name="classesMoneyName" size=20 value="<%=(classesMoneyNameS!=null)?classesMoneyNameS:""%>" onKeyUp="javascript:showWord(this.value)">
            <a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=13',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
        </td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>英文名稱</td>
		<td class=es02>
            <input type=text name="classesMoneyFullName" size=20>
            <a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=14',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
        </td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>預設金額</td>
		<td>
            <input type=text name="classesMoneyNumber" size=10 value="<%=(classesMoneyNumberS==null)?"0":classesMoneyNumberS%>">
            <a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=15',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
        </td>

	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>會計科目</td>
		<td class=es02>
		<%
			if(si==null)
			{
				out.println("尚未編輯學費項目!!");
				out.println("</td></tr></table>");
				return;
			}
		%>
			<select name="smallItem" size=1>
		<%	
			for(int sx=0;sx<si.length;sx++)
			{
		%>
			<option value="<%=si[sx].getId()%>"><%=si[sx].getIncomeSmallItemName()%></option>
		
		<%
			}
		%>
			</select>
		
		</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>延續區間</td>
		<td class=es02>
		<input type="radio" name="cmContinue" value=0 checked>無
		<input type="radio" name="cmContinue" value=1>每一個月
		<input type="radio" name="cmContinue" value=2>每兩個月
		<input type="radio" name="cmContinue" value=3>每三個月
		<input type="radio" name="cmContinue" value=4>每半年
		<input type="radio" name="cmContinue" value=5>每一年
        <a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=17',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
		</td>
	</tr>
	
		<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>繳款單形式</td>
		<td class=es02>
		<input type="radio" name="newFeenumber" value=0 checked>月帳單
		<input type="radio" name="newFeenumber" value=1>獨立帳單
		<%
		ClassesMoney[] cms=ja.getActiveNewFeenumber();
		
		if(cms!=null){
		%>
		<input type="radio" name="newFeenumber" value=2>附屬帳單
		
		<select name=newFeenumberCMId size=1>
		<%
		for(int o=0;o<cms.length;o++){
		%>
			<option value="<%=cms[o].getId()%>"><%=cms[o].getClassesMoneyName()%></option>
		<%
			}
		%>
		</select>
		
		<%
		}
		%>
        <a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=16',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>    
		<br>
		</td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>開徵對象</td>
		<td>
			<table class=es02>
				<tr bgcolor=A9B0F6>
				<td><input type=radio name="category" value=1 <%=(cate==1)?"checked":""%>>班級 </td>
				<td><% if(tal!=null){%><input type=radio name="category" value=2 <%=(cate==2)?"checked":""%>><%}%>才藝班</td>
				<td><input type=radio name="category" value=3 <%=(cate==3)?"checked":""%>>個人收費 
                </td>
                
				</tr>
				<tr>
				<td valign=top>
                    <%
                    if(cla !=null)
                    {
                        for(int i=0;i<cla.length;i++)
                        { 
                    %>
                            <input type="checkbox" name="classesId" value="<%=cla[i].getId()%>"> <%=cla[i].getClassesName()%><br>
                    <%
                            ClsGroup[] groups = ja.getClsGroups(cla[i].getId(), false);
                            if (groups!=null) { 
                                for (int j=0; j<groups.length; j++) {
                    %>
                    <input type="checkbox" name="classesId" value="<%=cla[i].getId()+"#"+groups[j].getId()%>">
                        <%=cla[i].getClassesName()+"-" +groups[j].getName()%><br>			
                    <%			}
                            }
                        }
                    }    
                    %>
                    <input type="checkbox" name="classesId" value="0"> 未定<br>
			</td>
			<td class=es02 valign=top>
			
			<%
			if(tal !=null)
			{
				for(int j=0;j<tal.length;j++)
				{ 
			%>
				<input type="radio" name="talentId" value="<%=tal[j].getId()%>" <%=(talId==tal[j].getId())?"checked":""%>><%=tal[j].getTalentName()%><br>
			<%
			}
			
			}else{
				out.println("尚無加入才藝班");
			}
			%>
			</td>
			</tr>
			</table>
		</td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>說明</td>
		<td class=es02>
		<textarea rows=3 cols=40 name="classesMoneyPs"></textarea>
		</td>
	</tr>
	<tr><td colspan=2 class=es02><center>
		<input type=submit value="新增" onclick="javascript:return(confirm('確認新增此開徵項目 ?'))">
	</center></td>
	</tr>
</table>

</td></tr></table>
</form>
    
    </td>
    <td width=42% valign=top>

        <%
            Student[] stu=ja.getStatusStudyStudents(2,999,999,999,11);
            
            String value1="";
            String value2="";
            if(stu !=null)
            {   
                ClassesMgr cmm=ClassesMgr.getInstance();
                if(stu[0].getStudentClassId()==0)
                {    
                    value1="班級: 未定";
                }else{
                   Classes claC=(Classes)cmm.find(stu[0].getStudentClassId());
                   if(claC !=null)
                     value1="班級: "+claC.getClassesName();
                }
                
                value2="學生: "+stu[0].getStudentName();
            }
        %>    
        <table background="pic/bag2.gif" border=0 width=290>
            <tr>
                <td width=27 height=110></tD>
                <td width=73></tD>
                <td width=68></td>
                <td width=77></tD>
                <td width=20></tD>
            </tr>
            <tr>
                <td height=20></tD>
                <td colspan=2 align=middle><div class=es02><font size=2 color=red><b><%=pZ2.getPaySystemCompanyName()%></b></font></div></td>    
                <td width=77></tD>
                <td width=20></tD>
            </tr>
            <tr>
                <td width=27 height=100></tD>
                <td colspan=3 align=middle>
                    <%=value1%><br><%=value2%>
                </tD>
                <td width=20></tD>
            </tr>
<%
            ClassesMoney[] cm=ja.getAllClassesMoney(1);
            
            int runCM=3;
            
            if(cm!=null)
            {        
                if(cm.length <3)
                    runCM=cm.length;
            }else{
                runCM=0;
            }
%>
            <tr>
            <td width=27 height=20></tD>
                <td width=73></tD>
                <td width=68></td>
                <td width=77></tD>
                <td width=20></tD>
            </tr>
            <tr>
                <td width=27 height=33></tD>
                <td width=73 colspan=3><div id="showPalce"></div></tD>
                <td width=20></tD>
            </tr>
<%
        if(runCM !=0)
        {
            for(int k=0;k<runCM;k++)
            {
%>
            <tr>
                <td width=27 height=33></tD>
                <td width=73>&nbsp;<%=cm[k].getClassesMoneyName()%></tD>
                <td width=68></td>
                <td width=97></tD>
            </tr>
<%
            }
        }
        
        int runNot=3-runCM;

        if(runNot !=0)
        {
            for(int k=0;k<runNot;k++)
            {
%>
                <tr>
                    <td width=27 height=33></tD>
                    <td width=73>&nbsp;</tD>
                    <td width=68></td>
                    <td width=97></tD>
                </tr>
<%
            }        

        }
%>  
            <tr>
                    <td width=27 height=33></tD>
                    <td width=73>&nbsp;........</tD>
                    <td width=68></td>
                    <td width=97></tD>
                </tr>
    
            <tr>
                <td width=27 height=50></tD>
                <td width=73></tD>
                <td width=68></td>
                <td width=97></tD>
            </tr>
        </table>
    </tD>
</tr>
</table>

<script>
    function showWord(xWord)
    {   
        document.getElementById("showPalce").innerHTML=xWord;
    }

</script>


<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>

