// ======== added by peter

function isIE(){
	if(document.all){   //IE    
		return true;
	} 
	return false;
}


function getClientSizeObject(){
	var w=document.body.clientWidth;
	//alert(dojo.render.html.ie);
	var h=isIE()?document.body.clientHeight:window.innerHeight;
	//alert(cHeight);
	return {
		w:w,
		h:h
	}
}

function _get_value(name, attr){
	var config=new RegExp(name+"=([^,]+)", "i") //get name/value config pair (ie: width=400px,)
	return (config.test(attr))? parseInt(RegExp.$1) : 0 //return value portion (int), or 0 (false) if none found
}

//=================

function openmypage(urlString,titleString,paraString){ //Define arbitrary function to run desired DHTML Window widget codes

	var desiredw = _get_value("width",paraString);
	var desiredh = _get_value("height",paraString);
	var csize = getClientSizeObject();	
	var vh = csize.h - 70;
	var vw = csize.w - 30;
	var realh = (desiredh > vh) ? vh : desiredh;
	var realw = (desiredw > vw) ? vw : desiredw;

	ajaxwin=dhtmlwindow.open("ajaxbox", "iframe",urlString, titleString, paraString)
	ajaxwin.setSize(realw, realh);
	ajaxwin.moveTo('middle', 'middle');
	ajaxwin.isResize(true);
}



function openRun(urlString,tfId)
{        
	ajaxwin2=dhtmlwindow.open("googlebox", "iframe",urlString,"","");
	ajaxwin2.hide();

	ajaxwin2.onclose=function(){ //Run custom code when window is about to be closed

		getClassFeeByCfId(tfId,'cla','2');
		  
		return true;
	} 

	if(confirm('已修改完成'))
	{
		ajaxwin2.close();
	}
   
}   

function openRun4(urlString, titleString, paraString)
{        
	var desiredw = _get_value("width",paraString);
	var desiredh = _get_value("height",paraString);
	var csize = getClientSizeObject();	
	var vh = csize.h - 70;
	var vw = csize.w - 30;
	var realh = (desiredh > vh) ? vh : desiredh;
	var realw = (desiredw > vw) ? vw : desiredw;

	ajaxwin4=dhtmlwindow.open("ajaxbox4", "iframe",urlString, titleString, paraString)

	ajaxwin4.setSize(realw, realh);
	ajaxwin4.moveTo('middle', 'middle');
	ajaxwin4.isResize(true);
	
	ajaxwin4.onclose=function(){

		window.location.reload();
		return true;
	} 
}   

function openRun2(urlString)
{        
	ajaxwin3=dhtmlwindow.open("googlebox3", "iframe",urlString,"","");
	ajaxwin3.hide();
	
	ajaxwin3.onclose=function(){

		window.location.reload();
		return true;
	} 

	if(confirm('已修改完成'))
	{
		ajaxwin3.close();
	}
}   

function openRun3win(urlString,titleString,paraString)
{        
	var desiredw = _get_value("width",paraString);
	var desiredh = _get_value("height",paraString);
	var csize = getClientSizeObject();	
	var vh = csize.h - 70;
	var vw = csize.w - 30;
	var realh = (desiredh > vh) ? vh : desiredh;
	var realw = (desiredw > vw) ? vw : desiredw;

	ajaxwin3Plus=dhtmlwindow.open("googlebox55", "iframe",urlString,titleString,paraString);

	ajaxwin3Plus.setSize(realw, realh);
	ajaxwin3Plus.moveTo('middle', 'middle');
	ajaxwin3Plus.isResize(true);
	
	ajaxwin3Plus.onclose=function(){
		para4++;		
		getStudentFeeticketMonth(para1,para2,para3,para4);
		return true;
	} 
}   


function openRun3(urlString)
{        
	ajaxwin4=dhtmlwindow.open("googlebox4", "iframe",urlString,"","");
	ajaxwin4.hide();
	
	ajaxwin4.onclose=function(){
		para4++;
		
		getStudentFeeticketMonth(para1,para2,para3,para4);

		return true;
	} 

	if(confirm('已修改完成'))
	{

		ajaxwin4.close();
	}
   
}   

function openRun5(urlString)
{        
	ajaxwin5=dhtmlwindow.open("googlebox5", "iframe",urlString,"","");
	ajaxwin5.hide();
} 

function openRunTicket2(showTypeXX,feeticketNum,urlString,titleString,paraString)
{        
	openRunTicketX2=dhtmlwindow.open("googlebox4z", "iframe",urlString,titleString,paraString);

	openRunTicketX2.moveTo('middle', 'middle');
	
	openRunTicketX2.onclose=function(){
		
		if(showTypeXX==1)
		{
			getTicket(feeticketNum);

		}else if(showTypeXX==0){

			window.location.reload();
		}

		return true;
	}
		
	if(confirm('已修改完成'))
	{

		openRunTicketX2.close();
	}
} 

function openRunTicket(showTypeXX,feeticketNum,urlString,titleString,paraString)
{        
	openRunTicketX=dhtmlwindow.open("googlebox3z", "iframe",urlString,titleString,paraString);

	openRunTicketX.moveTo('middle', 'middle');
	
	openRunTicketX.onclose=function(){
		
		if(showTypeXX==1)
		{
			getTicket(feeticketNum);

		}else if(showTypeXX==0){

			window.location.reload();
		}
		return true;
	} 
} 



