//94/06/29 佳豪修改 因應功能確認單#19059鈺婷提出之需求查詢功能中再新增一組縣市鄉鎮供複選查詢修改。本檔是由ca/area3.js複製新增並修改的檔案供index.asp include
County = new Array("縣市","基隆市","台北市","台北縣","桃園縣","新竹市", "新竹縣","宜蘭縣","苗栗縣","台中市","台中縣","南投縣","彰化縣","雲林縣","嘉義市","嘉義縣","台南市","台南縣","高雄市","高雄縣","屏東縣","花蓮縣","台東縣","澎湖縣");
//區域
t0= new Array("區域");
t1 = new Array("全部","仁愛區","信義區","中正區","中山區","安樂區","暖暖區","七堵區");
t2 = new Array("請選擇","中正區","大同區","中山區","松山區","大安區","萬華區","信義區","士林區","北投區","內湖區","南港區","文山區");
t3 = new Array("請選擇","萬里鄉","金山鄉","板橋市","汐止市","深坑鄉","石碇鄉","瑞芳鎮","平溪鄉","雙溪鄉","貢寮鄉","新店市","坪林鄉","烏來鄉","永和市","中和市","土城市","三峽鎮","樹林市","鶯歌鎮","三重市","新莊市","泰山鄉","林口鄉","蘆洲市","五股鄉","八里鄉","淡水鎮","三芝鄉","石門鄉");
t4 = new Array("請選擇","中壢市","平鎮市","龍潭鄉","楊梅鎮","新屋鄉","觀音鄉","桃園市","龜山鄉","八德市","大溪鎮","復興鄉","大園鄉","蘆竹鄉");
t5 = new Array("全部","香山區","東區","北區")
t6 = new Array("請選擇","竹北市","湖口鄉","新豐鄉","新埔鎮","關西鎮","芎林鄉","寶山鄉","竹東鎮","五峰鄉","橫山鄉","尖石鄉","北埔鄉","峨眉鄉");
t7 = new Array("請選擇","宜蘭市","頭城鎮","礁溪鄉","壯圍鄉","員山鄉","羅東鎮","三星鄉","大同鄉","五結鄉","冬山鄉","蘇澳鎮","南澳鄉");
t8 = new Array("請選擇","竹南鎮","頭份鎮","三灣鄉","南庄鄉","獅潭鄉","後龍鎮","通霄鎮","苑裡鎮","苗栗市","造橋鄉","頭屋鄉","公館鄉","大湖鄉","泰安鄉","銅鑼鄉","三義鄉","西湖鄉","卓蘭鎮");
t9 = new Array("請選擇","中區","東區","南區","西區","北區","北屯區","西屯區","南屯區");
t10 = new Array("請選擇","太平市","大里市","霧峰鄉","烏日鄉","豐原市","后里鄉","石岡鄉","東勢鎮","和平鄉","新社鄉","潭子鄉","大雅鄉","神岡鄉","大肚鄉","沙鹿鎮","龍井鄉","梧棲鎮","清水鎮","大甲鎮","外埔鄉","大安鄉");
t11 = new Array("請選擇","南投市","中寮鄉","草屯鎮","國姓鄉","埔里鎮","仁愛鄉","名間鄉","集集鎮","水里鄉","魚池鄉","信義鄉","竹山鎮","鹿谷鄉");
t12 = new Array("請選擇","彰化市","芬園鄉","花壇鄉","秀水鄉","鹿港鎮","福興鄉","線西鄉","和美鎮","伸港鄉","員林鎮","社頭鄉","永靖鄉","埔心鄉","溪湖鎮","大村鄉","埔鹽鄉","田中鎮","北斗鎮","田尾鄉","埤頭鄉","溪州鄉","竹塘鄉","二林鎮","大城鄉","芳苑鄉","二水鄉");
t13 = new Array("請選擇","斗南鎮","大埤鄉","虎尾鎮","土庫鎮","褒忠鄉","東勢鄉","台西鄉","崙背鄉","麥寮鄉","斗六市","林內鄉","古坑鄉","莿桐鄉","西螺鎮","二崙鄉","北港鎮","水林鄉","口湖鄉","四湖鄉","元長鄉");
t14 = new Array("全部","西區","東區")
t15 = new Array("請選擇","番路鄉","梅山鄉","竹崎鄉","阿里山鄉","中埔鄉","大埔鄉","水上鄉","鹿草鄉","太保市","朴子市","東石鄉","六腳鄉","新港鄉","民雄鄉","大林鎮","溪口鄉","義竹鄉","布袋鎮");
t16 = new Array("全部","東區","南區","中西區","北區","安平區","安南區");
t17 = new Array("請選擇","永康市","歸仁鄉","新化鎮","左鎮鄉","玉井鄉","楠西鄉","南化鄉","仁德鄉","關廟鄉","龍崎鄉","官田鄉","麻豆鎮","佳里鎮","西港鄉","七股鄉","將軍鄉","學甲鎮","北門鄉","新營市","後壁鄉","白河鎮","東山鄉","六甲鄉","下營鄉","柳營鄉","鹽水鎮","善化鎮","大內鄉","山上鄉","新市鄉","安定鄉");
t18 = new Array("請選擇","新興區","前金區","苓雅區","鹽埕區","鼓山區","旗津區","前鎮區","三民區","楠梓區","小港區","左營區");
t19 = new Array("請選擇","仁武鄉","大社鄉","岡山鎮","路竹鄉","阿蓮鄉","田寮鄉","燕巢鄉","橋頭鄉","梓官鄉","彌陀鄉","永安鄉","湖內鄉","鳳山市","大寮鄉","林園鄉","鳥松鄉","大樹鄉","旗山鎮","美濃鎮","六龜鄉","內門鄉","杉林鄉","甲仙鄉","桃源鄉","三民鄉","茂林鄉","茄萣鄉");
t20 = new Array("請選擇","屏東市","三地門鄉","霧台鄉","瑪家鄉","九如鄉","里港鄉","高樹鄉","鹽埔鄉","長治鄉","麟洛鄉","竹田鄉","內埔鄉","萬丹鄉","潮州鎮","泰武鄉","來義鄉","萬巒鄉","崁頂鄉","新埤鄉","南州鄉","林邊鄉","東港鎮","琉球鄉","佳冬鄉","新園鄉","枋寮鄉","枋山鄉","春日鄉","獅子鄉","車城鄉","牡丹鄉","恆春鎮","滿州鄉");
t21 = new Array("請選擇","花蓮市","新城鄉","秀林鄉","吉安鄉","壽豐鄉","鳳林鎮","光復鄉","豐濱鄉","瑞穗鄉","萬榮鄉","玉里鎮","卓溪鄉","富里鄉");
t22 = new Array("請選擇","台東市","綠島鄉","蘭嶼鄉","延平鄉","卑南鄉","鹿野鄉","關山鎮","海端鄉","池上鄉","東河鄉","成功鎮","長濱鄉","太麻里鄉","金峰鄉","大武鄉","達仁鄉");
t23 = new Array("請選擇","馬公市","西嶼鄉","望安鄉","七美鄉","白沙鄉","湖西鄉");

