<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<br>

<%
    String[] bIds=request.getParameterValues("bId");
    String[] sIds=request.getParameterValues("sid");

    int type=1;
    String typeS=request.getParameter("type");
    if(typeS !=null)
        type=Integer.parseInt(typeS);


    Hashtable bHa=new Hashtable();
    Hashtable sHa=new Hashtable();
    for(int i=0;bIds !=null && i<bIds.length;i++)
    {
        bHa.put(new Integer(bIds[i]),(String)"1");
    }

    for(int i=0;sIds !=null && i<sIds.length;i++)
    {
        sHa.put(new Integer(sIds[i]),(String)"1");
    }

    JsfAdmin ad=JsfAdmin.getInstance();

    BigItemMgr bim=BigItemMgr.getInstance();
    SmallItemMgr sim=SmallItemMgr.getInstance();
    BigItem[] bis=ad.getAllBigItem2ByType(type);
    for(int i=0;i<bis.length;i++)
    {
        int bitActive=bis[i].getBigItemActive();
        String xword=(String)bHa.get(new Integer(bis[i].getId()));       
        
        if(bitActive==1){
            if(xword==null)
            {    
                bis[i].setBigItemActive(0);
                bim.save(bis[i]);
            }
        }else{
            if(xword!=null){
                bis[i].setBigItemActive(1); 
                bim.save(bis[i]);
            }                           
        }
        SmallItem[] si=ad.getAllSmallItemByBID(bis[i].getId()); 
        
        for(int j=0;si !=null && j<si.length;j++)
        {
			int isiActive=si[j].getSmallItemActive();
            String xword2=(String)sHa.get(new Integer(si[j].getId()));       
            if(isiActive==1)
            {
                if(xword2==null)
                {    
                    si[j].setSmallItemActive(0);
                    sim.save(si[j]);
                }
            }else{
                if(xword2!=null)
                {    
                    si[j].setSmallItemActive(1);
                    sim.save(si[j]);
                }

            }
        }
    }

    response.sendRedirect("ListBigItem.jsp?m=1&type="+type);
%>