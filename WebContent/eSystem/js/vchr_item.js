// ### define vitem
var MODE_READ_ONLY = 0;
var MODE_EDIT_SAME = 1;
var MODE_EDIT_FREE = 2;
var MODE_EDIT_RESTRICT_NOTE = 3;

var STATUS_DISPLAY = 0;
var STATUS_EDITING = 1;

function vitem(id, bunit, flag, debit, credit, main, sub, bu, name, note) {
	this.id = id;
    this.bunit = bunit;
    this.flag = flag;
    this.debit = debit;
    this.credit = credit;
    this.main = main;
    this.sub = sub;
    this.bu = bu;
	this.name = name;
    this.note = note;

	this.ui = null;
    
    this.getCode = function() {
		return this.main + ((this.sub!=null)?this.sub:"");
	}

    this.getContent = function() {
        return "id:" + this.id + "|flag:" + this.flag + 
            "|debit:" + this.debit + "|credit:" + this.credit + 
            "|main:" + this.main + "|sub:" + this.sub + 
            "|bu:" + this.bu + "|name:" + encodeURI(this.name) +
            "|note:" + this.note;
    }

    this.setCode = function(code) {
        if (code.length>4) {
            this.main = code.substring(0,4);
            this.sub = code.substring(4);
        }
        else {
            this.main = code;
            this.sub = "";
        }
    }

	this.draw_bunit = function() {
        if (typeof this.ui.bunitIds=='undefined' || this.ui.bunitIds.length==0)
            return "----";
		if (this.ui.edit_status==STATUS_EDITING && this.ui.edit_mode!=MODE_EDIT_RESTRICT_NOTE) {
            var ret = '<select name="bu_'+this.idx+'" id="bu_'+this.idx+'">\n';
            ret += '<option value=0>----\n';
            for (var i=0; i<this.ui.bunitIds.length; i++) {
                ret += '<option value="' + this.ui.bunitIds[i] + '"';
                if (this.ui.bunitIds[i]==this.bu)
                    ret += ' selected';
                ret += ">" + this.ui.bunitNames[i] + '\n';
            }
            ret += "</select>\n";
            return ret;	
        }
        else {
            for (var i=0; i<this.ui.bunitIds.length; i++) {
                if (this.bu==this.ui.bunitIds[i])
        			return this.ui.bunitNames[i];
            }
            return "----";
        }
	}
	this.draw_code = function() {
		return (this.ui.edit_status==STATUS_EDITING && this.ui.edit_mode!=MODE_EDIT_RESTRICT_NOTE)?
'                    <div style="position:relative;overflow:visible;z-index:'+(1000-this.idx)+'">'+
'                        <input type=text name="code_'+this.idx+'" id="code_'+this.idx+'" value="'+this.getCode()+'" size=5 autocomplete=off>'+
'                        <div id="codetip_'+this.idx+'" style="position:absolute;left:0px;top:21px;visibility:hidden;border:solid green 2px;background-color:white;z-index:1"></div>'+
'                        <span onclick="find_acctcode('+this.idx+')"><img src="pic/mirror.png" width=10></span>'+
'                        <span id="name_'+this.idx+'">'+this.name+'</span>'+
'                    </div>':
				this.getCode() + "&nbsp;&nbsp;" + this.name;
	}
	this.draw_debit = function() {
        var fl = (this.debit!=0)?0:1;
		return (this.ui.edit_status==STATUS_EDITING && this.ui.edit_mode!=MODE_EDIT_RESTRICT_NOTE)?
            '<input type=text id="debit_'+this.idx+'" name="debit_'+this.idx+
                '" value="'+((this.debit==0)?"":(this.debit))+'" size=2 style="text-align:right">':
            (fl==0)?this.debit:"";
	}
	this.draw_credit = function() {
        var fl = (this.debit!=0)?0:1;
		return (this.ui.edit_status==STATUS_EDITING && this.ui.edit_mode!=MODE_EDIT_RESTRICT_NOTE)?
            '<input type=text id="credit_'+this.idx+'" name="credit_'+this.idx+
                '" value="'+((this.credit==0)?"":(this.credit))+'" size=2  style="text-align:right">':
            (fl==0)?"":this.credit;
	}

	this.draw_note = function() {
        if (this.ui.is_template)
            return "";
		return (this.ui.edit_status==STATUS_EDITING)?
			'<input type=text id="note_'+this.idx+'" name="note_'+this.idx+'" value="'+this.note+'" size=30>':
			(this.note!=null)?this.note:"";
	}
}

