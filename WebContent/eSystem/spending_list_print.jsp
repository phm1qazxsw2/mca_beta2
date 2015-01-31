<link href=ft02.css rel=stylesheet type=text/css>

<body onload="doinit()">
<div class=es02 id="content">
</div>
</body>

<script>
function doinit() {
   var html = opener.document.getElementById("result").innerHTML;
   document.getElementById("content").innerHTML = html;
}
</script>
