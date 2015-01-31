<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.lang.reflect.*,phm.importing.*,mca.*,phm.util.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    void findAreaInfo(String name, AreaMgr amgr, Map<String, Area> areaMap, Area[] ret, String fullname, String type)
        throws Exception
    {
        name = name.replace("'", "''");
        String str = type + "## " + name + ":" + fullname + "->";
        if (name!=null && name.length()>=3) {
            String token1 = name.substring(0,3).trim();
            String token2 = name.substring(3).trim();
            Area city = amgr.find("level=2 and cname='" + token1 + "'"); // city
            if (city!=null) {
                //System.out.println("市=" + city.getCName());
                if (token2!=null && token2.length()>0) {
                    Area district = amgr.find("level=3 and cname='" + token2 + "' and parentCode=" + city.getCode()); // district
                    if (district!=null) {
                        //System.out.println(str + "區:" + district.getCName());
                        ret[3] = district;
                        ret[2] = areaMap.get("2#" + district.getParentCode());
                        ret[1] = areaMap.get("1#" + ret[2].getParentCode());
                        ret[0] = areaMap.get("0#" + ret[1].getParentCode());
                    }
                    else {
                        System.out.println(str + " 。。。1");
                    }
                }
            }
            else {
                Area county = amgr.find("level=1 and cname='" + token1 + "'"); // county
                if (county!=null) {
                    //System.out.println("縣=" + county.getCName());
                    if (token2!=null && token2.length()>0) {
                        Area city2 = amgr.find("level=2 and cname='" + token2 + "' and parentCode=" + county.getCode()); // city
                        if (city2!=null) {
                            //System.out.println(str + "市:" + city2.getCName());
                            ret[3] = null;
                            ret[2] = areaMap.get("2#" + city2.getParentCode());
                            ret[1] = areaMap.get("1#" + ret[2].getParentCode());
                            ret[0] = areaMap.get("0#" + ret[1].getParentCode());
                        }
                        else {
                            System.out.println(str + " 。。。2");
                        }
                    }
                    else {
                        ret[3] = null;
                        ret[2] = null;
                        ret[1] = county;
                        ret[0] = areaMap.get("0#" + ret[1].getParentCode());
                    }
                }
                else {
                    Area country = amgr.find("level=0 and (cname='" + name + "' or ename='" + name + "')"); // county
                    if (country!=null) {
                        //System.out.println(str + "國:" + country.getCName());
                        ret[3] = null;
                        ret[2] = null;
                        ret[1] = null;
                        ret[0] = country;
                    }
                    else {
                        System.out.println(str + "。。。3");
                    }
                }
            }
        }
        else {
            Area country = amgr.find("level=0 and (cname='" + name + "' or ename='" + name + "')"); // county
            if (country!=null) {
                //System.out.println(str + "國:" + country.getCName());
                ret[3] = null;
                ret[2] = null;
                ret[1] = null;
                ret[0] = country;
            }
            else {
                System.out.println(str + "。。。4");
            }
        }
    }
