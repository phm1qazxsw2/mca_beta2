<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
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
	var fileName = 'updateNode.jsp';	// External file called by AJAX	
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
            if (aTag==null)
                continue;
			
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

<%
    McaAuthorizerMgr aumgr = McaAuthorizerMgr.getInstance();
    aumgr.setDataSourceName("mssql");
    // String q = McaService.getAcodeSubQueryString(_ws2.getSessionBunit());
    String q = "Sub_Account!=''";
    String t = request.getParameter("t");
    if (t!=null && t.length()>0) {
        q = "Account_Number like '" + t + "%' or Sub_Account like '" + t + 
            "%' or Account_Name like '%" + t + "%' or Description1 like '%" + t + 
            "%' or Description2 like '%" + t + "%'";
    }
    ArrayList<McaAuthorizer> authrs = aumgr.retrieveList(q, "");
%>

<form>
&nbsp;&nbsp;<input type=text name="t" size=4> <input type=button value="search" onclick="this.form.submit()">   
<ul id="dhtmlgoodies_tree">
    <li>
<%
        for(int j=0; j<authrs.size(); j++)
        {
            McaAuthorizer a = authrs.get(j);
            String acctcode = a.getAccount_Number() + "-" + a.getSub_Account();
            String description = McaService.getAcodeDescription(a);
%>
        <li class="dhtmlgoodies_sheet.gif"><a href="javascript:setcode('<%=acctcode%>')"> <%=acctcode%> <%=description%></a></li>
<%
        }
        out.println("</ul>");
%>
    </li>
</ul>
</form>
<div id="ajaxMessage"></div>
