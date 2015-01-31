<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	
	//設定管理員
		
	UserMgr um=UserMgr.getInstance();
    if (um.numOfRows("")>0)
        throw new Exception("db not empty..");	
	User u=new User();
	u.setUserLoginId   	("admin");
	u.setUserPassword   	("phm188588");
	u.setUserFullname   	("PHM Admin");
	u.setUserEmail   	("service@phm.com.tw");
	u.setUserPhone   	("23693566");
    u.setUserActive(1);
	u.setUserRole   	(1);
	um.createWithIdReturned(u);
	
	
	//設定系統資料
	
	EsystemMgr em=EsystemMgr.getInstance();
	Esystem es=new Esystem();
	int x1=1000;
	int x2=15;
	es.setEsystemIncomeVerufy   (x1);
	es.setEsystemCostVerufy   	(x1);
	es.setEsystemStupage   	(x2);
	es.setEsystemTeapage   	(x2);
	es.setEsystemIncomePage(x2);
	es.setEsystemCostPage(x2);
	es.setEsystemMySqlfile   	("C:\\Program Files\\MySQL\\MySQL Server 5.0\\data\\");
	es.setEsystemMysqlName   	("jsf");
	es.setEsystemMysqlBinary   	("ibdata1");
	es.setEsystemDBfile   	("dbbackup");
	em.createWithIdReturned(es);
	
	//設定付款系統資料
	
	PaySystemMgr pma=PaySystemMgr.getInstance();
	PaySystem ps=new PaySystem();
	ps.setPaySystemCompanyName   	("必亨商軟得意算");
	ps.setPaySystemCompanyAddress   	("106 台北市大安區羅斯福路二段93號19樓");
	ps.setPaySystemCompanyPhone   	("02-23693566");
	ps.setPaySystemLimitDate   	(15);
	ps.setPaySystemCompanyUniteId   ("23974356");
	ps.setPaySystemBankName   	("台新國際商業銀行");
	ps.setPaySystemBankId   	("812");
    ps.setPaySystemFirst5   	("");
	ps.setPaySystemBankStoreNickName   	("");
	ps.setPaySystemCompanyStoreNickName   	("");
	ps.setPaySystemBeforeLimitDate(3);
	ps.setPaySystemLimitMoney(20000);
    ps.setPaySystemEmailCode   	("big5");    

    ps.setPaySystemStoreActive   	(9);
    ps.setPaySystemATMActive(9);
    ps.setPaySystemMessageActive(9);
    ps.setPaySystemExtendNotpay(2);
	pma.createWithIdReturned(ps); 
	

    BigItemMgr bim=BigItemMgr.getInstance();
    SmallItemMgr sim=SmallItemMgr.getInstance();

    BigItem bi=new BigItem();
    bi.setBigItemName("伙食費用");
    bi.setBigItemActive(1);

    int biId=bim.createWithIdReturned(bi);

    SmallItem si=new SmallItem();
    si.setSmallItemActive(1); 
    si.setSmallItemBigItemId(biId);

    si.setSmallItemName("豬肉");
    sim.createWithIdReturned(si);

    si.setSmallItemName("雞肉");
    sim.createWithIdReturned(si);

    si.setSmallItemName("水果");
    sim.createWithIdReturned(si);

    si.setSmallItemName("青菜");
    sim.createWithIdReturned(si);

    si.setSmallItemName("蛋");
    sim.createWithIdReturned(si);

    si.setSmallItemName("麵類");
    sim.createWithIdReturned(si);

    si.setSmallItemName("乾糧雜貨");
    sim.createWithIdReturned(si);

    si.setSmallItemName("麵包土司");
    sim.createWithIdReturned(si);

    si.setSmallItemName("其他");
    sim.createWithIdReturned(si);

    si.setSmallItemName("青菜");
    sim.createWithIdReturned(si);

		bi=new BigItem();
		bi.setBigItemName("保險");
		bi.setBigItemActive(1);
	
		biId=bim.createWithIdReturned(bi);
		
		si=new SmallItem();
		si.setSmallItemActive(1); 
		si.setSmallItemBigItemId(biId);
		


		si.setSmallItemName("健保");
		sim.createWithIdReturned(si);
		
		si.setSmallItemName("勞保");
		sim.createWithIdReturned(si);
		
		si.setSmallItemName("幼生意險");
		sim.createWithIdReturned(si); 
		
		si.setSmallItemName("公共意外險");
		sim.createWithIdReturned(si);


	
	MessageTypeMgr rmXX=MessageTypeMgr.getInstance();
	
	MessageType ra=new MessageType();
	ra.setMessageTypeStatus(1);

	ra.setMessageTypeName("學費相關");
	rmXX.createWithIdReturned(ra);

	ra.setMessageTypeName("雜費相關");
	rmXX.createWithIdReturned(ra);
	
	ra.setMessageTypeName("代辦事項");
	rmXX.createWithIdReturned(ra);

	
	PositionMgr rmAS=PositionMgr.getInstance();
	
	Position rapo=new Position();
	rapo.setPositionActive(1);  
	rapo.setPositionName("園長"); 
	rmAS.createWithIdReturned(rapo); 
	
	rapo.setPositionName("所長");
	rmAS.createWithIdReturned(rapo);  
	
	rapo.setPositionName("主任");
	rmAS.createWithIdReturned(rapo);  
	
	rapo.setPositionName("行政");
	rmAS.createWithIdReturned(rapo);  
	
	rapo.setPositionName("課任老師");
	rmAS.createWithIdReturned(rapo);  
	
	rapo.setPositionName("才藝老師");
	rmAS.createWithIdReturned(rapo); 
	

	
	RelationMgr rmla=RelationMgr.getInstance();
	
	Relation rawq=new Relation();
	rawq.setRelationName("奶奶");
	rmla.createWithIdReturned(rawq);

	rawq.setRelationName("爺爺");
	rmla.createWithIdReturned(rawq);

	rawq.setRelationName("姑姑");
	rmla.createWithIdReturned(rawq);

	rawq.setRelationName("舅舅");
	rmla.createWithIdReturned(rawq);

	rawq.setRelationName("阿姨");
	rmla.createWithIdReturned(rawq); 

	
	DegreeMgr rmso=DegreeMgr.getInstance();
	Degree raew=new Degree();
	raew.setDegreeActive(1);

	raew.setDegreeName("碩士");
	rmso.createWithIdReturned(raew);

	
	raew.setDegreeName("大學");
	rmso.createWithIdReturned(raew);
	
	raew.setDegreeName("專科");
	rmso.createWithIdReturned(raew);
	
	raew.setDegreeName("高中職以下");
	rmso.createWithIdReturned(raew);

	LeaveReasonMgr rmiu=LeaveReasonMgr.getInstance();
	
	LeaveReason raqew=new LeaveReason();
	raqew.setLeaveReasonActive(1);

    String[] leavereasons = {"畢業", "適應不良", "家長決定不適合就讀", "搬家", "無法照顧", "其他原因" };
    for (int i=0; i<leavereasons.length; i++) {
        raqew.setLeaveReasonName(leavereasons[i]);
        rmiu.createWithIdReturned(raqew);
    }


	SalaryTypeMgr stmjh=SalaryTypeMgr.getInstance();
	SalaryType st=new SalaryType();
	st.setSalaryType   	(1);
	st.setSalaryTypeName   	("本薪");
	st.setSalaryTypeFullName   	("本薪");
	st.setSalaryTypeActive   	(1);
	st.setSalaryTypePs   	("");
	st.setSalaryTypeFixNumber(1);
	stmjh.createWithIdReturned(st); 
	
	st=new SalaryType();
	st.setSalaryType   	(2);
	st.setSalaryTypeName   	("勞保費");
	st.setSalaryTypeFullName   	("勞保費");
	st.setSalaryTypeActive   	(1);
	st.setSalaryTypePs   	("");
	st.setSalaryTypeFixNumber(1);
	stmjh.createWithIdReturned(st);

		
	st=new SalaryType();
	st.setSalaryType   	(2);
	st.setSalaryTypeName   	("健保費");
	st.setSalaryTypeFullName   	("健保費");
	st.setSalaryTypeActive   	(1);
	st.setSalaryTypePs   	("");
	st.setSalaryTypeFixNumber(1);
	stmjh.createWithIdReturned(st);

	st=new SalaryType();
	st.setSalaryType   	(3);
	st.setSalaryTypeName   	("請假");
	st.setSalaryTypeFullName   	("請假");
	st.setSalaryTypeActive   	(1);
	st.setSalaryTypePs   	("");
	st.setSalaryTypeFixNumber(0);
	stmjh.createWithIdReturned(st);

	IncomeSmallItemMgr simSD=IncomeSmallItemMgr.getInstance(); 
	
	IncomeSmallItem sii=new IncomeSmallItem();
	sii.setIncomeSmallItemActive(1); 
	sii.setIncomeSmallItemIncomeBigItemId(1);
	sii.setIncomeSmallItemName("註冊費收入");
	simSD.createWithIdReturned(sii);
	
	sii.setIncomeSmallItemName("月費收入");
	simSD.createWithIdReturned(sii);

	sii.setIncomeSmallItemName("課後才藝收入");
	simSD.createWithIdReturned(sii);

	sii.setIncomeSmallItemName("交通車收入");
	simSD.createWithIdReturned(sii);
	
	sii.setIncomeSmallItemName("餐點費收入");
	simSD.createWithIdReturned(sii);

	sii.setIncomeSmallItemName("學用品");
	simSD.createWithIdReturned(sii);

	sii.setIncomeSmallItemName("保險費收入");
	simSD.createWithIdReturned(sii);
	
	sii.setIncomeSmallItemName("扣款負項");
	simSD.createWithIdReturned(sii);

	DiscountTypeMgr dtmew=DiscountTypeMgr.getInstance();
	DiscountType dt=new DiscountType();
	
	dt.setDiscountTypeActive   	(1);
	dt.setDiscountTypePs   	("");

    String[] discountTypes = {"員工眷屬減免", "舊生減免", "合作廠商員工優待", "才藝班扣堂",
        "兄弟姐妹減免", "清寒減免", "請假折扣", "囉嗦家長", "校友", "中途入學", "父母為校友減免",
        "其他原因" };
    for (int i=0; i<discountTypes.length; i++) {
        dt.setDiscountTypeName   	(discountTypes[i]);
        dtmew.createWithIdReturned(dt);
    }



%>

done!


<br>
<br>
next
 
<br>
<a href="test/init_account_code_new.jsp">會計科目</a>

<br>
<a href="test/initial_authitem.jsp">授權項目設定</a>