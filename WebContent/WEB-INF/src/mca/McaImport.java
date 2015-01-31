package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.io.*;
import java.text.*;
import phm.util.*;
import dbo.*;

public class McaImport
{
    int tran_id;
    McaStudentMgr msmgr = null;
    AreaMgr amgr = null;
    Map<String, Area> areaMap = null;
    Map<String, Bunit> bunitMap = null;

    public McaImport(int tran_id)
        throws Exception
    {
        this.tran_id = tran_id; 
        msmgr = new McaStudentMgr(tran_id);
        amgr = new AreaMgr(tran_id);
    }

    private String parseCoopId(String coopId)
    {
        if (coopId==null || coopId.trim().length()==0)
            return "";
        return Integer.parseInt(coopId)+"";
    }

    public ArrayList<McaStudent> importChanceryTaipeiTaichong(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        br.readLine(); // skip table fields header
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;
                String[] tokens = line.split("\t");

                String campus   = TextUtil.trim(tokens[0], "\"");
                String str_studentId      = TextUtil.trim(tokens[1], "\"");
                int studentId = 0;
                try { studentId = Integer.parseInt(str_studentId); } catch (Exception e) {}
                String firstname = TextUtil.trim(tokens[2], "\"").toLowerCase();
                String lastname  = TextUtil.trim(tokens[3], "\"").toLowerCase();
                String chinesename = TextUtil.trim(tokens[4], "\"");
                String grade      = TextUtil.trim(tokens[5], "\"");
                String birthdate  = TextUtil.trim(tokens[6], "\"");
                String gender     = TextUtil.trim(tokens[7], "\"");
                String addr1      = TextUtil.trim(tokens[8], "\"");
                String district1  = TextUtil.trim(tokens[9], "\"");
                String city1      = TextUtil.trim(tokens[10], "\"");
                String county1    = TextUtil.trim(tokens[11], "\"");
                String country1   = TextUtil.trim(tokens[12], "\"");
                String postcode1  = TextUtil.trim(tokens[13], "\"");
                String c_addr      = TextUtil.trim(tokens[14], "\"");
                String c_district  = TextUtil.trim(tokens[15], "\"");
                String c_city      = TextUtil.trim(tokens[16], "\"");
                String c_county    = TextUtil.trim(tokens[17], "\"");
                String hphone      = TextUtil.trim(tokens[18], "\"");
                String mothersure = TextUtil.trim(tokens[19], "\"");
                String motherfirst  = TextUtil.trim(tokens[20], "\"");
                String fathersure = (tokens.length>21)?TextUtil.trim(tokens[21], "\""):"";
                String fatherfirst  = (tokens.length>22)?TextUtil.trim(tokens[22], "\""):"";
                String mothercell   = (tokens.length>23)?TextUtil.trim(tokens[23], "\""):"";
                String fathercell   = (tokens.length>24)?TextUtil.trim(tokens[24], "\""):"";
                String motheremail  = (tokens.length>25)?TextUtil.trim(tokens[25], "\""):"";
                String fatheremail  = (tokens.length>26)?TextUtil.trim(tokens[26], "\""):"";
                String motherchinese = (tokens.length>27)?TextUtil.trim(tokens[27], "\""):"";
                String fatherchinese = (tokens.length>28)?TextUtil.trim(tokens[28], "\""):"";

                boolean exist = false;
                McaStudent student = null;
                if (studentId>0) {
                    student = msmgr.find("StudentID=" + studentId);
                }
                if (student==null)
                    student = new McaStudent();
                else
                    exist = true;
                if (!exist) 
                    System.out.println("###### " + firstname + " " + lastname);

                student.setCampus(campus);
                student.setStudentID(studentId);
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                student.setStudentChineseName(chinesename);
                student.setBirthDate(birthdate);           
                //student.setPassportNumber(####);
                //student.setPassportCountry(####);
                student.setSex(gender);
                student.setHomePhone(hphone);
                student.setFatherFirstName(fatherfirst);
                student.setFatherSurname(fathersure);
                student.setFatherChineseName(fatherchinese);
                //student.setFatherPhone(####);
                student.setFatherCell(fathercell);
                student.setFatherEmail(fatheremail);
                //student.setFatherSendEmail(####);
                student.setMotherFirstName(motherfirst);
                student.setMotherSurname(mothersure);
                student.setMotherChineseName(motherchinese);
                //student.setMotherPhone(####);
                student.setMotherCell(mothercell);
                student.setMotherEmail(motheremail);

                Area[] infos = new Area[4];
                String fullname = student.getStudentFirstName() + " " + student.getStudentSurname();

                findAreaInfo(c_city+c_district, amgr, areaMap, infos, fullname, "home");      
                //student.setMotherSendEmail(####);
                student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
                student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
                student.setCityID((infos[2]!=null)?infos[2].getCode():null);
                student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);

                student.setChineseStreetAddress(c_addr);
                student.setEnglishStreetAddress(addr1);
                student.setPostalCode(postcode1);

