            <script>
                function find_target_<%=field%>()
                {
                    openwindow_phm2('schedule_find_target.jsp?field=<%=field%>&bunit=<%=bunit%>','設定對象',400,500,'settarget<%=field%>');
                }

                function setTarget_<%=field%>(id, name)
                {
                    var sdiv = document.getElementById('<%=field%>');
                    sdiv.innerHTML = "<input type=hidden name=<%=field%> value=" + id + ">" + name;
                    <%=extra%>
                }
            </script>

            <div class=es02 name="<%=field%>" id="<%=field%>">
                請選擇對象
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:find_target_<%=field%>();"><img src="pic/add.gif" border=0 width=12>&nbsp;設定對象</a>

            
