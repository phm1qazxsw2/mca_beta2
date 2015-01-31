<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml"> 
<%

    String q=request.getParameter("q");
%>

<head> 
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" /> 
    <title>Geocoding</title> 

    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAtcKKtf-I_HW6FpTov3f15BTvNrhNjBGfxr6rMR_SSSISOVQRQhTvX2aj4WGW1DqJ1EEzw6j74pf_3A" type="text/javascript"></script> 

    <script type="text/javascript"> 

    var map = null; 
    var geocoder = null; 
    var marker; 
     
    function initialize()  
    { 
        if (GBrowserIsCompatible())  
        { 
            map = new GMap2(document.getElementById("map")); 
            map.addControl(new GLargeMapControl());                 //加入地圖縮放工具 
            map.addControl(new GMapTypeControl());                 //加入地圖切換的工具 
            map.addMapType(G_PHYSICAL_MAP);                         //加入地形圖 
            map.setCenter(new GLatLng(25.001689, 121.460809), 8);   //設定台灣為中心點 
            geocoder = new GClientGeocoder(); 
        } 
    } 

    function createMarker(point,title,html)  
    { 
        var marker = new GMarker(point); 
         
        GEvent.addListener(marker, "click", function()  
        { 
            marker.openInfoWindowHtml( 
                html, 
                { 
                    maxContent: html, 
                    maxTitle: title} 
                ); 
        }); 
        return marker; 
    } 
     
    function showAddress(address)  
    { 
        if (geocoder)  
        { 
            geocoder.getLatLng( 
                address, 
                function(point)  
                { 
                    if (!point)  
                    { 
                        alert(address + " not found"); 
                    }  
                    else  
                    { 
                        if(marker)  //移除上一個點 
                        { 
                            map.removeOverlay(marker); 
                        } 
                         
                        map.setCenter(point, 13); 
                         
                        var title = "地址"; 
                         
                        marker = createMarker(point,title,address); 

                        map.addOverlay(marker); 

                        marker.openInfoWindowHtml( 
                            address, 
                            { 
                                maxContent: address, 
                                maxTitle: title} 
                            ); 
                    } 
                } 
            ); 
        } 
    } 

    </script> 

</head> 
<body onload="initialize()" onunload="GUnload()"> 
    <center>
    <form action="#" onsubmit="showAddress(this.address.value); return false" name="xs" id="xs"> 
        <p> 
            <input type="text" size="60" name="address" value="<%=q%>" /> 
            <input type="submit" value="Go!" /> 
        </p> 
        <div id="map" style="width: 550px; height: 350px"> 
        </div> 
    </form> 
    <center>
    <script>
        showAddress('<%=q%>');
    </script>

</body> 
</html>

