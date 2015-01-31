function check_zipcode(type)
{

	
	var url2 = "_checkzip.jsp?z="+new Date().getTime();

    var req = new XMLHttpRequest();
    if (req) 
    {
        window.onerror = function()
        {
            alert('Cannot connect, please try later #2');
            return true;
        }
        
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
             
                        document.xx.value =url2;
                      //  document.form1.billZip.focus();
                    }
                   
                }   
            }
        }
    };
    req.open('GET', url);
    req.send(null);   
}

function openwindow4(strTemp) {

window.open("verifyCost.jsp?costId="+strTemp,"xx4","height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
}