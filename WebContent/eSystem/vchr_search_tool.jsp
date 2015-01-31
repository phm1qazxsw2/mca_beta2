      <form name="fx">
        <a href="#" onclick="displayCalendar(document.fx.start,'yyyy/mm/dd',this);return false">從:</a>
        <input type=text id="fx_start" name="start" value="" size=6><br>
        <a href="#" onclick="displayCalendar(document.fx.end,'yyyy/mm/dd',this);return false">至:</a>
        <input type=text id="fx_end" name="end" value="" size=6> <span id="remind"></span>
        <br>
<% 
    SimpleDateFormat _sdfx = new SimpleDateFormat("yyyy/MM/dd"); 
/* %>
        <br>
        部門:
        <select name="fx_bu" id="fx_bu">
          <option value="">全部
<%
    ArrayList<Bunit> bunits = BunitMgr.getInstance().retrieveList("flag=1 and status=1", "");
    for (int i=0; i<bunits.size(); i++) { 
%>
        <option value="<%=bunits.get(i).getId()%>"><%=bunits.get(i).getLabel()%>
<%  } %>
        </select>
        <br>
<% */ %>
        <br>
        <input type=checkbox name="show_detail" id="show_detail" value="0"> 顯示次科目
        <br>
        <input type=checkbox name="full_mode" id="full_mode" value="1"> 顯示原始借貸
        <br>
        <br>
        類型:
        <br>
        <input type=checkbox name="fx_t0" id="fx_t0" value="0">全部
        <br>
        <input type=checkbox name="fx_t1" id="fx_t1" value="<%=VchrThread.SRC_TYPE_BILL%>">帳單
        <br>
        <input type=checkbox name="fx_t2" id="fx_t2" value="<%=VchrThread.SRC_TYPE_BILLPAID%>">帳單沖帳
        <br>
        <input type=checkbox name="fx_t3" id="fx_t3" value="<%=VchrThread.SRC_TYPE_BILLPAY%>">帳單付款
        <br>
        <input type=checkbox name="fx_t4" id="fx_t4" value="<%=VchrThread.SRC_TYPE_SALARY%>">薪資
        <br>
        <input type=checkbox name="fx_t5" id="fx_t5" value="<%=VchrThread.SRC_TYPE_SALARYPAID%>">薪資沖帳
        <br>
        <input type=checkbox name="fx_t6" id="fx_t6" value="<%=VchrThread.SRC_TYPE_SALARYPAY%>">薪資付款
        <br>
        <input type=checkbox name="fx_t7" id="fx_t7" value="<%=VchrThread.SRC_TYPE_INCOME%>">雜費收入
        <br>
        <input type=checkbox name="fx_t8" id="fx_t8" value="<%=VchrThread.SRC_TYPE_SPENDING%>">雜費支出
        <br>
        <input type=checkbox name="fx_t9" id="fx_t9" value="<%=VchrThread.SRC_TYPE_BUYGOODS%>">學用品進貨
        <br>
        <input type=checkbox name="fx_t10" id="fx_t10" value="<%=VchrThread.SRC_TYPE_INSIDETRADE%>">現金轉帳
        <br>
        <input type=checkbox name="fx_t11" id="fx_t11" value="<%=VchrThread.SRC_TYPE_CHEQUE_CASHIN%>">應收票據
        <br>
        <input type=checkbox name="fx_t12" id="fx_t12" value="<%=VchrThread.SRC_TYPE_CHEQUE_CASHOUT%>">應付票據
        <br>
        <input type=checkbox name="fx_t13" id="fx_t13" value="<%=VchrThread.SRC_TYPE_FUNDING%>">補助款
        <br>
        <input type=checkbox name="fx_t14" id="fx_t14" value="<%=VchrThread.SRC_TYPE_FUNDING_DIST%>">補助分配
        <br>
        <input type=checkbox name="fx_t15" id="fx_t15" value="<%=VchrThread.SRC_TYPE_MANUAL%>">人工輸入
        <br>
        <br>
<!--
        專案:
        <br>
        <select name="fx_prj" id="fx_prj">
          <option value="">全部
          <option value="1">2009-02
          <option value="2">2009-01
        </select>
