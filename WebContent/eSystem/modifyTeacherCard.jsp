<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    
    if(!checkAuth(ud2,authHa,700))
    {
        response.sendRedirect("authIndex.jsp?code=700");
    }

 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));

    String m=request.getParameter("m");

    if(m !=null && m.equals("1")){
%>
    <script>
        alert('設定成功,本卡將於隔日開始生效!');
    </script>
<%
    }
 
 	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
 
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId); 
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    Membr membr = MembrMgr.getInstance().find("type=" + Membr.TYPE_TEACHER + " and surrogateId=" + teacherId);
    CardMembrInfo ci=CardMembrInfoMgr.getInstance().find("membrId="+membr.getId()+" and active2=1");
%>
<script type="text/javascript" src="openWindow.js"></script>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>

    var rfid_url = "request_card.jsp";
    var cardNum1;
    var cardNum2;
    var machineId;
    var cardInfoId;
    function getNum1()
    {
        machineId = 'machineId in (<%=pd2.getCardmachine().replace("#", ",")%>)';
        SDIV = document.getElementById("showNum1");
        var url = rfid_url + "?m="+encodeURI(machineId)+"&r="+(new Date()).getTime();
        var req = new XMLHttpRequest();

        var showPic1=document.getElementById("showPic1");
        var showPic2=document.getElementById("showPic2");

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var xText=req.responseText;

                    if(xText.indexOf("##")>=0){
                        SDIV.innerHTML="發生錯誤! "+xText;
                    }else{

                        var xtext2=xText.split("#");
                        SDIV.innerHTML = xtext2[0];
                        cardInfoId=xtext2[1];
                        cardNum1=xtext2[0];
                        document.cardForm.cardNum1.value=xtext2[0];
                        document.fx.b1.disabled=true;
                        document.f2.b2.disabled=false;
                        showPic1.style.display="none";
                        showPic2.style.display="block";
                    }
                }
            }
        };
        req.open('GET', url);
        req.send(null);
    }


    function getNum2()
    {
        SDIV = document.getElementById("showNum2");

        var url = rfid_url + "?m="+machineId+"&r="+(new Date()).getTime()+"&cid="+cardInfoId;
        var req = new XMLHttpRequest();

        var showPic2=document.getElementById("showPic2");
        var showPic3=document.getElementById("showPic3");

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var xText=req.responseText;
                    var xtext3=xText.split("#");
                    if(xtext3[0]==-1)
                    {
                        alert('沒有資料,請重新刷卡.');
                    }else if(cardNum1 !=xtext3[0]){
                        alert('與第一次資料不同,請重新刷卡.');
                    }else{    

                        SDIV.innerHTML = xtext3[0];
                        cardNum2=xtext3[0];
                        document.f2.b2.disabled=true;
                        document.cardForm.b3.disabled=false;

                        showPic2.style.display="none";
                        showPic3.style.display="block";
                    }
                }
            }
        };
        req.open('GET', url);
        req.send(null);
    }

    function checkNum(){

        if(cardNum1==null || cardNum1.length<=0){
            alert('尚未偵測第一次感應卡號');
            return false;
        }
        if(cardNum2==null || cardNum2.length<=0){
            alert('尚未偵測第二次感應卡號');
            return false;
        }   
        if(cardNum1 !=cardNum2){
            
            alert('第一次與第二次的卡號不相同,請重新設定.');
            return false;
        }
        return true;
    }

    function changeMachine(midx){
        machineId=midx;
    }
</script>
<table width="100%" height="" border="0" cellpadding="8" cellspacing="0">
<tr align=left valign=top>
<td class=es02>

<%=(pd2.getCustomerType()==0)?"老師":"員工"%>:<font color=blue><b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b></font><br><br>
<a href="modifyTeacher.jsp?teacherId=<%=tea.getId()%>">基本資料</a>
 | 
<a href="modifyTeacherWork.jsp?teacherId=<%=tea.getId()%>">工作設定</a>
 | 
<a href="modifyTeacherFee.jsp?teacherId=<%=tea.getId()%>">勞健保設定</a> |
<a href="modifyTeacherAccount.jsp?teacherId=<%=tea.getId()%>">帳務資料</a> 
<% if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
| <a href="modifyTeacherUser.jsp?teacherId=<%=tea.getId()%>">登入設定</a>
| <a href="modify_outsourcing.jsp?teacherId=<%=tea.getId()%>">派遣對象</a>
<% } %>
| 感應卡設定
</td>
</tr>
</table>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 
<script>
    top.nowpage=7;
