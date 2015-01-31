            <script>
                function find_target_<%=field%>()
                {
                    if (get_source_membr()==-1) {
                        alert("請先選擇派遣人員");
                        return;
                    }
                    openwindow_phm2('manhour_find_target.jsp?field=<%=field%>&mid='+get_source_membr(),'設定對象',400,500,'settarget<%=field%>');
                }

                function setTarget_<%=field%>(id, name)
                {
                    var sdiv = document.getElementById('<%=field%>');
                    sdiv.innerHTML = "<input type=hidden name=<%=field%> value=" + id + ">" + name;
                    <%=extra%>
                }
            </script>
            <br>
            <span class=es02 name="<%=field%>" id="<%=field%>">
                尚未選擇客戶
            </span>
            &nbsp;&nbsp;<a href="javascript:find_target_<%=field%>();"><img src="pic/add.gif" border=0 width=12>&nbsp;設定</a>
            <br>
            <br>
            
