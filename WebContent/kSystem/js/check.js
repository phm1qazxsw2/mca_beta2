

function getLeaveStudentX(lsId)
{
     SDIV = document.getElementById("realtime");
     
     var url = "_getLeaveStudentX.jsp?lsId="+lsId;
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}


function showPicFrom(type,accountId,divName)
{
     var SDIV = document.getElementById(divName);     
     
     var url = "_showPicFrom.jsp?type="+type+"&accountId="+accountId;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}


function showEveryTalentdate(tdId,ron)
{
     SDIV = document.getElementById("realtime");
     
     var url = "showEveryTalentdate.jsp?tdId="+tdId+"&random="+ron;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}



function modifyEveryTalentdate(tdId,ron)
{
     SDIV = document.getElementById("realtime");
     
     var url = "modifyEveryTalentdate.jsp?tdId="+tdId+"&random="+ron;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}


function getMessageList(x,y,z)
{
	if(z=='1')  
	{
		if(x=='0')
		{ 
			document.getElementById("showGroup").innerHTML="全部";	
		}else if(x=='1'){
			document.getElementById("showGroup").innerHTML="行政";	
		}else if(x=='2'){ 
			document.getElementById("showGroup").innerHTML="老師";	
		}else if(x=='3'){ 					
			document.getElementById("showGroup").innerHTML="學生";	
		}
	}else{ 
		document.getElementById("showGroup").innerHTML="才藝班";	
	}		
     SDIV = document.getElementById("realtime");
     var url = "_getMessageList.jsp?x="+x+"&y="+y+"&z="+z;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}

function getStudentFeeticketMonth(stuId,syear,smonth,z)
{
	para1=stuId;
	para2=syear;
	para3=smonth;
	para4=z;
	
	SDIV = document.getElementById("realtime2");
	
	var url = "_getStudentFeeticketMonth.jsp?studentId="+stuId+"&year="+syear+"&month="+smonth+"&z="+z;	
	var req = new XMLHttpRequest();
   
    if (req) 
    {
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            { 
				
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}

function getCostpayDetail(url2,userId,xfilename)
{
	
     SDIV = document.getElementById("outword");
     var url = "_getCostpayDetail.jsp?z="+url2+"&userId="+userId+"&xfilename="+xfilename;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}

function getCostpayDetail(url2,userId,xfilename)
{
	
     SDIV = document.getElementById("outword");
     var url = "_getCostpayDetail.jsp?z="+url2+"&userId="+userId+"&xfilename="+xfilename;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}
function getIncomeSmallItem(url2)
{
	
     SDIV = document.getElementById("realtime");
     var url = "_getIncomeSnallItem.jsp?z="+url2;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}


function getAlbumCatelogId(url2)
{
	
     SDIV = document.getElementById("realtime");
     var url = "_getAlbumCatelog.jsp?z="+url2;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
}

function getIncomeSmallItem2(url2)
{
	
     SDIV = document.getElementById("realtime");
     var url = "_getSnallItem.jsp?z="+url2;	
    var req = new XMLHttpRequest();
   
    if (req) 
    {
    		//alert("x1");
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
    
    showWord("Xitem","請點選次項目");
}


function getCostDetailX(url2,userId,xxx)
{
	
     SDIV = document.getElementById("outword");
     var url = "_getCostDetailX.jsp?z="+url2+"&userId="+userId+"&xxx="+xxx;	
    var req = new XMLHttpRequest();
   
    if (req) 
    {
    		//alert("x1");
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}


function getStudentByClass(url2,talentId)
{
	
     SDIV = document.getElementById("realtime");
     var url = "_getStudentByClass.jsp?z="+url2+"&talentId="+talentId;	
    var req = new XMLHttpRequest();
   
    if (req) 
    {
    		//alert("x1");
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function getModifyTadentForm(url2,status,r)
{
     SDIV = document.getElementById("realtime");
     var url = "_getModifyTadentForm.jsp?z="+url2+"&status="+status+"&r="+r;	
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	//alert("x1");	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function getTalentdate(talentdateid)
{
     SDIV = document.getElementById("realtime");
     var url = "_getTalentdate.jsp?z="+talentdateid;
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	//alert("x1");	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function getModifySnoticeForm(talentId,stuId)
{
     SDIV = document.getElementById("realtime");
     
    
     var url = "_getModifySnoticeForm.jsp?z="+talentId+"&stuId="+stuId;
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	//alert("x1");	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function getModifyTadentFileForm(tfId,r)
{
     SDIV = document.getElementById("realtime");
     
     var url = "_getModifyTadentFileForm.jsp?z="+tfId+"&r="+r;
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	//alert("x1");	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function getClassFeeByCfId(tfId,cla,r)
{ 
	para1=tfId;
	para2=cla;
	para3=r;	
	
    SDIV = document.getElementById("realtime");
   
     var url = "_getClassFeeByCfId.jsp?z="+tfId+"&page2="+cla+"&r="+r;
     var req = new XMLHttpRequest();
   
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}


function getFeeticketByFeenumber(tfId)
{
	  feenumber =tfId ;
	  
     SDIV = document.getElementById("realtime");
                
     var url = "_getFeeticketFeenumberOneStop.jsp?z="+tfId;
     var req = new XMLHttpRequest();
   	
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}


function getFeeticketByFeenumberV2(tfId,r)
{
	  
	feenumber =tfId ;
	  
     SDIV = document.getElementById("realtime");
                
     var url = "_getFeeticketFeenumberOneStop.jsp?z="+tfId+"&r="+r;
     var req = new XMLHttpRequest();
   	
    if (req) 
    {
    	
        req.onreadystatechange = function() 
        {
        	
            if (req.readyState == 4 && req.status == 200) 
            {
            	
                SDIV.innerHTML = req.responseText;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}


function getFinancePage(page,syear,smonth)
{
	  
     SDIV = document.getElementById("realtime");
                
     var url2 ="";
     
     if(page==1)
     	url2="showFtype1.jsp?year="+syear+"&month="+smonth;
     else if(page==2)
     	url2="showFtype2.jsp?year="+syear+"&month="+smonth;
     else if(page==3)
     	url2="showFtype2Detail.jsp?year="+syear+"&month="+smonth;
     else if(page==4)
     	url2="showFtype3.jsp?year="+syear+"&month="+smonth;
     else if(page==5)
     	url2="showFtype4.jsp";
	 else if(page==6)
     	url2="showFtype5.jsp";
	 else if(page=7)
     	url2="showFtype6.jsp?month="+syear+"/"+smonth;
	     
     			
     
     var req = new XMLHttpRequest();
	    if (req) 
	    {
	    	
	        req.onreadystatechange = function() 
	        {
	        	
	            if (req.readyState == 4 && req.status == 200) 
	            {
	            	
	                SDIV.innerHTML = req.responseText;
	            }
	        }
	    };
    req.open('GET', url2);
    req.send(null);
}