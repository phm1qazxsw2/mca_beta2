﻿
function area(code, cname, ename, level, parentcode)
{
    this.code = code;
    this.cname = cname;
    this.ename = ename;
    this.level = level;
    this.parentcode = parentcode;
}

function draw_country(code)
{
    var r = '<select name="CountryID" onchange="__addr.setCountry(this.options[this.selectedIndex].value);__addr.redraw();">';
    for (var i=0; i<countries.length; i++) {
        r += '\n<option value='+countries[i].code+((countries[i].code==__addr.cId)?' selected':'')+'>' + countries[i].cname;
    }
    r += '</select>';
    return r;
}

function draw_county(code)
{
    var r = '<select name="CountyID" onchange="__addr.setCounty(this.options[this.selectedIndex].value);__addr.redraw();">';
    for (var i=0; i<counties.length; i++) {
        if (counties[i].parentcode!=__addr.cId) {
            continue;
        }
        var name = (counties[i].cname.length>0)?counties[i].cname:counties[i].ename;
        r += '\n<option value='+counties[i].code+((counties[i].code==__addr.tId)?' selected':'')+'>' + name;
    }
    r += '</select>';
    return r;
}

function draw_city(code)
{
    var r = '<select name="CityID" onchange="__addr.setCity(this.options[this.selectedIndex].value);__addr.redraw();">';
    r += '\n<option value="">';
    for (var i=0; i<cities.length; i++) {
        if (cities[i].parentcode!=__addr.tId) {
            continue;
        }
        //if (cities[i].code==__addr.yId)
        //    debug(cities[i].code + ":" + __addr.yId + ":" + cities[i].cname);
        r += '\n<option value='+cities[i].code+((cities[i].code==__addr.yId)?' selected':'')+'>' + cities[i].cname;
    }
    r += '</select>';
    return r;
}

function draw_district(code)
{
    var r = '<select name="DistrictID" onchange="__addr.setDistrict(this.options[this.selectedIndex].value);__addr.redraw();">';
    r += '\n<option value="">';
    for (var i=0; i<districts.length; i++) {
        if (districts[i].parentcode!=__addr.yId) {
            continue;
        }
        r += '\n<option value='+districts[i].code+((districts[i].code==__addr.rId)?' selected':'')+'>' + districts[i].cname;
    }
    r += '</select>';
    return r;
}

function draw_cstreet(street)
{
    var r = '<input size=30 type=text name="CStreet" value="'+street+'">';
    return r;
}

function draw_estreet(street)
{
    var r = '<input size=30 type=text name="EStreet" value="'+street+'">';
    return r;
}

function draw_postcode(pcode)
{
    var r = '<input type=text name="PostalCode" value="'+pcode+'">';
    return r;
}

var __addr;
function addr(cId, tId, yId, rId, pCode, cSt, eSt)
{
    this.cId = cId;
    this.tId = tId;
    this.yId = yId;
    this.rId = rId;
    this.pCode = pCode;
    this.cSt = cSt;
    this.eSt = eSt;
    this.draw = function(d1, d2, d3, d4, d5, d6, d7) {
        d1.innerHTML = draw_country(this.cId);
        d2.innerHTML = draw_county(this.tId);
        d3.innerHTML = draw_city(this.yId);
        d4.innerHTML = draw_district(this.rId);
        d5.innerHTML = draw_cstreet(this.cSt);
        d6.innerHTML = draw_estreet(this.eSt);
        d7.innerHTML = draw_postcode(this.pCode);
        this.d1 = d1;
        this.d2 = d2;
        this.d3 = d3;
        this.d4 = d4;
        this.d5 = d5;
        this.d6 = d6;
        this.d7 = d7;
    }
    this.setCountry = function(cid) {
        this.cId = cid;
        this.tId = '';
        this.yId = '';
        this.rId = '';
        if (this.cId=='1001')
            this.tId='1001';
    }
    this.setCounty = function(tid) {
        this.tId = tid;
        this.yId = '';
        this.rId = '';
    }
    this.setCity = function(yid) {
        this.yId = yid;
        this.rId = '';
    }
    this.setDistrict = function(rid) {
        this.rId = rid;
    }
    this.redraw = function() {
        this.draw(d1, d2, d3, d4, d5, d6, d7);
    }
    __addr = this;
}

