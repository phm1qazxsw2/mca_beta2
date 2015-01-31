<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="../jumpTop.jsp"%>

<%
    //##v2
    Document document = null;
            
    String fname = "";
    try {

        document = new Document(PageSize.A4,20,20,40,10);

        File root = new File(request.getRealPath("/"));
        File toolDir = new File(root + "/eSystem/pdf_example");
        fname = new Date().getTime() + ".pdf";
        File outdir = new File(root, "pdf_output");

        File testout = new File(outdir, fname);
        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
       
        document.open();
        PdfContentByte cb = pdfwriter.getDirectContent();


        Font defaultFont=new Font(Font.TIMES_ROMAN, 14, Font.NORMAL);
        Font defaultFont2=new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font defaultFont3=new Font(Font.TIMES_ROMAN, 20, Font.BOLD);

        float[] widths = {0.2f, 0.8f};
        PdfPTable table = new PdfPTable(widths);

        PdfPCell cell =null;
        BunitHelper bh= new BunitHelper();
        File logoPath = new File(root, "/eSystem/images/mcalogo.tif");
        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image logoI= Image.getInstance(logoPath.getAbsolutePath());
                logoI.setAbsolutePosition(10,720);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
            cell=new PdfPCell(new Paragraph("",defaultFont));
        }

        cell.setFixedHeight(80f);
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        Paragraph parag1=new Paragraph("");
        parag1.add(new Chunk("MORRISON ACADEMY – Director of Finance",defaultFont2));
        parag1.add(new Chunk("\n",defaultFont));

        parag1.add(new Chunk("\n",defaultFont));

        parag1.add(new Chunk("Address:	136-1 Shui Nan Road, Taichung 40679, Taiwan",defaultFont));
        parag1.add(new Chunk("\n",defaultFont));

        parag1.add(new Chunk(PaymentPrinter.makePrecise("Tel: (886) 04 2297 3927 Ext. 102",50,true,' ')+"Fax:	(886) 4 2292 1174",defaultFont));
        parag1.add(new Chunk("\n",defaultFont));
        parag1.add(new Chunk(PaymentPrinter.makePrecise("Email: lawm@mca.org.tw",51,true,' ')+"Web:	http://www.mca.org.tw",defaultFont));
    
        cell= new PdfPCell(parag1);
        cell.setBorderWidth((float)0.0);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    

        parag1=new Paragraph("");
        parag1.add(new Chunk("\n\n\n\n",defaultFont3));
        parag1.add(new Chunk("July 20, Year",defaultFont));
        parag1.add(new Chunk("\n\n\n",defaultFont3));
        parag1.add(new Chunk("Dear "+"Parents’ Names:",defaultFont));
        parag1.add(new Chunk("\n\n\n",defaultFont3));
        parag1.add(new Chunk("The record indicates that there is still an outstanding balance of $"+"        "+" in "+" Students’ Names"+"’s "+"2009-2010 Fall semester "+"tuition and fees account.  Pleased be reminded that  if the balance is not paid by the first day of next month, a 1% per month interest of the balance due, calculated from the due date to the payment date, will be added to outstanding amount.",defaultFont));
        parag1.add(new Chunk("\n\n",defaultFont));
        parag1.add(new Chunk("If you have any questions, please contact cashier ? phone#  in ? campus.",defaultFont));


        parag1.add(new Chunk("\n\n",defaultFont3));
        parag1.add(new Chunk("Sincerely,",defaultFont));

        String spaceX="                                                                                                ";
        parag1.add(new Chunk("\n\n\n\n",defaultFont3));
        parag1.add(new Chunk(spaceX+"Michele Law ",defaultFont));
        parag1.add(new Chunk("\n",defaultFont));
        parag1.add(new Chunk(spaceX+"Director of Finance",defaultFont));


        parag1.add(new Chunk("\n\n",defaultFont));
        parag1.add(new Chunk(spaceX+"Cc: "+"cashier’s name",defaultFont));

        cell= new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setBorderWidth((float)0.0);
        cell.setFixedHeight(650f);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);
            
        table.setWidthPercentage(100);
        document.add(table);

        cb.setLineWidth(2.0f);	 // Make a bit thicker than 1.0 default
	    cb.setGrayStroke(0.0f);  // 0 is black 1 is white 
        cb.moveTo(132,772);
        cb.lineTo(550,772);
        cb.stroke();



//### end the mess
    }
    catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    finally {
        if (document!=null)
            document.close();
    }
%>
<br>
<div class=pageName>
aaa
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  


<br>
<br>
<blockquote>
<a target="_blank" href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
</blockquote>