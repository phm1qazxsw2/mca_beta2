
<script src="js/string.js"></script>
<script src="js/dateformat.js"></script>
<script>
function do_check()
{
    if (trim(document.f1.title.value).length==0) {
        alert("Title is empty");
        document.f1.title.focus();
        return;
    }
    if (!isDate(document.f1.month.value, "yyyy-MM")) {
        alert("Bill Month format error");
        document.f1.month.focus();
        return;
    }
    if (!isDate(document.f1.billDate.value, "yyyy-MM-dd")) {
        alert("Last Paying Date format error");
        document.f1.billDate.focus();
        return;
    }
    
    if (!document.f1.feeType[0].checked && !document.f1.feeType[1].checked && !document.f1.feeType[2].checked) {
        alert("[Fee Type] is not checked");
        document.f1.feeType[0].focus();
        return false;
    }
    /*
    var s = document.f1.checkFeeId;
    if (document.f1.feeType[0].checked && s.options[s.selectedIndex].value=='') {
        alert("Must select a Registration for Fall");
        s.focus();
        return false;
    }
    */
    return true;
}

function setup_prorate() {
    openwindow_phm2('mca_setup_prorate.jsp?id=<%=fee.getId()%>', 'Pro-rate setup', 600, 500, 'proratewin');
}

</script>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=white align=center>
                <td>
                    Bill Title
                </td>
                <td colspan=4 align=left>
                    <input name="title" size=50 value="<%=(fee.getTitle()==null)?"":fee.getTitle()%>">
                </td>
            </tr>

            <tr class=es02 bgcolor=white align=center>
                <td>
                    Bill Month
                </td>
                <td colspan=4 align=left>
                    <input type=text name="month" size=10 value="<%=(fee.getMonth()!=null)?sdf.format(fee.getMonth()):""%>">
                    ex. <%=sdf.format(new Date())%>
                    <% if (ud2.getUserRole()<=3) { %>
                        <a href="#" onclick="displayCalendar(document.f1.month,'yyyy-mm',this);return false"><img src="pic/blog4.gif" border=0></a>
                    <% } %>
                </td>
            </tr>

            <tr class=es02 bgcolor=white align=center>
                <td>
                    Last Paying Date
                </td>
                <td colspan=4 align=left>
                    <input type=text name="billDate" size=10 value="<%=(fee.getBillDate()!=null)?sdf1.format(fee.getBillDate()):""%>">
                    ex. <%=sdf1.format(new Date())%>
                    <% if (ud2.getUserRole()<=3) { %>
                        <a href="#" onclick="displayCalendar(document.f1.billDate,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
                    <% } %>
                </td>
            </tr>

            <tr class=es02 bgcolor=white align=center>
                <td>
                    Late Fee
                </td>
                <td colspan=4 align=left>
                    <input type=text name="lateFee" size=8 value="<%=fee.getLateFee()%>">
                </td>
            </tr>

<% if (!create_new) { %>
            <tr class=es02 bgcolor=white align=center>
                <td>
                    Students
                </td>
                <td colspan=4 align=left>
                    <input type=button name="b1" value="&nbsp; Tags &nbsp;" onclick="edit_tag()">　
                    <input type=button name="b2" value="&nbsp; Billing Info &nbsp;" onclick="edit_billing()">
                </td>
            </tr>
            <tr class=es02 bgcolor=white align=center>
                <td>
                    Pro-rate schedules
                </td>
                <td colspan=4 align=left>
                    <%=new McaService().getSemesterDaysInfo(fee).replace("\n", "<br>")%>
<% if (ud2.getUserRole()<=3) { %>
                    (<a href="javascript:setup_prorate()">setup</a>)
<% } %>
                </td>
            </tr>
<% } %>

            <tr class=es02 bgcolor=white align=center>
                <td nowrap>
                    Fee Type
                </td>
                <td colspan=4 align=left nowrap>
                    <input type=radio name="feeType" value="1" <%=(fee.getFeeType()==McaFee.FALL)?"checked":""%>>Fall <br>
                    　　Registration check with 
                    <select name="checkFeeId">
                    <option value='0'>----- choose one -----
