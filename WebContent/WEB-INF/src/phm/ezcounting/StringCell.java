package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class StringCell
{

    private int   	colspan;
    private int   	rowspan;
    private String   	cell;
    private String   	htmlCellattibute;
    private int   	excelCellattibute;
    private int   	excelAlign;
    private int   	excelVAlign;


    public StringCell() {}


    public int   	getColspan   	() { return colspan; }
    public int   	getRowspan   	() { return rowspan; }
    public String   	getCell   	() { return cell; }
    public String   	getHtmlCellattibute   	() { return htmlCellattibute; }
    public int   	getExcelCellattibute   	() { return excelCellattibute; }
    public int   	getExcelAlign   	() { return excelAlign; }
    public int   	getExcelVAlign   	() { return excelVAlign; }


    public void 	setColspan   	(int colspan) { this.colspan = colspan; }
    public void 	setRowspan   	(int rowspan) { this.rowspan = rowspan; }
    public void 	setCell   	(String cell) { this.cell = cell; }
    public void 	setHtmlCellattibute   	(String htmlCellattibute) { this.htmlCellattibute = htmlCellattibute; }
    public void 	setExcelCellattibute   	(int excelCellattibute) { this.excelCellattibute = excelCellattibute; }
    public void 	setExcelAlign   	(int excelAlign) { this.excelAlign = excelAlign; }
    public void 	setExcelVAlign   	(int excelVAlign) { this.excelVAlign = excelVAlign; }

}
