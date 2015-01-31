function show_voucher(id, path)
{
    show_voucher2(id, path, true);
}

function show_voucher2(id, path, smart_position)
{
    if (smart_position && typeof parent.vchrwin2!='undefined') {
        x = parent.vchrwin2.style.left;
        if (eval(parent.vchrwin2.style.top.replace("px",""))<getClientSizeObject().h)
            y = parent.vchrwin2.style.top;
    }
    var url = 'show_voucher.jsp?id='+id;
    if (path!=null)
        url = path + ((path.charAt(path.length-1)=='/')?"":"/") + url;
    openwindow_phm2(url, '傳票', 500, 500, 'vchrwin2');
    if (smart_position && typeof x!='undefined') {
        y = (typeof y=='undefined')?null:y;
        parent.vchrwin2.moveTo(x, y);
    }
}
