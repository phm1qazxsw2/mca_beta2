
function goListStudent(depardId,levelId,classId,order,pageNum)
{

	/*
	SDIV = document.getElementById("searchWord");
    var url = "_goListStudent.jsp?depardId="+depardId+"&levelId="+levelId+"&classId="+classId+"&orderX="+order+"&pageNum="+pageNum;
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
	*/
}

var runPDF=0;
function goPDFNum()
{

	SDIV = document.getElementById("showArea");
	runPDF++;
	var url = "_showPDFNum.jsp?r="+(new Date()).getTime();
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

function showTip(urlPara)
{
	var url = urlPara+"&ran="+(new Date()).getTime();;
	var req = new XMLHttpRequest();

	if (req) 
	{
		req.onreadystatechange = function() 
		{
			if (req.readyState == 4 && req.status == 200) 
			{
				alert(req.responseText);
				return req.responseText;
			}
		}
	};
	req.open('GET', url);
	req.send(null);

	return '';
}



function doPay(urlString,divName)
{
	SDIV = document.getElementById(divName);

	var url = urlString+"&ran="+(new Date()).getTime();;
	var req = new XMLHttpRequest();

	if (req) 
	{
		req.onreadystatechange = function() 
		{
			if (req.readyState == 4 && req.status == 200) 
			{
				alert('已登入成功!');
				SDIV.innerHTML = req.responseText;
			}
		}
	};
	req.open('GET', url);
	req.send(null);
}


function goSearch(valuex)
{

	SDIV = document.getElementById("searchWord");

	var url = "_goSearchStudent.jsp?xId="+encodeURI(valuex) + "&r=" + (new Date()).getTime();
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


function showname(value)
{
 
     SDIV = document.getElementById("showName");
     var url = "_showName.jsp?xId="+encodeURI(value) + "&r=" + (new Date()).getTime();
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

function showid(value)
{
     SDIV = document.getElementById("showId");
     var url = "_showId.jsp?xId="+value + "&r=" + (new Date()).getTime();
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


function getEmail(value)
{
 
	 ran ++;
     SDIV = document.getElementById("showEmail");
     var url = "_getUserEmail.jsp?id="+value+"&ran="+(new Date()).getTime();
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


function getXlist(value)
{ 
	 ran ++;
     SDIV = document.getElementById("showXX");
     var url = "_searchStudentlist.jsp?id="+value+"&ran="+(new Date()).getTime();
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


function getSuggest(value)
{
     SDIV = document.getElementById("result");
      
      ran ++;
     var url = "searchAccount.jsp?search="+value+"&r="+(new Date()).getTime();
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


function getLeaveStudentX(lsId)
{
     SDIV = document.getElementById("realtime");
     
     var url = "_getLeaveStudentX.jsp?lsId="+lsId + "&r=" + (new Date()).getTime();
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
          
     var url = "_showPicFrom.jsp?type="+type+"&accountId="+accountId + "&r=" + (new Date()).getTime();
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
     
     var url = "showEveryTalentdate.jsp?tdId="+tdId+"&random="+(new Date()).getTime();
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
     
     var url = "modifyEveryTalentdate.jsp?tdId="+tdId+"&random="+(new Date()).getTime();
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
     var url = "_getMessageList.jsp?x="+x+"&y="+y+"&z="+z + "&r=" + (new Date()).getTime();
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
	
	var url = "_getStudentFeeticketMonth.jsp?studentId="+stuId+"&year="+syear+"&month="+smonth+"&z="+z + "&r=" +(new Date()).getTime();
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
     var url = "_getCostpayDetail.jsp?z="+url2+"&userId="+userId+"&xfilename="+xfilename+"&r="+(new Date()).getTime();
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
     var url = "_getCostpayDetail.jsp?z="+url2+"&userId="+userId+"&xfilename="+xfilename+"&r="+(new Date()).getTime();
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
     var url = "_getIncomeSnallItem.jsp?z="+url2 + "&r=" + (new Date()).getTime();
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
     var url = "_getAlbumCatelog.jsp?z="+url2 + "&r=" + (new Date()).getTime();
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
	xrun++;
	SDIV = document.getElementById("realtime");
	var url = "_getSnallItem.jsp?z="+url2+"&r="+(new Date()).getTime();
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
    
    showWord("Xitem","請點選次項目");
}


function getCostDetailX(url2,userId,xxx)
{
	
     SDIV = document.getElementById("outword");
     var url = "_getCostDetailX.jsp?z="+url2+"&userId="+userId+"&xxx="+xxx + "&r=" + (new Date()).getTime();
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
     var url = "_getStudentByClass.jsp?z="+url2+"&talentId="+talentId + "&r=" + (new Date()).getTime();
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
     var url = "_getModifyTadentForm.jsp?z="+url2+"&status="+status+"&r="+(new Date()).getTime();
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
     var url = "_getTalentdate.jsp?z="+talentdateid + "&r=" + (new Date()).getTime();
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
     
    
     var url = "_getModifySnoticeForm.jsp?z="+talentId+"&stuId="+stuId + "&r=" + (new Date()).getTime();
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
     
     var url = "_getModifyTadentFileForm.jsp?z="+tfId+"&r="+(new Date()).getTime();
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

var xRun=0;

function getClassFeeByCfId(tfId,cla)
{ 
	para1=tfId;
	para2=cla;	
	xRun++;

	SDIV = document.getElementById("realtime");
	var url = "_getClassFeeByCfId.jsp?z="+tfId+"&page2="+cla+"&r="+(new Date()).getTime();
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

		var url = "_getFeeticketFeenumberOneStop.jsp?z="+tfId + "&r=" + (new Date()).getTime();
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
			
	var url = "_getFeeticketFeenumberOneStop.jsp?z="+tfId+"&r="+(new Date()).getTime();
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
	     
	url2 += "&r=" + (new Date()).getTime();
     
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