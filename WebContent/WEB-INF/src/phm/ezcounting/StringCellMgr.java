package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class StringCellMgr extends dbo.Manager<StringCell>
{
    private static StringCellMgr _instance = null;

    StringCellMgr() {}

    public synchronized static StringCellMgr getInstance()
    {
        if (_instance==null) {
            _instance = new StringCellMgr();
        }
        return _instance;
    }

    public StringCellMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "stringcell";
    }

    protected Object makeBean()
    {
        return new StringCell();
    }

    protected String getIdentifier(Object obj)
    {
        StringCell o = (StringCell) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        StringCell item = (StringCell) obj;
        try {
            int	colspan		 = rs.getInt("colspan");
            item.setColspan(colspan);
            int	rowspan		 = rs.getInt("rowspan");
            item.setRowspan(rowspan);
            String	cell		 = rs.getString("cell");
            item.setCell(cell);
            String	htmlCellattibute		 = rs.getString("htmlCellattibute");
            item.setHtmlCellattibute(htmlCellattibute);
            int	excelCellattibute		 = rs.getInt("excelCellattibute");
            item.setExcelCellattibute(excelCellattibute);
            int	excelAlign		 = rs.getInt("excelAlign");
            item.setExcelAlign(excelAlign);
            int	excelVAlign		 = rs.getInt("excelVAlign");
            item.setExcelVAlign(excelVAlign);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getSaveString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        StringCell item = (StringCell) obj;

        String ret = 
            "colspan=" + item.getColspan()
            + ",rowspan=" + item.getRowspan()
            + ",cell='" + ServerTool.escapeString(item.getCell()) + "'"
            + ",htmlCellattibute='" + ServerTool.escapeString(item.getHtmlCellattibute()) + "'"
            + ",excelCellattibute=" + item.getExcelCellattibute()
            + ",excelAlign=" + item.getExcelAlign()
            + ",excelVAlign=" + item.getExcelVAlign()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "colspan,rowspan,cell,htmlCellattibute,excelCellattibute,excelAlign,excelVAlign";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        StringCell item = (StringCell) obj;

        String ret = 
            "" + item.getColspan()
            + "," + item.getRowspan()
            + ",'" + ServerTool.escapeString(item.getCell()) + "'"
            + ",'" + ServerTool.escapeString(item.getHtmlCellattibute()) + "'"
            + "," + item.getExcelCellattibute()
            + "," + item.getExcelAlign()
            + "," + item.getExcelVAlign()

        ;
        return ret;
    }
}
