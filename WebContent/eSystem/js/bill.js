// ##### show 帳單搜尋頁 連結的相關的 voucher    
function show_acode_detail(aid) {
    document.acodeform.a.value = aid;
    document.acodeform.submit();
}

//## for 顯示傳票, need by searchbillrecord.jsp
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
// ##############################

function show_bill_acodes(ticketIds, title)
{
    openwindow_inline("<div id='show_acodes_sum'></div>", title, 600, 500, 'vchrwin');
    
    var url = "vchr/show_bill_vchrsearch.jsp";
    var post_params = "o=" + encodeURI(ticketIds) + "&t=" + encodeURI(title);

    var req = new XMLHttpRequest();
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var d = document.getElementById("show_acodes_sum");
                d.style.overflow = "auto";
                d.innerHTML = req.responseText;
            }
            else if (req.readyState == 4 && req.status == 404) {
                alert("檔案不存在");
                return;
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('POST', url);
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("Content-length", post_params.length);
    req.setRequestHeader("Connection", "close");
    req.send(post_params);
}
    
// ##### show 單張帳單相關的 voucher    
function show_bill_vouchers(ticketId, threadId)
{
    var url = "vchr/show_bill_vchr.jsp?thread=" + threadId;
    openwindow_phm2(url, "帳單 " + ticketId + " 相關傳票", 800, 400, 'vchrwin');
}

// ######### 下面是用來儲存印賬單前修改 billDate 和 comment 的
function save_bill_modifyall(f)
{
    if (!isDate(f.billDate.value, 'yyyy-MM-dd')) {
        alert("請輸入正確的日期格式, 設定請打西元年.\n如 2010-10-21");
        f.billDate.focus();
        return;
    }

    var url = "bill_modify_all2.jsp"
    var post_params = "ticketIds=" + encodeURI(f.ticketIds.value) + "&billDate=" + encodeURI(f.billDate.value) +
        "&comment=" + encodeURI(f.comment.value) + "&overwrite=" + f.overwrite.checked;

    var req = new XMLHttpRequest();
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                parent.modify_win.hide();
                alert('設定成功');
                parent.location.reload();
                /*
                if (isIE()) {
                    alert('設定成功');
                }
                else {
                    parent.setBillDateComment(f.billDate.value, f.comment.value);
                }
                parent.modify_win.hide();
                */
            }
            else if (req.readyState == 4 && req.status == 404) {
                alert("檔案不存在");
                return;
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('POST', url);
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("Content-length", post_params.length);
    req.setRequestHeader("Connection", "close");
    req.send(post_params);
}

function modify_bill(ticketIds)
{
    // 要用 post 傳 ticketIds 才不會太長所以要用 openwindow_inline + ajax 處理
    openwindow_inline('<div id=space_area></div>', "修改繳費截止日期和備註", 600, 500, 'modify_win');
    var url = "bill_modify_all.jsp"
    var post_params = "o=" + encodeURI(ticketIds);

    var req = new XMLHttpRequest();
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                document.getElementById("space_area").innerHTML = req.responseText;
            }
            else if (req.readyState == 4 && req.status == 404) {
                alert("檔案不存在");
                return;
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('POST', url);
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("Content-length", post_params.length);
    req.setRequestHeader("Connection", "close");
    req.send(post_params);
}