// ### 使用 acode_tree_find.jsp 來選 acode 的用的 ####
var cur = 0; // 用來記錄現在 edit 是哪一個
function setCode(acctcode) {
	document.f1['code_' + cur].value = acctcode;
    document.f1['code_' + cur].onblur();
}

function find_acctcode(idx)
{
	cur = idx;
	if (typeof parent.acctcodewin!='undefined' && !parent.acctcodewin.isClosed)
		parent.acctcodewin.show();
	else
		openwindow_phm2('acode_tree_find.jsp','尋找會計科目',350,600,'acctcodewin');
}
// #################################


// #### 下面要非常配合 UI, form 名一定要叫 f1 #####
function ajax_get_name(idx)
{
	var code = document.f1['code_' + idx].value;
	var url = "acode_getname.jsp?code=" + encodeURI(code) + "&r="+(new Date()).getTime();
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
					var d = document.getElementById("name_" + idx);
                    var name = req.responseText;
					d.innerHTML = name;
                    parent.ui.items[idx].name = name;
                    document.f1['debit_'+idx].focus();
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

// ### 下面用 vitems array 畫界面出來 ####
function draw_table()
{
    var colspan = 4 + ((this.is_template)?0:1);
    if (this.edit_status==STATUS_EDITING || this.edit_mode!=MODE_EDIT_RESTRICT_NOTE)
        colspan += (this.items.length==2)?2:3; // 兩個時不印 "刪除"
	var str = 
'<form name=f1>' +
'  <table width="400" height="" border="0" cellpadding="0" cellspacing="0">' +
'        <tr align=left valign=top>'+
'        <td bgcolor="#e9e3de">'+
'            <table class=es02 width="100%" border=0 cellpadding=4 cellspacing=1>';
    if (!this.is_template) {
        str +=
'            <tr align=left bgcolor=f0f0f0>'+
'                <td colspan='+colspan+'>';
        if (this.edit_status==STATUS_EDITING) {
            if (this.edit_mode==MODE_EDIT_FREE) {
                str += '<a href="#" onclick="displayCalendar(document.f1.registerDate,\'yyyy/mm/dd\',this);return false">入帳日期</a>'+
'                       <input type=text name="registerDate" id="registerDate" value="'+this.registerDate+'" size=10>'+
'                   　　傳票編號 <input type=text name="serial" id="serial" value="'+this.serial+'" size=15> ';
            }
            else if (this.edit_mode==MODE_EDIT_SAME) {
                str += '<a href="#" onclick="displayCalendar(document.f1.registerDate,\'yyyy/mm/dd\',this);return false">入帳日期</a>'+
'                   <input type=text name="registerDate" id="registerDate" value="'+this.registerDate+'" size=10 disabled>'+
'                   　　傳票編號 <input type=text name="serial" id="serial" value="'+this.serial+'" size=15 disabled> ';
            }
            else if (this.edit_mode==MODE_EDIT_RESTRICT_NOTE) {
                str += '<a href="#" onclick="displayCalendar(document.f1.registerDate,\'yyyy/mm/dd\',this);return false">入帳日期</a>'+
'                   <input type=text name="registerDate" id="registerDate" value="'+this.registerDate+'" size=10>'+
'                   　　傳票編號 ' + this.serial + '<input type=hidden name="serial" id="serial" value="'+this.serial+'"> ';
            }
        }
        else {
            str += '<input type=hidden name="serial" id="serial" value="'+this.serial+'">';
            str += '<table class=es02  cellpadding="0" cellspacing="0" width=100% border=0>' +
                    '<tr align=left><td>入帳日期 :</td><td>' + this.registerDate + '</td><td>傳票編號 :</td><td>' + this.serial + '</td></tr>';
            str +=  '<tr align=left><td>登入人 :</td><td>' + this.userName + '</td><td>登入日期 :</td><td>' + this.createDate + '</td></tr>'+
                    '</table>';
        }
        str += 
'               </td>'+
'            </tr>'+
'            <tr bgcolor=white><td colspan='+colspan+'></td></tr>';
    }
    str +=
'            <tr align=center bgcolor=f0f0f0>'+
'                <td nowrap>'+
'                    部門'+
'                </td>'+
'                <td nowrap>'+
'                    會計科目' +
'                </td>'+
'                <td width=50>'+
'                    借'+
'                </td>'+
'                <td width=50>'+
'                    貸'+
'                </td>';
    if (!this.is_template) {
        str +=
'                <td width=100 nowrap>'+
'                    摘要';
    }
    str +=
'                </td>';
    if (this.edit_status==STATUS_EDITING && this.edit_mode!=MODE_EDIT_RESTRICT_NOTE && this.items.length>2)
        str += 
'                <td></td>';
    if (this.edit_status==STATUS_EDITING && this.edit_mode!=MODE_EDIT_RESTRICT_NOTE) {
        str += 
'                <td>上</td>'+
'                <td>下</td>';
    }
    str +=
'            </tr>';
    for (var i=0; i<this.items.length; i++) {
        var vi = this.items[i];
        str += 
'            <tr bgcolor=ffffff>'+
'                <td nowrap>'+
                     vi.draw_bunit() +
'                </td>'+
'                <td nowrap>'+
			         vi.draw_code() +
'                </td>' +
'                <td align=right nowrap>'+
                     vi.draw_debit() +
'                &nbsp;</td>'+
'                <td align=right nowrap>'+
                     vi.draw_credit() +
'                &nbsp;</td>';
        if (!this.is_template) {
            str +=
'                <td nowrap>'+
                     vi.draw_note() +
'                </td>';
        }

        if (this.edit_status==STATUS_EDITING &&  this.edit_mode!=MODE_EDIT_RESTRICT_NOTE && this.items.length>2) {
            str +=
'                <td nowrap><span id="remove_'+vi.idx+'">刪除</span></td>';
        }
        if (this.edit_status==STATUS_EDITING &&  this.edit_mode!=MODE_EDIT_RESTRICT_NOTE) {
            str +=
'                <td nowrap>' + ((i>0)?'<span id="up_'+vi.idx+'"><img src="images/Upicon2.gif" border=0></span>':'')+ '</td>'+
'                <td nowrap>' + ((i<this.items.length-1)?'<span id="down_'+vi.idx+'"><img src="images/Downicon2.gif" border=0></span>':'')+'</td>';
        }
        str +=
'            </tr>';
    }
    str += 
'            <tr bgcolor=#ffffff>'+
'                <td colspan='+colspan+' bgcolor="#f0f0f0" height=2></td>'+
'            </tr>'+
'            <tr bgcolor=#ffffff>'+
'                <td colspan=2>'+
                    ((this.edit_status==STATUS_EDITING && this.edit_mode!=MODE_EDIT_RESTRICT_NOTE)?'<a href="" id="add_item">+</a>':'') +
'                </td>'+
'                <td align=right id="debit_sum"></td>'+
'                <td align=right id="credit_sum"></td>';
    if (colspan>4) {
        str += 
'                <td colspan='+(colspan-4)+'></td>';
    }
    str +=
'            </tr>';
    if (this.edit_status==STATUS_EDITING) {
        str += 
'            <tr bgcolor=#ffffff>'+
'                <td colspan='+colspan+'>' + 
'                    <table width=100% class=es02><tr><td align=center><a href="" id="save">存檔</a></td>' +
'                       <td width=60>' + ((typeof this.paintfunc!="undefined" && this.paintfunc!=null)?"(<a href=\"javascript:"+this.paintfunc+"\">重畫介面</a>)":"") +
'                       </td></tr></table></td>'+
'            </tr>';
    }
    str +=
'        </table>'+
'    </td>'+
'    </tr>'+
'</table>';

    if (this.note!=null)
        str += '<span class=es02>附註:' + this.note + '</span>';

    str += 
'</form>';	

	this.mydiv.innerHTML = str;
}

function setup_auto_complete()
{
    for (var i=0; i<this.items.length; i++) {
        if (this.items[i].ui.edit_status!=STATUS_EDITING)
            continue;
        var idx = this.items[i].idx;
        new AutoComplete(aNames, 
            document.getElementById('code_' + idx), 
            document.getElementById('codetip_' + idx), 
            -1,
            ajax_get_name,
            idx
        );	
    }
}

function update_sum()
{
    var debit = 0;
    var credit = 0;
    for (var i=0; i<this.items.length; i++) {
        debit += this.items[i].debit;
        credit += this.items[i].credit;
    }
    document.getElementById("debit_sum").innerHTML = debit + " &nbsp;";
    document.getElementById("credit_sum").innerHTML = credit + " &nbsp;";
}

function onSumChange() {
    var v = this.value;
    if (v.length==0)
        v = "0";
    else if (v=="-")
        return;
    if (!IsNumeric(v, false)) {
        alert("請輸入數字");
        return;
    }
    if (this.flag==0) {
        this.item.debit = eval(v);
        if (this.item.debit!=0) {
            this.other.value = "";
            this.item.credit = 0;
        }
    }
    else {
        this.item.credit = eval(v);
        if (this.item.credit!=0) {
            this.other.value = "";
            this.item.debit = 0;
        }
    }
    this.ui.update_sum();
}

function modifyNote()
{
    var v = this.value;
    this.item.note = v;
}

function modifyBunit()
{
    var v = this.options[this.selectedIndex].value;
    this.item.bu = v;
}

function setup_handler()
{
    var divs = new Array;
    if (this.edit_status==STATUS_EDITING) {
        for (var i=0; i<this.items.length; i++) {
            var item = this.items[i];
            // 設定借貸金額輸入
            var d1 = document.getElementById("debit_" + item.idx);
            var d2 = document.getElementById("credit_" + item.idx);
            var d3 = document.getElementById("note_" + item.idx);
            var d4 = document.getElementById("bu_" + item.idx);
            if (d1!=null && d2!=null) {
                d1.ui = this;
                d1.item = item;
                d1.flag = 0;
                d1.onkeyup = onSumChange;
                d1.other = d2;

                d2.ui = this;
                d2.item = item;
                d2.flag = 1;
                d2.onkeyup = onSumChange;
                d2.other = d1;
            }
            if (d3!=null) {
                d3.item = item;
                d3.onkeyup = modifyNote;
            }
            if (d4!=null) {
                d4.item = item;
                d4.onchange = modifyBunit;
            }
            // 刪除 handler
            var d = document.getElementById("remove_" + item.idx);
            if (d!=null) {
                d.ui = this;
                d.idx = item.idx;
                d.onclick = function() {
                    this.ui.remove_item(this.idx);
                    this.ui.draw();
                }
            }
            // 上移 handler
            d =  document.getElementById("up_" + item.idx);
            if (d!=null) {
                d.ui = this;
                d.idx = item.idx;
                d.onclick = function() {
                    this.ui.move_up(this.idx);
                    this.ui.draw();
                }
            }
            // 下移 handler
            d =  document.getElementById("down_" + item.idx);
            if (d!=null) {
                d.ui = this;
                d.idx = item.idx;
                d.onclick = function() {
                    this.ui.move_down(this.idx);
                    this.ui.draw();
                }
            }
            // 設定 code 和 name 的 handler
            // 這里很重要
            // 當 code 設好(不管是手打的, 還是 autocomplete 來的, 還是從 acode_tree_find.jsp call 到 setCode 來的
            // 最后都要 call 這里, 把值設到 item 里并 call 原來的 AutoComplete.onblur, which then calls 
            // ajax_get_name 接著會設定 name
            d = document.getElementById("code_" + item.idx);
            if (d!=null) {
                d.item = item;
                d.ui = this;
                d.onblur = function() {
                    this.item.setCode(this.value);
                    // 記得 call 原來的 onblur
                    this.AutoComplete.onblur();
                }
            }
        }
        var d = document.getElementById("add_item");
        if (d!=null) {
            d.ui = this;
            d.onclick = function() {
                this.ui.addnew();
                this.ui.draw();
                return false;
            }            
        }
        d = document.getElementById("save");
        if (d!=null) {
            d.ui = this;
            d.onclick = function() {
                this.ui.save();
                return false;
            }
        }
        if (!this.is_template) {
            d = document.getElementById("serial");
            if (d!=null) {
                d.ui = this;
                d.onchange = function() {
                    this.ui.serial = this.value;
                }
            }
            d = document.getElementById("registerDate");
            if (d!=null) {
                d.ui = this;
                d.onchange = function() {
                    this.ui.registerDate = this.value;
                }
                d.onblur = function() {
                    if (this.ui.edit_mode == MODE_EDIT_FREE)
                        this.ui.reset_serial();
                }
            }
        }
    }
}

function vchr_ui(theDiv, theItems, edit_mode, is_template, note)
{
    parent.ui = this;
	this.mydiv = theDiv;
	this.items = theItems;
	this.draw_table = draw_table;
	this.setup_auto_complete = setup_auto_complete;
    this.update_sum = update_sum;
    this.setup_handler = setup_handler;
    this.edit_mode = edit_mode;
    // this.edit = (this.edit_mode!=MODE_READ_ONLY);
    this.is_template = is_template;
    this.note = note;
    this.printable = false;
    this.edit_status = STATUS_DISPLAY;
    this.still_editable = false;
 
    this.setVchrInfo = function(serial, registerDate, userName, createDate)
    {
        this.serial = serial;
        this.registerDate = registerDate;
        if (userName!=null)
            this.userName = userName;
        if (createDate!=null)
            this.createDate = createDate;
    }

    this.setRepaint = function (paintfunc)
    {
        this.paintfunc = paintfunc;
    }

    this.setBunitNames = function(bunitIds, bunitNames) {
        this.bunitIds = bunitIds;
        this.bunitNames = bunitNames;
    }

    this.addnew = function() {
        var vi = new vitem(0, 0, 0, 0, 0, "", "", 0, "", "");
        vi.idx = this.items.length;
        this.items[this.items.length] = vi;
    }
    this.remove_item = function(idx) {
        if (this.items.length<=2) {
            return;
        }
        var old = this.items;
        this.items = new Array;
        for (var i=0; i<old.length; i++) {
            if (i==idx)
                continue;
            this.items[this.items.length] = old[i];
        }
        this.old = null;
    }
    this.move_up = function(idx) {
        if (idx==0)
            return;
        var tmp = this.items[idx-1];
        this.items[idx-1] = this.items[idx];
        this.items[idx] = tmp;
    }
    this.move_down = function(idx) {
        if (idx==(this.items.length-1))
            return;
        var tmp = this.items[idx+1];
        this.items[idx+1] = this.items[idx];
        this.items[idx] = tmp;
    }

	this.draw = function() {
        for (var i=0; i<this.items.length; i++) {
            this.items[i].ui = this;
            this.items[i].idx = i;
        }
		this.draw_table();
        if (this.edit_status==STATUS_EDITING && this.edit_mode!=MODE_EDIT_RESTRICT_NOTE) {
            this.setup_auto_complete();
        }
        this.setup_handler();
        this.update_sum();    
	}

    this.getContent = function() {
        var ret = '';
        for (var i=0; i<this.items.length; i++) {
            ret += trim(this.items[i].getContent());
            ret += '\n';
        }
        return ret;
    }

    this.configSave = function(uri, params, callback)
    {
        this.uri = uri;
        this.params = params;
        this.callback = callback;
    }

    this.show_status = function(msg) {
        alert(msg);
    }

    this.show_error = function(msg) {
        alert(msg);
    }

    this.save = function() {
        if (typeof this.uri=='undefined') {
            alert("儲存處理函數未設,不能儲存");
            return;
        }

        if (!this.is_template && trim(document.f1.serial.value).length==0) {
            alert("請輸入傳票編號");
            document.f1.serial.focus();
            return;
        }

        if (!this.is_template && !isDate(document.f1.registerDate.value, "yyyy/MM/dd")) {
            alert("請輸入正確的入帳日期");
            document.f1.registerDate.focus();
            return;
        }

        for (var i=0; ; i++) {
            var a = document.f1['code_'+i];
            if (typeof a=='undefined')
                break;
            if (trim(a.value).length==0) {
                alert("會計科目不可空白");
                a.focus();
                return;
            }
            var b = document.f1['debit_'+i];
            var c = document.f1['credit_'+i];
            if (trim(b.value).length==0 && trim(c.value).length==0) {
                alert("借貸值不可為0");   
                b.focus();
                return;
            }
        }

        var debit = 0;
        var credit = 0;
        for (var i=0; i<this.items.length; i++) {
            debit += this.items[i].debit;
            credit += this.items[i].credit;
        }
        if (debit!=credit) {
            alert("借貸不相等無法儲存");
            return;
        }
        if (is_template && credit!=1) {
            alert("樣本傳票借貸金額要為 1.0 (代表100%)");
            return;
        }

        var url = this.uri;
        var post_params = "";
        if (!this.is_template) {
            document.f1.serial.enabled = true;
            post_params += "serial="+ encodeURI(document.f1.serial.value) +
            "&registerDate="+ encodeURI(document.f1.registerDate.value) + "&";
        }            
        post_params += "stuff=" + encodeURI(this.getContent()) + "&" + this.params;
        var req = new XMLHttpRequest();
        cur_ui = this; // 用 req.ui IE6 不行
        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var t = req.responseText.indexOf("@@");
                    if (t>0)
                        cur_ui.show_error(req.responseText.substring(t+2));
                    else {
                        cur_ui.show_status("存檔成功!");
                        cur_ui.edit_status = STATUS_DISPLAY;
                        if (!cur_ui.is_template)
                            cur_ui.setVchrInfo(document.f1.serial.value, document.f1.registerDate.value);
                        cur_ui.draw();
                        if (typeof cur_ui.callback!='undefined') {
                            cur_ui.callback();
                        }
                    }                        
                }
                else if (req.readyState == 4 && req.status == 404) {
                    cur_ui.show_error("存檔處理程式找不到 資料沒有寫入");
                    return;
                }
                else if (req.readyState == 4 && req.status == 500) {
                    cur_ui.show_error("存檔發生錯誤 資料沒有寫入");
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

    this.reset_serial = function() {
        var url = "vchr/get_serial.jsp?d=" + encodeURI(document.f1.registerDate.value);
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
                        document.f1.serial.value = trim(req.responseText); 
                        document.f1.serial.onchange(); // 這個才會放 value 到 this.ui.serial
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