</script>
<%
    if(ci==null){

        String[] mid=pd2.getCardmachine().split("#");
%>
        <script>
            machineId=<%=mid[0]%>;
        </script>
    <blockquote><div class=es02>
    <table>
        <tr class=es02>
            <td>        
            <font color=red>尚未設定感應卡.</font>
            </td>
    <%  
          if(mid !=null && mid.length>1){
    %>
            
                    <form id=fx2 name=fx2>
                    <td>
                &nbsp;感應的機器編號:
                    </td>
                    <td>
                        <select size=1 onBlur="changeMachine(this.value)">
                        <%
                            for(int i=0;i<mid.length;i++){
                        %>
                            <option value="<%=mid[i]%>"><%=mid[i]%></option>
                        <%  }   %>
                        </select>
                    </td>
    <%      }   %>
                    <td width=40>
                    </td>
                    <td>
                    <a href="modifyTeacherCard.jsp?teacherId=<%=teacherId%>"><img src="pic/last.gif" border=0>&nbsp;重新設定</a>
                    </td>
    </tr>
        </table>                                
            </form>

        <table BORDER=1>
            <tr class=es02>
                <td class=es02 width=250 height=100>
                    <div id="showPic1">
                    <b>步驟一:在刷卡後,點選"讀取卡號"的按鈕</b>
                    <br>
                        <center>
                        <img src="pic/rfid.jpg" border=0>
                        </center>
                    </div>
                </tD>
               <form id=fx name=fx>
                <td> 
                    <input name="b1" type=button value="讀取卡號" onClick="getNum1()">
                </td>
                </form>
                <td width=150>
                    第一次感應的卡號: <div id='showNum1'>尚未讀取</div>
                </td>
            </tr>

            <tr>
                <td class=es02  height=100>
                        <div id="showPic2" style="display:none">                        
                            <b>步驟二:再刷卡一次,並點選"確認卡號"的按鈕</b><br>
                        <center>
                            <img src="pic/rfid.jpg" border=0>
                        </center>
                        </div>  
                </tD>
                <form id=f2 name=f2>
                <td> 
                    <input name="b2" type=button value="確認卡號" onClick="getNum2()">
                </td>
                </form>
                <td class=es02>
                    第二次感應的卡號: <div id='showNum2'>尚未讀取</div>
                </td>
            </tr>
            <tr>
                <td  height=100>
                        <div id="showPic3" style="display:none">                        
                            <b>步驟三:確認儲存</b><br>
                            <center>
                            <img src="pic/rfid2.jpg" border=0>
                            </center>
                        </div>  
                </td>
                <form id="cardForm" name="cardForm" action="modifyTeacherCard2.jsp" method="post" onSubmit="return(checkNum())">
                    <td>
                        <input type=hidden name="cardNum1" value="">
                        <input type=hidden name="membr" value="<%=membr.getId()%>">
                        <input type=hidden name="teacherId" value="<%=tea.getId()%>">
                        <input name=b3 type=submit value="確認儲存">
                    </td>    
                </form>
                <td>
                </tD>
            </tr>
            </table>       
        </blockquote>      

    </div>
    </blockquote>

    <script>
        document.f2.b2.disabled=true;
        document.cardForm.b3.disabled=true;
    </script>                 
<%
    }else{

        SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");
%>
    <blockquote>
    <div class=es02>
        <%
            if(ci.getCardId().indexOf("mm")==-1){
        %>
        <font color=blue>感應卡已設定</font>
        <%  }else{  %>
        <font color=blue>目前使用臨時卡</font>
        <%  }   %>    
        <br>
        <blockquote>
        卡號: <b><%=ci.getCardId()%></b><br><br>
        使用起始日期: <%=sdf2.format(ci.getCreated())%>
        </blockquote>
        <br>
        <a href="deleteTeacherCard.jsp?teacherId=<%=tea.getId()%>&cid=<%=ci.getId()%>&membrId=<%=membr.getId()%>"><img src="pic/fix.gif" width=12 border=0>&nbsp;設定使用新的卡片</a>
    </div>
    </blockquote>
<%  }   %>