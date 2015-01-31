package mca;

import phm.ezcounting.*;
import java.text.*;
import java.util.*;
import java.io.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jsf.*;
import java.awt.Color;
import mca.*;
import java.lang.reflect.*;

public class McaPrint extends PaymentPrinter {

    Document document = null;
    McaService mcasvc = null;

    public McaPrint(String rootPath) 
        throws Exception
    {
        File toolDir = new File(rootPath + "/eSystem/pdf_example");
        this.rootPath = rootPath;
        this.fontPathName = new File(toolDir, "font/mingliu.ttc,0").getAbsolutePath();
        this.paySystem = PaySystem2Mgr.getInstance().find("id=1");
        this.document = getDocument();
    }

    ArrayList<McaStudent> getSameFamily(McaStudent ms, Map<Integer, ArrayList<McaStudentInfo>> familyMap, 
        Map<Integer, McaStudent> studentMap)
        throws Exception
    {
        if (studentMap.get(ms.getMembrId())==null)
            return null;
        ArrayList<McaStudent> ret = new ArrayList<McaStudent>();
        ret.add(ms);
        ArrayList<McaStudentInfo> famembrs = familyMap.get(ms.getMembrId());
        for (int i=0; famembrs!=null && i<famembrs.size(); i++) {
            McaStudent fm = famembrs.get(i);
            if (fm.getId()==ms.getId())
                continue;
            McaStudent tmp = studentMap.remove(fm.getMembrId());
            if (tmp==null)
                continue; // family membr but not in the same school
            ret.add(tmp);
        }
        return ret;
    }

    public void printRegForm(McaFee fee, String space)
        throws Exception
    {
        if (fee.getFeeType()!=McaFee.REGISTRATION_ONLY)
            throw new Exception("type is not Registration");
        ArrayList<McaRecordInfo> mrs = McaRecordInfoMgr.getInstance().retrieveList("mcaFeeId=" + fee.getId()
             + " and mca_fee.status!=-1", "");
        String billRecordIds = new RangeMaker().makeRange(mrs, "getBillRecordId");
        ArrayList<MembrInfoBillRecord> bills = MembrInfoBillRecordMgr.getInstance().retrieveListX(
            "billRecordId in (" + billRecordIds + ")", "", space);
        String membrIds = new RangeMaker().makeRange(bills, "getMembrId");
        ArrayList<McaStudent> students = McaStudentMgr.getInstance().retrieveList("membrId in (" + membrIds + ")", 
            "order by StudentSurname asc");
        Map<Integer, ArrayList<McaStudentInfo>> familyMap = new McaService().prepareFamilyMap();
        Map<Integer, McaStudent> studentMap = new SortingMap(students).doSortSingleton("getMembrId");

        mcasvc = new McaService();
        mcasvc.setupMembrsInfo(fee, membrIds);

        for (int i=0; i<students.size(); i++) {
            McaStudent ms = students.get(i);
            ArrayList<McaStudent> samefamily = getSameFamily(ms, familyMap, studentMap);
            if (samefamily==null)
                continue;
            printMCARegistration(samefamily);
        }
    }

    String getValue(ArrayList<McaStudent> students, String method)
        throws Exception
    {
        Class c = students.get(0).getClass();
        Class[] paramTypes = {};
        Method m = c.getMethod(method, paramTypes);
        Object[] params = {};

        String ret = "";
        for (int i=0; i<students.size(); i++) {
            McaStudent ms = students.get(i);
            String v = (String) m.invoke(ms, params);
            if (v!=null && v.length()>ret.length())
                ret = v;
        }
        return ret;
    }

    String getEnglishAddress(ArrayList<McaStudent> students)
        throws Exception
    {
        String addr = "";
        for (int i=0; i<students.size(); i++) {
            McaStudent ms = students.get(i);
            String tmp = mcasvc.formatEngAddr(ms.getCountryID(), ms.getCountyID(), ms.getCityID(), ms.getDistrictID(),
                ms.getEnglishStreetAddress(), ms.getPostalCode());
            if (tmp.length()>addr.length())
                addr = tmp;
        }
        return addr;
    }

