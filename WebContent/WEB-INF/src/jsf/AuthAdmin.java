package jsf;

import java.util.*;
import java.text.*;

public class AuthAdmin
{
    private static AuthAdmin instance;
    
    AuthAdmin() {}
    
    public synchronized static AuthAdmin getInstance()
    {
    	
			
        if (instance==null)
        {
            instance = new AuthAdmin();
        }
        return instance;
    }

    
    public static boolean authPage(User ud2,int authLevel)
    {
        int userLevel=ud2.getUserRole();
        
        if(userLevel==0)
            userLevel=5;

        if(ud2.getUserRole()<=authLevel)
            return true;
        else 
            return false;
    }
   

}
    