/*
County = new Array("請選擇","基隆市","台北市","台北縣","桃園縣","新竹市", "新竹縣","宜蘭縣","苗栗縣","台中市","台中縣","南投縣","彰化縣","雲林縣","嘉義市","嘉義縣","台南市","台南縣","高雄市","高雄縣","屏東縣","花蓮縣","台東縣","澎湖縣");

//區域
//94/6/10 靖文修改，鈺婷提出，將「基隆市、新竹市、嘉義市、台南市」的區域加上「全部」
t0= new Array("請選擇");
t1 = new Array("全部","仁愛區","信義區","中正區","中山區","安樂區","暖暖區","七堵區");
t2 = new Array("請選擇","中正區","大同區","中山區","松山區","大安區","萬華區","信義區","士林區","北投區","內湖區","南港區","文山區");
t3 = new Array("請選擇","萬里鄉","金山鄉","板橋市","汐止市","深坑鄉","石碇鄉","瑞芳鎮","平溪鄉","雙溪鄉","貢寮鄉","新店市","坪林鄉","烏來鄉","永和市","中和市","土城市","三峽鎮","樹林市","鶯歌鎮","三重市","新莊市","泰山鄉","林口鄉","蘆洲市","五股鄉","八里鄉","淡水鎮","三芝鄉","石門鄉");
t4 = new Array("請選擇","中壢市","平鎮市","龍潭鄉","楊梅鎮","新屋鄉","觀音鄉","桃園市","龜山鄉","八德市","大溪鎮","復興鄉","大園鄉","蘆竹鄉");
t5 = new Array("全部","香山區","東區","北區")
t6 = new Array("請選擇","竹北市","湖口鄉","新豐鄉","新埔鎮","關西鎮","芎林鄉","寶山鄉","竹東鎮","五峰鄉","橫山鄉","尖石鄉","北埔鄉","峨眉鄉");
t7 = new Array("請選擇","宜蘭市","頭城鎮","礁溪鄉","壯圍鄉","員山鄉","羅東鎮","三星鄉","大同鄉","五結鄉","冬山鄉","蘇澳鎮","南澳鄉");
t8 = new Array("請選擇","竹南鎮","頭份鎮","三灣鄉","南庄鄉","獅潭鄉","後龍鎮","通霄鎮","苑裡鎮","苗栗市","造橋鄉","頭屋鄉","公館鄉","大湖鄉","泰安鄉","銅鑼鄉","三義鄉","西湖鄉","卓蘭鎮");
t9 = new Array("請選擇","中區","東區","南區","西區","北區","北屯區","西屯區","南屯區");
t10 = new Array("請選擇","太平市","大里市","霧峰鄉","烏日鄉","豐原市","后里鄉","石岡鄉","東勢鎮","和平鄉","新社鄉","潭子鄉","大雅鄉","神岡鄉","大肚鄉","沙鹿鎮","龍井鄉","梧棲鎮","清水鎮","大甲鎮","外埔鄉","大安鄉");
t11 = new Array("請選擇","南投市","中寮鄉","草屯鎮","國姓鄉","埔里鎮","仁愛鄉","名間鄉","集集鎮","水里鄉","魚池鄉","信義鄉","竹山鎮","鹿谷鄉");
t12 = new Array("請選擇","彰化市","芬園鄉","花壇鄉","秀水鄉","鹿港鎮","福興鄉","線西鄉","和美鎮","伸港鄉","員林鎮","社頭鄉","永靖鄉","埔心鄉","溪湖鎮","大村鄉","埔鹽鄉","田中鎮","北斗鎮","田尾鄉","埤頭鄉","溪州鄉","竹塘鄉","二林鎮","大城鄉","芳苑鄉","二水鄉");
t13 = new Array("請選擇","斗南鎮","大埤鄉","虎尾鎮","土庫鎮","褒忠鄉","東勢鄉","台西鄉","崙背鄉","麥寮鄉","斗六市","林內鄉","古坑鄉","莿桐鄉","西螺鎮","二崙鄉","北港鎮","水林鄉","口湖鄉","四湖鄉","元長鄉");
t14 = new Array("全部","西區","東區")
t15 = new Array("請選擇","番路鄉","梅山鄉","竹崎鄉","阿里山鄉","中埔鄉","大埔鄉","水上鄉","鹿草鄉","太保市","朴子市","東石鄉","六腳鄉","新港鄉","民雄鄉","大林鎮","溪口鄉","義竹鄉","布袋鎮");
t16 = new Array("全部","東區","南區","中西區","北區","安平區","安南區");
t17 = new Array("請選擇","永康市","歸仁鄉","新化鎮","左鎮鄉","玉井鄉","楠西鄉","南化鄉","仁德鄉","關廟鄉","龍崎鄉","官田鄉","麻豆鎮","佳里鎮","西港鄉","七股鄉","將軍鄉","學甲鎮","北門鄉","新營市","後壁鄉","白河鎮","東山鄉","六甲鄉","下營鄉","柳營鄉","鹽水鎮","善化鎮","大內鄉","山上鄉","新市鄉","安定鄉");
t18 = new Array("請選擇","新興區","前金區","苓雅區","鹽埕區","鼓山區","旗津區","前鎮區","三民區","楠梓區","小港區","左營區");
t19 = new Array("請選擇","仁武鄉","大社鄉","岡山鎮","路竹鄉","阿蓮鄉","田寮鄉","燕巢鄉","橋頭鄉","梓官鄉","彌陀鄉","永安鄉","湖內鄉","鳳山市","大寮鄉","林園鄉","鳥松鄉","大樹鄉","旗山鎮","美濃鎮","六龜鄉","內門鄉","杉林鄉","甲仙鄉","桃源鄉","三民鄉","茂林鄉","茄萣鄉");
t20 = new Array("請選擇","屏東市","三地門鄉","霧台鄉","瑪家鄉","九如鄉","里港鄉","高樹鄉","鹽埔鄉","長治鄉","麟洛鄉","竹田鄉","內埔鄉","萬丹鄉","潮州鎮","泰武鄉","來義鄉","萬巒鄉","崁頂鄉","新埤鄉","南州鄉","林邊鄉","東港鎮","琉球鄉","佳冬鄉","新園鄉","枋寮鄉","枋山鄉","春日鄉","獅子鄉","車城鄉","牡丹鄉","恆春鎮","滿州鄉");
t21 = new Array("請選擇","花蓮市","新城鄉","秀林鄉","吉安鄉","壽豐鄉","鳳林鎮","光復鄉","豐濱鄉","瑞穗鄉","萬榮鄉","玉里鎮","卓溪鄉","富里鄉");
t22 = new Array("請選擇","台東市","綠島鄉","蘭嶼鄉","延平鄉","卑南鄉","鹿野鄉","關山鎮","海端鄉","池上鄉","東河鄉","成功鎮","長濱鄉","太麻里鄉","金峰鄉","大武鄉","達仁鄉");
t23 = new Array("請選擇","馬公市","西嶼鄉","望安鄉","七美鄉","白沙鄉","湖西鄉");
*/

