<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="topMenu.jsp"%>
<%
	JsfAdmin ja=JsfAdmin.getInstance();
	int stuId=Integer.parseInt(request.getParameter("stuId"));
	String pMonth=request.getParameter("pMonth");
	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(stuId);
	
	ClassesFee[] cf=ja.getClassesFeeByStuId(stuId);
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	
%>


<table width="100%" height="873" border="1">
  <tr> 
    <td width="40%" height="867" align="left" valign="middle"> 
      <table width="100%" height="883" border="0">
        <tr>
          <td width="10%" height="879"> 
            <p>第</p>
            <p>三</p>
            <p>聯</p>
            <p>:</p>
            <p>園</p>
            <p>方</p>
            <p>收</p>
            <p>執</p>
            <p>聯</p>
      </td>
          <td width="90%"><table width="95%" height="671" border="0">
              <tr> 
                <td height="25" colspan="4"> 
                  <div align="center"><b>幼稚園繳費單</b></div></td>
              </tr>
              <tr> 
                <td width="17%" height="27">地址</td>
                <td colspan="3">新店市明德路65巷5號</td>
              </tr>
              <tr> 
                <td height="17">電話</td>
                <td colspan="3">02-29110883</td>
              </tr>
              <tr> 
                <td height="21">姓名</td>
                <td width="30%"><%=stu.getStudentName()%></td>
                <td width="20%">班別</td>
                <td width="33%">
                <%
                	int stuCla=stu.getStudentClassId();
                	ClassesMgr clas=ClassesMgr.getInstance();
                	Classes cla=(Classes)clas.find(stuCla);	
                	out.println(cla.getClassesName());
                %>
                </td>
              </tr>
              <tr> 
                <td height="20">年月</td>
                <td><%=pMonth%></td>
                <td>連續號</td>
                <td></td>
              </tr>
              <tr> 
                <td height="491" colspan="4"> 
                  <table width="105%" height="362" border="1">
                    <tr> 
                      <td width="32%">收費內容</td>
                      <td width="22%">應繳</td>
                      <td width="25%">已繳</td>
                      <td width="21%">備註</td>
                    </tr>
       <% 
        String printMonth="";
	int total=0;
        int totalPay=0;
        for(int i=0;i<cf.length;i++)
	{
		ClassesMoney cmx=(ClassesMoney)cmm.find(cf[i].getClassesFeeCMId());
		int payTotal=ja.getPayFeeNumber(cf[i].getId(),stuId);
		int shouldPay=cf[i].getClassesFeeShouldNumber()-payTotal;
		total +=shouldPay;
        %>
                    <tr> 
                      <td height="129"><%=cmx.getClassesMoneyName()%></td>
                      <td><%=cf[i].getClassesFeeShouldNumber()%></td>
                      <td><%=payTotal%></td>
                      <td>&nbsp;</td>
                    </tr>
	<%
	
			totalPay +=payTotal;
		}
	%>

                    <tr> 
                      <td height="49"> 
                        <p>合計費用</p>
                        <p>本期已繳</p></td>
                      <td><%=totalPay%></td>
                      <td>前期尚欠</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="27">合計應收:</td>
                      <td colspan="3"><%=total%></td>
                    </tr>
                    <tr> 
                      <td height="96">&nbsp;</td>
                      <td colspan="3"><table width="111%" border="0">
                          <tr>
                            <td width="55%">銀行別</td>
                            <td width="45%">到期日</td>
                          </tr>
                          <tr>
                            <td>支票號碼</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td height="54">金額</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            <p>1 貴家長接到通知後,請於五號前繳費,以便行政作業.<br>
              2 收據於當(次)日發給,請家長務必向園方索取收據.<br>
              3 貴家長對於繳費若有任何疑問,請來電洽詢.<br>
              謝謝你的配合！</p>
            <p>所長： 　　　經手人：<br>
              收費日 <br>
            </p>
            </td>
        </tr>
      </table>
      
    </td>
    <td width="40%" height="867" align="left" valign="middle"> 
      <table width="100%" height="883" border="0">
        <tr>
          <td width="10%" height="879"> 
            <p>第</p>
            <p>二</p>
            <p>聯</p>
            <p>:</p>
            <p>學</p>
            <p>童</p>
            <p>繳</p>
            <p>費</p>
            <p>收</p>
      	    <p>據</p>	
      </td>
          <td width="90%"><table width="95%" height="671" border="0">
              <tr> 
                <td height="25" colspan="4"> 
                  <div align="center"><b>幼稚園繳費單</b></div></td>
              </tr>
              <tr> 
                <td width="17%" height="27">地址</td>
                <td colspan="3">新店市明德路65巷5號</td>
              </tr>
              <tr> 
                <td height="17">電話</td>
                <td colspan="3">02-29110883</td>
              </tr>
              <tr> 
                <td height="21">姓名</td>
                <td width="30%"><%=stu.getStudentName()%></td>
                <td width="20%">班別</td>
                <td width="33%">
                <%
                	
                	out.println(cla.getClassesName());
                %>
                </td>
              </tr>
              <tr> 
                <td height="20">年月</td>
                <td><%=pMonth%></td>
                <td>連續號</td>
                <td></td>
              </tr>
              <tr> 
                <td height="491" colspan="4"> 
                  <table width="105%" height="362" border="1">
                    <tr> 
                      <td width="32%">收費內容</td>
                      <td width="22%">應繳</td>
                      <td width="25%">已繳</td>
                      <td width="21%">備註</td>
                    </tr>
       <% 
     
        for(int i=0;i<cf.length;i++)
	{
		ClassesMoney cmx=(ClassesMoney)cmm.find(cf[i].getClassesFeeCMId());
		int payTotal=ja.getPayFeeNumber(cf[i].getId(),stuId);
		int shouldPay=cf[i].getClassesFeeShouldNumber()-payTotal;
		total +=shouldPay;
        %>
                    <tr> 
                      <td height="129"><%=cmx.getClassesMoneyName()%></td>
                      <td><%=cf[i].getClassesFeeShouldNumber()%></td>
                      <td><%=payTotal%></td>
                      <td>&nbsp;</td>
                    </tr>
	<%
	
			totalPay +=payTotal;
		}
	%>

                    <tr> 
                      <td height="49"> 
                        <p>合計費用</p>
                        <p>本期已繳</p></td>
                      <td><%=totalPay%></td>
                      <td>前期尚欠</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="27">合計應收:</td>
                      <td colspan="3"><%=total%></td>
                    </tr>
                    <tr> 
                      <td height="96">&nbsp;</td>
                      <td colspan="3"><table width="111%" border="0">
                          <tr>
                            <td width="55%">銀行別</td>
                            <td width="45%">到期日</td>
                          </tr>
                          <tr>
                            <td>支票號碼</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td height="54">金額</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            <p>1 貴家長接到通知後,請於五號前繳費,以便行政作業.<br>
              2 收據於當(次)日發給,請家長務必向園方索取收據.<br>
              3 貴家長對於繳費若有任何疑問,請來電洽詢.<br>
              謝謝你的配合！</p>
            <p>所長： 　　　經手人：<br>
              收費日 <br>
            </p>
            </td>
        </tr>
      </table>
      
    </td>
    <td width="40%" height="867" align="left" valign="middle"> 
      <table width="100%" height="883" border="0">
        <tr>
          <td width="10%" height="879"> 
           <p>第</p>
            <p>一</p>
            <p>聯</p>
            <p>:</p>
            <p>學</p>
            <p>童</p>
            <p>繳</p>
            <p>費</p>
            <p>通</p>
      	    <p>知</p>	
      	   <p>單</p>	
      </td>
          <td width="90%"><table width="95%" height="671" border="0">
              <tr> 
                <td height="25" colspan="4"> 
                  <div align="center"><b>幼稚園繳費單</b></div></td>
              </tr>
              <tr> 
                <td width="17%" height="27">地址</td>
                <td colspan="3">新店市明德路65巷5號</td>
              </tr>
              <tr> 
                <td height="17">電話</td>
                <td colspan="3">02-29110883</td>
              </tr>
              <tr> 
                <td height="21">姓名</td>
                <td width="30%"><%=stu.getStudentName()%></td>
                <td width="20%">班別</td>
                <td width="33%">
                <%
                	
                	out.println(cla.getClassesName());
                %>
                </td>
              </tr>
              <tr> 
                <td height="20">年月</td>
                <td><%=pMonth%></td>
                <td>連續號</td>
                <td></td>
              </tr>
              <tr> 
                <td height="491" colspan="4"> 
                  <table width="105%" height="362" border="1">
                    <tr> 
                      <td width="32%">收費內容</td>
                      <td width="22%">應繳</td>
                      <td width="25%">已繳</td>
                      <td width="21%">備註</td>
                    </tr>
       <% 
      
        for(int i=0;i<cf.length;i++)
	{
		ClassesMoney cmx=(ClassesMoney)cmm.find(cf[i].getClassesFeeCMId());
		int payTotal=ja.getPayFeeNumber(cf[i].getId(),stuId);
		int shouldPay=cf[i].getClassesFeeShouldNumber()-payTotal;
		total +=shouldPay;
        %>
                    <tr> 
                      <td height="129"><%=cmx.getClassesMoneyName()%></td>
                      <td><%=cf[i].getClassesFeeShouldNumber()%></td>
                      <td><%=payTotal%></td>
                      <td>&nbsp;</td>
                    </tr>
	<%
	
			totalPay +=payTotal;
		}
	%>

                    <tr> 
                      <td height="49"> 
                        <p>合計費用</p>
                        <p>本期已繳</p></td>
                      <td><%=totalPay%></td>
                      <td>前期尚欠</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="27">合計應收:</td>
                      <td colspan="3"><%=total%></td>
                    </tr>
                    <tr> 
                      <td height="96">&nbsp;</td>
                      <td colspan="3"><table width="111%" border="0">
                          <tr>
                            <td width="55%">銀行別</td>
                            <td width="45%">到期日</td>
                          </tr>
                          <tr>
                            <td>支票號碼</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td height="54">金額</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            <p>1 貴家長接到通知後,請於五號前繳費,以便行政作業.<br>
              2 收據於當(次)日發給,請家長務必向園方索取收據.<br>
              3 貴家長對於繳費若有任何疑問,請來電洽詢.<br>
              謝謝你的配合！</p>
            <p>所長： 　　　經手人：<br>
              收費日 <br>
            </p>
            </td>
        </tr>
      </table>
      
    </td>
  </tr>
</table>