    String getChineseAddress(ArrayList<McaStudent> students)
        throws Exception
    {
        String addr = "";
        for (int i=0; i<students.size(); i++) {
            McaStudent ms = students.get(i);
            String tmp = mcasvc.formatAddr(ms.getCountryID(), ms.getCountyID(), ms.getCityID(), ms.getDistrictID(),
                ms.getChineseStreetAddress(), ms.getPostalCode());
            if (tmp.length()>addr.length())
                addr = tmp;
        }
        return addr;
    }

    String[] getBillingAddress(ArrayList<McaStudent> students)
        throws Exception
    {
        String addr = "";
        for (int i=0; i<students.size(); i++) {
            McaStudent ms = students.get(i);
            String tmp = mcasvc.formatAddr(ms.getBillCountryID(), ms.getBillCountyID(), ms.getBillCityID(), ms.getBillDistrictID(),
                ms.getBillChineseStreetAddress(), ms.getBillPostalCode());
            if (tmp.length()>addr.length())
                addr = tmp;
        }

        if (addr.length()==0)
            addr = getChineseAddress(students);
        addr = addr.trim();       
        String[] ret = new String[2];
        ret[0] = PaymentPrinter.makePrecise(addr, 40, true, ' ').trim();
        if (ret[0].equals(addr))
            ret[1] = "";
        else {
            ret[1] = addr.substring(ret[0].length());
        }
        return ret;
    }

    public void printMCARegistration(ArrayList<McaStudent> students) 
        throws Exception
    {
        String parentName = mcasvc.getParent(students.get(0).getMembrId());
        String billTo1 = getValue(students, "getBillTo");
        String billTo2 = getValue(students, "getBillAttention");
        if (billTo1.length()==0)
            billTo1 = "PARENT";
        if (billTo1.equals("PARENT")) {
            billTo2 = "";//parentName;
        }
        String englishHomeAddr = getEnglishAddress(students);
        String chineseHomeAddr = getChineseAddress(students);
        String[] billing = getBillingAddress(students);
        String billAddr1 = billing[0];
        String billAddr2 = billing[1];
        String homePhone = getValue(students, "getHomePhone");

        String officePhone = getValue(students, "getOfficePhone");
        if (officePhone.length()==0) {
            officePhone = getValue(students, "getFatherPhone");
        }
        if (officePhone.length()==0) {
            officePhone = getValue(students, "getMotherPhone");
        }
        String fatherMobile = getValue(students, "getFatherCell");
        String motherMobile = getValue(students, "getMotherCell");
        String emails = getValue(students, "getFatherEmail");
        String motheremail = getValue(students, "getMotherEmail");
        if (motheremail.length()>0) {
            if (emails.length()>0)
                emails += ",";
            emails += motheremail;
        }

        document.newPage();

        PdfContentByte cb = this.pdfwriter.getDirectContent();
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);

        Font font16NORMAL = new Font(bfComic2, 16,Font.NORMAL);
        Font font16BOLD = new Font(bfComic2, 16,Font.BOLD);
        Font font12NORMAL = new Font(bfComic2, 12,Font.NORMAL);
        Font font10NORMAL = new Font(bfComic2, 10,Font.NORMAL);
        Font font9NORMAL = new Font(bfComic2, 9,Font.NORMAL);    
        Font font8NORMAL = new Font(bfComic2, 8,Font.NORMAL);    
        Font font6NORMAL = new Font(bfComic2, 6,Font.NORMAL);
        Font font4NORMAL = new Font(bfComic2, 4,Font.NORMAL);
        Font font2NORMAL = new Font(bfComic2, 2,Font.NORMAL);