/*
County = new Array("請選擇","台北市","台北縣","桃園縣","新竹市", "新竹縣","基隆市","宜蘭縣","苗栗縣","台中市","台中縣","南投縣","彰化縣","雲林縣","嘉義市","嘉義縣","台南市","台南縣","高雄市","高雄縣","屏東縣","花蓮縣","台東縣","澎湖縣");

//區域
t0= new Array("請選擇");
t1 = new Array("請選擇","中正區","大同區","中山區","松山區","大安區","萬華區","信義區","士林區","北投區","內湖區","南港區","文山區");
t2 = new Array("請選擇","萬里鄉","金山鄉","板橋市","汐止市","深坑鄉","石碇鄉","瑞芳鎮","平溪鄉","雙溪鄉","貢寮鄉","新店市","坪林鄉","烏來鄉","永和市","中和市","土城市","三峽鎮","樹林市","鶯歌鎮","三重市","新莊市","泰山鄉","林口鄉","蘆洲市","五股鄉","八里鄉","淡水鎮","三芝鄉","石門鄉");
t3 = new Array("請選擇","中壢市","平鎮市","龍潭鄉","楊梅鎮","新屋鄉","觀音鄉","桃園市","龜山鄉","八德市","大溪鎮","復興鄉","大園鄉","蘆竹鄉");
t4 = new Array("全部","香山區","東區","北區")
t5 = new Array("請選擇","竹北市","湖口鄉","新豐鄉","新埔鎮","關西鎮","芎林鄉","寶山鄉","竹東鎮","五峰鄉","橫山鄉","尖石鄉","北埔鄉","峨眉鄉");
t6 = new Array("全部","仁愛區","信義區","中正區","中山區","安樂區","暖暖區","七堵區");
t7 = new Array("請選擇","宜蘭市","頭城鎮","礁溪鄉","壯圍鄉","員山鄉","羅東鎮","三星鄉","大同鄉","五結鄉","冬山鄉","蘇澳鎮","南澳鄉");
t8 = new Array("請選擇","竹南鎮","頭份鎮","三灣鄉","南庄鄉","獅潭鄉","後龍鎮","通霄鎮","苑裡鎮","苗栗市","造橋鄉","頭屋鄉","公館鄉","大湖鄉","泰安鄉","銅鑼鄉","三義鄉","西湖鄉","卓蘭鎮");
t9 = new Array("請選擇","中區","東區","南區","西區","北區","北屯區","西屯區","南屯區");
t10 = new Array("請選擇","太平市","大里市","霧峰鄉","烏日鄉","豐原市","后里鄉","石岡鄉","東勢鎮","和平鄉","新社鄉","潭子鄉","大雅鄉","神岡鄉","大肚鄉","沙鹿鎮","龍井鄉","梧棲鎮","清水鎮","大甲鎮","外埔鄉","大安鄉");
t11 = new Array("請選擇","南投市","中寮鄉","草屯鎮","國姓鄉","埔里鎮","仁愛鄉","名間鄉","集集鎮","水里鄉","魚池鄉","信義鄉","竹山鎮","鹿谷鄉");
t12 = new Array("請選擇","彰化市","芬園鄉","花壇鄉","秀水鄉","鹿港鎮","福興鄉","線西鄉","和美鎮","伸港鄉","員林鎮","社頭鄉","永靖鄉","埔心鄉","溪湖鎮","大村鄉","埔鹽鄉","田中鎮","北斗鎮","田尾鄉","埤頭鄉","溪州鄉","竹塘鄉","二林鎮","大城鄉","芳苑鄉","二水鄉");
t13 = new Array("請選擇","斗南鎮","大埤鄉","虎尾鎮","土庫鎮","褒忠鄉","東勢鄉","台西鄉","崙背鄉","麥寮鄉","斗六市","林內鄉","古坑鄉","莿桐鄉","西螺鎮","二崙鄉","北港鎮","水林鄉","口湖鄉","四湖鄉","元長鄉");
t14 = new Array("全部","西區","東區")
t15 = new Array("請選擇","番路鄉","梅山鄉","竹崎鄉","阿里山鄉","中埔鄉","大埔鄉","水上鄉","鹿草鄉","太保市","朴子市","東石鄉","六腳鄉","新港鄉","民雄鄉","大林鎮","溪口鄉","義竹鄉","布袋鎮");
t16 = new Array("全部","中區","東區","南區","西區","北區","安平區","安南區");
t17 = new Array("請選擇","永康市","歸仁鄉","新化鎮","左鎮鄉","玉井鄉","楠西鄉","南化鄉","仁德鄉","關廟鄉","龍崎鄉","官田鄉","麻豆鎮","佳里鎮","西港鄉","七股鄉","將軍鄉","學甲鎮","北門鄉","新營市","後壁鄉","白河鎮","東山鄉","六甲鄉","下營鄉","柳營鄉","鹽水鎮","善化鎮","大內鄉","山上鄉","新市鄉","安定鄉");
t18 = new Array("請選擇","新興區","前金區","苓雅區","鹽埕區","鼓山區","旗津區","前鎮區","三民區","楠梓區","小港區","左營區");
t19 = new Array("請選擇","仁武鄉","大社鄉","岡山鎮","路竹鄉","阿蓮鄉","田寮鄉","燕巢鄉","橋頭鄉","梓官鄉","彌陀鄉","永安鄉","湖內鄉","鳳山市","大寮鄉","林園鄉","鳥松鄉","大樹鄉","旗山鎮","美濃鎮","六龜鄉","內門鄉","杉林鄉","甲仙鄉","桃源鄉","三民鄉","茂林鄉","茄萣鄉");
t20 = new Array("請選擇","屏東市","三地門鄉","霧台鄉","瑪家鄉","九如鄉","里港鄉","高樹鄉","鹽埔鄉","長治鄉","麟洛鄉","竹田鄉","內埔鄉","萬丹鄉","潮州鎮","泰武鄉","來義鄉","萬巒鄉","崁頂鄉","新埤鄉","南州鄉","林邊鄉","東港鎮","琉球鄉","佳冬鄉","新園鄉","枋寮鄉","枋山鄉","春日鄉","獅子鄉","車城鄉","牡丹鄉","恆春鎮","滿州鄉");
t21 = new Array("請選擇","花蓮市","新城鄉","秀林鄉","吉安鄉","壽豐鄉","鳳林鎮","光復鄉","豐濱鄉","瑞穗鄉","萬榮鄉","玉里鎮","卓溪鄉","富里鄉");
t22 = new Array("請選擇","台東市","綠島鄉","蘭嶼鄉","延平鄉","卑南鄉","鹿野鄉","關山鎮","海端鄉","池上鄉","東河鄉","成功鎮","長濱鄉","太麻里鄉","金峰鄉","大武鄉","達仁鄉");
t23 = new Array("請選擇","馬公市","西嶼鄉","望安鄉","七美鄉","白沙鄉","湖西鄉");
*/

