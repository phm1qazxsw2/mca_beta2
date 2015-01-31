<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%!
    public String getTagURI(String[] tagIds)
    {
        if (tagIds==null)
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<tagIds.length; i++) {
            sb.append("&tag=");
            sb.append(tagIds[i]);
        }
        return sb.toString();
    }

    public Student[] searchStudent(String searchWord, String space)
    {
        String orderString = "";
        String query ="";
        /*
        if (tagId>0) 
            query += " and tagmembr.tagId=" + tagId;
        else
            orderString = " group by student.id " + orderString; // elminate multiple entries of one student
        */
        if(searchWord !=null && searchWord.length()>=1)
        {
            query+=" (studentName like '%"+searchWord+"%'";            
            query+=" or studentFatherMobile like '%"+searchWord+"%'";
            query+=" or studentFatherMobile2 like '%"+searchWord+"%'"; 
            query+=" or studentMotherMobile like '%"+searchWord+"%'";                        
            query+=" or studentMotherMobile2 like '%"+searchWord+"%'";
            query+=" or studentPhone like '%"+searchWord+"%'";
            query+=" or studentPhone2 like '%"+searchWord+"%'";
            query+=" or studentPhone2 like '%"+searchWord+"%'";
            query+=" )";
        }

        StudentMgr smgr = StudentMgr.getInstance();
        Object[] objs = smgr.retrieveX(query, orderString, space);
        
        if (objs==null || objs.length==0)
            return null;

        Student[] ret = new Student[objs.length];
        for (int i=0; i<objs.length; i++)
            ret[i] = (Student) objs[i];
        return ret;
    }

    public Map<Integer/*studentId*/,Vector<Membr>> getMembrMap(Student[] st)
        throws Exception
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<st.length; i++) {
            if (i>0) sb.append(",");
            sb.append(st[i].getId());
        }
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("surrogateId in (" + sb.toString() + ")", "");
        return new SortingMap(membrs).doSort("getSurrogateId");
    }

%>
<%
    String num=request.getParameter("num");
%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%
    int topMenu=14;
    int leftMenu=14;
    JsfAdmin ja=JsfAdmin.getInstance();
    JsfPay jp=JsfPay.getInstance();

    String[] tagIds={"",""};
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu14.jsp"%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;新增客服記錄</b>

<form action="serviceRecord.jsp" method="post">
&nbsp;&nbsp;&nbsp;請輸入查詢的電話或姓名:<input type=text name="num" value="<%=(num !=null && num.length()>0)?num:""%>">
    <input type=submit value="查詢">