                // ######3 admisstion
                //student.setFreeHandAddress(c_addr);
                //student.setSensitiveAddress(####);
                //student.setApplyForYear(####);
                //student.setApplyForGrade(####);
                // ######3 extra
                //student.setParents(####);
                student.setGrade(grade);
                //student.setCategory(####);
                //student.setArcID(####);
                //student.setDorm(####);
                //student.setTDisc(####);
                //student.setMDisc(####);
                //student.setEmergency(####);
                //student.setBillTo(####);
                //student.setBillAttention(####);
                //student.setBillCountryID(####);
                //student.setBillCountyID(####);
                //student.setBillCityID(####);
                //student.setBillDistrictID(####);
                //student.setBillChineseStreetAddress(####);
                //student.setBillEnglishStreetAddress(####);
                //student.setBillPostalCode(####);

                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }

    public int getIdentity(String id)
    {
        id = id.toLowerCase();
        if (id.equalsIgnoreCase("m0") || id.equalsIgnoreCase("mo"))
            return McaStudent.IDENTITY_M0;
        else if (id.equalsIgnoreCase("m1"))
            return McaStudent.IDENTITY_M1;
        else if (id.equalsIgnoreCase("m2"))
            return McaStudent.IDENTITY_M2;
        else if (id.equalsIgnoreCase("cw"))
            return McaStudent.IDENTITY_CW;
        // for access_tpe parsing below
        else if (id.indexOf("cw")>=0 || id.indexOf("CW")>=0)
            return McaStudent.IDENTITY_CW;
        else if (id.indexOf("m1")>=0 || id.indexOf("M1")>=0)
            return McaStudent.IDENTITY_M1;
        else if (id.indexOf("m2")>=0 || id.indexOf("M2")>=0)
            return McaStudent.IDENTITY_M2;
        return McaStudent.IDENTITY_BK;
    }

    public ArrayList<McaStudent> importAccessTaichong(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;
                String[] tokens = line.split("\t");

                String chanceryId   = TextUtil.trim(tokens[1], "\"");
                String coopId   = TextUtil.trim(tokens[3], "\"");
                String firstname = TextUtil.trim(tokens[6], "\"").toLowerCase();
                String lastname  = TextUtil.trim(tokens[5], "\"").toLowerCase();
                String fullname = TextUtil.trim(tokens[4], "\"");
                String grade      = TextUtil.trim(tokens[7], "\"");
                String birthdate  = TextUtil.trim(tokens[8], "\"");
                String gender     = TextUtil.trim(tokens[9], "\"");
                String passportNo  = TextUtil.trim(tokens[10], "\"");
                String arcId       = TextUtil.trim(tokens[11], "\"");
                String passportCountry = TextUtil.trim(tokens[12], "\"");
                String category   = TextUtil.trim(tokens[14], "\"");
                String dorm       = TextUtil.trim(tokens[17], "\"");
                String parents    = TextUtil.trim(tokens[18], "\"");
                String hphone      = TextUtil.trim(tokens[19], "\"");
                String fax         = TextUtil.trim(tokens[21], "\"");
                String identity      = TextUtil.trim(tokens[22], "\"");
                String fathercell   = TextUtil.trim(tokens[24], "\"");
                String mothercell   = TextUtil.trim(tokens[25], "\"");
                String addr1      = TextUtil.trim(tokens[26], "\"");  // Homest	Homecity	Homecity-zip 
                String city1      = TextUtil.trim(tokens[27], "\"");  // #12 Sinsing Rd, Dali City,	Taichung County, Dali City	41283
                String postcode1  = TextUtil.trim(tokens[28], "\"");
                String c_addr      = TextUtil.trim(tokens[29], "\"");
                String c_city      = TextUtil.trim(tokens[30], "\"");
                String billTo      = TextUtil.trim(tokens[31], "\"");
                String bill_st      = TextUtil.trim(tokens[32], "\"");
                String bill_city     = TextUtil.trim(tokens[33], "\"");
                String bill_postcode      = TextUtil.trim(tokens[34], "\"");
                String TDisc       = TextUtil.trim(tokens[36], "\"");
                String MDisc       = TextUtil.trim(tokens[37], "\"");

                String reg         = TextUtil.trim(tokens[39], "\"");
                String building    = TextUtil.trim(tokens[40], "\"");
                String ell         = TextUtil.trim(tokens[42], "\"");
                String milk        = TextUtil.trim(tokens[44], "\"");
                String milk_cat    = TextUtil.trim(tokens[45], "\"");
                String music       = TextUtil.trim(tokens[46], "\"");
                String instr       = TextUtil.trim(tokens[47], "\"");
                String rentroom    = TextUtil.trim(tokens[48], "\"");
                String dormroom    = TextUtil.trim(tokens[51], "\"");
                String dormfood    = TextUtil.trim(tokens[52], "\"");
                String kitchen     = TextUtil.trim(tokens[53], "\"");
                String lunch       = TextUtil.trim(tokens[54], "\"");
                String email       = TextUtil.trim(tokens[79], "\"");


                boolean exist = false;
                McaStudent student = null;
                String q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "' and grade='" + grade + "'";
                if (chanceryId!=null && chanceryId.trim().length()>0)
                    q = "StudentID=" + chanceryId;
                //else if (passportNo.trim().length()>0)  // chancery bethany 沒有 passportnumber
                //    q = "PassportNumber='" + passportNo + "'";
                student = msmgr.find(q);

                if (student==null) {
                    student = new McaStudent();
                }
                else {
                    exist = true;
                }
                if (!exist) 
                    System.out.println("###### " + firstname + " " + lastname);
                
                //student.setStudentID(studentId);
                if (chanceryId!=null && chanceryId.trim().length()>0)
                    student.setStudentID(Integer.parseInt(chanceryId));
                student.setCampus("Taichung");
                student.setCoopID(parseCoopId(coopId)+"");
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                // student.setStudentChineseName(chinesename);
                student.setBirthDate(birthdate);           
                student.setPassportNumber(passportNo);

                Area[] info2s = new Area[4];
                findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
                student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

                student.setSex(gender);
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
                student.setEnglishStreetAddress(addr1);
                student.setPostalCode(postcode1);

                // ######3 admisstion
                //student.setFreeHandAddress(c_addr);
                //student.setSensitiveAddress(####);
                //student.setApplyForYear(####);
                //student.setApplyForGrade(####);

                // ######3 extra
                student.setParents(parents);
                student.setGrade(grade);
                if (category.length()>50) {
                    System.out.println("## category too long: " + fullname);
                    category = category.substring(0,50);
                }
                student.setCategory(category);
                if (arcId.length()>20) {
                    System.out.println("## arcId too long: " + fullname);
                    arcId = arcId.substring(0,20);
                }
                student.setIdentity(getIdentity(identity));
                student.setArcID(arcId);
                student.setDorm(dorm);
        
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

                student.setBillTo(billTo);
                //student.setBillAttention(####);
                
                Area[] binfos = new Area[4];
                findAreaInfo(bill_city, amgr, areaMap, binfos, fullname, "bill");
                student.setBillCountryID((binfos[0]!=null)?binfos[0].getCode():null);
                student.setBillCountyID((binfos[1]!=null)?binfos[1].getCode():null);
                student.setBillCityID((binfos[2]!=null)?binfos[2].getCode():null);
                student.setBillDistrictID((binfos[3]!=null)?binfos[3].getCode():null);

                student.setBillChineseStreetAddress(bill_st);
                //student.setBillEnglishStreetAddress(####);
                student.setBillPostalCode(bill_postcode);

                // ####### extra stuff                
                student.setTmpEll(ell);
                student.setTmpMilktype(milk_cat);
                student.setTmpMusic(music);
                student.setTmpInstr(instr);
                student.setTmpMusicRoom(rentroom);
                student.setTmpDorm(dormroom);
                student.setTmpDormFood(dormfood);
                student.setTmpKitchen(kitchen);
                student.setTmpLunch(lunch);


                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }

    public ArrayList<McaStudent> importAccessTaipei(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;

                String[] tokens = line.split("\t");
                String coopId   = TextUtil.trim(tokens[1], "\"");
                int studentId=0;
                try { studentId = Integer.parseInt(tokens[2]); } catch (Exception e) {}
                String firstname = TextUtil.trim(tokens[5], "\"").toLowerCase();
                String lastname  = TextUtil.trim(tokens[4], "\"").toLowerCase();
                String fullname = TextUtil.trim(tokens[3], "\"");
                String chinesename = TextUtil.trim(tokens[6], "\"");
                String grade      = TextUtil.trim(tokens[7], "\"");
                String birthdate  = TextUtil.trim(tokens[8], "\"");
                if (birthdate.indexOf(" ")>0)
                    birthdate = birthdate.substring(0, birthdate.indexOf(" ")+1);
                String gender     = TextUtil.trim(tokens[10], "\"");
                String passportNo  = TextUtil.trim(tokens[12], "\"");
                String arcId       = TextUtil.trim(tokens[13], "\"");
                String passportCountry = TextUtil.trim(tokens[14], "\"");
                String category   = TextUtil.trim(tokens[16], "\"");
                String parents    = TextUtil.trim(tokens[17], "\"");
                String fatherchinese    = TextUtil.trim(tokens[18], "\"");
                String motherchinese    = TextUtil.trim(tokens[19], "\"");
                String hphone      = TextUtil.trim(tokens[20], "\"");
                String fax         = TextUtil.trim(tokens[21], "\"");
                String ophone      = TextUtil.trim(tokens[22], "\"");
                String fathercell   = TextUtil.trim(tokens[23], "\"");
                String mothercell   = TextUtil.trim(tokens[24], "\"");
                String emergency1   = TextUtil.trim(tokens[25], "\"");
                String emergency2   = TextUtil.trim(tokens[26], "\"");
                String addr1      = TextUtil.trim(tokens[27], "\"");  // Homest	Homecity	Homecity-zip 
                String city1      = TextUtil.trim(tokens[28], "\"");  // #12 Sinsing Rd, Dali City,	Taichung County, Dali City	41283
                String postcode1  = TextUtil.trim(tokens[29], "\"");
                String c_addr      = TextUtil.trim(tokens[30], "\"");
                String c_city      = TextUtil.trim(tokens[31], "\"");
                String billTo      = TextUtil.trim(tokens[32], "\"");
                String bill_st_eng  = TextUtil.trim(tokens[33], "\"");
                String bill_city_eng  = TextUtil.trim(tokens[34], "\"");
                String bill_st      = TextUtil.trim(tokens[35], "\"");
                String bill_city     = TextUtil.trim(tokens[36], "\"");
                String bill_postcode      = TextUtil.trim(tokens[37], "\"");
                String bill_attention      = TextUtil.trim(tokens[38], "\"");
                String TDisc       = TextUtil.trim(tokens[39], "\"");
                String MDisc       = TextUtil.trim(tokens[40], "\"");
                String reg         = TextUtil.trim(tokens[41], "\"");
                String ell         = TextUtil.trim(tokens[44], "\"");
                String milk        = TextUtil.trim(tokens[46], "\"");
                String milk_cat    = TextUtil.trim(tokens[47], "\"");
                String music       = TextUtil.trim(tokens[48], "\"");
                String instr       = TextUtil.trim(tokens[49], "\"");
                String fatheremail       = TextUtil.trim(tokens[66], "\"");
                String motheremail       = TextUtil.trim(tokens[69], "\"");

                /*
                String dorm       = TextUtil.trim(tokens[17], "\"");
                String building    = TextUtil.trim(tokens[40], "\"");
                String rentroom    = TextUtil.trim(tokens[48], "\"");
                String dormroom    = TextUtil.trim(tokens[51], "\"");
                String dormfood    = TextUtil.trim(tokens[53], "\"");
                String kitchen     = TextUtil.trim(tokens[54], "\"");
                String lunch       = TextUtil.trim(tokens[55], "\"");
                */


                boolean exist = false;
                McaStudent student = null;
                String q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "' and grade='" + grade + "'";
                if (studentId>0)
                    q = "StudentID=" + studentId;
                //else if (passportNo.trim().length()>0)  // ##### chancery tch-tpe 沒有 passportNumber
                //    q = "PassportNumber='" + passportNo + "'";
                student = msmgr.find(q);

                if (student==null) {
                    student = new McaStudent();
                }
                else {
                    exist = true;
                }
                if (!exist) 
                    System.out.println("###### " + firstname + " " + lastname);

                if (studentId>0)
                    student.setStudentID(studentId);
                student.setCampus("Bethany");
                student.setCoopID(parseCoopId(coopId)+"");
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                student.setStudentChineseName(chinesename);
                student.setBirthDate(birthdate);           
                student.setPassportNumber(passportNo);
                student.setIdentity(getIdentity(category));

                Area[] info2s = new Area[4];
                findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
                student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

                student.setSex(gender);
                student.setHomePhone(hphone);
                //student.setFatherFirstName(fatherfirst);
                //student.setFatherSurname(fathersure);
                student.setFatherChineseName(fatherchinese);
                //student.setFatherPhone(####);
                student.setFatherCell(fathercell);
                if (fatheremail.trim().length()>0)
                    student.setFatherEmail(fatheremail.trim());
                //student.setMotherFirstName(motherfirst);
                //student.setMotherSurname(mothersure);
                student.setMotherChineseName(motherchinese);
                //student.setMotherPhone(####);
                student.setMotherCell(mothercell);
                if (motheremail.trim().length()>0)
                    student.setMotherEmail(motheremail.trim());
                //student.setMotherSendEmail(####);

                Area[] infos = new Area[4];
                findAreaInfo(c_city, amgr, areaMap, infos, fullname, "home");
                student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
                student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
                student.setCityID((infos[2]!=null)?infos[2].getCode():null);
                student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);
                
                student.setChineseStreetAddress(c_addr);
                student.setEnglishStreetAddress(addr1);
                student.setPostalCode(postcode1);

                // ######3 admisstion
                //student.setFreeHandAddress(c_addr);
                //student.setSensitiveAddress(####);
                //student.setApplyForYear(####);
                //student.setApplyForGrade(####);

                // ######3 extra
                student.setParents(parents);
                student.setGrade(grade);
                if (category.length()>50) {
                    System.out.println("## category too long: " + fullname);
                    category = category.substring(0,50);
                }
                student.setCategory(category);
                if (arcId.length()>20) {
                    System.out.println("## arcId too long: " + fullname);
                    arcId = arcId.substring(0,20);
                }
                student.setArcID(arcId);
                //student.setDorm(dorm);
        
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

                student.setBillTo(billTo);
                student.setBillAttention(bill_attention);
                
                Area[] binfos = new Area[4];
                findAreaInfo(bill_city, amgr, areaMap, binfos, fullname, "bill");
                student.setBillCountryID((binfos[0]!=null)?binfos[0].getCode():null);
                student.setBillCountyID((binfos[1]!=null)?binfos[1].getCode():null);
                student.setBillCityID((binfos[2]!=null)?binfos[2].getCode():null);
                student.setBillDistrictID((binfos[3]!=null)?binfos[3].getCode():null);

                student.setBillChineseStreetAddress(bill_st);
                //student.setBillEnglishStreetAddress(####);
                student.setBillPostalCode(bill_postcode);
                student.setFax(fax);
                student.setOfficePhone(ophone);
                String emergency = emergency1 + ((emergency2.length()>0)?"\n":"") + emergency2;
                student.setEmergency(emergency);

                // ######### extra stuff
                student.setTmpEll(ell);
                student.setTmpMilktype(milk_cat);
                student.setTmpMusic(music);
                student.setTmpInstr(instr);

                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }

    public ArrayList<McaStudent> importChanceryKaohsiung(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        br.readLine(); // skip table fields header
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;

                String[] tokens = line.split("\t");
                String coopId   = TextUtil.trim(tokens[0], "\"");
                String str_studentId      = TextUtil.trim(tokens[1], "\"");
                int studentId = 0;
                try { studentId = Integer.parseInt(str_studentId); } catch (Exception e) {}
                String fullname  = TextUtil.trim(tokens[2], "\"");
                String firstname = TextUtil.trim(tokens[4], "\"").toLowerCase();
                String lastname  = TextUtil.trim(tokens[3], "\"").toLowerCase();
                String chinesename = TextUtil.trim(tokens[5], "\"");
                String grade      = TextUtil.trim(tokens[6], "\"");
                String birthdate  = TextUtil.trim(tokens[7], "\"");
                String gender     = TextUtil.trim(tokens[8], "\"");
                String passportNo     = TextUtil.trim(tokens[10], "\"");
                String arcId     = TextUtil.trim(tokens[11], "\"");
                String passportCountry     = TextUtil.trim(tokens[12], "\"");
                String category     = TextUtil.trim(tokens[14], "\"");
                String parent     = TextUtil.trim(tokens[15], "\"");
                String fatherfirst     = TextUtil.trim(tokens[16], "\"");
                String motherfirst     = TextUtil.trim(tokens[17], "\"");
                String hphone      = TextUtil.trim(tokens[18], "\"");
                String fax      = TextUtil.trim(tokens[19], "\"");
                String ophone      = TextUtil.trim(tokens[20], "\"");
                String fathercell   = TextUtil.trim(tokens[21], "\"");
                String mothercell   = TextUtil.trim(tokens[22], "\"");
                String addr1      = TextUtil.trim(tokens[23], "\"");
                String district_eng      = TextUtil.trim(tokens[24], "\"");
                String city_eng      = TextUtil.trim(tokens[25], "\"");
                String postcode1  = TextUtil.trim(tokens[26], "\"");
                String c_addr      = TextUtil.trim(tokens[27], "\"");
                String c_district  = TextUtil.trim(tokens[28], "\"");
                String c_city      = TextUtil.trim(tokens[29], "\"");
                String billTo      = (tokens.length>30)?TextUtil.trim(tokens[30], "\""):"";
                String bill_st      = (tokens.length>31)?TextUtil.trim(tokens[31], "\""):"";
                String bill_city     = (tokens.length>32)?TextUtil.trim(tokens[32], "\""):"";
                String bill_postcode      = (tokens.length>33)?TextUtil.trim(tokens[33], "\""):"";
                String fatheremail  = (tokens.length>35)?TextUtil.trim(tokens[35], "\""):"";
                String motheremail  = (tokens.length>36)?TextUtil.trim(tokens[36], "\""):"";
                String extraemail = (tokens.length>39)?TextUtil.trim(tokens[39], "\""):"";

                boolean exist = false;
                McaStudent student = null;
                String q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "' and grade='" + grade + "'";
                if (studentId>0)
                    q = "StudentID=" + studentId;
                else if (passportNo.trim().length()>0)
                    q = "PassportNumber='" + passportNo + "'";
                student = msmgr.find(q);

                if (student==null)
                    student = new McaStudent();
                else
                    exist = true;
                if (!exist) 
                    System.out.println("###### " + firstname + " " + lastname);

                student.setCoopID(parseCoopId(coopId)+"");
                student.setCampus("Kaohsiung");
                student.setStudentID(studentId);
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                student.setStudentChineseName(chinesename);
                student.setBirthDate(birthdate);           
                student.setPassportNumber(passportNo);

                Area[] info2s = new Area[4];
                findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
                student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

                student.setSex(gender);
                student.setHomePhone(hphone);
                student.setFatherFirstName(fatherfirst);
                //student.setFatherSurname(fathersure);
                //student.setFatherChineseName(fatherchinese);
                //student.setFatherPhone(####);
                student.setFatherCell(fathercell);
                student.setFatherEmail(fatheremail);
                //student.setFatherSendEmail(####);
                student.setMotherFirstName(motherfirst);
                //student.setMotherSurname(mothersure);
                //student.setMotherChineseName(motherchinese);
                //student.setMotherPhone(####);
                student.setMotherCell(mothercell);
                student.setMotherEmail(motheremail);
                //student.setMotherSendEmail(####);

                Area[] infos = new Area[4];
                findAreaInfo(c_city, amgr, areaMap, infos, fullname, "home");
                student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
                student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
                student.setCityID((infos[2]!=null)?infos[2].getCode():null);
                student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);

                student.setChineseStreetAddress(c_addr);
                student.setEnglishStreetAddress(addr1);
                student.setPostalCode(postcode1);
                // ######3 admisstion
                //student.setFreeHandAddress(c_addr);
                //student.setSensitiveAddress(####);
                //student.setApplyForYear(####);
                //student.setApplyForGrade(####);
                // ######3 extra
                //student.setParents(####);
                student.setGrade(grade);
                student.setCategory(category);
                student.setArcID(arcId);
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
                */
                //student.setEmergency(####);
                student.setBillTo(billTo);
                //student.setBillAttention(####);

                Area[] binfos = new Area[4];
                findAreaInfo(bill_city, amgr, areaMap, binfos, fullname, "bill");
                student.setBillCountryID((binfos[0]!=null)?binfos[0].getCode():null);
                student.setBillCountyID((binfos[1]!=null)?binfos[1].getCode():null);
                student.setBillCityID((binfos[2]!=null)?binfos[2].getCode():null);
                student.setBillDistrictID((binfos[3]!=null)?binfos[3].getCode():null);

                //student.setBillChineseStreetAddress(####);
                //student.setBillEnglishStreetAddress(####);
                student.setBillPostalCode(bill_postcode);

                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }


    public ArrayList<McaStudent> importAccessKaohsiung(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;

                String[] tokens = line.split("\t");
                String coopId   = TextUtil.trim(tokens[1], "\"");
                String fullname = TextUtil.trim(tokens[2], "\"");
                String lastname  = TextUtil.trim(tokens[3], "\"").toLowerCase();
                String firstname = TextUtil.trim(tokens[4], "\"").toLowerCase();
                String grade      = TextUtil.trim(tokens[5], "\"");
                String parents    = TextUtil.trim(tokens[6], "\"");
                String TDisc       = TextUtil.trim(tokens[7], "\"");
                String MDisc       = TextUtil.trim(tokens[8], "\"");
                String reg       = TextUtil.trim(tokens[9], "\"");
                String ell       = TextUtil.trim(tokens[12], "\"");
                String milk       = TextUtil.trim(tokens[14], "\"");
                String milk_cat       = TextUtil.trim(tokens[15], "\"");
                String music       = TextUtil.trim(tokens[16], "\"");
                String instr       = TextUtil.trim(tokens[17], "\"");
                String bus       = TextUtil.trim(tokens[19], "\"");
                String lunch       = TextUtil.trim(tokens[20], "\"");


                boolean exist = false;
                McaStudent student = null;
                
                String q = null;
                if (coopId.trim().length()>0) {
                    q = "CoopID=" + parseCoopId(coopId);
                    student = msmgr.find(q);
                }
                if (student==null) {
                    q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "' and campus='Kaohsiung'";
                    student = msmgr.find(q);
                }

                if (student==null) {
                    student = new McaStudent();
                }
                else {
                    exist = true;
                }
                if (!exist) {
                    System.out.println("###### " + firstname + " " + lastname);// + ":" + q);
                }

                student.setCoopID(parseCoopId(coopId)+"");
                student.setCampus("Kaohsiung");
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                //student.setStudentChineseName(chinesename);
                //student.setBirthDate(birthdate);           
                //student.setPassportNumber(passportNo);
                
                /*
                Area[] info2s = new Area[4];
                findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
                student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

                student.setSex(gender);
                student.setHomePhone(hphone);
                //student.setFatherFirstName(fatherfirst);
                //student.setFatherSurname(fathersure);
                student.setFatherChineseName(fatherchinese);
                //student.setFatherPhone(####);
                student.setFatherCell(fathercell);
                if (fatheremail.trim().length()>0)
                    student.setFatherEmail(fatheremail.trim());
                //student.setMotherFirstName(motherfirst);
                //student.setMotherSurname(mothersure);
                student.setMotherChineseName(motherchinese);
                //student.setMotherPhone(####);
                student.setMotherCell(mothercell);
                if (motheremail.trim().length()>0)
                    student.setMotherEmail(motheremail.trim());
                //student.setMotherSendEmail(####);

                Area[] infos = new Area[4];
                findAreaInfo(c_city, amgr, areaMap, infos, fullname, "home");
                student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
                student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
                student.setCityID((infos[2]!=null)?infos[2].getCode():null);
                student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);
                
                student.setChineseStreetAddress(c_addr);
                student.setEnglishStreetAddress(addr1);
                student.setPostalCode(postcode1);

                // ######3 admisstion
                //student.setFreeHandAddress(c_addr);
                //student.setSensitiveAddress(####);
                //student.setApplyForYear(####);
                //student.setApplyForGrade(####);
                */
                // ######3 extra
                student.setParents(parents);
                student.setGrade(grade);
                /*
                if (category.length()>50) {
                    System.out.println("## category too long: " + fullname);
                    category = category.substring(0,50);
                }
                student.setCategory(category);
                if (arcId.length()>20) {
                    System.out.println("## arcId too long: " + fullname);
                    arcId = arcId.substring(0,20);
                }
                student.setArcID(arcId);
                //student.setDorm(dorm);
                */
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
                /*
                student.setBillTo(billTo);
                student.setBillAttention(bill_attention);
                
                Area[] binfos = new Area[4];
                findAreaInfo(bill_city, amgr, areaMap, binfos, fullname, "bill");
                student.setBillCountryID((binfos[0]!=null)?binfos[0].getCode():null);
                student.setBillCountyID((binfos[1]!=null)?binfos[1].getCode():null);
                student.setBillCityID((binfos[2]!=null)?binfos[2].getCode():null);
                student.setBillDistrictID((binfos[3]!=null)?binfos[3].getCode():null);

                student.setBillChineseStreetAddress(bill_st);
                //student.setBillEnglishStreetAddress(####);
                student.setBillPostalCode(bill_postcode);
                student.setFax(fax);
                student.setOfficePhone(ophone);
                String emergency = emergency1 + ((emergency2.length()>0)?"\n":"") + emergency2;
                student.setEmergency(emergency);
                */

                student.setTmpEll(ell);
                student.setTmpMilktype(milk_cat);
                student.setTmpMusic(music);
                student.setTmpInstr(instr);
                student.setTmpBus(bus);
                student.setTmpLunch(lunch);

                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }




    public ArrayList<McaStudent> importChanceryChiayi(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        br.readLine(); // skip table fields header
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;

                String[] tokens = line.split("\t");

                String str_studentId      = TextUtil.trim(tokens[0], "\"");
                int studentId = 0;
                try { studentId = Integer.parseInt(str_studentId); } catch (Exception e) {}

                String lastname = TextUtil.trim(tokens[1], "\"").toLowerCase();
                String firstname = TextUtil.trim(tokens[2], "\"").toLowerCase();
                String chinesename = TextUtil.trim(tokens[3], "\"");
                String grade      = TextUtil.trim(tokens[4], "\"");
                String birthdate  = TextUtil.trim(tokens[5], "\"");
                String c_gender   = TextUtil.trim(tokens[6], "\"");

                String fullname = TextUtil.trim(tokens[1], "\"")  + "," + TextUtil.trim(tokens[2], "\""); 

                String passportNo     = TextUtil.trim(tokens[7], "\"");
                String passportCountry     = TextUtil.trim(tokens[8], "\"");
                String parent     = TextUtil.trim(tokens[9], "\"");
                String hphone      = TextUtil.trim(tokens[10], "\"");
                String addr_eng      = TextUtil.trim(tokens[11], "\"");
                String district_eng      = TextUtil.trim(tokens[12], "\"");
                String city_eng      = TextUtil.trim(tokens[13], "\"");
                String postcode1  = TextUtil.trim(tokens[14], "\"");
                String c_addr      = TextUtil.trim(tokens[15], "\"");
                String c_district  = TextUtil.trim(tokens[16], "\"");
                String c_city      = TextUtil.trim(tokens[17], "\"");

                boolean exist = false;
                McaStudent student = null;
                String q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "' and campus='Chiayi'";
                if (studentId>0)
                    q = "StudentID=" + studentId;
                else if (passportNo.trim().length()>0)
                    q = "PassportNumber='" + passportNo + "'";
                student = msmgr.find(q);

                if (student==null)
                    student = new McaStudent();
                else
                    exist = true;
                if (!exist) 
                    System.out.println("###### " + firstname + " " + lastname);

                student.setCampus("Chiayi");
                student.setStudentID(studentId);
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                student.setStudentChineseName(chinesename);
                student.setBirthDate(birthdate);           
                student.setPassportNumber(passportNo);

                Area[] info2s = new Area[4];
                findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
                student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

                student.setSex((c_gender.equals("男"))?"M":(c_gender.equals("女"))?"F":"");
                student.setHomePhone(hphone);
                //student.setFatherFirstName(fatherfirst);
                //student.setFatherSurname(fathersure);
                //student.setFatherChineseName(fatherchinese);
                //student.setFatherPhone(####);
                //student.setFatherCell(fathercell);
                //student.setFatherEmail(fatheremail);
                //student.setFatherSendEmail(####);
                //student.setMotherFirstName(motherfirst);
                //student.setMotherSurname(mothersure);
                //student.setMotherChineseName(motherchinese);
                //student.setMotherPhone(####);
                //student.setMotherCell(mothercell);
                //student.setMotherEmail(motheremail);
                //student.setMotherSendEmail(####);

                Area[] infos = new Area[4];
                findAreaInfo(c_city, amgr, areaMap, infos, fullname, "home");
                student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
                student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
                student.setCityID((infos[2]!=null)?infos[2].getCode():null);
                student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);

                student.setChineseStreetAddress(c_addr);
                student.setEnglishStreetAddress(addr_eng);
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

                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }



    public ArrayList<McaStudent> importAccessChiayi(String path)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;

                String[] tokens = line.split("\t");
                String coopId   = TextUtil.trim(tokens[1], "\"");
                String fullname = TextUtil.trim(tokens[2], "\"");
                String lastname  = TextUtil.trim(tokens[3], "\"").toLowerCase();
                String firstname = TextUtil.trim(tokens[4], "\"").toLowerCase();
                String grade      = TextUtil.trim(tokens[5], "\"");
                String parents    = TextUtil.trim(tokens[6], "\"");
                String TDisc       = TextUtil.trim(tokens[7], "\"");
                String MDisc       = TextUtil.trim(tokens[8], "\"");
                String reg       = TextUtil.trim(tokens[9], "\"");
                String ell       = TextUtil.trim(tokens[12], "\"");
                String milk       = TextUtil.trim(tokens[14], "\"");
                String milk_cat       = TextUtil.trim(tokens[15], "\"");
                String music       = TextUtil.trim(tokens[16], "\"");
                String instr       = TextUtil.trim(tokens[17], "\"");
                String bus       = TextUtil.trim(tokens[19], "\"");
                String lunch       = TextUtil.trim(tokens[20], "\"");


                boolean exist = false;
                McaStudent student = null;
                String q = "StudentFirstName='" + firstname + "' and StudentSurName='" + lastname + "' and campus='Chiayi'";
                student = msmgr.find(q);

                if (student==null) {
                    student = new McaStudent();
                }
                else {
                    exist = true;
                }
                if (!exist) {
                    System.out.println("###### " + firstname + " " + lastname);
                }

                student.setCoopID(parseCoopId(coopId)+"");
                student.setCampus("Chiayi");
                student.setStudentFirstName(firstname);
                student.setStudentSurname(lastname);
                //student.setStudentChineseName(chinesename);
                //student.setBirthDate(birthdate);           
                //student.setPassportNumber(passportNo);
                
                /*
                Area[] info2s = new Area[4];
                findAreaInfo(passportCountry, amgr, areaMap, info2s, fullname, "passport");            
                student.setPassportCountry((info2s[0]!=null)?info2s[0].getCode():null);

                student.setSex(gender);
                student.setHomePhone(hphone);
                //student.setFatherFirstName(fatherfirst);
                //student.setFatherSurname(fathersure);
                student.setFatherChineseName(fatherchinese);
                //student.setFatherPhone(####);
                student.setFatherCell(fathercell);
                if (fatheremail.trim().length()>0)
                    student.setFatherEmail(fatheremail.trim());
                //student.setMotherFirstName(motherfirst);
                //student.setMotherSurname(mothersure);
                student.setMotherChineseName(motherchinese);
                //student.setMotherPhone(####);
                student.setMotherCell(mothercell);
                if (motheremail.trim().length()>0)
                    student.setMotherEmail(motheremail.trim());
                //student.setMotherSendEmail(####);

                Area[] infos = new Area[4];
                findAreaInfo(c_city, amgr, areaMap, infos, fullname, "home");
                student.setCountryID((infos[0]!=null)?infos[0].getCode():null);
                student.setCountyID((infos[1]!=null)?infos[1].getCode():null);
                student.setCityID((infos[2]!=null)?infos[2].getCode():null);
                student.setDistrictID((infos[3]!=null)?infos[3].getCode():null);
                
                student.setChineseStreetAddress(c_addr);
                student.setEnglishStreetAddress(addr1);
                student.setPostalCode(postcode1);

                // ######3 admisstion
                //student.setFreeHandAddress(c_addr);
                //student.setSensitiveAddress(####);
                //student.setApplyForYear(####);
                //student.setApplyForGrade(####);
                */
                // ######3 extra
                student.setParents(parents);
                student.setGrade(grade);
                /*
                if (category.length()>50) {
                    System.out.println("## category too long: " + fullname);
                    category = category.substring(0,50);
                }
                student.setCategory(category);
                if (arcId.length()>20) {
                    System.out.println("## arcId too long: " + fullname);
                    arcId = arcId.substring(0,20);
                }
                student.setArcID(arcId);
                //student.setDorm(dorm);
                */
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
                /*
                student.setBillTo(billTo);
                student.setBillAttention(bill_attention);
                
                Area[] binfos = new Area[4];
                findAreaInfo(bill_city, amgr, areaMap, binfos, fullname, "bill");
                student.setBillCountryID((binfos[0]!=null)?binfos[0].getCode():null);
                student.setBillCountyID((binfos[1]!=null)?binfos[1].getCode():null);
                student.setBillCityID((binfos[2]!=null)?binfos[2].getCode():null);
                student.setBillDistrictID((binfos[3]!=null)?binfos[3].getCode():null);

                student.setBillChineseStreetAddress(bill_st);
                //student.setBillEnglishStreetAddress(####);
                student.setBillPostalCode(bill_postcode);
                student.setFax(fax);
                student.setOfficePhone(ophone);
                String emergency = emergency1 + ((emergency2.length()>0)?"\n":"") + emergency2;
                student.setEmergency(emergency);
                */

                if (exist)
                    msmgr.save(student);
                else
                    msmgr.create(student);
                students.add(student);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
        return students;
    }



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
                    if (token2.length()>3)
                        token2 = token2.substring(0,3);
                    Area district = amgr.find("level=3 and cname='" + token2 + "' and parentCode=" + city.getCode()); // district
                    if (district!=null) {
                        //System.out.println(str + "區:" + district.getCName());
                        ret[3] = district;
                        ret[2] = areaMap.get("2#" + district.getParentCode());
                        ret[1] = areaMap.get("1#" + ret[2].getParentCode());
                        ret[0] = areaMap.get("0#" + ret[1].getParentCode());
                    }
                    else {
                        ret[3] = null;
                        ret[2] = city;
                        ret[1] = areaMap.get("1#" + ret[2].getParentCode());
                        ret[0] = areaMap.get("0#" + ret[1].getParentCode());
                    }
                }
                else {
                    ret[3] = null;
                    ret[2] = city;
                    ret[1] = areaMap.get("1#" + ret[2].getParentCode());
                    ret[0] = areaMap.get("0#" + ret[1].getParentCode());
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
                            ret[2] = city2;
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

if (fullname.indexOf("martin")>=0) {
    System.out.print("*** " + fullname + "(" + type + ") ");
    if (ret[0]!=null) System.out.print(" country=" + ret[0].getCName());
    if (ret[1]!=null) System.out.print(" county=" + ret[1].getCName());
    if (ret[2]!=null) System.out.print(" city=" + ret[2].getCName());
    if (ret[3]!=null) System.out.print(" district=" + ret[3].getCName());
    System.out.println("");
}

    }

    public void importArea(String path, int level)
        throws Exception
    {
        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "UTF-8"));
        String line = null;
        ArrayList<McaStudent> students = new ArrayList<McaStudent>();
        while ((line=br.readLine())!=null) {
            try {
                if (line.trim().length()==0)
                    continue;

                String[] tokens = line.split("\t");
                String code = tokens[0];
                String cname = tokens[1];
                String ename = tokens[2];
                String parentCode = (level>0)?tokens[3]:"";

                Area a = amgr.find("code='" + code + "' and level=" + level);
                boolean exist = false;
                if (a==null) {
                    a = new Area();
                }
                else
                    exist = true;

                a.setCode(code);
                a.setCName(cname);
                a.setEName(ename);
                a.setParentCode(parentCode);
                a.setLevel(level);
                if (!exist)
                    amgr.create(a);
                else
                    amgr.save(a);
            }
            catch (Exception e) {                
                System.out.println("## line=" + line);
                throw e;
            }
        }
    }

    public void initTags()
        throws Exception
    {
        TagTypeMgr ttmgr = new TagTypeMgr(tran_id);
        TagMgr tmgr = new TagMgr(tran_id);
        Date now = new Date();
        if (bunitMap==null) {
            bunitMap = new SortingMap(new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, ""))
                .doSortSingleton("getLabel");
        }

        String[] campus = { "Bethany", "Taichung", "Kaohsiung", "Chiayi" };

        if (ttmgr.numOfRows("name='Campus'")==0) {
            TagType tt = new TagType();
            tt.setName("Campus");
            ttmgr.create(tt);
            for (int i=0; i<campus.length; i++) {
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName(campus[i]);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setBunitId(bunitMap.get(campus[i]).getId());
                t.setProgId(McaService.campus_code[i]);
                tmgr.create(t);
            }
        }   

        String[] grades = { "K", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" };
        int[] grade_codes = { McaService.PROG_GRADE_K, 
            McaService.PROG_GRADE_1, McaService.PROG_GRADE_2, McaService.PROG_GRADE_3, McaService.PROG_GRADE_4, 
            McaService.PROG_GRADE_5, McaService.PROG_GRADE_6, McaService.PROG_GRADE_7, McaService.PROG_GRADE_8, 
            McaService.PROG_GRADE_9, McaService.PROG_GRADE_10, McaService.PROG_GRADE_11, McaService.PROG_GRADE_12 };  

        if (ttmgr.numOfRows("name='Grade'")==0) {
            TagType tt = new TagType();
            tt.setName("Grade");
            ttmgr.create(tt);
            for (int i=0; i<campus.length; i++) {
                int bunitId = bunitMap.get(campus[i]).getId();
                for (int j=0; j<grades.length; j++) {
                    Tag t = new Tag();
                    t.setCreated(now);
                    t.setModified(now);
                    t.setTypeId(tt.getId());
                    t.setName(campus[i].substring(0,1) + "#" + grades[j]);
                    t.setStatus(Tag.STATUS_CURRENT);
                    t.setBunitId(bunitMap.get(campus[i]).getId());
                    t.setProgId(grade_codes[j]);
                    tmgr.create(t);
                }
            }
        }

        String[] identity = { "M0", "M1", "M2", "CW" };
        int[] identity_codes = {
            McaService.PROG_IDENTITY_M0, McaService.PROG_IDENTITY_M1, McaService.PROG_IDENTITY_M2,  McaService.PROG_IDENTITY_CW};  

        if (ttmgr.numOfRows("name='Identity'")==0) {
            TagType tt = new TagType();
            tt.setName("Identity");
            ttmgr.create(tt);
            for (int i=0; i<campus.length; i++) {
                int bunitId = bunitMap.get(campus[i]).getId();
                for (int j=0; j<identity.length; j++) {
                    Tag t = new Tag();
                    t.setCreated(now);
                    t.setModified(now);
                    t.setTypeId(tt.getId());
                    t.setName(campus[i].substring(0,1) + "#" + identity[j]);
                    t.setStatus(Tag.STATUS_CURRENT);
                    t.setBunitId(bunitMap.get(campus[i]).getId());
                    t.setProgId(identity_codes[j]);
                    tmgr.create(t);
                }
            }
        }


        String[] taichunglunches = { 
            "K-2 Tue&Thu", 
            "K-2 Daily", 
            "3-5 Tue&Thu",
            "3-5 Daily",
            "9-12 Daily"
        };
        int[] tch_lunch_codes = { McaService.PROG_LUNCH_TCH_1, McaService.PROG_LUNCH_TCH_2, 
            McaService.PROG_LUNCH_TCH_3, McaService.PROG_LUNCH_TCH_4, McaService.PROG_LUNCH_TCH_5 };

        String[] kaohsiunglunches = { 
            "Lunch Large",
            "Lunch Moderate"
        };
        int[] kao_lunch_codes = { McaService.PROG_LUNCH_KAO_1, McaService.PROG_LUNCH_KAO_2 };

        String[] ell = { "Moderate", "Significant" };
        int[] ell_codes = { McaService.PROG_ESL_MODERATE, McaService.PROG_ESL_SIGNIFICANT };

        String[] music = { "Private", "Semi-Private", "Group", "Instrument", "Music Room" };
        int[] music_codes = { McaService.PROG_MUSIC_PRIVATE, McaService.PROG_MUSIC_SEMI, 
            McaService.PROG_MUSIC_GROUP, McaService.PROG_MUSIC_INSTRUMENT, McaService.PROG_MUSIC_RENTROOM };

        String[] milk = { "White", "Chocolate", "Low-Fat" };

        String[] dorm = { "Brugler", "Falk", "McGill", "Stacey", "Van Singel" };
        int[] dorm_codes = { McaService.PROG_DORM_PROGRAM, McaService.PROG_DORM_PROGRAM, McaService.PROG_DORM_PROGRAM,
            McaService.PROG_DORM_PROGRAM,  McaService.PROG_DORM_PROGRAM};

        /*
        String[] dorm = { "Program", "Facility", "Food", "Kitchen" };
        int[] dorm_codes = { McaService.PROG_DORM_PROGRAM, McaService.PROG_DORM_FACILITY, McaService.PROG_DORM_FOOD,
            McaService.PROG_DORM_KITCHEN };
        */
        
        String[] bus = { "Route A", "Route B", "Route C", "Route D" };

        if (ttmgr.numOfRows("name='Lunch'")==0) {
            TagType tt = new TagType();
            tt.setName("Lunch");
            ttmgr.create(tt);
            int buId = bunitMap.get("Taichung").getId();
            for (int i=0; i<taichunglunches.length; i++) {
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName("T#" + taichunglunches[i]);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setBunitId(buId);
                t.setProgId(tch_lunch_codes[i]);
                tmgr.create(t);
            }

            buId = bunitMap.get("Kaohsiung").getId();
            for (int i=0; i<kaohsiunglunches.length; i++) {
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName("K#" + kaohsiunglunches[i]);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setBunitId(buId);
                t.setProgId(kao_lunch_codes[i]);
                tmgr.create(t);
            }
        }

        if (ttmgr.numOfRows("name='ELLS'")==0) {
            TagType tt = new TagType();
            tt.setName("ELLS");
            ttmgr.create(tt);
            for (int i=0; i<campus.length; i++) {
                int buId = bunitMap.get(campus[i]).getId();
                for (int j=0; j<ell.length; j++) {
                    Tag t = new Tag();
                    t.setCreated(now);
                    t.setModified(now);
                    t.setTypeId(tt.getId());
                    t.setName(campus[i].substring(0,1) + "#" + ell[j]);
                    t.setStatus(Tag.STATUS_CURRENT);
                    t.setBunitId(buId);
                    t.setProgId(ell_codes[j]);
                    tmgr.create(t);
                }
            }
        }

        if (ttmgr.numOfRows("name='Music'")==0) {
            TagType tt = new TagType();
            tt.setName("Music");
            ttmgr.create(tt);
            for (int i=0; i<campus.length; i++) {
                int buId = bunitMap.get(campus[i]).getId();
                for (int j=0; j<music.length; j++) {
                    Tag t = new Tag();
                    t.setCreated(now);
                    t.setModified(now);
                    t.setTypeId(tt.getId());
                    t.setName(campus[i].substring(0,1) + "#" + music[j]);
                    t.setStatus(Tag.STATUS_CURRENT);
                    t.setBunitId(buId);
                    t.setProgId(music_codes[j]);
                    tmgr.create(t);
                }
            }
        }

        if (ttmgr.numOfRows("name='Milk'")==0) {
            TagType tt = new TagType();
            tt.setName("Milk");
            ttmgr.create(tt);
            for (int i=0; i<campus.length; i++) {
                int buId = bunitMap.get(campus[i]).getId();
                for (int j=0; j<milk.length; j++) {
                    Tag t = new Tag();
                    t.setCreated(now);
                    t.setModified(now);
                    t.setTypeId(tt.getId());
                    t.setName(campus[i].substring(0,1) + "#" + milk[j]);
                    t.setStatus(Tag.STATUS_CURRENT);
                    t.setBunitId(buId);
                    t.setProgId(McaService.PROG_MILK);
                    tmgr.create(t);
                }
            }
        }

        if (ttmgr.numOfRows("name='Dorm'")==0) {
            TagType tt = new TagType();
            tt.setName("Dorm");
            ttmgr.create(tt);
            int buId = bunitMap.get("Taichung").getId();
            for (int j=0; j<dorm.length; j++) {
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName(dorm[j]);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setBunitId(buId);
                t.setProgId(dorm_codes[j]);
                tmgr.create(t);
            }
        }

        if (ttmgr.numOfRows("name='Bus'")==0) {
            TagType tt = new TagType();
            tt.setName("Bus");
            ttmgr.create(tt);
            int buId = bunitMap.get("Kaohsiung").getId();
            for (int j=0; j<bus.length; j++) {
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName("K#" + bus[j]);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setBunitId(buId);
                t.setProgId(McaService.PROG_BUS);
                tmgr.create(t);
            }
        }
        
        if (ttmgr.numOfRows("name='Other'")==0) {
            TagType tt = new TagType();
            tt.setName("Other");
            ttmgr.create(tt);

            for (int i=0; i<campus.length; i++) {
                int buId = bunitMap.get(campus[i]).getId();
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName(campus[i].substring(0,1) + "#" + "Same Parent");
                t.setBunitId(buId);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setProgId(McaService.PROG_SAME_PARENT);
                tmgr.create(t);
            }

            for (int i=0; i<campus.length; i++) {
                int buId = bunitMap.get(campus[i]).getId();
                Tag t = new Tag();
                t.setCreated(now);
                t.setModified(now);
                t.setTypeId(tt.getId());
                t.setName(campus[i].substring(0,1) + "#" + "Testing");
                t.setBunitId(buId);
                t.setStatus(Tag.STATUS_CURRENT);
                t.setProgId(McaService.PROG_TESTING);
                tmgr.create(t);
            }        
        }
    }

    public void initBunits()
        throws Exception
    {
        BunitMgr bmgr = new BunitMgr(tran_id);
        if (bmgr.numOfRows("label='Bethany'")==0) {
            Bunit bu = new Bunit();
            bu.setLabel("Bethany");
            bu.setStatus(Bunit.STATUS_ACTIVE);
            bu.setFlag(Bunit.FLAG_BIZ);
            bmgr.create(bu);
        }
        if (bmgr.numOfRows("label='Taichung'")==0) {
            Bunit bu = new Bunit();
            bu.setLabel("Taichung");
            bu.setStatus(Bunit.STATUS_ACTIVE);
            bu.setFlag(Bunit.FLAG_BIZ);
            bmgr.create(bu);
        }
        if (bmgr.numOfRows("label='Kaohsiung'")==0) {
            Bunit bu = new Bunit();
            bu.setLabel("Kaohsiung");
            bu.setStatus(Bunit.STATUS_ACTIVE);
            bu.setFlag(Bunit.FLAG_BIZ);
            bmgr.create(bu);
        }
        if (bmgr.numOfRows("label='Chiayi'")==0) {
            Bunit bu = new Bunit();
            bu.setLabel("Chiayi");
            bu.setStatus(Bunit.STATUS_ACTIVE);
            bu.setFlag(Bunit.FLAG_BIZ);
            bmgr.create(bu);
        }
    }

    String getIdentityTagName(McaStudent s)
    {
        int i = s.getIdentity();
        if (i==McaStudent.IDENTITY_M0)
            return s.getCampus().substring(0,1) + "#M0";
        else if (i==McaStudent.IDENTITY_M1)
            return s.getCampus().substring(0,1) + "#M1";
        else if (i==McaStudent.IDENTITY_M2)
            return s.getCampus().substring(0,1) + "#M2";
        else if (i==McaStudent.IDENTITY_CW)
            return s.getCampus().substring(0,1) + "#CW";
        return s.getCampus().substring(0,1) + "#BK";
    }

    String getLunchTagName(McaStudent s)
    {
        if (s.getCampus().equals("Taichung")) {
            int lunch = getIntValue(s.getTmpLunch());
            switch (lunch) {
                case 10000: return "T#9-12 Daily";
                case 6000: return "T#K-2 Daily";
                case 3250: return "T#3-5 Tue&Thu";
                case 8000: return "T#3-5 Daily";
                case 2400: return "T#K-2 Tue&Thu";
            }
        }
        else if (s.getCampus().equals("Kaohsiung")) {
            int lunch = getIntValue(s.getTmpLunch());
            switch (lunch) {
                case 6750: return "K#Lunch Moderate";
                case 8100: return "K#Lunch Large";
            }
        }
        return "NA";
    }

    String getEllTagName(McaStudent s)
    {
        int ell = getIntValue(s.getTmpEll());
        if (s.getIdentity()>0)
            ell = 2 * ell;
        if (ell>30000) {
            return s.getCampus().substring(0,1) + "#Significant";
        }
        else if (ell>0) {
            return s.getCampus().substring(0,1) + "#Moderate";
        }
        return "NA";
    }

    String getMusicTagName(McaStudent s)
    {
        int music = getIntValue(s.getTmpMusic());
        switch (music) {
            case 2200: return s.getCampus().substring(0,1) + "#Group";
            case 3400:
            case 4400: return s.getCampus().substring(0,1) + "Semi-Private";
            case 5500: return s.getCampus().substring(0,1) + "#Private";
            case 6600:
            case 7040: 
            case 7700: 
            case 8250: 
            case 10560: 
            case 11000: 
            case 13750: 
            case 14080: 
            case 16500:
            case 17600:
            case 21120: return s.getCampus().substring(0,1) + "#Private";
        }
        return "NA";
    }

    String getBusTagName(McaStudent s)
    {
        if (s.getCampus().equals("Kaohsiung")) {
            int bus = getIntValue(s.getTmpBus());
            if (bus>0)
                return "K#Route A";
        }
        return "NA";
    }

    String getInstrTagName(McaStudent s)
    {
        int instr = getIntValue(s.getTmpInstr());
        if (instr>0)
            return s.getCampus().substring(0,1) + "#Instrument";
        return "NA";
    }

    String getMusicRoomTagName(McaStudent s)
    {
        int musicroom = getIntValue(s.getTmpMusicRoom());
        if (musicroom>0)
            return s.getCampus().substring(0,1) + "#Music Room";
        return "NA";
    }

    String getDormRoomTagName(McaStudent s)
    {
        int dormroom = getIntValue(s.getTmpDorm());
        if (dormroom>0)
            return s.getCampus().substring(0,1) + "#Program";
        return "NA";
    }

    String getDormFoodTagName(McaStudent s)
    {
        int dormfood = getIntValue(s.getTmpDormFood());
        if (dormfood>0)
            return s.getCampus().substring(0,1) + "#Food";
        return "NA";
    }

    String getKitchenTagName(McaStudent s)
    {
        int kitchen = getIntValue(s.getTmpKitchen());
        if (kitchen>0)
            return s.getCampus().substring(0,1) + "#Kitchen";
        return "NA";
    }

    String getMilkTypeTagName(McaStudent s)
    {
        if (s.getTmpMilktype().indexOf("L.F.")>=0 || s.getTmpMilktype().indexOf("lf")>=0 || s.getTmpMilktype().indexOf("LF")>=0)
            return s.getCampus().substring(0,1) + "#Low-Fat";
        else if (s.getTmpMilktype().indexOf("W")>=0 || s.getTmpMilktype().indexOf("white")>=0)
            return s.getCampus().substring(0,1) + "#White";
        else if (s.getTmpMilktype().indexOf("C")>=0 || s.getTmpMilktype().indexOf("choc")>=0)
            return s.getCampus().substring(0,1) + "#Chocolate";

        return "NA";
    }

    int getIntValue(String s)
    {
        if (s==null || s.length()==0)
            return 0;
        return Integer.parseInt(s);
    }

    void setupStudentTags(ArrayList<McaStudent> msts, int bunitId) 
        throws Exception
    {
        BunitHelper bh = new BunitHelper(tran_id);
        jsf.PaySystem ps = (jsf.PaySystem) jsf.PaySystemMgr.getInstance().find(1);
        TagHelper th = TagHelper.getInstance(ps, tran_id, bh.getStudentBunitId(bunitId));
        ArrayList<Tag> tags = th.getTags(false, "", bh.getStudentSpace("bunitId", bunitId));
        Map<String, Tag> tagMap = new SortingMap(tags).doSortSingleton("getName");
        Date now = new Date();
        
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        for (int i=0; i<msts.size(); i++) {
            McaStudent s = msts.get(i);
            Tag campusTag = tagMap.get(s.getCampus());
            Tag gradeTag = tagMap.get(s.getCampus().substring(0,1) + "#" + s.getGrade());
            Tag identityTag = tagMap.get(getIdentityTagName(s));
            Tag lunchTag = tagMap.get(getLunchTagName(s));
            Tag busTag = tagMap.get(getBusTagName(s));
            Tag ellTag = tagMap.get(getEllTagName(s));
            Tag milkTypeTag = tagMap.get(getMilkTypeTagName(s));
            Tag musicTag = tagMap.get(getMusicTagName(s));
            Tag instrTag = tagMap.get(getInstrTagName(s));
            Tag musicRoomTag = tagMap.get(getMusicRoomTagName(s));
            Tag kitchenTag = tagMap.get(getKitchenTagName(s));
            Tag dormRoomTag = tagMap.get(getDormRoomTagName(s));
            Tag dormFoodTag = tagMap.get(getDormFoodTagName(s));

            if (tmmgr.numOfRows("tagId=" + campusTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(campusTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (gradeTag!=null && tmmgr.numOfRows("tagId=" + gradeTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(gradeTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (identityTag!=null && tmmgr.numOfRows("tagId=" + identityTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(identityTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (lunchTag!=null && tmmgr.numOfRows("tagId=" + lunchTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(lunchTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (busTag!=null && tmmgr.numOfRows("tagId=" + busTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(busTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (ellTag!=null && tmmgr.numOfRows("tagId=" + ellTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(ellTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (milkTypeTag!=null && tmmgr.numOfRows("tagId=" + milkTypeTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(milkTypeTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (musicTag!=null && tmmgr.numOfRows("tagId=" + musicTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(musicTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (instrTag!=null && tmmgr.numOfRows("tagId=" + instrTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(instrTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (musicRoomTag!=null && tmmgr.numOfRows("tagId=" + musicRoomTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(musicRoomTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (dormRoomTag!=null && tmmgr.numOfRows("tagId=" + dormRoomTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(dormRoomTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (dormFoodTag!=null && tmmgr.numOfRows("tagId=" + dormFoodTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(dormFoodTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }

            if (kitchenTag!=null && tmmgr.numOfRows("tagId=" + kitchenTag.getId() + " and membrId=" + s.getMembrId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(kitchenTag.getId());
                tm.setMembrId(s.getMembrId());
                tm.setBindTime(now);
                tmmgr.create(tm);
            }
        }
    }

    public static void main(String[] args)
    {
        boolean commit = false;
        int tran_id = 0;
        try {
            DataSource.setup("datasource");
            tran_id = dbo.Manager.startTransaction();
            PArrayList<McaStudent> mstuds = new PArrayList<McaStudent>();

            McaImport im = new McaImport(tran_id);
            im.initBunits();
            im.initTags();
            System.out.println("############# Area #################");
            im.importArea("mca/country.txt", 0);
            im.importArea("mca/county.txt", 1);
            im.importArea("mca/city.txt", 2);
            im.importArea("mca/district.txt", 3);
            im.areaMap = new SortingMap(im.amgr.retrieveList("", "")).doSortSingleton("getMyKey");            
            System.out.println("############# Chancery Tch & Bethany #################");
            mstuds.concate(im.importChanceryTaipeiTaichong("mca/chancery_tpe_tch.txt"));
            System.out.println("\n\n############# Access Tch #################");
            mstuds.concate(im.importAccessTaichong("mca/access_tch.txt"));
            System.out.println("\n\n############# Access Bethany #################");
            mstuds.concate(im.importAccessTaipei("mca/access_tpe.txt"));
            System.out.println("\n\n############# Chancery 高雄 #################");
            mstuds.concate(im.importChanceryKaohsiung("mca/chancery_kaohsiung2.txt"));
            System.out.println("\n\n############# Access 高雄 #################");
            mstuds.concate(im.importAccessKaohsiung("mca/access_kaohsiung.txt"));
            System.out.println("\n\n############# Chancery 嘉義 #################");
            mstuds.concate(im.importChanceryChiayi("mca/chancery_chiayi2.txt"));
            System.out.println("\n\n############# Access 嘉義 #################");
            mstuds.concate(im.importAccessChiayi("mca/access_chiayi.txt"));
/*
            String mids = new RangeMaker().makeRange(mstuds, "getId");
            ArrayList<McaStudent> mstudents = new McaStudentMgr(tran_id).retrieveList("id in (" + mids + ")", "");
            McaService mcasvc = new McaService(tran_id);
            mcasvc.updateStudents(mstudents);
            im.setupStudentTags(mstudents);
*/
            dbo.Manager.commit(tran_id);
            commit = true;
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            if (!commit)
                try { dbo.Manager.rollback(tran_id); } catch (Exception e) {}
        }
    }
}

