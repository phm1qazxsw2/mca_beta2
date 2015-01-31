	/*
	These cookie functions are downloaded from 
	http://www.mach5.com/support/analyzer/manual/html/General/CookiesJavaScript.htm
	*/
	function Get_Cookie(name) { 
	   var start = document.cookie.indexOf(name+"="); 
	   var len = start+name.length+1; 
	   if ((!start) && (name != document.cookie.substring(0,name.length))) return null; 
	   if (start == -1) return null; 
	   var end = document.cookie.indexOf(";",len); 
	   if (end == -1) end = document.cookie.length; 
	   return unescape(document.cookie.substring(len,end)); 
	} 
	// This function has been slightly modified
	function Set_Cookie(name,value,expires,path,domain,secure) { 
		expires = expires * 60*60*24*1000;
		var today = new Date();
		var expires_date = new Date( today.getTime() + (expires) );
	    var cookieString = name + "=" +escape(value) + 
	       ( (expires) ? ";expires=" + expires_date.toGMTString() : "") + 
	       ( (path) ? ";path=" + path : "") + 
	       ( (domain) ? ";domain=" + domain : "") + 
	       ( (secure) ? ";secure" : ""); 
	    document.cookie = cookieString; 
	} 

	function Del_Cookie(name)
	{
		Set_Cookie(name, '', -1);
	}

	//============== 以下的有問題，只能給 spending_add.jsp 用 ============
	function setCookie(c_name,value,expiredays)
    {
        var exdate=new Date();
        
        if(expiredays>0)
            exdate.setDate(expiredays);
        else
            exdate.setTime(new Date().getTime()-1);
    
        var xvalue;
        if(value==1)            
            xvalue=document.xs.title.value;
        else if(value==2) 
            xvalue=document.xs.total.value;
        else if(value==3)
            xvalue=document.xs.recordTime.value;
                
        var outword;
        if(expiredays >0)
            outword=";expires="+exdate;
        else
            outword=";expires="+exdate.toGMTString();

        document.cookie=c_name+ "=" +escape(xvalue)+outword;
    }

    function getCookie(c_name)
    {
        if (document.cookie.length>0)
        {
          c_start=document.cookie.indexOf(c_name + "=");
          if (c_start!=-1)
            { 
                c_start=c_start + c_name.length+1 ;
                c_end=document.cookie.indexOf(";",c_start);
                
                if (c_end==-1) 
                    c_end=document.cookie.length
                        
                return unescape(document.cookie.substring(c_start,c_end));
            } 
          }
        return ""
    }