function changearea(x){	
	if (x == 1){	
		//var index=document.all.address_county1.selectedIndex;
		var index=xs.address_county1.selectedIndex;
	}else if (x == 2){	
		var index=xs.address_county2.selectedIndex;
	}else if (x == 3){	
		var index=xs.address_county3.selectedIndex;
	}else if (x == 4){	
		var index=xs.address_county4.selectedIndex;
	}
	
	var obj;
	obj = eval("t" + index)
	/*
	if (index==0)obj=t0; if (index==1)obj=t1; if (index==2)obj=t2; if (index==3)obj=t3; if (index==4)obj=t4;
	if (index==5)obj=t5; if (index==6)obj=t6; if (index==7)obj=t7; if (index==8)obj=t8; if (index==9)obj=t9;
	if (index==10)obj=t10; if (index==11)obj=t11; if (index==12)obj=t12; if (index==13)obj=t13; if (index==14)obj=t14;
	if (index==15)obj=t15; if (index==16)obj=t16; if (index==17)obj=t17; if (index==18)obj=t18; if (index==19)obj=t19;
	if (index==20)obj=t20; if (index==21)obj=t21; if (index==22)obj=t22; if (index==23)obj=t23; 
	*/
	if (x == 1){	
		xs.address_area1.length=obj.length;
	}else
	if (x == 2){	
		xs.address_area2.length=obj.length;
	}else
	if (x == 3){	
		xs.address_area3.length=obj.length;
	}else
	if (x == 4){	
		xs.address_area4.length=obj.length;
	}

	for (var i=0;i<obj.length ;i++ )
	{
		if (x == 1){
			xs.address_area1.options[i].value=obj[i];
			xs.address_area1.options[i].text=obj[i];
		}else
		if (x == 2){	
			xs.address_area2.options[i].value=obj[i];
			xs.address_area2.options[i].text=obj[i];
		}else
		if (x == 3){	
			xs.address_area3.options[i].value=obj[i];
			xs.address_area3.options[i].text=obj[i];
		}else
		if (x == 4){
			xs.address_area4.options[i].value=obj[i];
			xs.address_area4.options[i].text=obj[i];
		}
	}

}