function openwindow1(strTemp) {

	openmypage("modifyCFVerify.jsp?cfId="+strTemp,"xx","top=5,left=10,height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }


function openwindow2(strTemp) {

	openmypage("payFee1.jsp?cfId="+strTemp,"xx2","top=5,left=10,height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");

 }


function openwindow3(strTemp,strTemp2) {

	openmypage("listPayFee1.jsp?cfId="+strTemp+"&stuId="+strTemp2,"xx3","top=5,left=10,height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow4(strTemp) {

	openmypage("verifyCost.jsp?costId="+strTemp,"xx4","top=5,left=10,height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function cal(){
	
	tox=0;
	tox=eval(document.cfv.shouldM.value)-eval(document.cfv.discount.value);
	document.cfv.total.value=tox;	
}

function openwindow5(strTemp) {

openmypage("verifyIncome.jsp?incomeId="+strTemp,"xx4","top=5,left=10,height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow6() {

openmypage("listTalentMoney.jsp","xx6","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow7(strTemp) {

openmypage(strTemp,"xx7","top=5,left=10,height=500,width=600,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow8(strTemp) {

openmypage("modifyContact.jsp?contactId="+strTemp,"xx8","top=5,left=10,height=450,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow9(strTemp) {

openmypage("addContact.jsp?studentId="+strTemp,"xx9","top=5,left=10,height=450,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow10(strTemp) {

openmypage("modifyTcontact.jsp?tcontactId="+strTemp,"xx8","top=5,left=10,height=300,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow11(strTemp) {

openmypage("addTcontact.jsp?teacherId="+strTemp,"xx9","top=5,left=10,height=350,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow12(strTemp) {

openmypage("modifyStudentPhoneInterview.jsp?studentId="+strTemp,"xx9","top=5,left=10,height=550,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow13(strTemp) {

openmypage("modifyStudentVisit.jsp?studentId="+strTemp,"xx9","top=5,left=10,height=550,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow14(strTemp) {

openmypage("modifyVisit.jsp?studentId="+strTemp,"xx9","top=5,left=10,height=550,width=700,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow15(strTemp) {
	openmypage("modifyStudent.jsp?studentId="+strTemp,"基本資料","top=5,left=10,height=700,width=700,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
}

function openwindow15a(strTemp) {

	openmypage("studentVisit.jsp?studentId="+strTemp,"xx15","top=5,left=10,height=550,width=750,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow16(strTemp) {

	openmypage("modifyTeacher.jsp?teacherId="+strTemp,"教職員基本資料","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow16a(strTemp) {

	openmypage("modifyTeacherAccount.jsp?teacherId="+strTemp,"教職員帳務資料","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow16b(strTemp) {

	openmypage("listTeacherSalary.jsp?teacherId="+strTemp,"教職員薪資明細","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow17() {

openmypage("ListIncomeBigItem.jsp","xx17","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow18(strTemp) {

openmypage("modifyIncome.jsp?incomeId="+strTemp,"xx18","top=5,left=10,height=550,width=480,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow19() {

openmypage("ListBigItem.jsp","xx19","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow20(strTemp) {

openmypage("modifyCost.jsp?costId="+strTemp,"xx20","top=5,left=10,height=550,width=480,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow21() {

openmypage("listPlace.jsp","xx21","top=5,left=10,height=400,width=600,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow22(strTemp) {

openmypage("modifyTalent.jsp?talentId="+strTemp,"xx22","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }


function openwindow22a(strTemp) {

openmypage("listTadent.jsp?talentId="+strTemp,"xx22","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow23(strTemp) {

openmypage("listTadent.jsp?talentId="+strTemp,"xx23","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow24(strTemp) {

openmypage("addTalentWeekday.jsp?talentId="+strTemp,"xx24","top=5,left=10,height=550,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow25(strTemp) {

openmypage("modifyEveryTalentdate.jsp?tdId="+strTemp,"xx25","top=5,left=10,height=550,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow26(strTemp) {

	openmypage("modifyCM.jsp?cmId="+strTemp,"開單管理-依開徵項目","height=480,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow26a(strTemp) {

openmypage("addClassCharge.jsp?cmId="+strTemp,"開單管理-依開徵項目","height=480,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow26b(xPage) {

openmypage(xPage,"開單管理-依開徵項目","height=480,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }


function openwindow27(strTemp) {

openmypage("listHistoryFeeticket.jsp?studentId="+strTemp,"繳費資訊","top=5,left=10,height=550,width=980,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

}

function openwindow27type2(strTemp) {

	openmypage("listStudentAccount.jsp?studentId="+strTemp,"繳費資訊","top=5,left=10,height=550,width=980,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}


function openwindow27X(strTemp,year,month) {
openmypage("listHistoryFeeticket.jsp?studentId="+strTemp+"&year="+year+"&month="+month,"繳費資訊","top=5,left=10,height=550,width=980,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }


function openwindow271(strTemp,strTemp2,strTemp3) {

openmypage("listHistoryFeeticket.jsp?studentId="+strTemp+"&year="+strTemp2+"&month="+strTemp3,"學生繳費資訊","top=5,left=10,height=550,width=980,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow28(strTemp) {

	openRun3win("makePDF.jsp?FeenumberId="+strTemp,"產生繳款單","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

// function openwindow28x(strTemp) {
//
//	openRunTicket(showTypeX,strTemp,"makePDF.jsp?FeenumberId="+strTemp,"產生繳款單","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
// }

function openwindow28email(strTemp) {

openmypage("makeStudentEmail.jsp?FeenumberId="+strTemp,"產生繳款單","top=5,left=10,height=500,width=750,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow281(strTemp) {

openmypage("makeConfirmPdf.jsp?FeenumberId="+strTemp,"產生收據","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow29(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
	openmypage("makeClassPDFFace.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5+"&pu="+strTemp6,"產生所有繳款單","top=5,left=10,height=400,width=480,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");		 
}

function openwindow29Run(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
	openRun5("makeClassPDF.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5+"&pu="+strTemp6,"產生所有繳款單","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");		 
}

function openwindow29email(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
	openmypage("makeClassEmail.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5+"&pu="+strTemp6,"編輯Email名單","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}

function openwindow29message(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
	openmypage("makeClassMessage.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5+"&pu="+strTemp6,"xx29","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}

//function openwindow29preview(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
//	openmypage("makeFeeticketPreview.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5+"&pu="+strTemp6,"預覽繳款單","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");		 
//}

function openwindow30(strTemp,strTemp2) {

openmypage("_getClassFeeByCfId.jsp?z="+strTemp+"&page2="+strTemp2,"收費項目","top=5,left=10,height=550,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow30V2(strTemp,strTemp2) {

	openRun3win("_getClassFeeByCfIdV2.jsp?z="+strTemp+"&page2="+strTemp2,"收費項目","top=5,left=10,height=550,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	
}

function openwindow30V3(strTemp,strTemp2,ticketNum) {

	openRunTicket(showTypeX,ticketNum,"_getClassFeeByCfIdV2.jsp?z="+strTemp+"&page2="+strTemp2,"收費項目","height=480,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	
}

function openwindow31(strTemp,strTemp1,strTemp2) {

	para1=strTemp1;
	para2='cla';
	para3=strTemp2;	

	openmypage("deleteCfDiscount.jsp?cfd="+strTemp,"xx31","top=5,left=10,height=100,width=100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow31x(strTemp) {

	openmypage("modifyCfDiscountCintinue.jsp?cfdId="+strTemp,"xx31","top=5,left=10,height=100,width=100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}

function openwindow32(strTemp) {

openmypage("deleteClassesFee.jsp?cfId="+strTemp,"xx32","top=5,left=10,height=100,width=100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }


function openwindow33(strTemp) {

openmypage("modifyFeeticketPs.jsp?cfId="+strTemp,"xx33","top=5,left=10,height=300,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }


function openwindow33V2(strTemp) {

	openRun3win("modifyFeeticketPsV2.jsp?cfId="+strTemp,"修改繳款截止日及備註","top=5,left=10,height=300,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

}

function openwindow33V3(strTemp) {

	openRunTicket(showTypeX,strTemp,"modifyFeeticketPsV2.jsp?cfId="+strTemp,"修改繳款截止日及備註","top=5,left=10,height=300,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

}
function openwindow34(strTemp) {

 	openmypage("addPayFeeType4.jsp?z="+strTemp,strTemp,"top=5,left=10,height=550,width=600,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow35(strTemp,strTemp2) {

openmypage("PayFeeDetail.jsp?category="+strTemp+"&xId="+strTemp2,strTemp,"top=5,left=10,height=550,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow36(strTemp) {

openmypage("PayFeeDetail2.jsp?pfId="+strTemp,"銷帳紀錄","height=480,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow37(strTemp,strTemp2) {

openmypage("deletePayFee.jsp?pfId="+strTemp,"xx36","top=5,left=10,height=550,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow38(strTemp) {

	if(confirm('確認刪除?'))
	{
		openRun2("deleteClassesMoney.jsp?cmId="+strTemp,"xx38","top=5,left=10,height=100,width=100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	}
 }

function openwindow39(strTemp) {

openmypage("listClassesMoneyFee.jsp?cmId="+strTemp,"學生收費明細","top=5,left=10,height=550,width=520,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow40(strTemp,strTemp2,strTemp3,strTemp4) {

openmypage("makeFeeticketReport.jsp?classId="+strTemp+"&date="+strTemp2+"&level="+strTemp3+"&status="+strTemp4,"學費報表","top=5,left=10,height=450,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow40s(strTemp,strTemp2,strTemp3,strTemp4) {

openmypage("makeFeeticketReportS.jsp?classId="+strTemp+"&date="+strTemp2+"&level="+strTemp3+"&status="+strTemp4,"學費報表","top=5,left=10,height=450,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow41(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {

openmypage("addClassChargeTypeClassX.jsp?cmId="+strTemp+"&year="+strTemp2+"&month="+strTemp3+"&cfdate="+strTemp4+"&classesid="+strTemp5+"&ccId="+strTemp6,"開單管理-依開徵項目","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow42(strTemp,strTemp2,strTemp3) {

openmypage("addClassChargeTypeClassX.jsp?cmId="+strTemp+"&year="+strTemp2+"&month="+strTemp3,"xx42","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow43(strTemp,strTemp2,strTemp3,strTemp4,strTemp5) {

openmypage("makeClassConfirmPDF.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5,"xx43","top=5,left=10,height=550,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow44(strTemp,strTemp2,strTemp3,strTemp4) {

openmypage("listClassCfDiscont.jsp?classId="+strTemp+"&cmId="+strTemp2+"&year="+strTemp3+"&month="+strTemp4,"月費 折扣明細","top=5,left=10,height=550,width=600,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow45(strTemp,strTemp2,strTemp3,strTemp4) {

openmypage("classFeeReportDetail.jsp?cmId="+strTemp+"&year="+strTemp2+"&month="+strTemp3+"&classesId="+strTemp4+"&level=999","xx45","top=5,left=10,height=550,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow46(strTemp,strTemp2,strTemp3,strTemp4,strTemp5) {

	openmypage("modifyClassFeeticketPs.jsp?classId="+strTemp+"&date="+strTemp2+"&type="+strTemp3+"&cmIdI="+strTemp4+"&statusS="+strTemp5,"xx46","top=5,left=10,height=300,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}


function openwindow47(strTemp2,strTemp3,strTemp4) {

openmypage("listTalentCfDiscount.jsp?cmId="+strTemp2+"&year="+strTemp3+"&month="+strTemp4,"xx47","top=5,left=10,height=550,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow48(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {

openmypage("addClassCharge.jsp?cmId="+strTemp+"&year="+strTemp2+"&month="+strTemp3+"&cfdate="+strTemp4+"&classesid="+strTemp5+"&ccId="+strTemp6,"xx48","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow49(strTemp) {

openRun3win("modifyFeeticketLock.jsp?feenumber="+strTemp,"修改繳款單狀態","top=5,left=10,height=100,width=100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }


function openwindow49x(strTemp) {

	openRunTicket(showTypeX,strTemp,"modifyFeeticketLock.jsp?feenumber="+strTemp,"修改繳款單狀態","top=5,left=10,height=200,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

 function openwindow49x2(strTemp,strTemp2) {

	openRunTicket(showTypeX,strTemp2,"changeAdditionalFeeStatus.jsp?aid="+strTemp+"&fid="+strTemp2,"修改前期未繳連結狀態","top=5,left=10,height=200,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow50(strTemp,strTemp2,strTemp3) {

openmypage("makeClassesMoneyReport.jsp?year="+strTemp+"&month="+strTemp2+"&cmId="+strTemp3,"xx50","top=5,left=10,height=550,width=650,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");

 }

function openwindow51(strTemp) {

openmypage("salaryTicketDetail.jsp?stNumber="+strTemp,"xx51","top=5,left=10,height=550,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow52(strTemp) {

	openRun("_modifySalaryFee.jsp?sfId="+strTemp,"編輯薪資項目","top=5,left=10,height=400,width=450,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow52a(strTemp) {

	openRun4("_modifySalaryFee.jsp?sfId="+strTemp,"編輯薪資項目","top=5,left=10,height=400,width=450,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow53(strTemp) {

openmypage("listTeacherByPosition.jsp?pId="+strTemp,"xx53","top=5,left=10,height=500,width=450,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }

function openwindow54(strTemp) {

openmypage("listSalaryOutBanks.jsp?soId="+strTemp,"xx54","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow55(strTemp) {

openmypage("salaryPayDetailByBank.jsp?bankId="+strTemp,"xx55","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow551(strTemp) {

	openRun4("modifyBankAccountDetail.jsp?bankId="+strTemp,"修改銀行帳戶","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow56(strTemp) {

openmypage("salaryBankDetail.jsp?bankId="+strTemp,"xx56","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow57(strTemp) {

openmypage("salaryPayByFace.jsp?stId="+strTemp,"xx57","hgeiht=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow58() {

openmypage("addVisitNotLog.jsp","xx58","top=5,left=10,height=550,width=810,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow59(strTemp) {

		openRun4("changeFeeTicketStatus.jsp?ftId="+strTemp,"鐘點費管理","top=5,left=10,height=200,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow60() {

openmypage("authLogin.jsp","xx60","top=5,left=10,height=270,width=530,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow61(strTemp,strTemp2) {

	openmypage("financialReportFee1.jsp?year="+strTemp+"&month="+strTemp2+"&type=4","學費 統計報表","top=5,left=10,height=550,width=750,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

}

function openwindow62(strTemp,strTemp2,strTemp3) {

openmypage("addStudentmobile.jsp?stuId="+strTemp+"&mNumber="+strTemp2+"&to="+strTemp3,"發送簡訊","top=5,left=10,height=400,width=450,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

 }

function openwindow63(stuId,syear,smonth,z) {

openmypage("_getStudentFeeticketMonth.jsp?studentId="+stuId+"&year="+syear+"&month="+smonth+"&z="+z,"xx63","top=5,left=10,height=550,width=600,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

 }


function openwindow64(x,y,z) {

openmypage("addGroupMessage.jsp?x="+x+"&y="+y+"&z="+z,"發送簡訊","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

 }

function openwindow65(){

openmypage("modifyBillSetup.jsp","xx65","top=5,left=10,height=500,width=660,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

 }

function openwindow66(){

openmypage("modifyMessageSetup.jsp","修改簡訊狀態","top=5,left=10,height=100,width=100,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

 }

 function openwindow66Ticket(strTemp){
	
		openRunTicket(showTypeX,strTemp,"modifyMessageSetup.jsp","修改簡訊狀態","top=5,left=10,height=200,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");		
 }

function openwindow67(){

openmypage("modifyPlaceSetup.jsp","修改才藝教室","top=5,left=10,height=400,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	

 }

function openwindow68(strTemp) {

openmypage("modifyLeaveStudent.jsp?studentId="+strTemp,"xx27","top=5,left=10,height=300,width=500,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
 }


function openwindow69(strTemp) {

	openmypage("addTalentSalary.jsp?talentId="+strTemp,"鐘點費管理","top=5,left=10,height=500,width=650,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}

function openwindow69a(strTemp,syear,smonth) {

	openRun4("addTalentSalary.jsp?talentId="+strTemp+"&year="+syear+"&month="+smonth,"鐘點費管理 ","top=5,left=10,height=500,width=650,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}


function openwindow69b(strTemp) {

	openmypage("setupTalentSalary.jsp?talentId="+strTemp,"xx69","top=5,left=10,height=500,width=650,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}

function openwindow70(bid) {

	openRun4("modifyThisBigItem.jsp?bid="+bid,"編輯雜費會計科目","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
}

function openwindow71() {

	openRun4("addCosttrade.jsp","新增合作廠商","top=5,left=10,height=400,width=350,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");

}



function openwindow72(temp1) {

	openmypage("uploadBankPic.jsp?ctId="+temp1,"上傳照片","top=5,left=10,height=200,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
}


function openwindow72a(temp1) {

	openmypage("uploadTradePic.jsp?ctId="+temp1,"上傳照片","top=5,left=10,height=200,width=400,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
	
	 

}

function openwindow73(strTemp,strTemp2,strTemp3,strTemp4) {
	openmypage("makeSalaryReport.jsp?month="+strTemp+"&year="+strTemp2+"&poId="+strTemp3+"&classId="+strTemp4,"xx73","top=5,left=10,height=450,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}

function openwindow73a(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
	openmypage("makeSalaryReport.jsp?month="+strTemp+"&year="+strTemp2+"&poId="+strTemp3+"&classId="+strTemp4+"&departId="+strTemp5+"&partTime="+strTemp6,"薪資報表","top=5,left=10,height=450,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}


function openwindow74(strTemp,strTemp2,strTemp3,strTemp4,strTemp5) {
	openmypage("makeCostReport.jsp?type="+strTemp+"&trader="+strTemp2+"&logId="+strTemp3+"&startDate="+strTemp4+"&endDate="+strTemp5,"雜費報表","top=5,left=10,height=450,width=300,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}


function openwindow75(strTemp,strTemp2,strTemp3,strTemp4,strTemp5,strTemp6) {
	openmypage("makeSalaryPDFPages.jsp?month="+strTemp+"&year="+strTemp2+"&poId="+strTemp3+"&classId="+strTemp4+"&departId="+strTemp5+"&partTime="+strTemp6,"教職員薪資條","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	
	 
}


function openwindow76(strTemp) {
	openmypage("makeSalaryPDF.jsp?stId="+strTemp,"教職員薪資條","top=5,left=10,height=550,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	 
}

function openwindow77(strTemp) {
	openmypage("addBackOutSalary.jsp?soId="+strTemp,"匯款批次檔","top=5,left=10,height=400,width=580,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	 
}

function openwindow77a(strTemp,strTemp2,strTemp3,strTemp4) {
	openmypage("addBankWireTxt.jsp?pid="+strTemp+"&payDate="+strTemp2+"&nowTotal="+strTemp3+"&nowRun="+strTemp4,"匯款批次檔","top=5,left=10,height=400,width=580,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	 
}

function openwindow78(strTemp) {
	openmypage("addBackOutSalaryExl.jsp?soId="+strTemp,"匯款名單Excel檔","top=5,left=10,height=400,width=580,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	 
}

function openwindow79(strTemp) {
	openmypage("listHistoryFeeExcel.jsp?studentId="+strTemp,"學費紀錄","top=5,left=10,height=400,width=580,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");	 
}

function openwindow80(insideTradeId) {

	openmypage("modifyInsidetrade.jsp?inId="+insideTradeId,"xx80","top=5,left=10,height=500,width=550,toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
 }

function openwindow_phm(url,name,width,height,reload) 
{
	if (reload){
		openRun4(url, name,"height="+height+",width="+width+",toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
		onLay();
		document.body.scroll="no";	
			
	}else{
		openmypage(url, name,"height="+height+",width="+width+",toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no");
	}
}

function openwindow_phm2(url,name,width,height,winref) 
{
	var desiredw = width;
	var desiredh = height;
	var csize = getClientSizeObject();	
	var vh = csize.h - 70;
	var vw = csize.w - 30;
	var realh = (desiredh > vh) ? vh : desiredh;
	var realw = (desiredw > vw) ? vw : desiredw;

	var paraString = "height="+height+",width="+width+",toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no";
	var tmp = dhtmlwindow.open(winref, "iframe", url, name, paraString)
	tmp.setSize(realw, realh);
	tmp.moveTo('middle', 'middle');
	tmp.isResize(true);
	eval("window." + winref + "=tmp;");

	tmp.onclose=function(){
		if (typeof window.do_reload!='undefined' && window.do_reload) {
			window.do_reload = false;
			window.location.reload();
		}
		return true;
	}
}

function openwindow_inline(htmltext,name,width,height,winref) 
{
	var desiredw = width;
	var desiredh = height;
	var csize = getClientSizeObject();	
	var vh = csize.h - 70;
	var vw = csize.w - 30;
	var realh = (desiredh > vh) ? vh : desiredh;
	var realw = (desiredw > vw) ? vw : desiredw;

	var paraString = "height="+height+",width="+width+",toolbar=no,menubar=no,scrollbars=yes,resizable=yes, location=no, status=no";
	var tmp = dhtmlwindow.open(winref, "inline", htmltext, name, paraString)
	tmp.setSize(realw, realh);
	tmp.moveTo('middle', 'middle');
	tmp.isResize(true);
	eval("window." + winref + "=tmp;");

	tmp.onclose=function(){
		if (typeof window.do_reload!='undefined' && window.do_reload) {
			window.do_reload = false;
			window.location.reload();
		}
		return true;
	}
}

/***********************************************
* DHTML Window Widget- ?Dynamic Drive (www.dynamicdrive.com)
* This notice must stay intact for legal use.
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

// -------------------------------------------------------------------
// DHTML Window Widget- By Dynamic Drive, available at: http://www.dynamicdrive.com
// v1.0: Script created Feb 15th, 07'
// v1.01: Feb 21th, 07' (see changelog.txt)
// v1.02: March 26th, 07' (see changelog.txt)
// v1.03: May 5th, 07' (see changelog.txt)
// v1.1:  Oct 29th, 07' (see changelog.txt)
// -------------------------------------------------------------------

var dhtmlwindow={
imagefiles:['windowfiles/min.gif', 'windowfiles/close.gif', 'windowfiles/restore.gif', 'windowfiles/resize.gif'], //Path to 4 images used by script, in that order
ajaxbustcache: true, //Bust caching when fetching a file via Ajax?
ajaxloadinghtml: '<b>Loading Page. Please wait...</b>', //HTML to show while window fetches Ajax Content?

minimizeorder: 0,
zIndexvalue:100,
tobjects: [], //object to contain references to dhtml window divs, for cleanup purposes
lastactivet: {}, //reference to last active DHTML window

init:function(t){
	var domwindow=document.createElement("div") //create dhtml window div
	domwindow.id=t
	domwindow.className="dhtmlwindow"
	var domwindowdata=''
	domwindowdata='<div class="drag-handle">'
	domwindowdata+='DHTML Window <div class="drag-controls"><img src="'+this.imagefiles[1]+'" title="Close" /></div>'
	domwindowdata+='</div>'
	domwindowdata+='<div class="drag-contentarea"></div>'
	domwindowdata+='<div class="drag-statusarea"><div class="drag-resizearea" style="background: transparent url('+this.imagefiles[3]+') top right no-repeat;">&nbsp;</div></div>'
	domwindowdata+='</div>'
	domwindow.innerHTML=domwindowdata
	document.getElementById("dhtmlwindowholder").appendChild(domwindow)
	//this.zIndexvalue=(this.zIndexvalue)? this.zIndexvalue+1 : 100 //z-index value for DHTML window: starts at 0, increments whenever a window has focus
	var t=document.getElementById(t)
	var divs=t.getElementsByTagName("div")
	for (var i=0; i<divs.length; i++){ //go through divs inside dhtml window and extract all those with class="drag-" prefix
		if (/drag-/.test(divs[i].className))
			t[divs[i].className.replace(/drag-/, "")]=divs[i] //take out the "drag-" prefix for shorter access by name
	}
	//t.style.zIndex=this.zIndexvalue //set z-index of this dhtml window
	t.handle._parent=t //store back reference to dhtml window
	t.resizearea._parent=t //same
	t.controls._parent=t //same
	t.onclose=function(){return true} //custom event handler "onclose"
	t.onmousedown=function(){dhtmlwindow.setfocus(this)} //Increase z-index of window when focus is on it
	t.handle.onmousedown=dhtmlwindow.setupdrag //set up drag behavior when mouse down on handle div
	t.resizearea.onmousedown=dhtmlwindow.setupdrag //set up drag behavior when mouse down on resize div
	t.controls.onclick=dhtmlwindow.enablecontrols
	t.show=function(){dhtmlwindow.show(this)} //public function for showing dhtml window
	t.hide=function(){dhtmlwindow.hide(this)} //public function for hiding dhtml window
	t.close=function(){dhtmlwindow.close(this)} //public function for closing dhtml window (also empties DHTML window content)
	t.setSize=function(w, h){dhtmlwindow.setSize(this, w, h)} //public function for setting window dimensions
	t.moveTo=function(x, y){dhtmlwindow.moveTo(this, x, y)} //public function for moving dhtml window (relative to viewpoint)
    t.shiftRight=function(x){dhtmlwindow.shiftTo(this, x)} //public function for moving dhtml window (relative to viewpoint)
	t.isResize=function(bol){dhtmlwindow.isResize(this, bol)} //public function for specifying if window is resizable
	t.isScrolling=function(bol){dhtmlwindow.isScrolling(this, bol)} //public function for specifying if window content contains scrollbars
	t.load=function(contenttype, contentsource, title){dhtmlwindow.load(this, contenttype, contentsource, title)} //public function for loading content into window
	this.tobjects[this.tobjects.length]=t
	return t //return reference to dhtml window div
},

open:function(t, contenttype, contentsource, title, attr, recalonload){
	var d=dhtmlwindow //reference dhtml window object
	function getValue(Name){
		var config=new RegExp(Name+"=([^,]+)", "i") //get name/value config pair (ie: width=400px,)
		return (config.test(attr))? parseInt(RegExp.$1) : 0 //return value portion (int), or 0 (false) if none found
	}
	if (document.getElementById(t)==null) //if window doesn't exist yet, create it
		t=this.init(t) //return reference to dhtml window div
	else
		t=document.getElementById(t)
	this.setfocus(t)
	t.setSize(getValue(("width")), (getValue("height"))) //Set dimensions of window
	var xpos=getValue("center")? "middle" : getValue("left") //Get x coord of window
	var ypos=getValue("center")? "middle" : getValue("top") //Get y coord of window
	//t.moveTo(xpos, ypos) //Position window
	if (typeof recalonload!="undefined" && recalonload=="recal" && this.scroll_top==0){ //reposition window when page fully loads with updated window viewpoints?
		if (window.attachEvent && !window.opera) //In IE, add another 400 milisecs on page load (viewpoint properties may return 0 b4 then)
			this.addEvent(window, function(){setTimeout(function(){t.moveTo(xpos, ypos)}, 400)}, "load")
		else
			this.addEvent(window, function(){t.moveTo(xpos, ypos)}, "load")
	}
	t.isResize(getValue("resize")) //Set whether window is resizable
	t.isScrolling(getValue("scrolling")) //Set whether window should contain scrollbars
	t.style.visibility="visible"
	t.style.display="block"
	t.contentarea.style.display="block"
	t.moveTo(xpos, ypos) //Position window
	t.load(contenttype, contentsource, title)
	if (t.state=="minimized" && t.controls.firstChild.title=="Restore"){ //If window exists and is currently minimized?
		t.controls.firstChild.setAttribute("src", dhtmlwindow.imagefiles[0]) //Change "restore" icon within window interface to "minimize" icon
		t.controls.firstChild.setAttribute("title", "Minimize")
		t.state="fullview" //indicate the state of the window as being "fullview"
	}
	return t
},

setSize:function(t, w, h){ //set window size (min is 150px wide by 100px tall)
	t.style.width=Math.max(parseInt(w), 150)+"px"
	t.contentarea.style.height=Math.max(parseInt(h), 100)+"px"
},

moveTo:function(t, x, y){ //move window. Position includes current viewpoint of document
	this.getviewpoint() //Get current viewpoint numbers
	t.style.left=(x=="middle")? this.scroll_left+(this.docwidth-t.offsetWidth)/2+"px" : this.scroll_left+parseInt(x)+"px"
    if (y!=null)
    	t.style.top=(y=="middle")? this.scroll_top+(this.docheight-t.offsetHeight)/2+"px" : this.scroll_top+parseInt(y)+"px"
},

shiftRight:function(t, x){ //move window. Position includes current viewpoint of document
	this.getviewpoint() //Get current viewpoint numbers
    var newx = eval(t.style.left.substring(0,t.style.left.length-2)+"+"+parseInt(x));
	this.moveTo(t, newx+"px", null);
},

isResize:function(t, bol){ //show or hide resize inteface (part of the status bar)
	t.statusarea.style.display=(bol)? "block" : "none"
	t.resizeBool=(bol)? 1 : 0
},

isScrolling:function(t, bol){ //set whether loaded content contains scrollbars
	t.contentarea.style.overflow=(bol)? "auto" : "hidden"
},

load:function(t, contenttype, contentsource, title){ //loads content into window plus set its title (3 content types: "inline", "iframe", or "ajax")
	if (t.isClosed){
		alert("DHTML Window has been closed, so no window to load contents into. Open/Create the window again.")
		return
	}
	var contenttype=contenttype.toLowerCase() //convert string to lower case
	if (typeof title!="undefined")
		t.handle.firstChild.nodeValue=title
	if (contenttype=="inline") {
		t.contentarea.innerHTML=contentsource
        t.contentarea.style.overflow="auto"
    }
	else if (contenttype=="div"){
		var inlinedivref=document.getElementById(contentsource)
		t.contentarea.innerHTML=(inlinedivref.defaultHTML || inlinedivref.innerHTML) //Populate window with contents of inline div on page
		if (!inlinedivref.defaultHTML)
			inlinedivref.defaultHTML=inlinedivref.innerHTML //save HTML within inline DIV
		inlinedivref.innerHTML="" //then, remove HTML within inline DIV (to prevent duplicate IDs, NAME attributes etc in contents of DHTML window
		inlinedivref.style.display="none" //hide that div
	}
	else if (contenttype=="iframe"){
		t.contentarea.style.overflow="hidden" //disable window scrollbars, as iframe already contains scrollbars
		if (!t.contentarea.firstChild || t.contentarea.firstChild.tagName!="IFRAME") //If iframe tag doesn't exist already, create it first
			t.contentarea.innerHTML='<iframe src="javascript:;" style="margin:0; padding:0; width:100%; height: 100%" name="_iframe-'+t.id+'"></iframe>'
		window.frames["_iframe-"+t.id].location.replace(contentsource) //set location of iframe window to specified URL
		}
	else if (contenttype=="ajax"){
		this.ajax_connect(contentsource, t) //populate window with external contents fetched via Ajax
	}
	t.contentarea.datatype=contenttype //store contenttype of current window for future reference
},

setupdrag:function(e){
	var d=dhtmlwindow //reference dhtml window object
	var t=this._parent //reference dhtml window div
	d.etarget=this //remember div mouse is currently held down on ("handle" or "resize" div)
	var e=window.event || e
	d.initmousex=e.clientX //store x position of mouse onmousedown
	d.initmousey=e.clientY
	d.initx=parseInt(t.offsetLeft) //store offset x of window div onmousedown
	d.inity=parseInt(t.offsetTop)
	d.width=parseInt(t.offsetWidth) //store width of window div
	d.contentheight=parseInt(t.contentarea.offsetHeight) //store height of window div's content div
	if (t.contentarea.datatype=="iframe"){ //if content of this window div is "iframe"
		t.style.backgroundColor="#f8f8f8" //colorize and hide content div (while window is being dragged)
		t.contentarea.style.visibility="hidden"
	}
	document.onmousemove=d.getdistance //get distance travelled by mouse as it moves
	document.onmouseup=function(){
		if (t.contentarea.datatype=="iframe"){ //restore color and visibility of content div onmouseup
			t.contentarea.style.backgroundColor="white"
			t.contentarea.style.visibility="visible"
		}
		d.stop()
	}
	return false
},

getdistance:function(e){
	var d=dhtmlwindow
	var etarget=d.etarget
	var e=window.event || e
	d.distancex=e.clientX-d.initmousex //horizontal distance travelled relative to starting point
	d.distancey=e.clientY-d.initmousey
	if (etarget.className=="drag-handle") //if target element is "handle" div
		d.move(etarget._parent, e)
	else if (etarget.className=="drag-resizearea") //if target element is "resize" div
		d.resize(etarget._parent, e)
	return false //cancel default dragging behavior
},

getviewpoint:function(){ //get window viewpoint numbers
	var ie=document.all && !window.opera
	var domclientWidth=document.documentElement && parseInt(document.documentElement.clientWidth) || 100000 //Preliminary doc width in non IE browsers
	this.standardbody=(document.compatMode=="CSS1Compat")? document.documentElement : document.body //create reference to common "body" across doctypes
	this.scroll_top=(ie)? this.standardbody.scrollTop : window.pageYOffset
	this.scroll_left=(ie)? this.standardbody.scrollLeft : window.pageXOffset
	this.docwidth=(ie)? this.standardbody.clientWidth : (/Safari/i.test(navigator.userAgent))? window.innerWidth : Math.min(domclientWidth, window.innerWidth-16)
	this.docheight=(ie)? this.standardbody.clientHeight: window.innerHeight
},

rememberattrs:function(t){ //remember certain attributes of the window when it's minimized or closed, such as dimensions, position on page
	this.getviewpoint() //Get current window viewpoint numbers
	t.lastx=parseInt((t.style.left || t.offsetLeft))-dhtmlwindow.scroll_left //store last known x coord of window just before minimizing
	t.lasty=parseInt((t.style.top || t.offsetTop))-dhtmlwindow.scroll_top
	t.lastwidth=parseInt(t.style.width) //store last known width of window just before minimizing/ closing
},

move:function(t, e){
	t.style.left=dhtmlwindow.distancex+dhtmlwindow.initx+"px"
	t.style.top=dhtmlwindow.distancey+dhtmlwindow.inity+"px"
},

resize:function(t, e){
	t.style.width=Math.max(dhtmlwindow.width+dhtmlwindow.distancex, 150)+"px"
	t.contentarea.style.height=Math.max(dhtmlwindow.contentheight+dhtmlwindow.distancey, 100)+"px"
},

enablecontrols:function(e){
	var d=dhtmlwindow
	var sourceobj=window.event? window.event.srcElement : e.target //Get element within "handle" div mouse is currently on (the controls)
	if (/Minimize/i.test(sourceobj.getAttribute("title"))) //if this is the "minimize" control
		d.minimize(sourceobj, this._parent)
	else if (/Restore/i.test(sourceobj.getAttribute("title"))) //if this is the "restore" control
		d.restore(sourceobj, this._parent)
	else if (/Close/i.test(sourceobj.getAttribute("title"))) //if this is the "close" control
		d.close(this._parent)
	return false
},

minimize:function(button, t){
	dhtmlwindow.rememberattrs(t)
	button.setAttribute("src", dhtmlwindow.imagefiles[2])
	button.setAttribute("title", "Restore")
	t.state="minimized" //indicate the state of the window as being "minimized"
	t.contentarea.style.display="none"
	t.statusarea.style.display="none"
	if (typeof t.minimizeorder=="undefined"){ //stack order of minmized window on screen relative to any other minimized windows
		dhtmlwindow.minimizeorder++ //increment order
		t.minimizeorder=dhtmlwindow.minimizeorder
	}
	t.style.left="10px" //left coord of minmized window
	t.style.width="200px"
	var windowspacing=t.minimizeorder*10 //spacing (gap) between each minmized window(s)
	t.style.top=dhtmlwindow.scroll_top+dhtmlwindow.docheight-(t.handle.offsetHeight*t.minimizeorder)-windowspacing+"px"
},

restore:function(button, t){
	dhtmlwindow.getviewpoint()
	button.setAttribute("src", dhtmlwindow.imagefiles[0])
	button.setAttribute("title", "Minimize")
	t.state="fullview" //indicate the state of the window as being "fullview"
	t.style.display="block"
	t.contentarea.style.display="block"
	if (t.resizeBool) //if this window is resizable, enable the resize icon
		t.statusarea.style.display="block"
	t.style.left=parseInt(t.lastx)+dhtmlwindow.scroll_left+"px" //position window to last known x coord just before minimizing
	t.style.top=parseInt(t.lasty)+dhtmlwindow.scroll_top+"px"
	t.style.width=parseInt(t.lastwidth)+"px"
},


close:function(t){
	try{
		var closewinbol=t.onclose()
	}
	catch(err){ //In non IE browsers, all errors are caught, so just run the below
		var closewinbol=true
 }
	finally{ //In IE, not all errors are caught, so check if variable isn't defined in IE in those cases
		if (typeof closewinbol=="undefined"){
			alert("An error has occured somwhere inside your \"onclose\" event handler")
			var closewinbol=true
		}
	}
	if (closewinbol){ //if custom event handler function returns true
		if (t.state!="minimized") //if this window isn't currently minimized
			dhtmlwindow.rememberattrs(t) //remember window's dimensions/position on the page before closing
		if (window.frames["_iframe-"+t.id]) //if this is an IFRAME DHTML window
			window.frames["_iframe-"+t.id].location.replace("javascript:;")
		else
			t.contentarea.innerHTML=""
		t.style.display="none"
		t.isClosed=true //tell script this window is closed (for detection in t.show())
	}
	return closewinbol
},


setopacity:function(targetobject, value){ //Sets the opacity of targetobject based on the passed in value setting (0 to 1 and in between)
	if (!targetobject)
		return
	if (targetobject.filters && targetobject.filters[0]){ //IE syntax
		if (typeof targetobject.filters[0].opacity=="number") //IE6
			targetobject.filters[0].opacity=value*100
		else //IE 5.5
			targetobject.style.filter="alpha(opacity="+value*100+")"
		}
	else if (typeof targetobject.style.MozOpacity!="undefined") //Old Mozilla syntax
		targetobject.style.MozOpacity=value
	else if (typeof targetobject.style.opacity!="undefined") //Standard opacity syntax
		targetobject.style.opacity=value
},

setfocus:function(t){ //Sets focus to the currently active window
	this.zIndexvalue++
	t.style.zIndex=this.zIndexvalue
	t.isClosed=false //tell script this window isn't closed (for detection in t.show())
	this.setopacity(this.lastactivet.handle, 0.5) //unfocus last active window
	this.setopacity(t.handle, 1) //focus currently active window
	this.lastactivet=t //remember last active window
},


show:function(t){
	if (t.isClosed){
		alert("DHTML Window has been closed, so nothing to show. Open/Create the window again.")
		return
	}
	if (t.lastx) //If there exists previously stored information such as last x position on window attributes (meaning it's been minimized or closed)
		dhtmlwindow.restore(t.controls.firstChild, t) //restore the window using that info
	else
		t.style.display="block"
	this.setfocus(t)
	t.state="fullview" //indicate the state of the window as being "fullview"
},

hide:function(t){
	t.style.display="none"
},

ajax_connect:function(url, t){
	var page_request = false
	var bustcacheparameter=""
	if (window.XMLHttpRequest) // if Mozilla, IE7, Safari etc
		page_request = new XMLHttpRequest()
	else if (window.ActiveXObject){ // if IE6 or below
		try {
		page_request = new ActiveXObject("Msxml2.XMLHTTP")
		} 
		catch (e){
			try{
			page_request = new ActiveXObject("Microsoft.XMLHTTP")
			}
			catch (e){}
		}
	}
	else
		return false
	t.contentarea.innerHTML=this.ajaxloadinghtml
	page_request.onreadystatechange=function(){dhtmlwindow.ajax_loadpage(page_request, t)}
	if (this.ajaxbustcache) //if bust caching of external page
		bustcacheparameter=(url.indexOf("?")!=-1)? "&"+new Date().getTime() : "?"+new Date().getTime()
	page_request.open('GET', url+bustcacheparameter, true)
	page_request.send(null)
},

ajax_loadpage:function(page_request, t){
	if (page_request.readyState == 4 && (page_request.status==200 || window.location.href.indexOf("http")==-1)){
	t.contentarea.innerHTML=page_request.responseText
	}
},


stop:function(){
	dhtmlwindow.etarget=null //clean up
	document.onmousemove=null
	document.onmouseup=null
},

addEvent:function(target, functionref, tasktype){ //assign a function to execute to an event handler (ie: onunload)
	var tasktype=(window.addEventListener)? tasktype : "on"+tasktype
	if (target.addEventListener)
		target.addEventListener(tasktype, functionref, false)
	else if (target.attachEvent)
		target.attachEvent(tasktype, functionref)
},

cleanup:function(){
	for (var i=0; i<dhtmlwindow.tobjects.length; i++){
		dhtmlwindow.tobjects[i].handle._parent=dhtmlwindow.tobjects[i].resizearea._parent=dhtmlwindow.tobjects[i].controls._parent=null
	}
	window.onload=null
}

} //End dhtmlwindow object

document.write('<div id="dhtmlwindowholder"><span style="display:none">.</span></div>') //container that holds all dhtml window divs on page
window.onunload=dhtmlwindow.cleanup
