/*
 * $Id: Bookmarks.java 2570 2007-02-06 13:29:11Z blowagie $
 * $Name$
 *
 * This code is part of the 'iText Tutorial'.
 * You can find the complete tutorial at the following address:
 * http://itextdocs.lowagie.com/tutorial/
 *
 * This code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * itext-questions@lists.sourceforge.net
 */

package jsf;


import java.io.FileOutputStream;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfDestination;
import com.lowagie.text.pdf.PdfOutline;
import com.lowagie.text.pdf.PdfPageEventHelper;
import com.lowagie.text.pdf.PdfWriter;

/**
 * Creates a document with outlines (bookmarks).
 * 
 * @author blowagie
 */

public class Bookmarks extends PdfPageEventHelper {
    
    /** Keeps the number of the current paragraph. */
    private int n = 0;
    
    /**
     * Adds an outline for every new Paragraph
     * @param writer
     * @param document
     * @param position
     */
    public void onParagraph(PdfWriter writer, Document document, float position) {
        n++;
        PdfContentByte cb = writer.getDirectContent();
        PdfDestination destination = new PdfDestination(PdfDestination.FITH, position);
        new PdfOutline(cb.getRootOutline(), destination, "paragraph " + n);
    }

}