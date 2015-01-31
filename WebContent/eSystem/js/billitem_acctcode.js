    function setCode(acctcode) {
        document.f1.acctcode.value = acctcode;
        document.f1.acctcode.onblur();
    }
    function find_acctcode(cond)
    {
        if (typeof parent.acctcodewin!='undefined' && !parent.acctcodewin.isClosed)
            parent.acctcodewin.show();
        else
            openwindow_phm2('mca_acode_tree_find.jsp?' + cond,'尋找會計科目',650,600,'acctcodewin');
    }

    function ajax_get_name()
    {
        var code = document.f1.acctcode.value;
        code = code.replace("#","-"); // # encodeURI 沒法處理
        var url = "mca_acode_getname.jsp?code=" + encodeURI(code) + "&r="+(new Date()).getTime();
        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var t = req.responseText.indexOf("@@");
                    if (t>0)
                        alert(req.responseText.substring(t+2));
                    else {
                        var d = document.getElementById("acodename");
                        var name = req.responseText;
                        d.innerHTML = name;
                    }                        
                }
                else if (req.readyState == 4 && req.status == 500) {
                    alert("查詢服務器時發生錯誤");
                    return;
                }
            }
        };
        req.open('GET', url);
        req.send(null);
    }
