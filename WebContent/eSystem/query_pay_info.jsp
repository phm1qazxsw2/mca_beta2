<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=2;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,104))
    {
        response.sendRedirect("authIndex.jsp?code=104");
    }
%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf3 = new SimpleDateFormat("MM/dd");

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    DecimalFormat mnf2 = new DecimalFormat("###,###.##");
    int total = (int)0;

    //long ago = -1;
    //try { ago = Long.parseLong(request.getParameter("ago")); } catch (Exception e) {}
    
    Date d2=new Date();
    String eDateS=sdf.format(d2);
    String endDateS=request.getParameter("eDate");
    if(endDateS !=null){
        eDateS=endDateS;      
        d2=sdf.parse(eDateS);
    }
    Date d1=new Date(new Date().getTime() - (7 * ((long)86400 * (long)1000)));
    String sDate=sdf.format(d1);
    String startDateS=request.getParameter("sDate");
    if(startDateS !=null){
        sDate=startDateS;
        d1=sdf.parse(sDate);
    }
    int via = -1;
    try { via = Integer.parseInt(request.getParameter("via")); } catch (Exception e) {}

   
    long endDateL=d2.getTime()+(long)1000*60*60*24;
    Date newEndDate=new Date(endDateL);

    String q="recordTime >='"+sdf.format(d1)+"' and recordTime < '"+sdf.format(newEndDate)+"' and amount!=0";
    
    if (via<0)
        q +=  " and via<10";
    else
        q += " and via=" + via;

    ArrayList<BillPayInfo> payinfos = BillPayInfoMgr.getInstance().
        retrieveListX(q, "order by recordTime asc, id asc", _ws.getBunitSpace("billpay.bunitId"));

    String payIds = new RangeMaker().makeRange(payinfos, "getId");
    ArrayList<Costpay2> costpays = Costpay2Mgr.getInstance().retrieveListX("costpayFeePayFeeID=" + 
        Costpay2.COSPAY_TYPE_TUITION + " and costpayStudentAccountId in (" + payIds + ")", "", _ws.getBunitSpace("bunitId"));
    Map<Integer, Costpay2> costpayMap = new SortingMap(costpays).doSortSingleton("getCostpayStudentAccountId");

    String myurl = "query_pay_info.jsp?" + request.getQueryString();
    String title = "收款查詢";
    if (startDateS!=null && endDateS!=null)
        title += "-" + sdf3.format(d1) + " to " + sdf3.format(d2);
    _ws.setBookmark(ud2, title);


    Object[] users2 = UserMgr.getInstance().retrieveX("", "", _ws.getBunitSpace("userBunitAccounting"));
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getId");

    String backurl = "query_pay_info.jsp?" + request.getQueryString();
%>
<script>
function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;
}

function checkDate(d) {
    var tokens = d.split("/");
    if (tokens.length!=3)
        return false;
    for (var i=0; i<tokens.length; i++) {
        if (!IsNumeric(tokens[i])) {
            return false;
        }
    }    
    if (tokens[0].length!=4 || tokens[1].length!=2 || tokens[2].length!=2) {
        return false;
    }
    return true;
}


function doSubmit(f)
{
    if (!checkDate(f.sDate.value)) {
        alert("開始日期格式錯誤");
        f.sDate.focus();
        return false;
    }
    if (!checkDate(f.eDate.value)) {
        alert("結束日期格式錯誤");
        f.eDate.focus();
        return false;
    }
    return true;
}

function calcSubtotal()
{
    var c = document.f.testcheck;
    if (typeof c=='undefined')
        return;
    var d = document.getElementById("calcsum");
    if (typeof c.length=='undefined' && c.checked) {
        var tokens = c.value.split("#");
        d.innerHTML = tokens[1];
        return;
    }
    var n = 0;
    var num = 0;
    for (var i=0; i<c.length; i++) {
        if (c[i].checked) {
            num ++;
            var tokens = c[i].value.split("#");
            n += eval(tokens[1]);
        }
    }
    d.innerHTML = n + " (" + num + "筆)";
}

function do_verify()
{
    document.f.action = "verify_pay_info.jsp";
    document.f.method = "post";
    document.f.submit();
}

function do_delete(payId)
{
    if (confirm('確定刪除此筆收款記錄?'))
        location.href = "payinfo_delete.jsp?pid=" + payId + "&backurl=<%=java.net.URLEncoder.encode(backurl)%>";
}
</script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<br>
<b>&nbsp;&nbsp;&nbsp;查詢繳費記錄</b>
 

