            <script>
                function find_charge_<%=field%>()
                {
                    openwindow_phm2('manhour_find_charge.jsp?field=<%=field%>','設定收費項目',400,500,'setcharge<%=field%>');
                }

                function setCharge_<%=field%>(id, name)
                {
                    var sdiv = document.getElementById('<%=field%>');
                    sdiv.innerHTML = "<input type=hidden name=<%=field%> value=" + id + ">" + name;
                    <%=extra%>
                }
            </script>
            <br>
            <span class=es02 name="<%=field%>" id="<%=field%>">
                尚未選擇收費項目
            </span>
            &nbsp;&nbsp;<a href="javascript:find_charge_<%=field%>();"><img src="pic/add.gif" border=0 width=12>&nbsp;設定</a>
            <br>
            <br>
            

            
