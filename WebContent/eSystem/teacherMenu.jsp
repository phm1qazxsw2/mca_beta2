<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
        String frameWidth=request.getParameter("frameWidth");
%>

<%@ include file="jumpTopExpress.jsp"%>
<%
    String orderString=request.getParameter("order");
	String pageNum=request.getParameter("pageNum");	
	int order=0;	
	if(orderString !=null)
		order=Integer.parseInt(orderString);

    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    String query="(teacherStatus ='2' or teacherStatus ='1') ";
    if(bunit !=-1)
        query +=" and teacherBunitId='"+bunit+"'";

    Teacher2Mgr tm=Teacher2Mgr.getInstance(); 
    ArrayList<Teacher2> teaArray=tm.retrieveListX(query,"", _ws2.getBunitSpace("bunitId"));  

	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws2.getBunitSpace("buId"));
    Map<Integer,Vector<Teacher2>> bnuitMap = new SortingMap(teaArray).doSort("getTeacherBunitId");
%>
<script>
    function checkPage(teaId){
        top.checkPage(teaId);
    }

</script>


<body>
<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">


<div class=es02>
<%
	if(teaArray==null || teaArray.size()<=0)
	{
%>
            沒有資料.
<%
        return;
    }


    for(int j=0;b !=null && j<(b.size()+1);j++){
        
        Bunit bb=null;
        Vector teaV=null;
        
        boolean lastOne=(j==b.size())?true:false;

        if(lastOne){
            if(bnuitMap !=null && bnuitMap.size()>0)
                teaV=bnuitMap.get(new Integer(0));        
        }else{

            bb=b.get(j);        
            if(bnuitMap !=null && bnuitMap.size()>0){
                teaV=bnuitMap.get(new Integer(bb.getId()));
            }
        }

        if(teaV==null || teaV.size()<=0){
            continue;        
        }
%>
    <br>
    <div class=es02>&nbsp;部 門:&nbsp;<b><%=(lastOne)?"未定":bb.getLabel()%></b></div><br>

    <%
        for(int i=0;teaV !=null && i<teaV.size();i++)
        {        
            Teacher2 tea=(Teacher2)teaV.get(i);
    %>
    &nbsp;&nbsp;&nbsp;<a href="#" onClick="checkPage('<%=tea.getId()%>');return false;">
                <%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></a><br>
    <%
        }
    }
    %>    
    </div>

</center>