<div class=es02>
<form name="xs" action="query_pay_info.jsp" method="get" onsubmit="return doSubmit(this)">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.xs.sDate,'yyyy/mm/dd',this);return false">開始日期:</a><input type=text name="sDate" value="<%=sDate%>" size=8>
&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.xs.eDate,'yyyy/mm/dd',this);return false">結束日期:</a><input type=text name="eDate" value="<%=eDateS%>" size=8>
&nbsp;&nbsp;付款方式: 
    <select name="via">
    <!-- 0: cash, 1: atm, 2:store, 3:check, 4:wire, 5:credit card -->
    <option value="-1" <%=(via==-1)?"selected":""%>>全部
    <option value="0" <%=(via==0)?"selected":""%>>臨櫃現金
    <option value="1" <%=(via==1)?"selected":""%>>銀行轉帳
    <option value="2" <%=(via==2)?"selected":""%>>便利商店
    <option value="3" <%=(via==3)?"selected":""%>>支票
    <option value="4" <%=(via==4)?"selected":""%>>匯款
    <option value="5" <%=(via==5)?"selected":""%>>信用卡
    </select>
    &nbsp;&nbsp;
    <input type=submit value="查詢">
</form>
</div>
 

<form name="f">
<input type=hidden name="backurl" value="<%=myurl%>">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<%    
        if (payinfos.size()==0) {
%>

        <blockquote>
            <div class=es02><font color=blue>沒有入帳記錄!</font>

            <br>
            <br>
            <font color=red>入帳說明:</font>
                <blockquote>
                    <li><b>便利商店繳款:</b> 入帳時間需要一~二個工作天</li><br><br>
                    <li><b>銀行轉帳(虛擬帳號轉帳):</b> <br>
                            &nbsp;&nbsp;&nbsp;&nbsp;非假日: 入帳時間需要半小時 ~ 一小時<br> 
                            &nbsp;&nbsp;&nbsp;&nbsp;假日: 入帳時間需要一個工作天.
                    </li>
                </blockquote>                
            </div>
            
            
            
        </blockquote>

        <%@ include file="bottom.jsp"%>
<%
            return;
        }
%>
<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap>繳費日期</td>
        <td align=middle>帳號</td>
        <td nowrap>
            方式
        </td>
        <td align=middle>金額</td>
        <td align=center>登入人</td>
        <td align=middle nowrap>對帳</td>
        <td></td>
		<td width=100 align=middle>登入日期</td>
        <td>備註</td>
	</tr>
<%
        int allTotal=0;
        String sourceIds = new RangeMaker().makeRange(payinfos, "getBillSourceId");
        ArrayList<BillSource> sourcelines = BillSourceMgr.getInstance().
            retrieveList("id in (" + sourceIds + ")", "");
        Map<Integer/*sourceId*/, Vector<BillSource>> sourceMap = new SortingMap(sourcelines).doSort("getId");

        Iterator<BillPayInfo> iter = payinfos.iterator();
        while (iter.hasNext()) {
            BillPayInfo b = iter.next();
            total += b.getAmount();
            int subtotal = b.getAmount();
            Calendar cal = Calendar.getInstance();
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02 align=center><%=sdf.format(b.getRecordTime())%></td>
        <td class=es02 nowrap><a href="bill_detail2.jsp?sid=<%=b.getMembrId()%>&poId=-1&backurl=<%=java.net.URLEncoder.encode(myurl)%>"><%=b.getMembrName()%></td>
        <td class=es02 nowrap>
            <%  
            if (b.getVia()==BillPay.VIA_INPERSON)
                out.println("臨櫃繳款");
            else if (b.getVia()==BillPay.VIA_ATM) {
                out.println("ATM繳款"); // we want to print the virtual account number as well
                Vector<BillSource> bsv = sourceMap.get(new Integer(b.getBillSourceId()));
                if (bsv!=null) {
                    BillSource bs = bsv.get(0);
                    try { // 臺新和聯邦的格式不同
                        String accountId = bs.getLine().substring(57,71);
                        out.println(" " + accountId);
                    } 
                    catch (Exception e) {
                        String accountId = bs.getLine().substring(21,30);
                        out.println(" " + accountId);
                    }
                }
            }
            else if (b.getVia()==BillPay.VIA_STORE) {
                String str = "便利商店代收 (" + sdf3.format(b.getRecordTime()) + " 繳款";
                if (pZ2.getBanktype()==1)
                    str += " 約加四工作天轉帳存入";
                str += ")";
                out.println(str);
            }
            else if (b.getVia()==BillPay.VIA_CHECK) {
                out.println("支票");
                if (b.getPending()==1) {
                    out.println(" <a href='query_cheque.jsp'>尚未兌現</a>");
                }
            }
            else if (b.getVia()==BillPay.VIA_WIRE) {
                out.println("轉帳");
            }
            else if (b.getVia()==BillPay.VIA_CREDITCARD) {
                out.println("信用卡");
            }
            else
                out.println("其他");

            allTotal+=b.getAmount();
            %>	
        </td>	
        <td align=right class=es02 nowrap>
        <%
            Costpay2 cp = costpayMap.get(b.getId());
            if (cp.getCostpayAccountType()>=4)
                out.println("(USD$ " + mnf2.format(cp.getOrgAmount()) + ")");
            out.println(mnf.format(b.getAmount()));
        %>
        <% if (b.getVerifyStatus()==BillPay.STATUS_NOT_VERIFIED) { %>
            <input type=checkbox name="testcheck" value="<%=b.getId()%>#<%=b.getAmount()%>" onclick="calcSubtotal()">
        <% } else { %>
           &nbsp;　&nbsp;
        <% } %>
        </td>
        <td align=center class=es02 nowrap>&nbsp;<%=(b.getUserId()==0)?"系統":getUserName(b.getUserId(), userMap)%>&nbsp;</td>  
        <td align=center nowrap class=es02>
        <%
            if (b.getVerifyStatus()==BillPay.STATUS_VERIFIED) {
                out.print(getUserName(b.getVerifyId(), userMap));
                out.print("("+sdf3.format(b.getVerifyDate())+")");
                //out.println("<br>" + sdf.format(b.getVerifyDate()));
                out.println("<br><a href='cancel_pay_verify.jsp?id=" + b.getId() + "&backurl="+java.net.URLEncoder.encode(myurl)+"'>取消</a>");
            }
            else 
                out.println("No");
        %>
        </td>
        <td class=es02 align=middle nowrap>
            <a href="javascript:openwindow_phm('pay_info.jsp?sid=<%=b.getMembrId()%>','繳費歷史',800,500,false);">帳戶明細</a>
        <% //if (b.getVerifyStatus()==BillPay.STATUS_NOT_VERIFIED && b.getUserId()==ud2.getId()) { %>
            &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp; <a href="javascript:do_delete(<%=b.getId()%>)">刪除</a>
        <% //} %>
        </td>
        <td class=es02><%=sdf.format(b.getCreateTime())%></td>
        <td class=es02 align=left nowrap>
            <a href="javascript:openwindow_phm('modify_billpay_note.jsp?pid=<%=b.getId()%>','編輯註解',300,200,true);"><img src="images/lockyes.gif" border=0 width=15 alt="編輯註記"></a>
            <%=(b.getNote()!=null)?b.getNote():""%>
        </td>        
    </tr>	
<%      } %>
    <tr class=es02>
        <td colspan=3 align=middle>
            本次查詢小計
        </td>       
        <TD align=right><b><%=mnf.format(allTotal)%></b></TD>
        <td colspan=3></td>
    </tr>

    </table> 

