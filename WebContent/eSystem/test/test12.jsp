<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,phm.ezcounting.*,dbo.*,java.util.*"
    contentType="text/html;charset=UTF-8"%>
<%

    String mName=request.getParameter("mName");
    String[] mNameS=mName.split("\n");
    int bunitId=Integer.parseInt(request.getParameter("bunit"));

    if(mNameS !=null && mNameS.length>0){

	    TeacherMgr tm=TeacherMgr.getInstance();
        for(int i=0;i<mNameS.length;i++)
            if(mNameS[i] !=null){
                
                String teacherFirstName=mNameS[i].substring(0,1);
                String teacherLastName=mNameS[i].substring(1).trim();
                Teacher tea=new Teacher();
                tea.setTeacherFirstName   	(teacherFirstName);
    	        tea.setTeacherLastName   	(teacherLastName);  
                tea.setTeacherBunitId(bunitId);
	            tea.setTeacherStatus   	(1);              
    	        int teaId=tm.createWithIdReturned(tea);

                phm.ezcounting.Membr membr = new phm.ezcounting.Membr();
                membr.setName(tea.getTeacherFirstName()+tea.getTeacherLastName());
                membr.setActive(1);
                membr.setType(phm.ezcounting.Membr.TYPE_TEACHER);
                membr.setSurrogateId(teaId);
                membr.setBunitId(bunitId);
                phm.ezcounting.MembrMgr.getInstance().create(membr);

            }
    }
%>

done;