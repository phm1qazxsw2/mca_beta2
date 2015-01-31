            <script>
                function find_source_<%=field%>()
                {
                    openwindow_phm2('manhour_find_source.jsp?field=<%=field%>','設定對象',400,500,'setsource<%=field%>');
                }

                function setSource_<%=field%>(id, name)
                {
                    var sdiv = document.getElementById('<%=field%>');
                    sdiv.innerHTML = "<input type=hidden name=<%=field%> value=" + id + ">" + name;
                    <%=extra%>
                }
            </script>
            <span class=es02 name="<%=field%>" id="<%=field%>">
                尚未選擇派遣人員
            </span>
            &nbsp;&nbsp; <a href="javascript:find_source_<%=field%>();"><img src="pic/add.gif" border=0 width=12>&nbsp;設定</a>

            