</td>
</tr>
</table>
</form>
</center>
<br>
<br>
<%@ include file="bottom.jsp"%>

<%!
    public String getUserName(int uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(new Integer(uid));
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }

%>
<!-- ############# fix window stuff below ################ -->
<script>
if (!document.layers)
document.write('<div id="divStayTopLeft" style="position:absolute">')
</script>

<layer id="divStayTopLeft">

<!--EDIT BELOW CODE TO YOUR OWN MENU-->
<div class=es02 align=middle>
<b>對帳小計:</b>
</div>

<table border=1 align=left width=80 bgcolor="#6B696B">
<tr><td align=center nowrap>
<font color="white"><span id="calcsum">0</span></font>
</td></tr></table>
<%
    if(checkAuth(ud2,authHa,106)){
%>
<input type=button value="確認" onclick="do_verify();">
<%
    }
%>
<!--END OF EDIT-->

</layer>


<script type="text/javascript">

/*
Floating Menu script-  Roy Whittle (http://www.javascript-fx.com/)
Script featured on/available at http://www.dynamicdrive.com/
This notice must stay intact for use
*/

//Enter "frombottom" or "fromtop"
var verticalpos="frombottom"

if (!document.layers)
document.write('</div>')

function JSFX_FloatTopDiv()
{
	var startX = 3,
	startY = 130;
	var ns = (navigator.appName.indexOf("Netscape") != -1);
	var d = document;
	function ml(id)
	{
		var el=d.getElementById?d.getElementById(id):d.all?d.all[id]:d.layers[id];
		if(d.layers)el.style=el;
		el.sP=function(x,y){this.style.left=x;this.style.top=y;};
		el.x = startX;
		if (verticalpos=="fromtop")
		el.y = startY;
		else{
		el.y = ns ? pageYOffset + innerHeight : document.body.scrollTop + document.body.clientHeight;
		el.y -= startY;
		}
		return el;
	}
	window.stayTopLeft=function()
	{
		if (verticalpos=="fromtop"){
		var pY = ns ? pageYOffset : document.body.scrollTop;
		ftlObj.y += (pY + startY - ftlObj.y)/8;
		}
		else{
		var pY = ns ? pageYOffset + innerHeight : document.body.scrollTop + document.body.clientHeight;
		ftlObj.y += (pY - startY - ftlObj.y)/8;
		}
		ftlObj.sP(ftlObj.x, ftlObj.y);
		setTimeout("stayTopLeft()", 10);
	}
	ftlObj = ml("divStayTopLeft");
	stayTopLeft();
}
JSFX_FloatTopDiv();
</script>