function SetSelected(SelectedCounty,SelectedDistrict) {
	var i,j;
	xs.address_county1.length=County.length;
	for(i=0;i<County.length;i++){
		if(SelectedCounty==County[i]){
			xs.address_county1.options[i].selected=true;
			j=i;
			break;
		}
	}
	
	
	if (j==0)obj=t0; if (j==1)obj=t1; if (j==2)obj=t2; if (j==3)obj=t3; if (j==4)obj=t4;
	if (j==5)obj=t5; if (j==6)obj=t6; if (j==7)obj=t7; if (j==8)obj=t8; if (j==9)obj=t9;
	if (j==10)obj=t10; if (j==11)obj=t11; if (j==12)obj=t12; if (j==13)obj=t13; if (j==14)obj=t14;
	if (j==15)obj=t15; if (j==16)obj=t16; if (j==17)obj=t17; if (j==18)obj=t18; if (j==19)obj=t19;
	if (j==20)obj=t20; if (j==21)obj=t21; if (j==22)obj=t22; if (j==23)obj=t23;
	
	var obj;
	xs.address_area1.length=obj.length;
	
	for (i=0;i<obj.length ;i++ ){
		xs.address_area1.options[i].value=(obj[i]=="請選擇"?"":obj[i]);
		xs.address_area1.options[i].text=obj[i];
	}

	for(j=0;j<obj.length;j++){
		if(SelectedDistrict==obj[j]){
			xs.address_area1.options[j].selected=true;
			break;
		}
	}
}