        Font[] f_times=new Font[6];
        f_times[0] =new Font(Font.TIMES_ROMAN, 16, Font.NORMAL);
        f_times[1] =new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
        f_times[2] =new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        f_times[3] =new Font(Font.TIMES_ROMAN, 9, Font.NORMAL);
        f_times[4] =new Font(Font.TIMES_ROMAN, 6, Font.NORMAL);
        f_times[5] =new Font(Font.TIMES_ROMAN, 5, Font.NORMAL);

        Font f_times_bold =new Font(Font.TIMES_ROMAN, 9, Font.BOLD);

        Font[] f_underline=new Font[5];
        f_underline[0] =new Font(Font.TIMES_ROMAN, 10, Font.UNDERLINE);
        f_underline[1] =new Font(bfComic2, 10,Font.UNDERLINE);
        f_underline[2] =new Font(Font.TIMES_ROMAN, 9, Font.UNDERLINE);
        f_underline[3] =new Font(bfComic2, 8,Font.UNDERLINE);
        f_underline[4] =new Font(Font.COURIER, 9,Font.UNDERLINE);  //answer

        float superscript = 9.2f;

//        Font underLine= FontFactory.getFont(FontFactory.TIMES_ROMAN, Font.DEFAULTSIZE, Font.UNDERLINE);

