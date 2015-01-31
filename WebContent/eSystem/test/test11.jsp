<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,phm.ezcounting.*,dbo.*,java.util.*"
    contentType="text/html;charset=UTF-8"%>
<%
    
    String numX="9577888880118";

    int xSum=0;
    int ySum=0;
    for(int i=0;i<13;i++)
    {
        if(i==0 || i%2==0)
        {    
            xSum+=Integer.parseInt(numX.substring(i,(i+1)));            
        }else{
            ySum+=Integer.parseInt(numX.substring(i,(i+1)));
        }
    }
    xSum=xSum*3;
    String suntotal=String.valueOf(xSum+ySum);
    int sunTotalInt=Integer.parseInt(suntotal.substring((suntotal.length()-1),suntotal.length()));
    if(sunTotalInt !=0)
        sunTotalInt=10-sunTotalInt;
    
    out.println(numX+"-"+sunTotalInt);


    //String peterstr = "9528297020111";
    String peterstr = "9577888880118";
    int oddsum = 0, evensum = 0;
    for (int i=0; i<peterstr.length(); i++) {
        if (i%2==0)
            evensum += (int) (peterstr.charAt(i)-'0');
        else
            oddsum +=  (int) (peterstr.charAt(i)-'0');
    }
    String sum = (evensum*3 + oddsum) + "";
    out.println("## peter:" + sum);
    
%> 

<BR>
done!




