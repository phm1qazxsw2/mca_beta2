            <script>
                function find_costtrade()
                {
                    var code = '';
                    if (typeof document.xs.acctcode!='undefined')
                        code = document.xs.acctcode.value;
                    openwindow_phm2('find_costtrade.jsp?bicode='+code,'設定廠商',400,500,'costtradewin');
                }

                function setCostTradeId(id, name)
                {
                    var sdiv = document.getElementById("ct");
                    sdiv.innerHTML = "<input type=hidden name=costTradeId value=" + id + ">" + name;
                }
            </script>

            <div class=es02 name="ct" id="ct">
                不指定廠商
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:find_costtrade()"><img src="pic/add.gif" border=0 width=12>&nbsp;設定廠商</a>