<%
    ArrayList<McaFee> reg_fees = McaFeeMgr.getInstance().retrieveList("feeType=" + McaFee.REGISTRATION_ONLY
        + " and status=" + McaFee.STATUS_ACTIVE, "");
    for (int i=0; i<reg_fees.size(); i++) {
        //if (reg_fees.get(i).getId()==fee.getId())
        //    continue;
        String name = reg_fees.get(i).getTitle();
        int fid = reg_fees.get(i).getId();
        if (name.length()>25) name = name.substring(0, 25);
        out.println("\n<option value=\""+fid+"\" "+((fee.getCheckFeeId()==fid)?"selected":"")+">" + name);
    }
%>
                    </select>
                    <br>
                    　　Prepay Deadline: <input type=text name="regPrepayDeadline" value="<%=(fee.getRegPrepayDeadline()!=null)?sdf1.format(fee.getRegPrepayDeadline()):""%>" size=10>
                    <% if (ud2.getUserRole()<=3) { %>
                        <a href="#" onclick="displayCalendar(document.f1.regPrepayDeadline,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
                    <% } %>
                        Penalty: <input type=text name="regPenalty" value="<%=fee.getRegPenalty()%>" size=5>
                    <br>
                    <input type=radio name="feeType" value="2"<%=(fee.getFeeType()==McaFee.SPRING)?"checked":""%>>Spring
                    <br>
                    　　Fall check with 
                    <select name="checkFallFeeId">
                    <option value='0'>----- choose one -----
<%
    ArrayList<McaFee> fall_fees = McaFeeMgr.getInstance().retrieveList("feeType=" + McaFee.FALL
        + " and status=" + McaFee.STATUS_ACTIVE, "");
    for (int i=0; i<fall_fees.size(); i++) {
        String name = fall_fees.get(i).getTitle();
        int fid = fall_fees.get(i).getId();
        if (name.length()>25) name = name.substring(0, 25);
        out.println("\n<option value=\""+fid+"\" "+((fee.getCheckFallFeeId()==fid)?"selected":"")+">" + name);
    }
