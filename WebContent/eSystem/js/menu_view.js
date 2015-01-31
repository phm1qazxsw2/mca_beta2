function menu_view(divname)
{
    this.mydiv = document.getElementById(divname);
    this.menu = new Array;
    this.link1 = new Array;
    this.link2 = new Array;

    this.add = function(name, link1, link2, link3) {
        this.menu[this.menu.length] = name;
        this.link1[this.link1.length] = link1;
        this.link2[this.link2.length] = link2;
    }

    this.add_separator = function() {
        this.add('-','-');
    }

    this.draw = function() {
        var str = '';
        for (var i=0; i<this.menu.length; i++) {
            if (this.menu[i]=='-') {
                str += '<div style="position:relative;left:20px;height:10px"></div>';
                continue;
            }
            str += '<div id=m'+i+' style="position:relative;left:20px;border:solid green 0px">' + 
                this.menu[i] + 
                '<br>　　 <a href="#" id="a'+i+'">總分類帳</a>' +
                ' <a href="#" id="b'+i+'">明細分類帳</a>'+
                '</div>';
        }
        this.mydiv.innerHTML = str;
        // setup handler
        for (var i=0; i<this.menu.length; i++) {
            if (this.menu[i]=='-')
                continue;
            var d = document.getElementById('a'+i);
            if (d!=null) {
                d.view = this;
                d.idx = i;
                d.link = this.link1[i];
                d.name = this.menu[i] + "(分類總覽)";
                d.onclick = function() {
                    this.view.open(this.link, this.name);
                    return false;
                }
            }
            d = document.getElementById('b'+i);
            if (d!=null) {
                d.view = this;
                d.idx = i;
                d.link = this.link2[i];
                d.name = this.menu[i] + "(分類明細)";
                d.onclick = function() {
                    this.view.open(this.link, this.name);
                    return false;
                }
            }
        }
    }

    this.open = function(l, name) {
        //if (typeof parent.vchrwin!='undefined') {
        //    this.x = parent.vchrwin.style.left;
        //    if (eval(parent.vchrwin.style.top.replace("px",""))<getClientSizeObject().h)
        //        this.y = parent.vchrwin.style.top;
        //}
        openwindow_phm2(l, name, 600,500,'vchrwin');
        parent.vchrwin.shiftRight(200);
        //if (typeof this.x!='undefined') {
        //    parent.vchrwin.moveTo(this.x, this.y);
        //}
    }

    this.load = function (idx) {
        var url = this.link[idx];
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
                        var d = document.getElementById("c" + idx);
                        d.innerHTML = req.responseText;
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
}