        Paragraph parag1=new Paragraph("");
        parag1.add(new Chunk("                                                   MORRISON ACADEMY  \n",f_times[0]));
        parag1.add(new Chunk("                                                                          REGISTRATION FORM \n", f_times[1]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Please return this form with the registration fee receipt to the Business Office. ",f_underline[0]));
        parag1.add(new Chunk("     請填妥本註冊單,連同註冊費收據交回總務處.",f_underline[1]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk(makePrecise("Parent", 30, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(parentName, 45, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise("Bill to", 25, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(billTo1, 45, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk(makePrecise("Home Address", 22, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(englishHomeAddr, 45, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise(" ", 28, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(billTo2, 45, true, ' '),f_underline[3]));
        document.add(parag1);
       
        parag1=new Paragraph("");
        parag1.add(new Chunk(makePrecise("Chinese Address", 22, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(chineseHomeAddr, 45, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise("Bill Address", 20, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(billAddr1, 45, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk(makePrecise("Telephone    ", 26, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise("(H)" + homePhone, 20, true, ' '),f_underline[3]));
        parag1.add(new Chunk(makePrecise("(O)" + officePhone, 25, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise(" ", 32, true, ' '),f_times[3]));
        parag1.add(new Chunk(makePrecise(billAddr2, 45, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk(makePrecise("Cell phone   ", 26, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise("(F)" + fatherMobile, 22, true, ' '),f_underline[3]));
        parag1.add(new Chunk(makePrecise("(M)" + motherMobile, 23, true, ' '),f_underline[3]));
        parag1.add(new Chunk("       ",f_times[2]));
        parag1.add(new Chunk(makePrecise("E-mail", 23, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(emails, 50, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("\nCheck the following boxes that apply to you. \n",f_times[3]));
        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" The student(s) listed below will reside with parents or legal guardian next school year. If not, please explain. \n",f_times[3]));
        parag1.add(new Chunk("   下列生若於下學年度非與家長或法定監人同住請說明:",font9NORMAL));
        parag1.add(new Chunk(makePrecise("  ", 65, true, ' ')+"\n",f_underline[3]));
        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" (For Missionary/Christian worker discount recipients only) My relationship with",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 30, true, ' '),f_underline[3]));
        parag1.add(new Chunk("remains the same as last \n",f_times[3]));
        parag1.add(new Chunk("    year. If not, please explain.    ",f_times[3]));
        parag1.add(new Chunk("傳教士/基督徒工作者請填隸屬機構,與去年不同者請說明:",font9NORMAL));
        parag1.add(new Chunk(makePrecise("  ", 35, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n\n",f_times[3]));

        parag1.setLeading(13f);
        document.add(parag1);

        float[] widths3 = {0.2f,0.05f,0.03f,0.08f,0.1f,0.1f,0.1f,0.05f,0.05f,0.05f,0.05f,0.05f};

        PdfPTable nest = new PdfPTable(widths3);

/*
        Rectangle border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        border.setBorderWidthLeft(0.0f);
        border.setBorderColorLeft(Color.WHITE);
        border.setBorderWidthRight(0f);
        border.setBorderColorRight(Color.WHITE);
        border.setBorderWidthBottom(0f);
        border.setBorderColorBottom(Color.WHITE);

        //cell.cloneNonPositionParameters(border);
*/  
//table title
        parag1=new Paragraph("");
        parag1.add(new Chunk("Student Name",f_times[4]));

        PdfPCell cell = new PdfPCell(parag1);
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("Grade\n",f_times[4]));
        parag1.add(new Chunk("Registered For",f_times[5]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Sex",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Citizenship",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Passport",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("ARC or ID \n",f_times[4]));
        parag1.add(new Chunk("No",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Birthday",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Milk",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Lunch",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Dorm",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Music",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Bus",f_times[4]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        for (int i=0; i<students.size(); i++) {
            McaStudent ms = students.get(i);
            String studentName = ms.getFullName();
            String grade = mcasvc.getGrade(ms.getMembrId());
            String gender = ms.getSex();
            String citizen = ms.getPassportCountry(); // mcasvc.getPassportCountry(ms.getPassportCountry());
            String passport = ms.getPassportNumber();
            String arcId = ms.getArcID();
            String birthday = ms.getBirthDate();
            String milk = mcasvc.getMilk(ms.getMembrId());
            String lunch = mcasvc.getLunch(ms.getMembrId());
            String dorm = mcasvc.getDorm(ms.getMembrId());
            String music = mcasvc.getMusic(ms.getMembrId());
            String bus = mcasvc.getBus(ms.getMembrId());

//table content
            parag1=new Paragraph("");
            parag1.add(new Chunk(studentName,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setFixedHeight(15f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);


            parag1=new Paragraph("");
            parag1.add(new Chunk(grade,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(gender,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(citizen,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(passport,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(arcId,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(birthday,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(milk,f_times[3]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(lunch,f_times[4]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(dorm,f_times[4]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(music,f_times[4]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            parag1=new Paragraph("");
            parag1.add(new Chunk(bus,f_times[4]));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);
        }

        nest.setWidthPercentage(100);
        document.add(nest);


        parag1=new Paragraph("");
        parag1.add(new Chunk("Emergency contact (not the parent) with power to act on my child's behalf, if parent/guardian cannot be reached:	",f_times_bold));
        parag1.add(new Chunk("\n    家長或監護人除外的緊急聯絡人:",font9NORMAL));
        parag1.add(new Chunk("\n    Name:",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 20, true, ' '),f_underline[3]));
        parag1.add(new Chunk("    Relationship:",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 20, true, ' '),f_underline[3]));
        parag1.add(new Chunk("    Phone #: (H)",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 17, true, ' '),f_underline[3]));
        parag1.add(new Chunk("    (O):",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 17, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("==========================================================================================================\n",f_times_bold));
        document.add(parag1);


        parag1=new Paragraph("");
        parag1.add(new Chunk("If your child(ren) has had any of the following conditions or treatment since the beginning of their last year in the Morrison Academy system, write the student's name and give details.",f_times[3]));
        parag1.add(new Chunk("學生若於上學年度曾發生如下狀況,請列載其姓名及詳情.\n",font9NORMAL));
        parag1.add(new Chunk("Tuberculosis?",f_times[3]));
        parag1.add(new Chunk("肺結核;",font9NORMAL));
        parag1.add(new Chunk("Hepatitis?",f_times[3]));
        parag1.add(new Chunk("肝炎;",font9NORMAL));
        parag1.add(new Chunk("Head Injury?",f_times[3]));
        parag1.add(new Chunk("頭部受傷;",font9NORMAL));
        parag1.add(new Chunk("Asthma?",f_times[3]));
        parag1.add(new Chunk("哮喘;",font9NORMAL));
        parag1.add(new Chunk("Asthma?",f_times[3]));
        parag1.add(new Chunk("哮喘;",font9NORMAL));
        parag1.add(new Chunk("Convulsions?",f_times[3]));
        parag1.add(new Chunk("痙攣;",font9NORMAL));
        parag1.add(new Chunk("Hernia?",f_times[3]));
        parag1.add(new Chunk("疝脫;",font9NORMAL));
        parag1.add(new Chunk("Heart Murmur?",f_times[3]));
        parag1.add(new Chunk("心臟雜音;",font9NORMAL));
        parag1.add(new Chunk("Operation?",f_times[3]));
        parag1.add(new Chunk("手術;",font9NORMAL));

        parag1.add(new Chunk("Hospitalization?",f_times[3]));
        parag1.add(new Chunk("住院治療;",font9NORMAL));
        parag1.add(new Chunk("Allergies?",f_times[3]));
        parag1.add(new Chunk("過敏;",font9NORMAL));
        parag1.add(new Chunk("(List to what substance/s?",f_times[3]));
        parag1.add(new Chunk("請列過敏原);",font9NORMAL));
        parag1.add(new Chunk("Bone/Joint/Muscle injury?",f_times[3]));
        parag1.add(new Chunk("骨頭/關節/肌肉受傷;",font9NORMAL));
        parag1.add(new Chunk("Fainting or chest pain while exercising?",f_times[3]));
        parag1.add(new Chunk("運動中昏厥或胸痛;",font9NORMAL));
        parag1.add(new Chunk("Family member that died suddenly from heart problems?",f_times[3]));
        parag1.add(new Chunk("家人曾因心臟疾病突發去世? \n",font9NORMAL));

        parag1.setLeading(13f);
        document.add(parag1);

        parag1=new Paragraph("");

        parag1.add(new Chunk(makePrecise("  ", 120, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

        parag1.add(new Chunk(makePrecise("  ", 120, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

/*
        parag1.add(new Chunk(makePrecise("  ", 120, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

        parag1.add(new Chunk(makePrecise("  ", 120, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));
*/        

        parag1.add(new Chunk("Regular medication?(list)	",f_times[3]));
        parag1.add(new Chunk("請列出慣用的藥物",font9NORMAL));
        parag1.add(new Chunk(makePrecise("  ", 80, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

        parag1.add(new Chunk("Other",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 100, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

        parag1.add(new Chunk("Immunizations since last April:",f_times[3]));
        parag1.add(new Chunk("請列出去年四月迄今形成免疫的項目",font9NORMAL));
        parag1.add(new Chunk(makePrecise("  ", 40, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));
        parag1.add(new Chunk(makePrecise("  ", 120, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

        parag1.add(new Chunk("Date of Last Dental Exam:",f_times[3]));
        parag1.add(new Chunk("最近一次齒科檢查日期",font9NORMAL));
        parag1.add(new Chunk(makePrecise("  ", 15, true, ' '),f_underline[3]));
        parag1.add(new Chunk("   Date of Last Eye Exam",f_times[3]));
        parag1.add(new Chunk("最近一次眼科檢查日期",font9NORMAL));
        parag1.add(new Chunk(makePrecise("  ", 15, true, ' '),f_underline[3]));
        parag1.add(new Chunk("\n",f_times[3]));

        parag1.setLeading(13f);
        document.add(parag1);


        parag1=new Paragraph("");
        parag1.add(new Chunk("==========================================================================================================",f_times_bold));
        document.add(parag1);


        parag1=new Paragraph("");
        parag1.add(new Chunk("The custodial parent/guardian of the above named students hereby agrees to the following terms:\n\n",f_times_bold));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("1. Adherence to all Morrison Christian Academy policies and procedures.",f_times[3]));
        parag1.add(new Chunk("恪守馬禮遜學校的政策及程序",font6NORMAL));
        parag1.add(new Chunk("\n",font2NORMAL));
        parag1.add(new Chunk("2. Acknowledgment that Morrison Academy falls exclusively within the jurisdiction of the Republic of China.",f_times[3]));
        parag1.add(new Chunk("馬禮遜學校受中華民國司法權之管轄",font6NORMAL));
        parag1.add(new Chunk("\n",f_times[3]));
        parag1.add(new Chunk("3. Recognition that reasonable precautions are taken for the safety of my child while in the Academy's care. Morrison Academy will not be liable in case of\n    accident or abduction.",f_times[3]));
        parag1.add(new Chunk("馬禮遜學校可採取合理措施保護本人子女, 對於意外事件或誘拐, 綁架, 劫持等可予免責",font6NORMAL));
        parag1.add(new Chunk("\n",font2NORMAL));

        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" Permission is granted for the Academy's nurse/personnel to give general and emergency first aid treatment and dispense prescribed medicines to my\n      child and further emergency treatment, as they deem necessary, until I can be reached.\n",f_times[3]));
        parag1.add(new Chunk("    本人同意在學校連絡到本人前,學校護理人員給予子女一般性緊急醫護處理, 必要時也可給予孩子服用藥物或急救治療 \n",font6NORMAL));

       // parag1.add(new Chunk("□",font9NORMAL));
       // parag1.add(new Chunk(" I give permission for my child(ren) to receive one dose of Combantrin for the treatment of possible worm infestation.",f_times[3]));
       // parag1.add(new Chunk("  本人同意校方給予子女服用驅蟲藥 \n",font6NORMAL));

        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" Recognizing the inherent risk of injury in spite of precaution and supervision, I give my child(ren) permission to participate in field trips, practices,\n      travel, and interschool games and thereby relieve Morrison Academy of liability, unless otherwise communicated to the Academy in writing.\n",f_times[3]));
        parag1.add(new Chunk("    本人同意子女參與戶外教學及校際舉辦之活動及旅遊, 且若在防範督導下仍發生無可避免之傷害時, 校方可予免責.\n",font6NORMAL));


        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" Permission for my child to have supervised access to the world-wide web and to have his/her work and name published on our websites\n      (www.mca.org.tw) ",f_times[3]));
        parag1.add(new Chunk("    本人同意子女在學校督導下使用網路,並同意刊登其作品與姓名於學校網站中.\n",font6NORMAL));


        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" I give permission for Morrison Academy to use my child's still image, video footage or audio recording for such purposes as yearbook, school web\n    pages, and promotional materials.  I understand that my child's full name will not be revealed, except in the yearbook.\n",f_times[3]));
        parag1.add(new Chunk("   本人同意馬禮遜學校使用子女的照片、錄影、和錄音於紀念冊、學校的官方網站、或發行刊物中。 子女的全名除了記錄在紀念冊中，將不會在其他任何地方出現.",font6NORMAL));
        parag1.add(new Chunk("\n",font2NORMAL));


        parag1.add(new Chunk("□",font9NORMAL));
        parag1.add(new Chunk(" I give permission for family contact information to be published in the Student Directory.",f_times[3]));
        parag1.add(new Chunk("  同意在學生通訊錄中刊登本人聯絡電話.\n",font6NORMAL));

        parag1.setLeading(10f);

        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("To the best of my knowledge, I declare that the information on this form is correct and complete.",f_times_bold));
        parag1.add(new Chunk("本人僅此聲明,以上陳述無誤.\n",font6NORMAL));

        parag1.add(new Chunk("Parent/Guardian's Signature:",f_times_bold));
        parag1.add(new Chunk(makePrecise("  ", 50, true, ' '),f_underline[3]));
        parag1.add(new Chunk("Date:",f_times_bold));
        parag1.add(new Chunk(makePrecise("  ", 30, true, ' '),f_underline[3]));
        document.add(parag1);
    }
}