-->
      </form>

    <script>
        var d = document.getElementById("fx_start");
        d.onchange = function() {
            Set_Cookie("fx_start", this.value);
            do_change();
        }
        d = document.getElementById("fx_end");
        d.onchange = function() {
            Set_Cookie("fx_end", this.value);
            do_remind();
            do_change();
        }
        d = document.getElementById("show_detail");
        d.onclick = function() {
            do_change();
        }
        d = document.getElementById("full_mode");
        d.onclick = function() {
            do_change();
        }
        for (var i=0; ;i++) {
            d = document.getElementById("fx_t"+i);
            if (typeof d=='undefined' || d==null)
                break;
            d.idx = i;
            d.onclick = function() {
                if (this.idx==0) {
                    for (var i=1; ;i++) {
                        var e = document.fx["fx_t" + i];
                        if (typeof e=='undefined')
                            break;
                        e.checked = false;
                    }                    
                }
                else {
                    document.fx["fx_t0"].checked = false;
                }            
                do_change();
            }
        }
        /*
        d = document.getElementById("fx_bu");
        d.onchange = function() {
            do_change();
        }
        d = document.getElementById("fx_prj");
        d.onchange = function() {
            alert("功能即將完成,同一個月份的帳單與其銷帳傳票會用一個專案整合(與入帳日期無關),敬請期待");
        }
        */

        function do_change() {

            var start = document.fx.fx_start.value;
            var end = document.fx.fx_end.value;

            //debug(start);
            //debug(end);

            if (trim(start).length==0 || trim(end).length==0) {
                clear_display();
                return;
            }

            var t = '';
            if (document.fx["fx_t0"].checked){
            }
            else {
                for (var i=1; ;i++) {
                    var e = document.fx["fx_t" + i];
                    if (typeof e=='undefined')
                        break;
                    if (!e.checked)
                        continue;
                    if (t.length>0)
                        t+=",";
                    t+=e.value;
                }
                if (t=='') {
                    clear_display();
                    return;
                }
            }

            var m = 'main';
            if (document.fx.show_detail.checked)
                m = '';

            var f = '';
            if (document.fx.full_mode.checked)
                f = 'true';

            //var bu = document.fx.fx_bu;
            //var buv = <%=_ws.getSessionBunitId()%>; // bu.options[bu.selectedIndex].value;
            //debug("部門:" + buv);

            //var prj = document.fx.fx_prj;
            //var prjv = prj.options[prj.selectedIndex].value;
            //debug("專案:" + prjv);

            var param = "s=" + encodeURI(start) + "&e=" + encodeURI(end) + 
                "&t=" + encodeURI(t) + "&m=" + m + "&f=" + f;// + "&p=" + prjv; "&b=" + buv + 
            var url = "vchr_do_search.jsp?" + param;

            if (displaydiv==null) {
                alert("找不到顯示的 div");
                return;
            }

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
                            displaydiv.innerHTML = req.responseText;
                            displaydiv.style.border = "solid #e0e0e0 1px";
                            descdiv.innerHTML = '';
                            if (req.responseText.indexOf("沒有")<0) {
                                if (!document.fx.full_mode.checked) {
                                    descdiv.innerHTML = 
                                    "按科目編號可看該科目的分類帳<br><br>" +
                                    '<a href="javascript:do_export(\''+param+'\')">匯出</a> (可編輯摘要並印出)<br>';
                                }
                            }
                            // descdiv.innerHTML += '<br><a href="javascript:export_history()">歷史匯出資料</a>';
                            var d = document.getElementById("checkall");
                            d.onclick = checkall;
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

        function export_history()
        {
            var url = 'vchr_export_history.jsp?';
            openwindow_phm2(url, '分類帳匯出歷史', 800, 600, 'exporthistorywin');
        }

        function show_export(vid)
        {
            var url = 'vchr_edit.jsp?id='+vid+'&export=true';
            openwindow_phm2(url,'分類帳匯出',700,600,'exportvchrwin2');
        }

        function do_export(param)
        {
            var url = 'vchr_export.jsp?' + param;
            openwindow_phm2(url, '分類帳匯出', 700, 600, 'exportvchrwin1');
        }

        function do_remind()
        {
            var d1 = new Date(document.fx.fx_end.value);
            var d2 = new Date();
            var days = (d1-d2)/(1000*86400);
            var label = (days<0)?"天前":"天後";
            var tmp = days + "";
            var dot = tmp.indexOf(".");
            var n = days;
            if (dot>0) {
                n = eval(tmp.substring(0,dot));
                if (days>0) {
                    n = n + 1;
                    label = n + label;
                }
                else {
                    n = 0 - n;
                    if (n==1) {
                        label = "昨天";
                    }
                    else if (n==2) {
                        label = "前天";
                    }
                    else 
                        label = n + label;
                }
                if (n==0) {
                    label = "今天";
                }
            }
            var s = document.getElementById("remind");
            s.innerHTML = label;
        }

        var displaydiv = null;
        var descdiv = null;
        function setup_display(divname, descname) {
            displaydiv = document.getElementById(divname);
            descdiv = document.getElementById(descname);

            var start = Get_Cookie("fx_start");
            if (start!=null)
                document.fx.fx_start.value = start;
            else
                document.fx.fx_start.value = '<%=_sdfx.format(new Date())%>';
            var end = Get_Cookie("fx_end");
            if (end!=null)
                document.fx.fx_end.value = end;
            else
                document.fx.fx_end.value = '<%=_sdfx.format(new Date())%>';
            document.fx.fx_t0.checked = true;
            do_remind();
            do_change();
        }

        function clear_display() {
            displaydiv.innerHTML = '';
            displaydiv.style.border = "";
            descdiv.innerHTML = '';
        }

        function checkall(f)
        {
            var target = this.form.a;
            if (typeof target!='undefined') {
                if (typeof target.length=='undefined')
                    target.checked = this.checked;
                else {
                    for (var i=0; i<target.length; i++) {
                        target[i].checked = this.checked;
                    }
                }
            }
        }
    </script>