function SetSelstrArea(SelectedCounty) {
	var i,j;
	xs.address_county1.length=County.length;
	for(i=0;i<County.length;i++){
		if(SelectedCounty==County[i]){
			xs.address_county1.options[i].selected=true;
			j=i;
			break;
		}
	}
	
	if (j==0)obj=t0; if (j==1)obj=t1; if (j==2)obj=t2; if (j==3)obj=t3; if (j==4)obj=t4;
	if (j==5)obj=t5; if (j==6)obj=t6; if (j==7)obj=t7; if (j==8)obj=t8; if (j==9)obj=t9;
	if (j==10)obj=t10; if (j==11)obj=t11; if (j==12)obj=t12; if (j==13)obj=t13; if (j==14)obj=t14;
	if (j==15)obj=t15; if (j==16)obj=t16; if (j==17)obj=t17; if (j==18)obj=t18; if (j==19)obj=t19;
	if (j==20)obj=t20; if (j==21)obj=t21; if (j==22)obj=t22; if (j==23)obj=t23;
	
	var obj;
	xs.address_area1.length=obj.length;		
	
	for (i=0;i<obj.length ;i++ ){
		xs.address_area1.options[i].value=(obj[i]=="請選擇"?"":obj[i]);
		xs.address_area1.options[i].text=obj[i];
	}	
}