%>
<%          
    String data = request.getParameter("data");

    McaStudent s = new McaStudent();
    Class c = s.getClass();
    Method[] methods = c.getDeclaredMethods();

    Vector<Method> getMethods = new Vector<Method>();            
    out.println("<table border=1><tr>");
    for (int i=0; i<methods.length; i++) {
        if (methods[i].getName().indexOf("get")>=0) {
            getMethods.addElement(methods[i]);
            out.println("<th>" + methods[i].getName() + "</th>");
        }
    }
    System.out.println("</tr>");

    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {            
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        AreaMgr amgr = new AreaMgr(tran_id);
        Map<String, Area> areaMap = new SortingMap(amgr.retrieveList("", "")).doSortSingleton("getMyKey");

        String line = null;
        String[] lines = data.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            
            String coopId   = TextUtil.trim(tokens[0], "\"");
            String fullname  = TextUtil.trim(tokens[1], "\"");
            int comma = fullname.indexOf(",");
            String firstname = fullname;
            String lastname = "";
            if (comma>0) {
                lastname = TextUtil.trim(fullname.substring(0,comma).trim(), "\"").toLowerCase();
                firstname = TextUtil.trim(fullname.substring(comma+1).trim(), "\"").toLowerCase();
            }

            String chinesename = TextUtil.trim(tokens[2], "\"");
            String grade      = TextUtil.trim(tokens[3], "\"");
            String birthdate  = TextUtil.trim(tokens[4], "\"");
            
            String passportNo     = TextUtil.trim(tokens[5], "\"");
            String passportCountry     = TextUtil.trim(tokens[6], "\"");
            String parent     = TextUtil.trim(tokens[7], "\"");
            String hphone      = TextUtil.trim(tokens[8], "\"");
            String fathercell   = TextUtil.trim(tokens[9], "\"");
            String mothercell   = TextUtil.trim(tokens[10], "\"");
            String postcode1  = TextUtil.trim(tokens[11], "\"");
            String c_addr      = TextUtil.trim(tokens[12], "\"");
            String c_district  = TextUtil.trim(tokens[13], "\"");
            String c_city      = TextUtil.trim(tokens[14], "\"");

            boolean exist = false;
            McaStudent student = null;
            String q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "'";
            student = msmgr.find(q);

            if (student==null)
                student = new McaStudent();
            else
                exist = true;
            if (!exist) 
                System.out.println(fullname);

            student.setCoopID(coopId);
            student.setCampus("Chiayi");
            student.setStudentFirstName(firstname);
            student.setStudentSurname(lastname);
            student.setStudentChineseName(chinesename);
            student.setBirthDate(birthdate);           
            student.setPassportNumber(passportNo);

            Area[] info2s = new Area[4];
            findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
            student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

            //student.setSex(gender);
            student.setHomePhone(hphone);
            //student.setFatherFirstName(fatherfirst);
            //student.setFatherSurname(fathersure);
            //student.setFatherChineseName(fatherchinese);
            //student.setFatherPhone(####);
            student.setFatherCell(fathercell);
            //student.setFatherEmail(fatheremail);
            //student.setFatherSendEmail(####);
            //student.setMotherFirstName(motherfirst);
            //student.setMotherSurname(mothersure);
            //student.setMotherChineseName(motherchinese);
            //student.setMotherPhone(####);
            student.setMotherCell(mothercell);
            //student.setMotherEmail(motheremail);
            //student.setMotherSendEmail(####);

            Area[] infos = new Area[4];
            findAreaInfo(c_city, amgr, areaMap, infos, fullname, "home");
            student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
            student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
            student.setCityID((infos[2]!=null)?infos[2].getCode():null);
            student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);

            student.setChineseStreetAddress(c_addr);
            //student.setEnglishStreetAddress(addr1);
            student.setPostalCode(postcode1);
            // ######3 admisstion
            //student.setFreeHandAddress(c_addr);
            //student.setSensitiveAddress(####);
            //student.setApplyForYear(####);
            //student.setApplyForGrade(####);
            // ######3 extra
            //student.setParents(####);
            student.setGrade(grade);
            //student.setCategory(category);
            //student.setArcID(arcId);
            //student.setDorm(####);
            /*
            if (TDisc.length()>0) {
                if (TDisc.charAt(0)=='-')
                    TDisc = TDisc.substring(1);
                double tdisc = Double.parseDouble(TDisc);
                student.setTDisc(tdisc);
            }
            if (MDisc.length()>0) {
                if (MDisc.charAt(0)=='-')
                    MDisc = MDisc.substring(1);
                double mdisc = Double.parseDouble(MDisc);
                student.setMDisc(mdisc);
            }
            //student.setEmergency(####);
            //student.setBillTo(billTo);
            //student.setBillAttention(####);

            Area[] binfos = new Area[4];
            findAreaInfo(bill_city, amgr, areaMap, binfos, fullname, "bill");
            student.setBillCountryID((binfos[0]!=null)?binfos[0].getCode():null);
            student.setBillCountyID((binfos[1]!=null)?binfos[1].getCode():null);
            student.setBillCityID((binfos[2]!=null)?binfos[2].getCode():null);
            student.setBillDistrictID((binfos[3]!=null)?binfos[3].getCode():null);

            //student.setBillChineseStreetAddress(####);
            //student.setBillEnglishStreetAddress(####);
            //student.setBillPostalCode(####);
            */

            Map<String,Object> m = ImportStudent.printObj(student, getMethods);
            out.println("<tr bgcolor="+((exist)?"lightyellow":"white")+">");
            for (int j=0; j<getMethods.size(); j++) {
                Object o = m.get(getMethods.get(j).getName());
                out.println("<td>" + ((o==null)?"":o.toString()) + "</td>");
            }
            out.println("</tr>");        

            if (exist)
                msmgr.save(student);
            else
                msmgr.create(student);
        }
        out.println("</table>");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>