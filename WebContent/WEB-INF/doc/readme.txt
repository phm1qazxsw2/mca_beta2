TOMCAT STUFF
==============
tail -f /opt/tomcat-6/logs/catalina.out
tail -f /opt/tomcat-6/logs/localhost.2008-03-12.log
sudo rm /opt/tomcat-6/logs/catalina.out

/home/webadm/bin/START.sh
/home/webadm/bin/STOP.sh
sudo /opt/tomcat-6/bin/RefineState.sh


RESIN STUFF
=============
tail -f /opt/resin/log/stdout.log
sudo /opt/resin/bin/httpd.sh start
sudo /opt/resin/bin/httpd.sh stop
ps -aux | grep java

ln -s /home/webadm/hostings/easycounting/easycounting_beta/ ezcounting_beta
ln -s /home/webadm/hostings/easyblog/ezblog_beta ezblog_beta


sudo rm -r ezblog_beta; ln -s /home/webadm/hostings/easyblog/ezblog_beta/ ezblog_beta








stop webapps
============
rm jsftc.phm.com.tw; 
rm jsftp.phm.com.tw; 
rm kid.phm.com.tw;


start webapps
============
sudo rm -r jsftc.phm.com.tw; ln -s /home/webadm/hosting_setup/jsftc.phm.com.tw/ jsftc.phm.com.tw; 
sudo rm -r jsftp.phm.com.tw; ln -s /home/webadm/hosting_setup/jsftp.phm.com.tw/ jsftp.phm.com.tw; 
sudo rm -r kid.phm.com.tw; ln -s /home/webadm/hosting_setup/kid.phm.com.tw/ kid.phm.com.tw;


stop beta webapps
==================
rm ezblogdev.phm.com.tw
rm ezcountingdev.phm.com.tw

start beta webapps
==================
sudo rm -r ezblogdev.phm.com.tw; ln -s /home/webadm/hosts/ezblog_host/ ezblogdev.phm.com.tw; 
sudo rm -r ezcountingdev.phm.com.tw; ln -s /home/webadm/hosts/ezcounting_host/ ezcountingdev.phm.com.tw; 


diff ezblog/ kid2/ -q -r -x .svn > diffresult


svn updating 
=============
in hostings directory

cd f_js_changhua;
svn update;
cd ../f_js_taichong_v2/;
svn update;
cd ../f_neil;
svn update;
cd ../f_starlight;
svn update;
cd ../f_yoyo_taichong2;
svn update
cd ../f_internal_v2
svn update
cd ../f_js_daycare
svn update
cd ../f_js_tainan
svn update
cd ../f_showme
svn update
cd ../f_js_taipei_v2
svn update
cd ../f_hoho
svn update
cd ../f_kjf_shiren
svn update
cd ../f_nw_datun
svn update
cd ../f_karen
svn update
cd ../f_stock_1
svn update
cd ../f_ccg1168
svn update
cd ../f_daniel
svn update
cd ../f_robrita
svn update
cd ../f_nbp_hk
svn update
cd ../f_leader
svn update
cd ../f_hawsheng
svn update
cd ../f_bowjinn
svn update
cd ..


==== beta
cd f_beta_v2
svn update
cd ../f_anima
svn update
cd ../f_stock1
svn update
cd ../f_mca
svn update
cd ..


mysql 
===========
use f_beta_v2;
alter table student change bloodType bloodType VARCHAR(4);

use f_leader_beta;
alter table student change bloodType bloodType VARCHAR(4);

use f_anima;
alter table student change bloodType bloodType VARCHAR(4);

use f_js_taichong_v2;
alter table student change bloodType bloodType VARCHAR(4);


use f_js_changhua;
alter table student change bloodType bloodType VARCHAR(4);


use f_neil;
alter table student change bloodType bloodType VARCHAR(4);


use f_starlight;
alter table student change bloodType bloodType VARCHAR(4);


use f_yoyo_taichong;
alter table student change bloodType bloodType VARCHAR(4);

use f_internal;
alter table student change bloodType bloodType VARCHAR(4);

