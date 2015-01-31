<link href=ft02.css rel=stylesheet type=text/css>

<body onload="init()">
<div id="content">
</div>
</body>

<script>
function init() {
    var d = opener.document.getElementById("content");
    document.getElementById("content").innerHTML = d.innerHTML;
}
</script>