%>
                    </select>
                    <br>
                    　　(for Deposit Return & Family Discount)
                    <br>
                    <input type=radio name="feeType" value="3" <%=(fee.getFeeType()==McaFee.REGISTRATION_ONLY)?"checked":""%>>Registration
                </td>
            </tr>


            <tr class=es02 bgcolor=f0f0f0 align=center>
                <td>                    
                </td>
                <td>
                    Regular
                </td>
                <td>
                    Christian Worker
                </td>
                <td>
                    Off Island Missionary
                </td>
                <td>
                    Taiwan Misionary
                </td>
            </tr>

            <tr class=es02 bgcolor=f0f0f0 align=center>
                <td>                    
                    Discount
                </td>
                <td>
                    
                </td>
                <td>
                    0.5
                </td>
                <td>
                    0.5
                </td>
                <td>
                    0.55
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Registration
                </td>
                <td>
                    <input type=text size=7 name="RegA" value="<%=fee.getRegA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="RegB" value="<%=fee.getRegB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="RegC" value="<%=fee.getRegC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="RegD" value="<%=fee.getRegD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=5>
                    Tuition(Semester)--Taichung
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　K-5
                </td>
                <td>
                    <input type=text size=7 name="TuitionK5A" value="<%=fee.getTuitionK5A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TuitionK5B" value="<%=fee.getTuitionK5B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TuitionK5C" value="<%=fee.getTuitionK5C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TuitionK5D" value="<%=fee.getTuitionK5D()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Grade <%=(fee.getId()>76)?"6-8":"6-9"%>
                </td>
                <td>
                    <input type=text size=7 name="Tuition69A" value="<%=fee.getTuition69A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="Tuition69B" value="<%=fee.getTuition69B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="Tuition69C" value="<%=fee.getTuition69C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="Tuition69D" value="<%=fee.getTuition69D()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Grade <%=(fee.getId()>76)?"9-12":"10-12"%>
                </td>
                <td>
                    <input type=text size=7 name="Tuition1012A" value="<%=fee.getTuition1012A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="Tuition1012B" value="<%=fee.getTuition1012B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="Tuition1012C" value="<%=fee.getTuition1012C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="Tuition1012D" value="<%=fee.getTuition1012D()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=5>
                    Tuition(Semester)--Bethany
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　K-5
                </td>
                <td>
                    <input type=text size=7 name="TP_TuitionK5A" value="<%=fee.getTP_TuitionK5A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_TuitionK5B" value="<%=fee.getTP_TuitionK5B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_TuitionK5C" value="<%=fee.getTP_TuitionK5C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_TuitionK5D" value="<%=fee.getTP_TuitionK5D()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Grade <%=(fee.getId()>76)?"6-8":"6-9"%>
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition69A" value="<%=fee.getTP_Tuition69A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition69B" value="<%=fee.getTP_Tuition69B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition69C" value="<%=fee.getTP_Tuition69C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition69D" value="<%=fee.getTP_Tuition69D()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　<%=(fee.getId()>76)?"9-12":"10-12"%>
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition1012A" value="<%=fee.getTP_Tuition1012A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition1012B" value="<%=fee.getTP_Tuition1012B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition1012C" value="<%=fee.getTP_Tuition1012C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TP_Tuition1012D" value="<%=fee.getTP_Tuition1012D()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=5>
                    Tuition(Semester)--Kaohsiung
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　K-5
                </td>
                <td>
                    <input type=text size=7 name="K_TuitionK5A" value="<%=fee.getK_TuitionK5A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_TuitionK5B" value="<%=fee.getK_TuitionK5B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_TuitionK5C" value="<%=fee.getK_TuitionK5C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_TuitionK5D" value="<%=fee.getK_TuitionK5D()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Grade <%=(fee.getId()>76)?"6-8":"6-9"%>
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition69A" value="<%=fee.getK_Tuition69A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition69B" value="<%=fee.getK_Tuition69B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition69C" value="<%=fee.getK_Tuition69C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition69D" value="<%=fee.getK_Tuition69D()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　<%=(fee.getId()>76)?"9-12":"10-12"%>
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition1012A" value="<%=fee.getK_Tuition1012A()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition1012B" value="<%=fee.getK_Tuition1012B()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition1012C" value="<%=fee.getK_Tuition1012C()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="K_Tuition1012D" value="<%=fee.getK_Tuition1012D()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Building
                </td>
                <td>
                    <input type=text size=7 name="BuildingA" value="<%=fee.getBuildingA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="BuildingB" value="<%=fee.getBuildingB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="BuildingC" value="<%=fee.getBuildingC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="BuildingD" value="<%=fee.getBuildingD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Entrance
                </td>
                <td>
                    <input type=text size=7 name="EntranceA" value="<%=fee.getEntranceA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="EntranceB" value="<%=fee.getEntranceB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="EntranceC" value="<%=fee.getEntranceC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="EntranceD" value="<%=fee.getEntranceD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=5>
                    Dorm
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Program
                </td>
                <td>
                    <input type=text size=7 name="DormProgramA" value="<%=fee.getDormProgramA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormProgramB" value="<%=fee.getDormProgramB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormProgramC" value="<%=fee.getDormProgramC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormProgramD" value="<%=fee.getDormProgramD()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Deposit
                </td>
                <td>
                    <input type=text size=7 name="DormDepositA" value="<%=fee.getDormDepositA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormDepositB" value="<%=fee.getDormDepositB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormDepositC" value="<%=fee.getDormDepositC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormDepositD" value="<%=fee.getDormDepositD()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Facility
                </td>
                <td>
                    <input type=text size=7 name="DormFacilityA" value="<%=fee.getDormFacilityA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormFacilityB" value="<%=fee.getDormFacilityB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormFacilityC" value="<%=fee.getDormFacilityC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormFacilityD" value="<%=fee.getDormFacilityD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Food
                </td>
                <td>
                    <input type=text size=7 name="DormFoodA" value="<%=fee.getDormFoodA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormFoodB" value="<%=fee.getDormFoodB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormFoodC" value="<%=fee.getDormFoodC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="DormFoodD" value="<%=fee.getDormFoodD()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td colspan=5>
                    ELL(Semester)
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Moderate
                </td>
                <td>
                    <input type=text size=7 name="ELLModerateA" value="<%=fee.getELLModerateA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="ELLModerateB" value="<%=fee.getELLModerateB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="ELLModerateC" value="<%=fee.getELLModerateC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="ELLModerateD" value="<%=fee.getELLModerateD()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Significant
                </td>
                <td>
                    <input type=text size=7 name="ELLSignificantA" value="<%=fee.getELLSignificantA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="ELLSignificantB" value="<%=fee.getELLSignificantB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="ELLSignificantC" value="<%=fee.getELLSignificantC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="ELLSignificantD" value="<%=fee.getELLSignificantD()%>"  style="text-align:right">
                </td>
            </tr>


            <tr class=es02 bgcolor=ffffff>
                <td colspan=5>
                    Music Lessions (Semester)
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Private
                </td>
                <td>
                    <input type=text size=7 name="MusicPrivateA" value="<%=fee.getMusicPrivateA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicPrivateB" value="<%=fee.getMusicPrivateB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicPrivateC" value="<%=fee.getMusicPrivateC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicPrivateD" value="<%=fee.getMusicPrivateD()%>"  style="text-align:right">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Semi-Private
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiPrivateA" value="<%=fee.getMusicSemiPrivateA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiPrivateB" value="<%=fee.getMusicSemiPrivateB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiPrivateC" value="<%=fee.getMusicSemiPrivateC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiPrivateD" value="<%=fee.getMusicSemiPrivateD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    　　　Group
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiGroupA" value="<%=fee.getMusicSemiGroupA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiGroupB" value="<%=fee.getMusicSemiGroupB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiGroupC" value="<%=fee.getMusicSemiGroupC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="MusicSemiGroupD" value="<%=fee.getMusicSemiGroupD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    Testing
                </td>
                <td>
                    <input type=text size=7 name="TestingA" value="<%=fee.getTestingA()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TestingB" value="<%=fee.getTestingB()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TestingC" value="<%=fee.getTestingC()%>"  style="text-align:right">
                </td>
                <td>
                    <input type=text size=7 name="TestingD" value="<%=fee.getTestingD()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Milk
                </td>
                <td align=left>
                    <input type=text size=7 name="Milk" value="<%=fee.getMilk()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Taichung Hot Lunch<br>K-2 Tue&Thu.
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch1" value="<%=fee.getTchLunch1()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Taichung Hot Lunch K-2 Daily
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch2" value="<%=fee.getTchLunch2()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Taichung Hot Lunch 3-5 Tue&Thu.
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch3" value="<%=fee.getTchLunch3()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                     Taichung Hot Lunch 3-5 Daily
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch4" value="<%=fee.getTchLunch4()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Taichung Hot Lunch 9-12 Daily
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch5" value="<%=fee.getTchLunch5()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Taichung Hot Lunch 6-12 Daily
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch6" value="<%=fee.getTchLunch6()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Taichung Hot Lunch 6-12 Tue&Thu.
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="TchLunch7" value="<%=fee.getTchLunch7()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Kaohsiung Hot Lunch Large#
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="KaoLunch1" value="<%=fee.getKaoLunch1()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Kaohsiung Hot Lunch Moderate#
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="KaoLunch2" value="<%=fee.getKaoLunch2()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Instrument Rental
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="Instrument" value="<%=fee.getInstrument()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Music Room Rental
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="MusicRoom" value="<%=fee.getMusicRoom()%>"  style="text-align:right">
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=1>
                    Family Discount
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="FamilyDiscountA" value="<%=fee.getFamilyDiscountA()%>"  style="text-align:right">
                </td>
                <td colspan=3 align=right>
                    <input type=text size=20 name="FamilyDiscountB" value="<%=fee.getFamilyDiscountB()%>"  style="text-align:right"> &nbsp;&nbsp;
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td colspan=4>
                    Bus
                </td>
                <td colspan=1 align=left>
                    <input type=text size=7 name="Bus" value="<%=fee.getBus()%>"  style="text-align:right">
                </td>
            </tr>
            <tr>
                <td colspan=5 bgcolor=ffffff valign=bottom align=middle>
                <div id="buttons"></div>
                </td>
            </tr>
        </table>
        <a target=_blank href="mca_card_export.jsp?feeId=<%=fee.getId()%>">&nbsp;Export Card Info</a>
    </td>
    </tr>
</table>

