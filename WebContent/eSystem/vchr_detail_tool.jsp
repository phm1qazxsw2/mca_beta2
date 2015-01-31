<%
    SimpleDateFormat _sdfx = new SimpleDateFormat("yyyy/MM/dd"); 
%>
    <form name="fx">
    　　
    <a href="#" onclick="displayCalendar(document.fx.start,'yyyy/mm/dd',this);return false">從:</a>
    <input type=text id="fx_start" name="start" value="" size=6>　
    <a href="#" onclick="displayCalendar(document.fx.end,'yyyy/mm/dd',this);return false">至:</a>
    <input type=text id="fx_end" name="end" value="" size=6>
    　　
    <input type=button value="查詢" onclick="do_change()">
    &nbsp;&nbsp;&nbsp;
    <input type=radio name="type" value=0 checked> 入帳日期 <input type=radio name="type" value=1> 產生時間
    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type=checkbox name="format" value=1 checked> 匯出格式 
    </form>

    <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>	

    <script>
        function getPrintHeader()
        {
            return "<div class=es02b><b>日記帳 : " + 
                document.fx.fx_start.value + "-" + document.fx.fx_end.value + "</b><br><br>" +
                "</div>";
        }

        function getData()
        {
            return displaydiv.innerHTML;
        }

        function print()
        {
            window.open('vchr_detail_print.jsp?r=' + new Date().getTime());
        }

        function show_summary()
        {
            var start = document.fx.fx_start.value;
            var end = document.fx.fx_end.value;

            var param = "s=" + encodeURI(start) + "&e=" + encodeURI(end) + 
                "&t=&b=&m=main&f="; // + "&p=" + prjv;
            var url = "vchr_do_search.jsp?" + param;

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
                            if (req.responseText.indexOf("沒有資料")>=0)
                                return;
                            summarydiv.innerHTML = req.responseText;
                            summarydiv.style.border = "solid #e0e0e0 1px";
                        }                        
                    }
                    else if (req.readyState == 4 && req.status == 500) {
                        alert("查詢 Server 時發生錯誤");
                        return;
                    }
                }
            };
            req.open('GET', url);
            req.send(null);
        }

        function do_change() {

            var start = document.fx.fx_start.value;
            var end = document.fx.fx_end.value;
            var created = document.fx.type[1].checked;

            if (trim(start).length==0 || trim(end).length==0) {
                clear_display();
                return;
            }

            var param = "s=" + encodeURI(start) + "&e=" + encodeURI(end) + "&t=" + ((created)?1:0);
            if (document.fx.format.checked)
                param += "&format=1";
            var url = "vchr_detail_search.jsp?" + param;
            // location.href = url;
            
            if (displaydiv==null) {
                alert("找不到顯示的 div");
                return;
            }

            clear_display();
            var req = new XMLHttpRequest();
            displaydiv.innerHTML = "查詢中..";
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
                            displaydiv.innerHTML = req.responseText;
                            if (req.responseText.indexOf("沒有")<0){
                                // descdiv.innerHTML = '<br><br><center><input type=button value="列印" onclick="print()"></center>';
                                descdiv.innerHTML = '<a href="javascript:print();"><img src="pic/print.png" border=0>&nbsp;列印本頁</a>';
                            }
                            show_summary();
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

        var displaydiv = null;
        var descdiv = null;
        var summarydiv = null;

        function setup_display(divname, descname, summaryname) {
            displaydiv = document.getElementById(divname);
            descdiv = document.getElementById(descname);
            summarydiv = document.getElementById(summaryname);

            document.fx.fx_start.value = '<%=_sdfx.format(new Date())%>';
            document.fx.fx_end.value = '<%=_sdfx.format(new Date())%>';
            do_change();
        }

        function clear_display() {
            displaydiv.innerHTML = '';
            displaydiv.style.border = "";
            descdiv.innerHTML = '';
            summarydiv.innerHTML = "";
            summarydiv.style.border = "";
        }

    </script>