use f_js_daycare;
alter table student change bloodType bloodType VARCHAR(4);


use f_js_tainan;
alter table student change bloodType bloodType VARCHAR(4);

use f_showme;
alter table student change bloodType bloodType VARCHAR(4);

use f_hoho;
alter table student change bloodType bloodType VARCHAR(4);

use f_kjf_shiren
alter table student change bloodType bloodType VARCHAR(4);


use f_nw_datun
alter table student change bloodType bloodType VARCHAR(4);

use f_karen
alter table student change bloodType bloodType VARCHAR(4);

use f_daniel
alter table student change bloodType bloodType VARCHAR(4);

use f_ccg1168
alter table student change bloodType bloodType VARCHAR(4);

use f_robrita
alter table student change bloodType bloodType VARCHAR(4);

use f_nbp_hk
alter table student change bloodType bloodType VARCHAR(4);

use f_leader
alter table student change bloodType bloodType VARCHAR(4);


use f_stock_1
alter table student change bloodType bloodType VARCHAR(4);


use f_js_taipei
alter table student change bloodType bloodType VARCHAR(4);

use f_hawsheng
alter table student change bloodType bloodType VARCHAR(4);

use f_mca
alter table student change bloodType bloodType VARCHAR(4);

use f_bowjinn
alter table student change bloodType bloodType VARCHAR(4);



===========
on 61.66.231.2 db backup is
cd /.phm
tar -jxvf MySQLDump.bz


===========
mysqladmin processlist
root :  /etc/init.d/mysql restart



upgrade
===============
upgrade_membr.jsp
upgrade_feeticket.jsp
upgrade_salary.jsp
upgrade_acctcode.jsp
upgrade_costbook.jsp

init_account_code.jsp
init_ct_bi.jsp

##################################################################################
		                 �t�Φ^�_ SOP
##################################################################################

[�W�� 10:09:56] nicepeter �� : 1. �C�� webapp �� directory
2. �C�� webapp �s�^�ۤv db 
3. /opt/resin/webapps �U��C�� webapp �� symbolic link
4. crontab �^�_�A�]�A
     a. /home/webadm/ftpbalancer/*   
     b. /home/webadm/bin/*
     c. crontab -e �������]�w
5. resin.conf

== �H�U�o�@�I�A���ίS�O�B�z�C�C

6. �٦��� url �n�վ�, �]�A
     a. /home/webadm/ftpbalancer/urls.txt �n�s��s ip
     b. �C�� webapp �U�� eSystem/request_card.jsp
[�W�� 10:12:17] [admin] michael �L����~ �� : okok
[�W�� 10:13:21] nicepeter �� : �p�G�O 60.251.12.20 ���O���F, �^�_�ɤ@�w�n

== �H�U�]�O peter&henry
1. cardreader webapp �@�w�n run (http://60.251.12.20:4444)
2. http://60.251.12.20:8080/cardreader/requestCard.jsp �@�w�n�b�C�C

####################################################################################





�R���״ڥI�~���O��
========================
delete from costpay where costpayStudentAccountId=305;
delete from billpaid where billPayId=305;
update membrbillrecord set paidStatus=0 where ticketId in (97070070,97070071,97070072,97070074,97070077);
update membrbillrecord set received=0 where ticketId in (97070070,97070071,97070072,97070074,97070077);
delete from billpay where id=305;



check how many billpays and SMS
========================
select count(*) from billpay where via in (1,2) and createTime>'2008-07-20';

use sms_server
select sender,count(*) from item where tstamp>'2008-07-15' and status=4 group by sender;
��X�ĤG���� �K�өM��b�� �O��
select billpay.id from billpaid,billpay,membrbillrecord where billpaid.ticketId=membrbillrecord.ticketId and billPayId=billpay.id and via in (1,2) and  billRecordId=5 group by billpay.id;

==>
http://localhost:8080/ezcounting/eSystem/test/query-usage.jsp?from=2008-11-20

�������ͫH�d���
https://secure.easycounting.cc/kjfsr/eSystem/test/print_ticket_info.jsp?month=2008-11-01


