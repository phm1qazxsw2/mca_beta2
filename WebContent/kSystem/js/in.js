 function up2tab(s_obj){
  
  	//alert('cdate:'+document.xs.cdate.value);
  	
  	if(s_obj.value.length==2 && s_obj.value>90)
  	{
  		//alert(s_obj.value);	
  		document.xs.studentBirth.value="0"+s_obj.value+"/";
  	}
  	else if(s_obj.value.length==3)
  	{
  		document.xs.studentBirth.value=s_obj.value+"/";	
  	}
  	
  	
  	
  	if(s_obj.value.length==6)
  	{
  		//alert(s_obj.value);	
  		document.xs.studentBirth.value=s_obj.value+"/";
  	}
  	
  	if(s_obj.value.length==9)
  	{
  		return document.xs.studentFather.focus();
  	}
  	
  }
  
    
  function up3tab(s_obj,len,next_obj){
    var tmp_obj;
    if((s_obj.value.length >= len) && next_obj && (tmp_obj = eval("document.xs." + next_obj))) return tmp_obj.focus();
  }

  
  function emailCheck(eMail){
  	
  	re = /^([\w\.%-]+)\@([\w%-]+\.[\w\.%-]+)$/i;
  	var emailStirng=eMail.value;
  	
  	if(emailStirng.length==0)
  	{
  		return; 
  	}
  	found=emailStirng.match(re);
  	if(!found){
  		alert('½Ð¶ñ¤J¥¿½Temail');
  		return eMail.focus();
  	}
  	return found[0];
  }
  
   function up4tab(s_obj){
  
  	//alert('cdate:'+document.xs.cdate.value);
  	
  	if(s_obj.value.length==2 && s_obj.value>90)
  	{
  		//alert(s_obj.value);	
  		document.xs.teacherBirth.value="0"+s_obj.value+"/";
  	}
  	else if(s_obj.value.length==3)
  	{
  		document.xs.teacherBirth.value=s_obj.value+"/";	
  	}
  	
  	
  	
  	if(s_obj.value.length==6)
  	{
  		//alert(s_obj.value);	
  		document.xs.teacherBirth.value=s_obj.value+"/";
  	}
  	
  	if(s_obj.value.length==9)
  	{
  		return document.xs.teacherSchool.focus();
  	}
  	
  }
  
   function upCase1(s_obj){
  
  	//alert('cdate:'+document.xs.cdate.value);
  	
  	if(s_obj.value.length==1)
  	{
  		//alert(s_obj.value);	
  		document.xs.studentIDNumber.value=s_obj.value.toUpperCase();
  	}
  	
  }
  
     function upCase2(s_obj){
  
  	//alert('cdate:'+document.xs.cdate.value);
  	
  	if(s_obj.value.length==1)
  	{
  		//alert(s_obj.value);	
  		document.xs.teacherIdNumber.value=s_obj.value.toUpperCase();
  	}
  	
  }
  
     function up5tab(s_obj){
  
  	//alert('cdate:'+document.xs.cdate.value);
  	
  	if(s_obj.value.length==2 && s_obj.value>90)
  	{
  		//alert(s_obj.value);	
  		document.xs.teacherComeDate.value="0"+s_obj.value+"/";
  	}
  	else if(s_obj.value.length==3)
  	{
  		document.xs.teacherComeDate.value=s_obj.value+"/";	
  	}
  	
  	
  	
  	if(s_obj.value.length==6)
  	{
  		//alert(s_obj.value);	
  		document.xs.teacherComeDate.value=s_obj.value+"/";
  	}
  }
  
    function checkYear(){
  
  	
  	if(document.sample.T1.value.indexOf('-') != -1)
	{
			
	  	var y=document.sample.T1.value.slice(0,4);
	  	var m=document.sample.T1.value.slice(5,7);
	  	var d=document.sample.T1.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	
	  	document.sample.T1.value=chineseDate;
	  	
  	}
  	
  }
  
   function checkYear2(){
  	
  	
  	if(document.xs.studentBirth.value.indexOf('-') != -1)
	{
	  	var y=document.xs.studentBirth.value.slice(0,4);
	  	var m=document.xs.studentBirth.value.slice(5,7);
	  	var d=document.xs.studentBirth.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.studentBirth.value=chineseDate;
  	}
  	
  }
  
     function checkYear3(){
  	
  	
  	if(document.xs.teacherBirth.value.indexOf('-') != -1)
	{
	  	var y=document.xs.teacherBirth.value.slice(0,4);
	  	var m=document.xs.teacherBirth.value.slice(5,7);
	  	var d=document.xs.teacherBirth.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.teacherBirth.value=chineseDate;
  	}
  	
  }
  
    function checkYear4(){
  	
  	
  	if(document.xs.teacherComeDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.teacherComeDate.value.slice(0,4);
	  	var m=document.xs.teacherComeDate.value.slice(5,7);
	  	var d=document.xs.teacherComeDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.teacherComeDate.value=chineseDate;
  	}
  	
  }
  
   function checkYear5(){
  	
  	
  	if(document.xs.phoneDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.phoneDate.value.slice(0,4);
	  	var m=document.xs.phoneDate.value.slice(5,7);
	  	var d=document.xs.phoneDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.phoneDate.value=chineseDate;
  	}
  	
  }
     function checkYear6(){
  	
  	
  	if(document.xs.testDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.testDate.value.slice(0,4);
	  	var m=document.xs.testDate.value.slice(5,7);
	  	var d=document.xs.testDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.testDate.value=chineseDate;
  	}
  	
  }
       function checkYear7(){
  	
  	
  	if(document.xs.studentVisitDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.studentVisitDate.value.slice(0,4);
	  	var m=document.xs.studentVisitDate.value.slice(5,7);
	  	var d=document.xs.studentVisitDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.studentVisitDate.value=chineseDate;
  	}
  	
  }
  
    function checkYear8(){
  	
  	
  	if(document.xs.studentVisitDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.studentVisitDate.value.slice(0,4);
	  	var m=document.xs.studentVisitDate.value.slice(5,7);
	  	var d=document.xs.studentVisitDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.studentVisitDate.value=chineseDate;
  	}
  	
  }
  
    function checkYear9(){
  	
  	
  	if(document.xs.studentTryDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.studentTryDate.value.slice(0,4);
	  	var m=document.xs.studentTryDate.value.slice(5,7);
	  	var d=document.xs.studentTryDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.studentTryDate.value=chineseDate;
  	}
  	
  }
  
    function checkYear10(){
  	
  	
  	if(document.xs.sDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.sDate.value.slice(0,4);
	  	var m=document.xs.sDate.value.slice(5,7);
	  	var d=document.xs.sDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.sDate.value=chineseDate;
  	}
  	
  	if(document.xs.eDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.eDate.value.slice(0,4);
	  	var m=document.xs.eDate.value.slice(5,7);
	  	var d=document.xs.eDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate2=y+'/'+m+'/'+d;
	  	document.xs.eDate.value=chineseDate2;
  	}
  	
  }
  
   function checkYear11(){
  	
  	
  	if(document.xs.talentStartDate.value.indexOf('-') != -1)
	{
	  	var y=document.xs.talentStartDate.value.slice(0,4);
	  	var m=document.xs.talentStartDate.value.slice(5,7);
	  	var d=document.xs.talentStartDate.value.slice(8,10);
	  	y=y-1911;
	  	if(y <=99)
	  		y='0'+y;
	  	
	  	var chineseDate=y+'/'+m+'/'+d;
	  	document.xs.talentStartDate.value=chineseDate;
  	}
  	
  	if(document.xs.talentEndDate.value.indexOf('-') != -1)
	{
	  	var y2=document.xs.talentEndDate.value.slice(0,4);
	  	var m=document.xs.talentEndDate.value.slice(5,7);
	  	var d=document.xs.talentEndDate.value.slice(8,10);
	  	
	  	
	  	y2=y2-1911;
	  	if(y2 <=99)
	  		y2='0'+y2;
	  	
	  	var chinestalentEndDate2=y2+'/'+m+'/'+d;
	  	document.xs.talentEndDate.value=chinestalentEndDate2;
  	}
  	
  }
  
  