/*
var countries = new Array;
var counties = new Array;
var cities = new Array;
var districts = new Array;
countries[countries.length] = new area('1001','台灣', 'Taiwan', 0, '');
countries[countries.length] = new area('1002','美國', 'USA', 0, '');
countries[countries.length] = new area('1003','加拿大', 'Canada', 0, '');
countries[countries.length] = new area('1004','中國', 'China', 0, '');
countries[countries.length] = new area('1005','菲律賓', 'Philippines', 0, '');
countries[countries.length] = new area('1006','泰國', 'Thailand', 0, '');
countries[countries.length] = new area('1007','香港', 'Hong Kong', 0, '');
countries[countries.length] = new area('1008','澳門', 'Macau', 0, '');
countries[countries.length] = new area('1009','蒙古', 'Mongolia', 0, '');
countries[countries.length] = new area('9010','南韓', 'Korea', 0, '');
countries[countries.length] = new area('9011','馬來西亞', 'Malaysia', 0, '');
countries[countries.length] = new area('9012','澳大利亞', 'Australia', 0, '');
countries[countries.length] = new area('9013','德國', 'Germany', 0, '');
countries[countries.length] = new area('9014','多明尼加', 'Dominicana', 0, '');
countries[countries.length] = new area('9015','英國', 'UK', 0, '');
countries[countries.length] = new area('9016','紐西蘭', 'New Zealand', 0, '');
countries[countries.length] = new area('9017','日本', 'Japan', 0, '');
countries[countries.length] = new area('9018','厄瓜多', 'Ecuador', 0, '');
countries[countries.length] = new area('9019','法國', 'France', 0, '');
countries[countries.length] = new area('9020','印度', 'India', 0, '');
countries[countries.length] = new area('9021','哥斯達黎加', 'Costa Rica', 0, '');
countries[countries.length] = new area('9022','俄國', 'RSA', 0, '');
countries[countries.length] = new area('9023','印尼', 'Indonesia', 0, '');
countries[countries.length] = new area('9024','葡萄牙', 'Portugal', 0, '');
countries[countries.length] = new area('9025','馬歇爾群島', 'REP.OF MARSHALL IS.', 0, '');
countries[countries.length] = new area('9026','荷蘭', 'Netherlands', 0, '');
countries[countries.length] = new area('9027','星加坡', 'Singapore', 0, '');
countries[countries.length] = new area('9028','南非', 'South Africa', 0, '');
countries[countries.length] = new area('9029','捷克', 'Czech', 0, '');
counties[counties.length] = new area('1001','', '', 1, '1001');
counties[counties.length] = new area('1002','新北市', 'Taipei County', 1, '1001');
counties[counties.length] = new area('1003','桃園縣', 'Taoyuan County', 1, '1001');
counties[counties.length] = new area('1004','新竹縣', 'Xinzhu County', 1, '1001');
counties[counties.length] = new area('1005','苗栗縣', 'Miaoli County', 1, '1001');
counties[counties.length] = new area('1006','台中市', 'Taichung County', 1, '1001');
counties[counties.length] = new area('1007','彰化縣', 'Zhanghua County', 1, '1001');
counties[counties.length] = new area('1008','南投縣', 'Nantou County', 1, '1001');
counties[counties.length] = new area('1009','雲林縣', 'Yunlin County', 1, '1001');
counties[counties.length] = new area('1010','嘉義縣', 'Jiayi County', 1, '1001');
counties[counties.length] = new area('1011','台南市', 'Tainan County', 1, '1001');
counties[counties.length] = new area('1012','高雄市', 'Kaohsiung County', 1, '1001');
counties[counties.length] = new area('1013','屏東縣', 'Pingdong County', 1, '1001');
counties[counties.length] = new area('1014','台東縣', 'Taidong County', 1, '1001');
counties[counties.length] = new area('1015','花蓮縣', 'Hualian County', 1, '1001');
counties[counties.length] = new area('1016','宜蘭縣', 'Yilan County', 1, '1001');
counties[counties.length] = new area('1017','澎湖縣', 'Penghu County', 1, '1001');
counties[counties.length] = new area('1018','金門縣', 'Jinmen County', 1, '1001');
counties[counties.length] = new area('1019','連江縣', 'Lianjiang County', 1, '1001');
counties[counties.length] = new area('1020','', 'Alabama', 1, '1002');
counties[counties.length] = new area('1021','', 'Alaska', 1, '1002');
counties[counties.length] = new area('1022','', 'Arizona', 1, '1002');
counties[counties.length] = new area('1023','', 'Arkansas', 1, '1002');
counties[counties.length] = new area('1024','', 'California', 1, '1002');
counties[counties.length] = new area('1025','', 'Colorado', 1, '1002');
counties[counties.length] = new area('1026','', 'Connecticut', 1, '1002');
counties[counties.length] = new area('1027','', 'Delaware', 1, '1002');
counties[counties.length] = new area('1028','', 'Florida', 1, '1002');
counties[counties.length] = new area('1029','', 'Georgia', 1, '1002');
counties[counties.length] = new area('1030','', 'Hawaii', 1, '1002');
counties[counties.length] = new area('1031','', 'Idaho', 1, '1002');
counties[counties.length] = new area('1032','', 'Illinois', 1, '1002');
counties[counties.length] = new area('1033','', 'Indiana', 1, '1002');
counties[counties.length] = new area('1034','', 'Iowa', 1, '1002');
counties[counties.length] = new area('1035','', 'Kansas', 1, '1002');
counties[counties.length] = new area('1036','', 'Kentucky', 1, '1002');
counties[counties.length] = new area('1037','', 'Louisiana', 1, '1002');
counties[counties.length] = new area('1038','', 'Maine', 1, '1002');
counties[counties.length] = new area('1039','', 'Maryland', 1, '1002');
counties[counties.length] = new area('1040','', 'Massachusetts', 1, '1002');
counties[counties.length] = new area('1041','', 'Michigan', 1, '1002');
counties[counties.length] = new area('1042','', 'Minnesota', 1, '1002');
counties[counties.length] = new area('1043','', 'Mississippi', 1, '1002');
counties[counties.length] = new area('1044','', 'Missouri', 1, '1002');
counties[counties.length] = new area('1045','', 'Montana', 1, '1002');
counties[counties.length] = new area('1046','', 'Nebraska', 1, '1002');
counties[counties.length] = new area('1047','', 'Nevada', 1, '1002');
counties[counties.length] = new area('1048','', 'New Hampshire', 1, '1002');
counties[counties.length] = new area('1049','', 'New Jersey', 1, '1002');
counties[counties.length] = new area('1050','', 'New Mexico', 1, '1002');
counties[counties.length] = new area('1051','', 'New York', 1, '1002');
counties[counties.length] = new area('1052','', 'North Carolina', 1, '1002');
counties[counties.length] = new area('1053','', 'North Dakota', 1, '1002');
counties[counties.length] = new area('1054','', 'Ohio', 1, '1002');
counties[counties.length] = new area('1055','', 'Oklahoma', 1, '1002');
counties[counties.length] = new area('1056','', 'Oregon', 1, '1002');
counties[counties.length] = new area('1057','', 'Pennsylvania', 1, '1002');
counties[counties.length] = new area('1058','', 'Rhode Island', 1, '1002');
counties[counties.length] = new area('1059','', 'South Carolina', 1, '1002');
counties[counties.length] = new area('1060','', 'South Dakota', 1, '1002');
counties[counties.length] = new area('1061','', 'Tennessee', 1, '1002');
counties[counties.length] = new area('1062','', 'Texas', 1, '1002');
counties[counties.length] = new area('1063','', 'Utah', 1, '1002');
counties[counties.length] = new area('1064','', 'Vermont', 1, '1002');
counties[counties.length] = new area('1065','', 'Virginia', 1, '1002');
counties[counties.length] = new area('1066','', 'Washington', 1, '1002');
counties[counties.length] = new area('1067','', 'West Virginia', 1, '1002');
counties[counties.length] = new area('1068','', 'Wisconsin', 1, '1002');
counties[counties.length] = new area('1069','', 'Wyoming', 1, '1002');
counties[counties.length] = new area('1070','', 'Alberta', 1, '1003');
counties[counties.length] = new area('1071','', 'British Columbia', 1, '1003');
counties[counties.length] = new area('1072','', 'Manitoba', 1, '1003');
counties[counties.length] = new area('1073','', 'New Brunswick', 1, '1003');
counties[counties.length] = new area('1074','', 'Newfoundland and Labrador', 1, '1003');
counties[counties.length] = new area('1075','', 'Northwest Territories', 1, '1003');
counties[counties.length] = new area('1076','', 'Nova Scotia', 1, '1003');
counties[counties.length] = new area('1077','', 'Nunavut', 1, '1003');
counties[counties.length] = new area('1078','', 'Ontario', 1, '1003');
counties[counties.length] = new area('1079','', 'Prince Edward Island', 1, '1003');
counties[counties.length] = new area('1080','', 'Quebec', 1, '1003');
counties[counties.length] = new area('1081','', 'Saskatchewan', 1, '1003');
counties[counties.length] = new area('1082','', 'Yukon', 1, '1003');
cities[cities.length] = new area('1001','台北市', 'Taipei City', 2, '1001');
cities[cities.length] = new area('1002','基隆市', 'Jilong City', 2, '1001');
cities[cities.length] = new area('1003','新竹市', 'Xinzhu City', 2, '1001');
cities[cities.length] = new area('1004','台中市', 'Taichung City', 2, '1001');
cities[cities.length] = new area('1005','嘉義市', 'Jiayi City', 2, '1001');
cities[cities.length] = new area('1006','台南市', 'Tainan City', 2, '1001');
cities[cities.length] = new area('1007','高雄市', 'Kaohsiung City', 2, '1001');
cities[cities.length] = new area('1008','板橋市', 'Banqiao City', 2, '1002');
cities[cities.length] = new area('1009','三重區', 'Sanchong City', 2, '1002');
cities[cities.length] = new area('1010','永和區', 'Yonghe City', 2, '1002');
cities[cities.length] = new area('1011','中和區', 'Zhonghe City', 2, '1002');
cities[cities.length] = new area('1012','新莊區', 'Xinzhuang City', 2, '1002');
cities[cities.length] = new area('1013','新店區', 'Xindian City', 2, '1002');
cities[cities.length] = new area('1014','鶯歌區', 'Yingge Township', 2, '1002');
cities[cities.length] = new area('1015','三峽區', 'Sanxia Township', 2, '1002');
cities[cities.length] = new area('1016','淡水區', 'Danshui Township', 2, '1002');
cities[cities.length] = new area('1017','瑞芳區', 'Ruifang Township', 2, '1002');
cities[cities.length] = new area('1018','五股區', 'Wugu Township', 2, '1002');
cities[cities.length] = new area('1019','泰山區', 'Taishan Township', 2, '1002');
cities[cities.length] = new area('1020','林口區', 'Linkou Township', 2, '1002');
cities[cities.length] = new area('1021','深坑區', 'Shenkeng Township', 2, '1002');
cities[cities.length] = new area('1022','石碇區', 'Shiding Township', 2, '1002');
cities[cities.length] = new area('1023','坪林區', 'Pinglin Township', 2, '1002');
cities[cities.length] = new area('1024','三芝區', 'Sanzhi Township', 2, '1002');
cities[cities.length] = new area('1025','石門區', 'Shimen Township', 2, '1002');
cities[cities.length] = new area('1026','八里區', 'Bali Township', 2, '1002');
cities[cities.length] = new area('1027','平溪區', 'Pingxi Township', 2, '1002');
cities[cities.length] = new area('1028','雙溪區', 'Shuangxi Township', 2, '1002');
cities[cities.length] = new area('1029','貢寮區', 'Gongliao Township', 2, '1002');
cities[cities.length] = new area('1030','金山區', 'Jinshan Township', 2, '1002');
cities[cities.length] = new area('1031','萬里區', 'Wanli Township', 2, '1002');
cities[cities.length] = new area('1032','烏來區', 'Wulai Township', 2, '1002');
cities[cities.length] = new area('1033','土城區', 'Tucheng City', 2, '1002');
cities[cities.length] = new area('1034','蘆洲區', 'Luzhou City', 2, '1002');
cities[cities.length] = new area('1035','汐止區', 'Xizhi City', 2, '1002');
cities[cities.length] = new area('1036','樹林區', 'Shulin City', 2, '1002');
cities[cities.length] = new area('1037','桃園市', 'Taoyuan City', 2, '1003');
cities[cities.length] = new area('1038','中壢市', 'Zhongli City', 2, '1003');
cities[cities.length] = new area('1039','大溪鎮', 'Daxi Township', 2, '1003');
cities[cities.length] = new area('1040','楊梅鎮', 'Yangmei Township', 2, '1003');
cities[cities.length] = new area('1041','蘆竹鄉', 'Luzhu Township', 2, '1003');
cities[cities.length] = new area('1042','大園鄉', 'Dayuan Township', 2, '1003');
cities[cities.length] = new area('1043','龜山鄉', 'Guishan Township', 2, '1003');
cities[cities.length] = new area('1044','龍潭鄉', 'Longtan Township', 2, '1003');
cities[cities.length] = new area('1045','新屋鄉', 'Xinwu Township', 2, '1003');
cities[cities.length] = new area('1046','觀音鄉', 'Guanyin Township', 2, '1003');
cities[cities.length] = new area('1047','復興鄉', 'Fuxing Township', 2, '1003');
cities[cities.length] = new area('1048','平鎮市', 'Pingzhen City', 2, '1003');
cities[cities.length] = new area('1049','八德市', 'Bade City', 2, '1003');
cities[cities.length] = new area('1050','竹北市', 'Zhubei City', 2, '1004');
cities[cities.length] = new area('1051','關西鎮', 'Guanxi Township', 2, '1004');
cities[cities.length] = new area('1052','新埔鎮', 'Xinpu Township', 2, '1004');
cities[cities.length] = new area('1053','竹東鎮', 'Zhudong Township', 2, '1004');
cities[cities.length] = new area('1054','湖口鄉', 'Hukou Township', 2, '1004');
cities[cities.length] = new area('1055','橫山鄉', 'Hengshan Township', 2, '1004');
cities[cities.length] = new area('1056','新豐鄉', 'Xinfeng Township', 2, '1004');
cities[cities.length] = new area('1057','芎林鄉', 'Qionglin Township', 2, '1004');
cities[cities.length] = new area('1058','寶山鄉', 'Baoshan Township', 2, '1004');
cities[cities.length] = new area('1059','北埔鄉', 'Beipu Township', 2, '1004');
cities[cities.length] = new area('1060','峨眉鄉', 'Emei Township', 2, '1004');
cities[cities.length] = new area('1061','尖石鄉', 'Jianshi Township', 2, '1004');
cities[cities.length] = new area('1062','五峰鄉', 'Wufeng Township', 2, '1004');
cities[cities.length] = new area('1063','苗栗市', 'Miaoli City', 2, '1005');
cities[cities.length] = new area('1064','苑裡鎮', 'Yuanli Township', 2, '1005');
cities[cities.length] = new area('1065','通霄鎮', 'Tongxiao Township', 2, '1005');
cities[cities.length] = new area('1066','竹南鎮', 'Zhunan Township', 2, '1005');
cities[cities.length] = new area('1067','頭份鎮', 'Toufen Township', 2, '1005');
cities[cities.length] = new area('1068','後龍鎮', 'Houlong Township', 2, '1005');
cities[cities.length] = new area('1069','卓蘭鎮', 'Zhuolan Township', 2, '1005');
cities[cities.length] = new area('1070','大湖鄉', 'Dahu Township', 2, '1005');
cities[cities.length] = new area('1071','公館鄉', 'Gongguan Township', 2, '1005');
cities[cities.length] = new area('1072','銅鑼鄉', 'Tongluo Township', 2, '1005');
cities[cities.length] = new area('1073','南庄鄉', 'Nanzhuang Township', 2, '1005');
cities[cities.length] = new area('1074','頭屋鄉', 'Touwu Township', 2, '1005');
cities[cities.length] = new area('1075','三義鄉', 'Sanyi Township', 2, '1005');
cities[cities.length] = new area('1076','西湖鄉', 'Xihu Township', 2, '1005');
cities[cities.length] = new area('1077','造橋鄉', 'Zaoqiao Township', 2, '1005');
cities[cities.length] = new area('1078','三灣鄉', 'Sanwan Township', 2, '1005');
cities[cities.length] = new area('1079','獅潭鄉', 'Shitan Township', 2, '1005');
cities[cities.length] = new area('1080','泰安鄉', 'Taian Township', 2, '1005');
cities[cities.length] = new area('1081','豐原區', 'Fengyuan City', 2, '1006');
cities[cities.length] = new area('1082','東勢區', 'Dongshi Township', 2, '1006');
cities[cities.length] = new area('1083','大甲區', 'Dajia Township', 2, '1006');
cities[cities.length] = new area('1084','清水區', 'Qingshui Township', 2, '1006');
cities[cities.length] = new area('1085','沙鹿區', 'Shalu Township', 2, '1006');
cities[cities.length] = new area('1086','梧棲區', 'Wuqi Township', 2, '1006');
cities[cities.length] = new area('1087','后里區', 'Houli Township', 2, '1006');
cities[cities.length] = new area('1088','神岡區', 'Shengang Township', 2, '1006');
cities[cities.length] = new area('1089','潭子區', 'Tanzi Township', 2, '1006');
cities[cities.length] = new area('1090','大雅區', 'Daya Township', 2, '1006');
cities[cities.length] = new area('1091','新社區', 'Xinshe Township', 2, '1006');
cities[cities.length] = new area('1092','石岡區', 'Shigang Township', 2, '1006');
cities[cities.length] = new area('1093','外埔區', 'Waipu Township', 2, '1006');
cities[cities.length] = new area('1094','大安區', 'Daan Township', 2, '1006');
cities[cities.length] = new area('1095','烏日區', 'Wuri Township', 2, '1006');
cities[cities.length] = new area('1096','大肚區', 'Dadu Township', 2, '1006');
cities[cities.length] = new area('1097','龍井區', 'Longjing Township', 2, '1006');
cities[cities.length] = new area('1098','霧峰區', 'Wufeng Township', 2, '1006');
cities[cities.length] = new area('1099','和平區', 'Heping Township', 2, '1006');
cities[cities.length] = new area('1100','大里區', 'Dali City', 2, '1006');
cities[cities.length] = new area('1101','太平區', 'Taiping City', 2, '1006');
cities[cities.length] = new area('1102','彰化市', 'Zhanghua City', 2, '1007');
cities[cities.length] = new area('1103','鹿港鎮', 'Lugang Township', 2, '1007');
cities[cities.length] = new area('1104','和美鎮', 'Hemei Township', 2, '1007');
cities[cities.length] = new area('1105','北斗鎮', 'Beidou Township', 2, '1007');
cities[cities.length] = new area('1106','員林鎮', 'Yuanlin Township', 2, '1007');
cities[cities.length] = new area('1107','溪湖鎮', 'Xihu Township', 2, '1007');
cities[cities.length] = new area('1108','田中鎮', 'Tianzhong Township', 2, '1007');
cities[cities.length] = new area('1109','二林鎮', 'Erlin Township', 2, '1007');
cities[cities.length] = new area('1110','線西鄉', 'Xianxi Township', 2, '1007');
cities[cities.length] = new area('1111','伸港鄉', 'Shengang Township', 2, '1007');
cities[cities.length] = new area('1112','福興鄉', 'Fuxing Township', 2, '1007');
cities[cities.length] = new area('1113','秀水鄉', 'Xiushui Township', 2, '1007');
cities[cities.length] = new area('1114','花壇鄉', 'Huatan Township', 2, '1007');
cities[cities.length] = new area('1115','芬園鄉', 'Fenyuan Township', 2, '1007');
cities[cities.length] = new area('1116','大村鄉', 'Dacun Township', 2, '1007');
cities[cities.length] = new area('1117','埔鹽鄉', 'Puyan Township', 2, '1007');
cities[cities.length] = new area('1118','埔心鄉', 'Puxin Township', 2, '1007');
cities[cities.length] = new area('1119','永靖鄉', 'Yongjing Township', 2, '1007');
cities[cities.length] = new area('1120','社頭鄉', 'Shetou Township', 2, '1007');
cities[cities.length] = new area('1121','二水鄉', 'Ershui Township', 2, '1007');
cities[cities.length] = new area('1122','田尾鄉', 'Tianwei Township', 2, '1007');
cities[cities.length] = new area('1123','埤頭鄉', 'Pitou Township', 2, '1007');
cities[cities.length] = new area('1124','芳苑鄉', 'Fangyuan Township', 2, '1007');
cities[cities.length] = new area('1125','大城鄉', 'Dacheng Township', 2, '1007');
cities[cities.length] = new area('1126','竹塘鄉', 'Zhutang Township', 2, '1007');
cities[cities.length] = new area('1127','溪州鄉', 'Xizhou Township', 2, '1007');
cities[cities.length] = new area('1128','南投市', 'Nantou City', 2, '1008');
cities[cities.length] = new area('1129','埔里鎮', 'Puli Township', 2, '1008');
cities[cities.length] = new area('1130','草屯鎮', 'Caotun Township', 2, '1008');
cities[cities.length] = new area('1131','竹山鎮', 'Zhushan Township', 2, '1008');
cities[cities.length] = new area('1132','集集鎮', 'Jiji Township', 2, '1008');
cities[cities.length] = new area('1133','名間鄉', 'Mingjian Township', 2, '1008');
cities[cities.length] = new area('1134','鹿谷鄉', 'Lugu Township', 2, '1008');
cities[cities.length] = new area('1135','中寮鄉', 'Zhongliao Township', 2, '1008');
cities[cities.length] = new area('1136','魚池鄉', 'Yuchi Township', 2, '1008');
cities[cities.length] = new area('1137','國姓鄉', 'Guoxing Township', 2, '1008');
cities[cities.length] = new area('1138','水里鄉', 'Shuili Township', 2, '1008');
cities[cities.length] = new area('1139','信義鄉', 'Xinyi Township', 2, '1008');
cities[cities.length] = new area('1140','仁愛鄉', 'Renai Township', 2, '1008');
cities[cities.length] = new area('1141','斗六市', 'Douliu City', 2, '1009');
cities[cities.length] = new area('1142','斗南鎮', 'Dounan Township', 2, '1009');
cities[cities.length] = new area('1143','虎尾鎮', 'Huwei Township', 2, '1009');
cities[cities.length] = new area('1144','西螺鎮', 'Xiluo Township', 2, '1009');
cities[cities.length] = new area('1145','土庫鎮', 'Tuku Township', 2, '1009');
cities[cities.length] = new area('1146','北港鎮', 'Beigang Township', 2, '1009');
cities[cities.length] = new area('1147','古坑鄉', 'Gukeng Township', 2, '1009');
cities[cities.length] = new area('1148','大埤鄉', 'Dapi Township', 2, '1009');
cities[cities.length] = new area('1149','莿桐鄉', 'Citong Township', 2, '1009');
cities[cities.length] = new area('1150','林內鄉', 'Linnei Township', 2, '1009');
cities[cities.length] = new area('1151','二崙鄉', 'Erlun Township', 2, '1009');
cities[cities.length] = new area('1152','崙背鄉', 'Lunbei Township', 2, '1009');
cities[cities.length] = new area('1153','麥寮鄉', 'Mailiao Township', 2, '1009');
cities[cities.length] = new area('1154','東勢鄉', 'Dongshi Township', 2, '1009');
cities[cities.length] = new area('1155','褒忠鄉', 'Baozhong Township', 2, '1009');
cities[cities.length] = new area('1156','台西鄉', 'Taixi Township', 2, '1009');
cities[cities.length] = new area('1157','元長鄉', 'Yuanchang Township', 2, '1009');
cities[cities.length] = new area('1158','四湖鄉', 'Sihu Township', 2, '1009');
cities[cities.length] = new area('1159','口湖鄉', 'Kouhu Township', 2, '1009');
cities[cities.length] = new area('1160','水林鄉', 'Shuilin Township', 2, '1009');
cities[cities.length] = new area('1161','太保市', 'Taibao City', 2, '1010');
cities[cities.length] = new area('1162','大林鎮', 'Dalin Township', 2, '1010');
cities[cities.length] = new area('1163','民雄鄉', 'Minxiong Township', 2, '1010');
cities[cities.length] = new area('1164','溪口鄉', 'Xikou Township', 2, '1010');
cities[cities.length] = new area('1165','新港鄉', 'Xingang Township', 2, '1010');
cities[cities.length] = new area('1166','六腳鄉', 'Liujiao Township', 2, '1010');
cities[cities.length] = new area('1167','東石鄉', 'Dongshi Township', 2, '1010');
cities[cities.length] = new area('1168','義竹鄉', 'Yizhu Township', 2, '1010');
cities[cities.length] = new area('1169','鹿草鄉', 'Lucao Township', 2, '1010');
cities[cities.length] = new area('1170','水上鄉', 'Shuishang Township', 2, '1010');
cities[cities.length] = new area('1171','中埔鄉', 'Zhongpu Township', 2, '1010');
cities[cities.length] = new area('1172','竹崎鄉', 'Zhuqi Township', 2, '1010');
cities[cities.length] = new area('1173','梅山鄉', 'Meishan Township', 2, '1010');
cities[cities.length] = new area('1174','番路鄉', 'Fanlu Township', 2, '1010');
cities[cities.length] = new area('1175','大埔鄉', 'Dapu Township', 2, '1010');
cities[cities.length] = new area('1176','布袋鎮', 'Budai Township', 2, '1010');
cities[cities.length] = new area('1177','朴子市', 'Puzi City', 2, '1010');
cities[cities.length] = new area('1178','阿里山鄉', 'Alishan Township', 2, '1010');
cities[cities.length] = new area('1179','新營區', 'Xinying City', 2, '1011');
cities[cities.length] = new area('1180','鹽水區', 'Yanshui Township', 2, '1011');
cities[cities.length] = new area('1181','白河區', 'Baihe Township', 2, '1011');
cities[cities.length] = new area('1182','麻豆區', 'Madou Township', 2, '1011');
cities[cities.length] = new area('1183','佳里區', 'Jiali Township', 2, '1011');
cities[cities.length] = new area('1184','新化區', 'Xinhua Township', 2, '1011');
cities[cities.length] = new area('1185','善化區', 'Shanhua Township', 2, '1011');
cities[cities.length] = new area('1186','學甲區', 'Xuejia Township', 2, '1011');
cities[cities.length] = new area('1187','柳營區', 'Liuying Township', 2, '1011');
cities[cities.length] = new area('1188','後壁區', 'Houbi Township', 2, '1011');
cities[cities.length] = new area('1189','東山區', 'Dongshan Township', 2, '1011');
cities[cities.length] = new area('1190','下營區', 'Xiaying Township', 2, '1011');
cities[cities.length] = new area('1191','六甲區', 'Liujia Township', 2, '1011');
cities[cities.length] = new area('1192','官田區', 'Guantian Township', 2, '1011');
cities[cities.length] = new area('1193','大內區', 'Danei Township', 2, '1011');
cities[cities.length] = new area('1194','西港區', 'Xigang Township', 2, '1011');
cities[cities.length] = new area('1195','七股區', 'Qigu Township', 2, '1011');
cities[cities.length] = new area('1196','將軍區', 'Jiangjun Township', 2, '1011');
cities[cities.length] = new area('1197','北門區', 'Beimen Township', 2, '1011');
cities[cities.length] = new area('1198','安定區', 'Anding Township', 2, '1011');
cities[cities.length] = new area('1199','楠西區', 'Nanxi Township', 2, '1011');
cities[cities.length] = new area('1200','新市區', 'Xinshi Township', 2, '1011');
cities[cities.length] = new area('1201','山上區', 'Shanshang Township', 2, '1011');
cities[cities.length] = new area('1202','玉井區', 'Yujing Township', 2, '1011');
cities[cities.length] = new area('1203','南化區', 'Nanhua Township', 2, '1011');
cities[cities.length] = new area('1204','左鎮區', 'Zuozhen Township', 2, '1011');
cities[cities.length] = new area('1205','仁德區', 'Rende Township', 2, '1011');
cities[cities.length] = new area('1206','歸仁區', 'Guiren Township', 2, '1011');
cities[cities.length] = new area('1207','關廟區', 'Guanmiao Township', 2, '1011');
cities[cities.length] = new area('1208','龍崎區', 'Longqi Township', 2, '1011');
cities[cities.length] = new area('1209','永康區', 'Yongkang City', 2, '1011');
cities[cities.length] = new area('1210','鳳山區', 'Fengshan City', 2, '1012');
cities[cities.length] = new area('1211','岡山區', 'Gangshan Township', 2, '1012');
cities[cities.length] = new area('1212','旗山區', 'Qishan Township', 2, '1012');
cities[cities.length] = new area('1213','美濃區', 'Meinong Township', 2, '1012');
cities[cities.length] = new area('1214','林園區', 'Linyuan Township', 2, '1012');
cities[cities.length] = new area('1215','大寮區', 'Daliao Township', 2, '1012');
cities[cities.length] = new area('1216','大樹區', 'Dashu Township', 2, '1012');
cities[cities.length] = new area('1217','仁武區', 'Renwu Township', 2, '1012');
cities[cities.length] = new area('1218','大社區', 'Dashe Township', 2, '1012');
cities[cities.length] = new area('1219','鳥松區', 'Niaosong Township', 2, '1012');
cities[cities.length] = new area('1220','橋頭區', 'Qiaotou Township', 2, '1012');
cities[cities.length] = new area('1221','燕巢區', 'Yanchao Township', 2, '1012');
cities[cities.length] = new area('1222','田寮區', 'Tianliao Township', 2, '1012');
cities[cities.length] = new area('1223','阿蓮區', 'Alian Township', 2, '1012');
cities[cities.length] = new area('1224','路竹區', 'Luzhu Township', 2, '1012');
cities[cities.length] = new area('1225','湖內區', 'Hunei Township', 2, '1012');
cities[cities.length] = new area('1226','茄萣區', 'Jiading Township', 2, '1012');
cities[cities.length] = new area('1227','永安區', 'Yongan Township', 2, '1012');
cities[cities.length] = new area('1228','彌陀區', 'Mituo Township', 2, '1012');
cities[cities.length] = new area('1229','梓官區', 'Ziguan Township', 2, '1012');
cities[cities.length] = new area('1230','六龜區', 'Liugui Township', 2, '1012');
cities[cities.length] = new area('1231','甲仙區', 'Jiaxian Township', 2, '1012');
cities[cities.length] = new area('1232','杉林區', 'Shanlin Township', 2, '1012');
cities[cities.length] = new area('1233','內門區', 'Neimen Township', 2, '1012');
cities[cities.length] = new area('1234','茂林區', 'Maolin Township', 2, '1012');
cities[cities.length] = new area('1235','桃源區', 'Taoyuan Township', 2, '1012');
cities[cities.length] = new area('1236','三民區', 'Sanmin Township', 2, '1012');
cities[cities.length] = new area('1237','屏東市', 'Pingdong City', 2, '1013');
cities[cities.length] = new area('1238','潮州鎮', 'Chaozhou Township', 2, '1013');
cities[cities.length] = new area('1239','東港鎮', 'Donggang Township', 2, '1013');
cities[cities.length] = new area('1240','恆春鎮', 'Hengchun Township', 2, '1013');
cities[cities.length] = new area('1241','萬丹鄉', 'Wandan Township', 2, '1013');
cities[cities.length] = new area('1242','長治鄉', 'Changzhi Township', 2, '1013');
cities[cities.length] = new area('1243','麟洛鄉', 'Linluo Township', 2, '1013');
cities[cities.length] = new area('1244','九如鄉', 'Jiuru Township', 2, '1013');
cities[cities.length] = new area('1245','里港鄉', 'Ligang Township', 2, '1013');
cities[cities.length] = new area('1246','鹽埔鄉', 'Yanpu Township', 2, '1013');
cities[cities.length] = new area('1247','高樹鄉', 'Gaoshu Township', 2, '1013');
cities[cities.length] = new area('1248','萬巒鄉', 'Wanluan Township', 2, '1013');
cities[cities.length] = new area('1249','內埔鄉', 'Neipu Township', 2, '1013');
cities[cities.length] = new area('1250','竹田鄉', 'Zhutian Township', 2, '1013');
cities[cities.length] = new area('1251','新埤鄉', 'Xinpi Township', 2, '1013');
cities[cities.length] = new area('1252','枋寮鄉', 'Fangliao Township', 2, '1013');
cities[cities.length] = new area('1253','新園鄉', 'Xinyuan Township', 2, '1013');
cities[cities.length] = new area('1254','崁頂鄉', 'Kanding Township', 2, '1013');
cities[cities.length] = new area('1255','林邊鄉', 'Linbian Township', 2, '1013');
cities[cities.length] = new area('1256','南州鄉', 'Nanzhou Township', 2, '1013');
cities[cities.length] = new area('1257','佳冬鄉', 'Jiadong Township', 2, '1013');
cities[cities.length] = new area('1258','琉球鄉', 'Liuqiu Township', 2, '1013');
cities[cities.length] = new area('1259','車城鄉', 'Checheng Township', 2, '1013');
cities[cities.length] = new area('1260','滿州鄉', 'Manzhou Township', 2, '1013');
cities[cities.length] = new area('1261','枋山鄉', 'Fangshan Township', 2, '1013');
cities[cities.length] = new area('1262','霧台鄉', 'Wutai Township', 2, '1013');
cities[cities.length] = new area('1263','瑪家鄉', 'Majia Township', 2, '1013');
cities[cities.length] = new area('1264','泰武鄉', 'Taiwu Township', 2, '1013');
cities[cities.length] = new area('1265','來義鄉', 'Laiyi Township', 2, '1013');
cities[cities.length] = new area('1266','春日鄉', 'Chunri Township', 2, '1013');
cities[cities.length] = new area('1267','獅子鄉', 'Shizi Township', 2, '1013');
cities[cities.length] = new area('1268','牡丹鄉', 'Mudan Township', 2, '1013');
cities[cities.length] = new area('1269','三地門鄉', 'Sandimen Township', 2, '1013');
cities[cities.length] = new area('1270','台東市', 'Taidong City', 2, '1014');
cities[cities.length] = new area('1271','成功鎮', 'Chenggong Township', 2, '1014');
cities[cities.length] = new area('1272','關山鎮', 'Guanshan Township', 2, '1014');
cities[cities.length] = new area('1273','卑南鄉', 'Beinan Township', 2, '1014');
cities[cities.length] = new area('1274','大武鄉', 'Dawu Township', 2, '1014');
cities[cities.length] = new area('1275','東河鄉', 'Donghe Township', 2, '1014');
cities[cities.length] = new area('1276','長濱鄉', 'Changbin Township', 2, '1014');
cities[cities.length] = new area('1277','鹿野鄉', 'Luye Township', 2, '1014');
cities[cities.length] = new area('1278','池上鄉', 'Chishang Township', 2, '1014');
cities[cities.length] = new area('1279','綠島鄉', 'L?dao Township', 2, '1014');
cities[cities.length] = new area('1280','延平鄉', 'Yanping Township', 2, '1014');
cities[cities.length] = new area('1281','海端鄉', 'Haiduan Township', 2, '1014');
cities[cities.length] = new area('1282','達仁鄉', 'Daren Township', 2, '1014');
cities[cities.length] = new area('1283','金峰鄉', 'Jinfeng Township', 2, '1014');
cities[cities.length] = new area('1284','蘭嶼鄉', 'Lanyu Township', 2, '1014');
cities[cities.length] = new area('1285','太麻里鄉', 'Taimali Township', 2, '1014');
cities[cities.length] = new area('1286','花蓮市', 'Hualian City', 2, '1015');
cities[cities.length] = new area('1287','鳳林鎮', 'Fenglin Township', 2, '1015');
cities[cities.length] = new area('1288','玉里鎮', 'Yuli Township', 2, '1015');
cities[cities.length] = new area('1289','新城鄉', 'Xincheng Township', 2, '1015');
cities[cities.length] = new area('1290','吉安鄉', 'Jian Township', 2, '1015');
cities[cities.length] = new area('1291','壽豐鄉', 'Shoufeng Township', 2, '1015');
cities[cities.length] = new area('1292','光復鄉', 'Guangfu Township', 2, '1015');
cities[cities.length] = new area('1293','豐濱鄉', 'Fengbin Township', 2, '1015');
cities[cities.length] = new area('1294','瑞穗鄉', 'Ruisui Township', 2, '1015');
cities[cities.length] = new area('1295','富里鄉', 'Fuli Township', 2, '1015');
cities[cities.length] = new area('1296','秀林鄉', 'Xiulin Township', 2, '1015');
cities[cities.length] = new area('1297','卓溪鄉', 'Zhuoxi Township', 2, '1015');
cities[cities.length] = new area('1298','萬榮鄉', 'Wanrong Township', 2, '1015');
cities[cities.length] = new area('1299','宜蘭市', 'Yilan City', 2, '1016');
cities[cities.length] = new area('1300','羅東鎮', 'Luodong Township', 2, '1016');
cities[cities.length] = new area('1301','蘇澳鎮', 'Suao Township', 2, '1016');
cities[cities.length] = new area('1302','頭城鎮', 'Toucheng Township', 2, '1016');
cities[cities.length] = new area('1303','礁溪鄉', 'Jiaoxi Township', 2, '1016');
cities[cities.length] = new area('1304','壯圍鄉', 'Zhuangwei Township', 2, '1016');
cities[cities.length] = new area('1305','員山鄉', 'Yuanshan Township', 2, '1016');
cities[cities.length] = new area('1306','冬山鄉', 'Dongshan Township', 2, '1016');
cities[cities.length] = new area('1307','五結鄉', 'Wujie Township', 2, '1016');
cities[cities.length] = new area('1308','三星鄉', 'Sanxing Township', 2, '1016');
cities[cities.length] = new area('1309','大同鄉', 'Datong Township', 2, '1016');
cities[cities.length] = new area('1310','南澳鄉', 'Nanao Township', 2, '1016');
cities[cities.length] = new area('1311','馬公市', 'Magong City', 2, '1017');
cities[cities.length] = new area('1312','湖西鄉', 'Huxi Township', 2, '1017');
cities[cities.length] = new area('1313','白沙鄉', 'Baisha Township', 2, '1017');
cities[cities.length] = new area('1314','西嶼鄉', 'Xiyu Township', 2, '1017');
cities[cities.length] = new area('1315','望安鄉', 'Wangan Township', 2, '1017');
cities[cities.length] = new area('1316','七美鄉', 'Qimei Township', 2, '1017');
cities[cities.length] = new area('1317','金城鎮', 'Jincheng Township', 2, '1018');
cities[cities.length] = new area('1318','金湖鎮', 'Jinhu Township', 2, '1018');
cities[cities.length] = new area('1319','金沙鎮', 'Jinsha Township', 2, '1018');
cities[cities.length] = new area('1320','金寧鄉', 'Jinning Township', 2, '1018');
cities[cities.length] = new area('1321','烈嶼鄉', 'Lieyu Township', 2, '1018');
cities[cities.length] = new area('1322','烏坵鄉', 'Wuqiu Township', 2, '1018');
cities[cities.length] = new area('1323','南竿鄉', 'Nangan Township', 2, '1019');
cities[cities.length] = new area('1324','北竿鄉', 'Beigan Township', 2, '1019');
cities[cities.length] = new area('1325','莒光鄉', 'Juguang Township', 2, '1019');
cities[cities.length] = new area('1326','東引鄉', 'Dongyin Township', 2, '1019');
districts[districts.length] = new area('1001','松山區', 'Songshan District', 3, '1001');
districts[districts.length] = new area('1002','大安區', 'Daan District', 3, '1001');
districts[districts.length] = new area('1003','大同區', 'Datong District', 3, '1001');
districts[districts.length] = new area('1004','中山區', 'Zhongshan District', 3, '1001');
districts[districts.length] = new area('1005','內湖區', 'Neihu District', 3, '1001');
districts[districts.length] = new area('1006','南港區', 'Nangang District', 3, '1001');
districts[districts.length] = new area('1007','士林區', 'Shilin District', 3, '1001');
districts[districts.length] = new area('1008','北投區', 'Beitou District', 3, '1001');
districts[districts.length] = new area('1009','信義區', 'Xinyi District', 3, '1001');
districts[districts.length] = new area('1010','中正區', 'Zhongzheng District', 3, '1001');
districts[districts.length] = new area('1011','萬華區', 'Wanhua District', 3, '1001');
districts[districts.length] = new area('1012','文山區', 'Wenshan District', 3, '1001');
districts[districts.length] = new area('1013','七堵區', 'Qidu District', 3, '1002');
districts[districts.length] = new area('1014','中山區', 'Zhongshan District', 3, '1002');
districts[districts.length] = new area('1015','中正區', 'Zhongzheng District', 3, '1002');
districts[districts.length] = new area('1016','信義區', 'Xinyi District', 3, '1002');
districts[districts.length] = new area('1017','仁愛區', 'Renai District', 3, '1002');
districts[districts.length] = new area('1018','安樂區', 'Anle District', 3, '1002');
districts[districts.length] = new area('1019','暖暖區', 'Nuannuan District', 3, '1002');
districts[districts.length] = new area('1020','東區', 'Dong District', 3, '1003');
districts[districts.length] = new area('1021','北區', 'Bei District', 3, '1003');
districts[districts.length] = new area('1022','香山區', 'Xiangshan District', 3, '1003');
districts[districts.length] = new area('1023','西區', 'Xi District', 3, '1004');
districts[districts.length] = new area('1024','北區', 'Bei District', 3, '1004');
districts[districts.length] = new area('1025','中區', 'Zhong District', 3, '1004');
districts[districts.length] = new area('1026','東區', 'Dong District', 3, '1004');
districts[districts.length] = new area('1027','南區', 'Nan District', 3, '1004');
districts[districts.length] = new area('1028','南屯區', 'Nantun District', 3, '1004');
districts[districts.length] = new area('1029','西屯區', 'Xitun District', 3, '1004');
districts[districts.length] = new area('1030','北屯區', 'Beitun District', 3, '1004');
districts[districts.length] = new area('1031','西區', 'Xi District', 3, '1005');
districts[districts.length] = new area('1032','東區', 'Dong District', 3, '1005');
districts[districts.length] = new area('1033','南區', 'Nan District', 3, '1006');
districts[districts.length] = new area('1034','中西區', 'Zhongxi District', 3, '1006');
districts[districts.length] = new area('1035','東區', 'Dong District', 3, '1006');
districts[districts.length] = new area('1036','安平區', 'Anping District', 3, '1006');
districts[districts.length] = new area('1037','北區', 'Bei District', 3, '1006');
districts[districts.length] = new area('1038','安南區', 'Annan District', 3, '1006');
districts[districts.length] = new area('1039','鹽埕區', 'Yancheng District', 3, '1007');
districts[districts.length] = new area('1040','鼓山區', 'Gushan District', 3, '1007');
districts[districts.length] = new area('1041','左營區', 'Zuoying District', 3, '1007');
districts[districts.length] = new area('1042','楠梓區', 'Nanzi District', 3, '1007');
districts[districts.length] = new area('1043','三民區', 'Sanmin District', 3, '1007');
districts[districts.length] = new area('1044','新興區', 'Xinxing District', 3, '1007');
districts[districts.length] = new area('1045','前金區', 'Qianjin District', 3, '1007');
districts[districts.length] = new area('1046','苓雅區', 'Lingya District', 3, '1007');
districts[districts.length] = new area('1047','前鎮區', 'Qianzhen District', 3, '1007');
districts[districts.length] = new area('1048','旗津區', 'Qijin District', 3, '1007');
districts[districts.length] = new area('1049','小港區', 'Xiaogang District', 3, '1007');
*/