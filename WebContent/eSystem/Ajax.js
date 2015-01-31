// 建立XMLHttpRequest物件
function getHttpRequestObject() {
   // 建立XMLHttpRequest物件
   var httpRequest = new XMLHttpRequest();
   
   
 
   return httpRequest;
}
// 開啟和送出非同步請求
function makeRequest(httpRequest, url2) {
  	 httpRequest.open('GET',url2);
    httpRequest.send(null);
}
var xmlHttp;
// 送出HTTP請求來取得建議清單
function getSuggest(value) {
   // 建立XMLHttpRequest物件
	xmlHttp = getHttpRequestObject();
	
	showSuggestItems(xmlHttp); 
	var urlString="";
	if(objNav.appName=="Microsoft Internet Explorer")
	 	urlString= "getSuggest.jsp?search=" + value;
	else
		urlString= "getSuggest2.jsp?search=" + value;
	makeRequest(xmlHttp, urlString); // 建立HTTP請求      

   
 
}
// 顯示建議清單
function showSuggestItems(xmlHttp) {
  	// if ( xmlHttp.readyState == 4 ) {
      // 取得回應
    var xmlResult;
      
    if (xmlHttp) 
    {
        xmlHttp.onreadystatechange = function() 
        {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) 
            {
                 xmlDoc = xmlHttp.responseText;
                	result.innerHTML = xmlDoc;
                 	
            }
        }
    }
}	
	

// 滑鼠按一下, 即可更改欄位內容
function setSearch(value,stuId) {
   document.getElementById("txtSearch").value = value;
   document.getElementById("result").innerHTML = "";
   var stuIdValue="";
   //stuIdValue=stuId;
   //alert(typeof(stuIdValue));
   document.getElementById("studentId").value = stuId;
   

	
}
// 指定滑鼠移過的樣式
function suggestOver(tag) {
  // tag.className = "LinkOver";
}
// 指定滑鼠移出的樣式
function suggestOut(tag) {
   //tag.className = "Link";
}