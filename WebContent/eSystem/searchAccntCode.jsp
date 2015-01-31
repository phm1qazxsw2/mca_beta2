<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<style type="text/css">

	#ajaxMessage{
		margin-top:10px;
		font-size:0.9em;
		color:red;
	
	}
	#expandCollapse{
		font-size:0.9em;
	}
	a{
		color:#000;
		font-family:arial;
	}
	
	#dhtmlgoodies_tree{
		margin:0px;
		padding:0px;
		margin-left:10px;
	}
	#dhtmlgoodies_tree ul{	/* Sub menu groups */
		margin-left:20px;	/* Left spacing */
		padding-left:0px;
		display:none;	/* Initially hide sub nodes */
	}
	#dhtmlgoodies_tree li{	/* Nodes */
		list-style-type:none;
		vertical-align:middle;
		
	}
	#dhtmlgoodies_tree li a{	/* Node links */
		color:#000;
		text-decoration:none;
		font-family:arial;
		font-size:0.8em;
		padding-left:2px;
	}
	#dhtmlgoodies_tree input{
		width:200px;
		font-size:0.7em;
		margin-left:2px;
		font-family:arial;
	}
	</style>
    <script src="js/cookie.js"></script>
	<script type="text/javascript" src="js/ajax.js"></script>
	<script type="text/javascript">
	/************************************************************************************************************
	(C) www.dhtmlgoodies.com, November 2005
	
	This is a script from www.dhtmlgoodies.com. You will find this and a lot of other scripts at our website.	
	
	Terms of use:
	You are free to use this script as long as the copyright message is kept intact. However, you may not
	redistribute, sell or repost it without our permission.
	
	Thank you!
	
	www.dhtmlgoodies.com
	Alf Magne Kalleland
	
	************************************************************************************************************/
		
	var dhtmlgoodies_tree;
	var imageFolder = 'images/';	// Path to images
	var folderImage = 'dhtmlgoodies_folder.gif';
	var plusImage = 'dhtmlgoodies_plus.gif';
	var minusImage = 'dhtmlgoodies_minus.gif';
	var initExpandedNodes = '';	// Cookie - initially expanded nodes;
	var fileName = 'updateNode.php';	// External file called by AJAX	
	var timeoutEdit = 20;	// Lower value = shorter delay from mouse is pressed down to textbox appears.
	
	
	var ajax = new sack();
		
	function expandAll()
	{
		var menuItems = dhtmlgoodies_tree.getElementsByTagName('LI');
		for(var no=0;no<menuItems.length;no++){
			var subItems = menuItems[no].getElementsByTagName('UL');
			if(subItems.length>0 && subItems[0].style.display!='block'){
				showHideNode(false,menuItems[no].id.replace(/[^0-9]/g,''));
			}			
		}
	}
	
	function collapseAll()
	{
		var menuItems = dhtmlgoodies_tree.getElementsByTagName('LI');
		for(var no=0;no<menuItems.length;no++){
			var subItems = menuItems[no].getElementsByTagName('UL');
			if(subItems.length>0 && subItems[0].style.display=='block'){
				showHideNode(false,menuItems[no].id.replace(/[^0-9]/g,''));
			}			
		}		
	}
			
	function showHideNode(e,inputId)
	{
		if(inputId){
			if(!document.getElementById('dhtmlgoodies_treeNode'+inputId))return;
			thisNode = document.getElementById('dhtmlgoodies_treeNode'+inputId).getElementsByTagName('IMG')[0]; 
		}else {
			thisNode = this;
		}
		if(thisNode.style.visibility=='hidden')return;
		var parentNode = thisNode.parentNode;
		inputId = parentNode.id.replace(/[^0-9]/g,'');
		if(thisNode.src.indexOf('plus')>=0){
			thisNode.src = thisNode.src.replace('plus','minus');
			parentNode.getElementsByTagName('UL')[0].style.display='block';
			if(!initExpandedNodes)initExpandedNodes = ',';
			if(initExpandedNodes.indexOf(',' + inputId + ',')<0) initExpandedNodes = initExpandedNodes + inputId + ',';
			
		}else{
			thisNode.src = thisNode.src.replace('minus','plus');
			parentNode.getElementsByTagName('UL')[0].style.display='none';
			initExpandedNodes = initExpandedNodes.replace(',' + inputId,'');
		}	
		Set_Cookie('dhtmlgoodies_expandedNodes',initExpandedNodes,500);
	}

	function okToNavigate()
	{
		if(editCounter<10)return true;
		return false;		
	}
	
	var editCounter = -1;
	var editEl = false;
	
	function initEditLabel()
	{	
		if(editEl)hideEdit();
		editCounter = 0;
		editEl = this;	// Referenc to a Tag
		startEditLabel();
	}
	
	function startEditLabel()
	{
		if(editCounter>=0 && editCounter<10){
			editCounter = editCounter + 1;
			setTimeout('startEditLabel()',timeoutEdit);
			return;
		}
		if(editCounter==10){
			var el = editEl.previousSibling;
			el.value = editEl.innerHTML;
			editEl.style.display='none';
			el.style.display='inline';	
			el.select();
			return;
		}		
	}
	
	function showUpdate()
	{
		document.getElementById('ajaxMessage').innerHTML = ajax.response;
	}
	
	function hideEdit()
	{				
		var editObj = editEl.previousSibling;	
		if(editObj.value.length>0){
			editEl.innerHTML = editObj.value;	
			ajax.requestFile = fileName + '?updateNode='+editObj.id.replace(/[^0-9]/g,'') + '&newValue='+editObj.value;	// Specifying which file to get
			ajax.onCompletion = showUpdate;	// Specify function that will be executed after file has been found
			ajax.runAJAX();		// Execute AJAX function
						
		}
		editEl.style.display='inline';
		editObj.style.display='none';
		editEl = false;			
		editCounter=-1;
	}
	
	function mouseUpEvent()
	{
		editCounter=-1;		
	}
	
	function initTree()
	{
		dhtmlgoodies_tree = document.getElementById('dhtmlgoodies_tree');
		var menuItems = dhtmlgoodies_tree.getElementsByTagName('LI');	// Get an array of all menu items
		for(var no=0;no<menuItems.length;no++){
			var subItems = menuItems[no].getElementsByTagName('UL');
			var img = document.createElement('IMG');
			img.src = imageFolder + plusImage;
			img.onclick = showHideNode;
			if(subItems.length==0)img.style.visibility='hidden';
			var aTag = menuItems[no].getElementsByTagName('A')[0];
			
			if(aTag.id)numericId = aTag.id.replace(/[^0-9]/g,'');else numericId = (no+1);
			
			aTag.id = 'dhtmlgoodies_treeNodeLink' + numericId;
			
			var input = document.createElement('INPUT');
			input.style.width = '200px';
			input.style.display='none';
			menuItems[no].insertBefore(input,aTag);
			input.id = 'dhtmlgoodies_treeNodeInput' + numericId;
			input.onblur = hideEdit;
						
			menuItems[no].insertBefore(img,input);
			menuItems[no].id = 'dhtmlgoodies_treeNode' + numericId;
			aTag.onclick = okToNavigate;
			aTag.onmousedown = initEditLabel;
			var folderImg = document.createElement('IMG');
			if(menuItems[no].className){
				folderImg.src = imageFolder + menuItems[no].className;
			}else{
				folderImg.src = imageFolder + folderImage;
			}
			menuItems[no].insertBefore(folderImg,input);
		}	
		initExpandedNodes = Get_Cookie('dhtmlgoodies_expandedNodes');
		if(initExpandedNodes){
			var nodes = initExpandedNodes.split(',');
			for(var no=0;no<nodes.length;no++){
				if(nodes[no])showHideNode(false,nodes[no]);	
			}			
		}	
		
		document.documentElement.onmouseup = mouseUpEvent;
        collapseAll();
	}
	
	window.onload = initTree;	

