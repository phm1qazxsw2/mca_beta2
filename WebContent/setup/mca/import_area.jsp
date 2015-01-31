<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.lang.reflect.*,phm.importing.*,mca.*,phm.util.*" 
    contentType="text/html;charset=UTF-8"%>
<%          
    String country = request.getParameter("country");
    String county = request.getParameter("county");
    String city = request.getParameter("city");
    String district = request.getParameter("district");

    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {            
        CountryMgr mgr0 = new CountryMgr(tran_id);
        CountyMgr mgr1 = new CountyMgr(tran_id);
        CityMgr mgr2 = new CityMgr(tran_id);
        DistrictMgr mgr3 = new DistrictMgr(tran_id);

        String line = null;
        String[] lines = country.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            Country c = new Country();
            c.setLevel(0);
            c.setCode(tokens[0]);
            c.setCName(tokens[1]);
            c.setEName(tokens[2]);
            mgr0.create(c);
        }

        lines = county.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            County c = new County();
            c.setLevel(1);
            c.setCode(tokens[0]);
            c.setCName(tokens[1]);
            c.setEName(tokens[2]);
            c.setParentCode(tokens[3]);
            mgr1.create(c);
        }

        lines = city.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            City c = new City();
            c.setLevel(2);
            c.setCode(tokens[0]);
            c.setCName(tokens[1]);
            c.setEName(tokens[2]);
            c.setParentCode(tokens[3]);
            mgr2.create(c);
        }

        lines = district.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            District c = new District();
            c.setLevel(3);
            c.setCode(tokens[0]);
            c.setCName(tokens[1]);
            c.setEName(tokens[2]);
            c.setParentCode(tokens[3]);
            mgr3.create(c);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>done!