/*94/06/29 佳豪修改 因應功能確認單#19059鈺婷提出之需求查詢功能中再新增一組縣市鄉鎮供複選查詢修改*/
function SetSelstrArea1(SelectedCounty1) {
	var i,j;
	xs.address_county2.length=County.length;
	for(i=0;i<County.length;i++){
		if(SelectedCounty1==County[i]){
			xs.address_county2.options[i].selected=true;
			j=i;
			break;
		}
	}
	
	if (j==0)obj=t0; if (j==1)obj=t1; if (j==2)obj=t2; if (j==3)obj=t3; if (j==4)obj=t4;
	if (j==5)obj=t5; if (j==6)obj=t6; if (j==7)obj=t7; if (j==8)obj=t8; if (j==9)obj=t9;
	if (j==10)obj=t10; if (j==11)obj=t11; if (j==12)obj=t12; if (j==13)obj=t13; if (j==14)obj=t14;
	if (j==15)obj=t15; if (j==16)obj=t16; if (j==17)obj=t17; if (j==18)obj=t18; if (j==19)obj=t19;
	if (j==20)obj=t20; if (j==21)obj=t21; if (j==22)obj=t22; if (j==23)obj=t23;
	
	var obj;
	xs.address_area2.length=obj.length;		
	
	for (i=0;i<obj.length ;i++ ){
		xs.address_area2.options[i].value=(obj[i]=="請選擇"?"":obj[i]);
		xs.address_area2.options[i].text=obj[i];
	}	
}
