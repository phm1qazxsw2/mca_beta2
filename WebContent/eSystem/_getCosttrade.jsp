<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

    try
    {
		String code=request.getParameter("bicode");
		String ran=request.getParameter("ran");

        JsfAdmin ja=JsfAdmin.getInstance();
        BigItem[] bi=ja.getActiveBigItemByCodex(code);

        if(bi ==null)
        {
            Costtrade[] ct=ja.getActiveCosttrade(); 

            if(ct==null)
            {
%>
                尚未設定交易對象
                <input type=hidden name="costTradeId" value="0">	
        <%  }else{  %>
            
            <select size=1 name="costTradeId" onchange="Set_Cookie('phm17',this.options[this.selectedIndex].value,0.5);">
                <option value=0>不指定廠商</option>

            <%
            for(int k=0;k<ct.length;k++)
            {
            %>
                <option value="<%=ct[k].getId()%>"><%=ct[k].getCosttradeName()%></option> 
            <%
            }
            %>		
        </select>
<%  
            }   
        }else{

            Costbigitem[]  cbi=ja.getCostbigitemByBiId(bi[0].getId(),true);
        
            if(cbi==null){
%>
            沒有可用的廠商名單.
            <input type=hidden name="costTradeId" value=0>
<%
            }else{
                CosttradeMgr cmm=CosttradeMgr.getInstance();
%>
            <select name="costTradeId" onchange="Set_Cookie('phm17',this.options[this.selectedIndex].value,0.5);">
                <option value=0>不指定廠商</option>
                <%
                for(int i=0; cbi !=null && i<cbi.length ;i++){
                    Costtrade ctc=(Costtrade)cmm.find(cbi[i].getCosttradeId());
                %>
                    <option value="<%=ctc.getId()%>"><%=ctc.getCosttradeName()%></option>
                <%  }   %>          
            </select>
<%

            }
        }

    }catch(Exception ex){


    }


%>	