</form>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<%
    if(num==null || num.length()<=0)
    {
%>
        <blockquote>
            <div class=es02>
            請填入電話或姓名.
            </div>
        </blockquote>
        <%@ include file="bottom.jsp"%>
<%        
        return;
    }
    Student[] st=searchStudent(num.trim(), _ws.getStudentBunitSpace("bunitId"));
    if(st==null)
    {
%>
       <blockquote>
            <div class=es02>
            沒有<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>資料.
            </div>
        </blockquote>
<% 
   }else{
        
        Map<Integer/*studentId*/, Vector<Membr>> membrMap = getMembrMap(st);
%>
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr  bgcolor=#f0f0f0  class=es02 cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
        <td width="70" align=middle><%=(pZ2.getCustomerType()==0)?"學生姓名":"客戶名稱"%></td>
        <td align=middle nowrap><%=(pZ2.getCustomerType()==0)?"父親":"負責人"%></td>
        <td align=middle>手機</td>
        <td align=middle nowrap><%=(pZ2.getCustomerType()==0)?"母親":"聯絡人"%></td>
        <td align=middle>手機</td>
        <td align=middle>家中電話</td>
        <td></td>
    </tr>
<%
        for(int i=0;i<st.length;i++){
%>
        <tr class=es02 bgcolor=ffffff>
            <td><%=st[i].getStudentName()%></td>

            <%
                if(st[i].getStudentEmailDefault()!=0){
            %>

                    <td class=es02 nowrap>
                        <%
                        if(st[i].getStudentEmailDefault()==1 && st[i].getStudentFather()!=null && st[i].getStudentFather().length()>0){ 
                            
                        %>
                            <font color=red>*</font>
                        <%  }else{ out.println("&nbsp;"); }   %>
                        <%=st[i].getStudentFather()%>
                    </td>
                    <td class=es02 nowrap align=left>
                    <%
                    if(st[i].getStudentFatherMobile()!=null && jp.checkMobile(st[i].getStudentFatherMobile()))
                    {
                    %> 

                    <a href="#" onClick="javascript:openwindow62('<%=st[i].getId()%>','<%=st[i].getStudentFatherMobile()%>','1');return false"><%=st[i].getStudentFatherMobile()%></a>

                    <%  }else{   %>
                            <%=st[i].getStudentFatherMobile()%>
                    <%  }   %>
                    </td>
                    <td class=es02 nowrap align=left>
                        <%
                        if(st[i].getStudentEmailDefault()==2  && st[i].getStudentMother()!=null && st[i].getStudentMother().length()>0){
                        %>
                            <font color=red>*</font>
                        <%  }else{ out.println("&nbsp;"); }   %>
                        <%=st[i].getStudentMother()%>
                    </td>
                    <td class=es02 nowrap align=left>
                    <%
                    if(st[i].getStudentMotherMobile()!=null && jp.checkMobile(st[i].getStudentMotherMobile()))
                    {
                    %> 
                    <a href="#" onClick="javascript:openwindow62('<%=st[i].getId()%>','<%=st[i].getStudentMotherMobile()%>','1');return false"><%=st[i].getStudentMotherMobile()%></a>

                    <%  }else{   %>
                            <%=st[i].getStudentMotherMobile()%>
                    <%  }   %>
                    </td>
            <%
                }else{  
            %>
                    <td class=es02 colspan=4 nowrap align=left>
                            <font color=red>*</font>
                    <%
                            Contact[] cons=ja.getAllContact(st[i].getId());
                            
                            if(cons !=null)
                            {
                                int raId=cons[0].getContactReleationId();
                                RelationMgr rm=RelationMgr.getInstance();
                                Relation ra=(Relation)rm.find(raId);
                      %>
                            <%=ra.getRelationName()%>:<%=cons[0].getContactName()%> 電話:<%=cons[0].getContactPhone1()%> 手機:
                            <%
                                if(cons[0].getContactMobile()!=null && jp.checkMobile(cons[0].getContactMobile()))
                                {
                                %> 
                    <a href="#" onClick="javascript:openwindow62('<%=st[i].getId()%>','<%=cons[0].getContactMobile()%>','1');return false"><%=cons[0].getContactMobile()%></a>
                    <%
                                }else{
                    %>
                                    <%=cons[0].getContactMobile()%>
                    <%            
                                }
                            }
                    %>
                    </td>
            <%  }   %> 
            <td>  
                <%=(st[i].getStudentPhone()!=null && st[i].getStudentPhone().length()>0)?st[i].getStudentPhone():""%>&nbsp;
                <%=(st[i].getStudentPhone2()!=null && st[i].getStudentPhone2().length()>0)?st[i].getStudentPhone2():""%>&nbsp;
                <%=(st[i].getStudentPhone3()!=null && st[i].getStudentPhone3().length()>0)?st[i].getStudentPhone3():""%>&nbsp;
            </td>
            <td align=middle>
                <a href="javascript:openwindow_phm2('addClientService.jsp?studentId=<%=st[i].getId()%>','新增客服記錄',700,700,true);">新增客服記錄</a>
        <%
        if(checkAuth(ud2,authHa,101))
        {
            Membr m = membrMap.get(new Integer(st[i].getId())).get(0);
        %>

        | <a href="bill_detail2.jsp?sid=<%=m.getId()%>&poId=-1&backurl=<%=URLEncoder.encode("listStudent.jsp?status=-1"+getTagURI(tagIds))%>" target="_blank">帳單資訊</a>
	    <%
        }
        %>    
        </td>      
        </tr>
<%
        }
%>
    </table>
    </td>
    </tr>
    </table>
    </center>
    <br>
    <%
        if(st !=null && st.length==1){
    %>
     
    <script>
        openwindow_phm2('addClientService.jsp?studentId=<%=st[0].getId()%>','新增客服記錄',700,700,true);
    </script>
    <%  }   %>           
<%
    }
%>
<%@ include file="bottom.jsp"%>