<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<AreaChange> changes = new AreaChangeMgr(tran_id).retrieveList("", "");
		
		ArrayList<McaStudent> ms = new McaStudentMgr(tran_id).retrieveList("","");
		Map<String, ArrayList<McaStudent>> mailing_county_map = new SortingMap(ms).doSortA("getCountyID");
		Map<String, ArrayList<McaStudent>> mailing_city_map = new SortingMap(ms).doSortA("getCityID");
		Map<String, ArrayList<McaStudent>> mailing_district_map = new SortingMap(ms).doSortA("getDistrictID");

		Map<String, ArrayList<McaStudent>> billing_county_map = new SortingMap(ms).doSortA("getBillCountyID");
		Map<String, ArrayList<McaStudent>> billing_city_map = new SortingMap(ms).doSortA("getBillCityID");
		Map<String, ArrayList<McaStudent>> billing_district_map = new SortingMap(ms).doSortA("getBillDistrictID");

		StringBuffer sb = new StringBuffer();

        for (int i=0; i<changes.size(); i++) {
			AreaChange ac = changes.get(i);
			if (new AreaChangeMgr(tran_id).find("level=" + ac.getOrgLevel() + 
				" and code='" + ac.getOrgCode() + "'")==null) 
			{
				Area olda = new AreaMgr(tran_id).find("level=" + ac.getOrgLevel() + " and code='" + ac.getOrgCode() + "'");
				Object[] objs = { olda };
				new AreaMgr(tran_id).remove(objs);
			}
			Area a = new AreaMgr(tran_id).find("level=" + ac.getLevel() + " and code='" + ac.getCode() + "'");
			if (a!=null) {
				a.setParentCode(ac.getParentCode());
				a.setCName(ac.getCName());
				a.setEName(ac.getEName());
				new AreaMgr(tran_id).save(a);
				sb.append(a.getCName() + ":" + a.getLevel() + ":" + a.getCode() + " saved<br/>\n");
			}
			else {
				a = new Area();
				a.setLevel(ac.getLevel());
				a.setCode(ac.getCode());
				a.setParentCode(ac.getParentCode());
				a.setCName(ac.getCName());
				a.setEName(ac.getEName());
				new AreaMgr(tran_id).create(a);
				sb.append(a.getCName() + ":" + a.getLevel() + ":" + a.getCode() + " created<br/>\n");
			}
			Map<String, ArrayList<McaStudent>>  mailing_map=null, billing_map=null;
			if (ac.getOrgLevel()==1) {
				mailing_map = mailing_county_map;
				billing_map = billing_county_map;
			}
			else if (ac.getOrgLevel()==2) {
				mailing_map = mailing_city_map;
				billing_map = billing_city_map;
			}
			else if (ac.getOrgLevel()==3) {
				mailing_map = mailing_district_map;
				billing_map = billing_district_map;
			}
			// 找到 orgLevel, orgCode 的这些 student, 更新新设定
			List<McaStudent> mailing_ms = mailing_map.get(ac.getOrgCode());
			List<McaStudent> billing_ms = billing_map.get(ac.getOrgCode());
			for (int j=0; mailing_ms!=null && j<mailing_ms.size(); j++) {
				McaStudent s = mailing_ms.get(j);
				
				if (ac.getOrgLevel()==1)
					s.setCountyID("");
				else if (ac.getOrgLevel()==2)
					s.setCityID("");
				else if (ac.getOrgLevel()==3)
					s.setDistrictID("");

				if (ac.getLevel()==1)
					s.setCountyID(ac.getCode());
				else if (ac.getLevel()==2)
					s.setCityID(ac.getCode());
				else if (ac.getLevel()==3) {
					s.setCityID(ac.getParentCode());
					s.setDistrictID(ac.getCode());
				}

				new McaStudentMgr(tran_id).save(s);
			}

			for (int j=0; billing_ms!=null && j<billing_ms.size(); j++) {
				McaStudent s = billing_ms.get(j);
				
				if (ac.getOrgLevel()==1)
					s.setBillCountyID("");
				else if (ac.getOrgLevel()==2)
					s.setBillCityID("");
				else if (ac.getOrgLevel()==3)
					s.setBillDistrictID("");

				if (ac.getLevel()==1)
					s.setBillCountyID(ac.getCode());
				else if (ac.getLevel()==2)
					s.setBillCityID(ac.getCode());
				else if (ac.getLevel()==3) {
					s.setBillCityID(ac.getParentCode());
					s.setBillDistrictID(ac.getCode());
				}

				new McaStudentMgr(tran_id).save(s);
			}

			//sb.append("level:" + ac.getLevel() + " code=" + ac.getCode() + " parent=" + ac.getParentCode() 
			//	+ " orgLevel=" + ac.getOrgLevel() + " orgCode=" + ac.getOrgCode()
			//	+ " cName=" + ac.getCName());
			
			//if (a!=null)
			//	sb.append(" found a=").append(a.getCName());
		}

		out.println(sb.toString());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
done6!