</script>
<script>
    function setcode(acctcode) {
        parent.setCode(acctcode);
        parent.acctcodewin.hide();
    }
</script>

</head>
<body>

	<ul id="dhtmlgoodies_tree">
<%
    int showall=0;

    String showallS=request.getParameter("showall");

    if(showallS !=null)
        showall=Integer.parseInt(showallS);

    int type=1;
    String typeS=request.getParameter("type").trim();

    if(typeS !=null)
        type=Integer.parseInt(typeS);

    String vid=request.getParameter("vid");
    String urlString="";

    if(vid !=null && !vid.equals("null") && !vid.equals("NULL")){
        urlString="spending_modify.jsp?id="+vid+"&";
    }else{
        urlString="spending_add.jsp?";
    }

    if(showall !=0){
%>
<div class=es02>
<%=(type==3)?"":"<a href=\"searchAccntCode.jsp?type=3&vid="+vid+"&showall=1\">"%>資產(1)<%=(type==3)?"":"</a>"%> | 
<%=(type==4)?"":"<a href=\"searchAccntCode.jsp?type=4&vid="+vid+"&showall=1\">"%>負債(2)<%=(type==4)?"":"</a>"%> |
<%=(type==5)?"":"<a href=\"searchAccntCode.jsp?type=5&vid="+vid+"&showall=1\">"%>業主權益(3)<%=(type==5)?"":"</a>"%> | 
<%=(type==2)?"":"<a href=\"searchAccntCode.jsp?type=2&vid="+vid+"&showall=1\">"%>收入(4,7)<%=(type==2)?"":"</a>"%> | 
<%=(type==1)?"":"<a href=\"searchAccntCode.jsp?type=1&vid="+vid+"&showall=1\">"%>支出(5,6)<%=(type==1)?"":"</a>"%> |
</div>        
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<%

    }



    int peterType=0;
    
    if(type==1)
        peterType=0;
    else if(type==2)
        peterType=1;





    JsfAdmin ja=JsfAdmin.getInstance();
    BigItem[] bi=ja.getActiveBigItem2ByType(type);

    if(bi ==null)
    {
%>
        <blockquote>
        <div class=es02>
            沒有可用的會計科目.

            <br>
            <br>
            <a href="ListBigItem.jsp?type=<%=type%>" target="_top"><img src="pic/fix.gif" border=0 width=14>編輯會計科目</a>
        </div>
        </blockquote>
<%
        return;
    }    

    for(int i=0;bi !=null && i<bi.length;i++)
    {
%>
    <li><a href="javascript:setcode('<%=bi[i].getAcctCode()%>')"><%=bi[i].getAcctCode()%>-<%=bi[i].getBigItemName()%></a>
        <ul>
<%
        SmallItem[] si=ja.getActiveSmallItemByBID(bi[i].getId());
        
        for(int j=0;si !=null && j<si.length; j++)
        {
%>
        <li class="dhtmlgoodies_sheet.gif"><a href="javascript:setcode('<%=bi[i].getAcctCode()%><%=si[j].getAcctCode()%>')"><%=si[j].getAcctCode()%> <%=si[j].getSmallItemName()%></a></li>
<%
        }

    if(checkAuth(ud2,authHa,203))
    {
%>     
        <li class="add.gif"><a href="modifySmallItem2.jsp?sid=0&bid=<%=bi[i].getId()%>&backurl=<%=java.net.URLEncoder.encode(urlString+"&type="+peterType)%>" id="node7">新增子科目</a></li>
<%  }   %>   
        </ul>
    </li>
<%  }  

    if(checkAuth(ud2,authHa,203))
    {
%>
    <li class="add.gif"><a href="addBigItemX.jsp?bi=0&type=<%=type%>&backurl=<%=java.net.URLEncoder.encode("searchAccntCode.jsp?type="+type)%>">新增主科目</a></li>
<%  }   %>
	</ul>
	<div id="ajaxMessage"></div>
