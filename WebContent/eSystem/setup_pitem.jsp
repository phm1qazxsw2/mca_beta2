            <script>
                function find_pitem()
                {
                    openwindow_phm2('find_pitem.jsp','設定產品',400,500,'pitemwin');
                }

                function setPitem(id, name)
                {
                    var sdiv = document.getElementById("pi");
                    sdiv.innerHTML = "<input type=hidden name=pitemId value=" + id + ">" + name;
                }
            </script>

            <div class=es02 name="pi" id="pi">
                不指定產品
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:find_pitem()"><img src="pic/add.gif" border=0 width=12>&nbsp;設定產品</a>
