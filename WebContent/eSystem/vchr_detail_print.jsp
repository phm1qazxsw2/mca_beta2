
<link href="ft02.css" rel=stylesheet type=text/css>
<body onload="init()">
<div id="display">
</div>

<script>
function init() {
    var h = window.opener.getPrintHeader();
    var d = window.opener.getData();
    document.getElementById("display").innerHTML = "<center>" + h + d + "</center>";
}
</script>
