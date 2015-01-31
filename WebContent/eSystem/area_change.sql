

USE `phm_db`;

#
# Source for table area_change
#

DROP TABLE IF EXISTS `area_change`;
CREATE TABLE `area_change` (
  `id` int(11) NOT NULL auto_increment,
  `level` tinyint(3) default NULL,
  `code` varchar(4) default NULL,
  `cName` varchar(10) default NULL,
  `eName` varchar(50) default NULL,
  `parentCode` varchar(4) default NULL,
  `orgLevel` tinyint(3) default NULL,
  `orgCode` varchar(4) default NULL,
  `orgParent` varchar(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;

#
# Dumping data for table area_change
#

INSERT INTO `area_change` VALUES (1,2,'1002','新北市','NewTaipei City','1001',1,'1002','1001');
INSERT INTO `area_change` VALUES (2,2,'1004','台中市','Taichung City','1001',1,'1006','1001');
INSERT INTO `area_change` VALUES (3,2,'1006','台南市','Tainan City','1001',1,'1011','1001');
INSERT INTO `area_change` VALUES (4,2,'1007','高雄市','Kaohsiung City','1001',1,'1012','1001');
INSERT INTO `area_change` VALUES (5,2,'1008','基隆市','Jilong City','1001',2,'1002','1001');
INSERT INTO `area_change` VALUES (6,2,'1009','新竹市','Xinzhu City','1001',2,'1003','1001');
INSERT INTO `area_change` VALUES (7,2,'1010','嘉義市','Jiayi City','1001',2,'1005','1001');
INSERT INTO `area_change` VALUES (8,3,'1013','七堵區','Qidu District','1008',3,'1013','1002');
INSERT INTO `area_change` VALUES (9,3,'1014','中山區','Zhongshan District','1008',3,'1014','1002');
INSERT INTO `area_change` VALUES (10,3,'1015','中正區','Zhongzheng District','1008',3,'1015','1002');
INSERT INTO `area_change` VALUES (11,3,'1016','信義區','Xinyi District','1008',3,'1016','1002');
INSERT INTO `area_change` VALUES (12,3,'1017','仁愛區','Renai District','1008',3,'1017','1002');
INSERT INTO `area_change` VALUES (13,3,'1018','安樂區','Anle District','1008',3,'1018','1002');
INSERT INTO `area_change` VALUES (14,3,'1019','暖暖區','Nuannuan District','1008',3,'1019','1002');
INSERT INTO `area_change` VALUES (15,3,'1020','東區','Dong District','1009',3,'1020','1003');
INSERT INTO `area_change` VALUES (16,3,'1021','北區','Bei District','1009',3,'1021','1003');
INSERT INTO `area_change` VALUES (17,3,'1022','香山區','Xiangshan District','1009',3,'1022','1003');
INSERT INTO `area_change` VALUES (18,3,'1031','西區','Xi District','1010',3,'1031','1005');
INSERT INTO `area_change` VALUES (19,3,'1032','東區','Dong District','1010',3,'1032','1005');
INSERT INTO `area_change` VALUES (20,3,'2001','板橋區','Banqiao District','1002',2,'1008','1002');
INSERT INTO `area_change` VALUES (21,3,'2002','三重區','Sanchong District','1002',2,'1009','1002');
INSERT INTO `area_change` VALUES (22,3,'2003','永和區','Yonghe District','1002',2,'1010','1002');
INSERT INTO `area_change` VALUES (23,3,'2004','中和區','Zhonghe District','1002',2,'1011','1002');
INSERT INTO `area_change` VALUES (24,3,'2005','新莊區','Xinzhuang District','1002',2,'1012','1002');
INSERT INTO `area_change` VALUES (25,3,'2006','新店區','Xindian District','1002',2,'1013','1002');
INSERT INTO `area_change` VALUES (26,3,'2007','鶯歌區','Yingge District','1002',2,'1014','1002');
INSERT INTO `area_change` VALUES (27,3,'2008','三峽區','Sanxia District','1002',2,'1015','1002');
INSERT INTO `area_change` VALUES (28,3,'2009','淡水區','Danshui District','1002',2,'1016','1002');
INSERT INTO `area_change` VALUES (29,3,'2010','瑞芳區','Ruifang District','1002',2,'1017','1002');
INSERT INTO `area_change` VALUES (30,3,'2011','五股區','Wugu District','1002',2,'1018','1002');
INSERT INTO `area_change` VALUES (31,3,'2012','泰山區','Taishan District','1002',2,'1019','1002');
INSERT INTO `area_change` VALUES (32,3,'2013','林口區','Linkou District','1002',2,'1020','1002');
INSERT INTO `area_change` VALUES (33,3,'2014','深坑區','Shenkeng District','1002',2,'1021','1002');
INSERT INTO `area_change` VALUES (34,3,'2015','石碇區','Shiding District','1002',2,'1022','1002');
INSERT INTO `area_change` VALUES (35,3,'2016','坪林區','Pinglin District','1002',2,'1023','1002');
INSERT INTO `area_change` VALUES (36,3,'2017','三芝區','Sanzhi District','1002',2,'1024','1002');
INSERT INTO `area_change` VALUES (37,3,'2018','石門區','Shimen District','1002',2,'1025','1002');
INSERT INTO `area_change` VALUES (38,3,'2019','八里區','Bali District','1002',2,'1026','1002');
INSERT INTO `area_change` VALUES (39,3,'2020','平溪區','Pingxi District','1002',2,'1027','1002');
INSERT INTO `area_change` VALUES (40,3,'2021','雙溪區','Shuangxi District','1002',2,'1028','1002');
INSERT INTO `area_change` VALUES (41,3,'2022','貢寮區','Gongliao District','1002',2,'1029','1002');
INSERT INTO `area_change` VALUES (42,3,'2023','金山區','Jinshan District','1002',2,'1030','1002');
INSERT INTO `area_change` VALUES (43,3,'2024','萬里區','Wanli District','1002',2,'1031','1002');
INSERT INTO `area_change` VALUES (44,3,'2025','烏來區','Wulai District','1002',2,'1032','1002');
INSERT INTO `area_change` VALUES (45,3,'2026','土城區','Tucheng District','1002',2,'1033','1002');
INSERT INTO `area_change` VALUES (46,3,'2027','蘆洲區','Luzhou District','1002',2,'1034','1002');
INSERT INTO `area_change` VALUES (47,3,'2028','汐止區','Xizhi District','1002',2,'1035','1002');
INSERT INTO `area_change` VALUES (48,3,'2029','樹林區','Shulin District','1002',2,'1036','1002');
INSERT INTO `area_change` VALUES (49,3,'2030','豐原區','Fengyuan District','1004',2,'1081','1006');
INSERT INTO `area_change` VALUES (50,3,'2031','東勢區','Dongshi District','1004',2,'1082','1006');
INSERT INTO `area_change` VALUES (51,3,'2032','大甲區','Dajia District','1004',2,'1083','1006');
INSERT INTO `area_change` VALUES (52,3,'2033','清水區','Qingshui District','1004',2,'1084','1006');
INSERT INTO `area_change` VALUES (53,3,'2034','沙鹿區','Shalu District','1004',2,'1085','1006');
INSERT INTO `area_change` VALUES (54,3,'2035','梧棲區','Wuqi District','1004',2,'1086','1006');
INSERT INTO `area_change` VALUES (55,3,'2036','后里區','Houli District','1004',2,'1087','1006');
INSERT INTO `area_change` VALUES (56,3,'2037','神岡區','Shengang District','1004',2,'1088','1006');
INSERT INTO `area_change` VALUES (57,3,'2038','潭子區','Tanzi District','1004',2,'1089','1006');
INSERT INTO `area_change` VALUES (58,3,'2039','大雅區','Daya District','1004',2,'1090','1006');
INSERT INTO `area_change` VALUES (59,3,'2040','新社區','Xinshe District','1004',2,'1091','1006');
INSERT INTO `area_change` VALUES (60,3,'2041','石岡區','Shigang District','1004',2,'1092','1006');
INSERT INTO `area_change` VALUES (61,3,'2042','外埔區','Waipu District','1004',2,'1093','1006');
INSERT INTO `area_change` VALUES (62,3,'2043','大安區','Daan District','1004',2,'1094','1006');
INSERT INTO `area_change` VALUES (63,3,'2044','烏日區','Wuri District','1004',2,'1095','1006');
INSERT INTO `area_change` VALUES (64,3,'2045','大肚區','Dadu District','1004',2,'1096','1006');
INSERT INTO `area_change` VALUES (65,3,'2046','龍井區','Longjing District','1004',2,'1097','1006');
INSERT INTO `area_change` VALUES (66,3,'2047','霧峰區','Wufeng District','1004',2,'1098','1006');
INSERT INTO `area_change` VALUES (67,3,'2048','和平區','Heping District','1004',2,'1099','1006');
INSERT INTO `area_change` VALUES (68,3,'2049','大里區','Dali District','1004',2,'1100','1006');
INSERT INTO `area_change` VALUES (69,3,'2050','太平區','Taiping District','1004',2,'1101','1006');
INSERT INTO `area_change` VALUES (70,3,'2051','新營區','Xinying District','1006',2,'1179','1011');
INSERT INTO `area_change` VALUES (71,3,'2052','鹽水區','Yanshui District','1006',2,'1180','1011');
INSERT INTO `area_change` VALUES (72,3,'2053','白河區','Baihe District','1006',2,'1181','1011');
INSERT INTO `area_change` VALUES (73,3,'2054','麻豆區','Madou District','1006',2,'1182','1011');
INSERT INTO `area_change` VALUES (74,3,'2055','佳里區','Jiali District','1006',2,'1183','1011');
INSERT INTO `area_change` VALUES (75,3,'2056','新化區','Xinhua District','1006',2,'1184','1011');
INSERT INTO `area_change` VALUES (76,3,'2057','善化區','Shanhua District','1006',2,'1185','1011');
INSERT INTO `area_change` VALUES (77,3,'2058','學甲區','Xuejia District','1006',2,'1186','1011');
INSERT INTO `area_change` VALUES (78,3,'2059','柳營區','Liuying District','1006',2,'1187','1011');
INSERT INTO `area_change` VALUES (79,3,'2060','後壁區','Houbi District','1006',2,'1188','1011');
INSERT INTO `area_change` VALUES (80,3,'2061','東山區','Dongshan District','1006',2,'1189','1011');
INSERT INTO `area_change` VALUES (81,3,'2062','下營區','Xiaying District','1006',2,'1190','1011');
INSERT INTO `area_change` VALUES (82,3,'2063','六甲區','Liujia District','1006',2,'1191','1011');
INSERT INTO `area_change` VALUES (83,3,'2064','官田區','Guantian District','1006',2,'1192','1011');
INSERT INTO `area_change` VALUES (84,3,'2065','大內區','Danei District','1006',2,'1193','1011');
INSERT INTO `area_change` VALUES (85,3,'2066','西港區','Xigang District','1006',2,'1194','1011');
INSERT INTO `area_change` VALUES (86,3,'2067','七股區','Qigu District','1006',2,'1195','1011');
INSERT INTO `area_change` VALUES (87,3,'2068','將軍區','Jiangjun District','1006',2,'1196','1011');
INSERT INTO `area_change` VALUES (88,3,'2069','北門區','Beimen District','1006',2,'1197','1011');
INSERT INTO `area_change` VALUES (89,3,'2070','安定區','Anding District','1006',2,'1198','1011');
INSERT INTO `area_change` VALUES (90,3,'2071','楠西區','Nanxi District','1006',2,'1199','1011');
INSERT INTO `area_change` VALUES (91,3,'2072','新區區','Xinshi District','1006',2,'1200','1011');
INSERT INTO `area_change` VALUES (92,3,'2073','山上區','Shanshang District','1006',2,'1201','1011');
INSERT INTO `area_change` VALUES (93,3,'2074','玉井區','Yujing District','1006',2,'1202','1011');
INSERT INTO `area_change` VALUES (94,3,'2075','南化區','Nanhua District','1006',2,'1203','1011');
INSERT INTO `area_change` VALUES (95,3,'2076','左鎮區','Zuozhen District','1006',2,'1204','1011');
INSERT INTO `area_change` VALUES (96,3,'2077','仁德區','Rende District','1006',2,'1205','1011');
INSERT INTO `area_change` VALUES (97,3,'2078','歸仁區','Guiren District','1006',2,'1206','1011');
INSERT INTO `area_change` VALUES (98,3,'2079','關廟區','Guanmiao District','1006',2,'1207','1011');
INSERT INTO `area_change` VALUES (99,3,'2080','龍崎區','Longqi District','1006',2,'1208','1011');
INSERT INTO `area_change` VALUES (100,3,'2081','永康區','Yongkang District','1006',2,'1209','1011');
INSERT INTO `area_change` VALUES (101,3,'2082','鳳山區','Fengshan District','1007',2,'1210','1012');
INSERT INTO `area_change` VALUES (102,3,'2083','岡山區','Gangshan District','1007',2,'1211','1012');
INSERT INTO `area_change` VALUES (103,3,'2084','旗山區','Qishan District','1007',2,'1212','1012');
INSERT INTO `area_change` VALUES (104,3,'2085','美濃區','Meinong District','1007',2,'1213','1012');
INSERT INTO `area_change` VALUES (105,3,'2086','林園區','Linyuan District','1007',2,'1214','1012');
INSERT INTO `area_change` VALUES (106,3,'2087','大寮區','Daliao District','1007',2,'1215','1012');
INSERT INTO `area_change` VALUES (107,3,'2088','大樹區','Dashu District','1007',2,'1216','1012');
INSERT INTO `area_change` VALUES (108,3,'2089','仁武區','Renwu District','1007',2,'1217','1012');
INSERT INTO `area_change` VALUES (109,3,'2090','大社區','Dashe District','1007',2,'1218','1012');
INSERT INTO `area_change` VALUES (110,3,'2091','鳥松區','Niaosong District','1007',2,'1219','1012');
INSERT INTO `area_change` VALUES (111,3,'2092','橋頭區','Qiaotou District','1007',2,'1220','1012');
INSERT INTO `area_change` VALUES (112,3,'2093','燕巢區','Yanchao District','1007',2,'1221','1012');
INSERT INTO `area_change` VALUES (113,3,'2094','田寮區','Tianliao District','1007',2,'1222','1012');
INSERT INTO `area_change` VALUES (114,3,'2095','阿蓮區','Alian District','1007',2,'1223','1012');
INSERT INTO `area_change` VALUES (115,3,'2096','路竹區','Luzhu District','1007',2,'1224','1012');
INSERT INTO `area_change` VALUES (116,3,'2097','湖內區','Hunei District','1007',2,'1225','1012');
INSERT INTO `area_change` VALUES (117,3,'2098','茄萣區','Jiading District','1007',2,'1226','1012');
INSERT INTO `area_change` VALUES (118,3,'2099','永安區','Yongan District','1007',2,'1227','1012');
INSERT INTO `area_change` VALUES (119,3,'2100','彌陀區','Mituo District','1007',2,'1228','1012');
INSERT INTO `area_change` VALUES (120,3,'2101','梓官區','Ziguan District','1007',2,'1229','1012');
INSERT INTO `area_change` VALUES (121,3,'2102','六龜區','Liugui District','1007',2,'1230','1012');
INSERT INTO `area_change` VALUES (122,3,'2103','甲仙區','Jiaxian District','1007',2,'1231','1012');
INSERT INTO `area_change` VALUES (123,3,'2104','杉林區','Shanlin District','1007',2,'1232','1012');
INSERT INTO `area_change` VALUES (124,3,'2105','內門區','Neimen District','1007',2,'1233','1012');
INSERT INTO `area_change` VALUES (125,3,'2106','茂林區','Maolin District','1007',2,'1234','1012');
INSERT INTO `area_change` VALUES (126,3,'2107','桃源區','Taoyuan District','1007',2,'1235','1012');
INSERT INTO `area_change` VALUES (127,3,'2108','那瑪夏區','Namaxia District','1007',2,'1236','1012');
