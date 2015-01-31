<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text\html;charset=UTF-8"%>

<%
 
	request.setCharacterEncoding("UTF-8");
	
	String search=request.getParameter("search");
 	
	if(search==null || search.length()<1)
 
	{
		out.println("PLEASE INPUT NAME");
		return; 
 
	}	
	
	StudentMgr um=StudentMgr.getInstance();
	
	Object[] objs = um.retrieve("studentName like ('"+search+"%') and studentStatus=4", "order by studentName");
	


	ClassesMgr cmx=ClassesMgr.getInstance();
	DepartMgr dm=DepartMgr.getInstance();
	LevelMgr lm=LevelMgr.getInstance();

	
		

	if (objs==null || objs.length==0)
	{
		out.println("在校生目前查無此人");
		return ;
	}
	    

	String str="";
 
	
	
	str="<table width=85% border=0 cellpadding=0 cellspacing=0>";
	str+="<tr align=left valign=top><td class=es02 class=es02 bgcolor=#e9e3de>";	
	str+="<table width=\"100%\"	 border=0 cellpadding=4 cellspacing=1>";
	
	str+="<tr align=\"center\" bgcolor=\"lightgrey\" cellpadding=\"1\" cellspacing=\"0\" width=\"98%\" border=\"1\" bordercolordark=\"#ffffff\" bordercolorlight=\"#000000\" bordercolor=\"#a8a8a8\">";
	str+="<td><b>學生姓名</b></td><td>性別</td><td>單位</td><td>班級</td><td>年級</td><td colspan=3></td></tr>"
; 
	



    Student[] u2 = new Student[objs.length];
    
    for (int i=0; i<u2.length; i++)
    {
  		u2[i]=(Student)objs[i];
		
		Classes cla=(Classes)cmx.find(u2[i].getStudentClassId());  		
  		
    	String stuId=String.valueOf(u2[i].getId());
    	
		str+="<tr class=\"normal\" onmouseover=\"this.className='highlight'\" onmouseout=\"this.className='normal'\">"+
				"<td><a href=\"#\" onClick=\"javascript:openwindow15('"+u2[i].getId()+"');return false\">";
	
		str +=u2[i].getStudentName()+"</a></td><td>";
		if(u2[i].getStudentSex()==1)
			str +="男";		 
		else
			str +="女";	
		str +="</td><td>"; 
		int departIdx=u2[i].getStudentDepart();
		if(departIdx==0)
		{
			str+="未定";
		}
		else
		{
			Depart dex=(Depart)dm.find(departIdx);
			str+=dex.getDepartName();
		}
		str+="</td><td>"; 
		
		int cid=u2[i].getStudentClassId(); 
		if(cid==0)
		{
			str+="未定";
		}
		else
		{
			Classes cla2=(Classes)cmx.find(cid);
			str+=cla2.getClassesName();
		}	
	  
	     str +="</td><td>";
	     
		int levelx=u2[i].getStudentLevel(); 
		if(levelx==0)
		{
			str+="未定";
		}
		else
		{
			Level leve=(Level)lm.find(levelx);
			str +=leve.getLevelName();
		}
	    str +="</td><td>";
	
		str +="<a href=\"#\" onClick=\"javascript:openwindow27('"+u2[i].getId()+"');return false\">繳費資訊</a>";
		str +="</td></tr>";



/*

    	str += "<div onmouseover='suggestOver(this)' ";
		str += "onmouseout='suggestOut(this)' ";
		str += "onclick='setSearch(this.innerText,"+stuId+")' ";
		str += "class='Link'><font size=4>" + u2[i].getStudentName()+"-"+cla.getClassesName()+ "</font></div>";
*/	
    }	
     
   	str+= "</able></td></tr></table>"
 ; 
      
	out.println(str);

%>