<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,phm.ezcounting.*,dbo.*,java.util.*"
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    Vector alltable=new Vector();
    Vector row1=new Vector();
    StringCell sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setCell("a");
    sc.setExcelCellattibute(20);
    sc.setHtmlCellattibute("width=200 height=20");
    row1.add(sc);

    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setExcelCellattibute(10);
    sc.setCell("b");
    row1.add(sc);

    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setExcelCellattibute(50);
    sc.setCell("c");
    row1.add(sc);
    
    alltable.add(row1);

    Vector row2=new Vector();
    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setCell("a");
    row2.add(sc);

    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(2);
    sc.setCell("rows");
    row2.add(sc);

    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setCell("f2");
    row2.add(sc);
    alltable.add(row2);

    Vector row3=new Vector();
    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setCell("excuse me");
    row3.add(sc);

    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setCell("f");
    row3.add(sc);
    alltable.add(row3);


    
    CellPrinter cp=CellPrinter.getInstance();    
    String path=application.getRealPath("/")+"eSystem/exlfile/aaa17.xls";

    // file path ; title ; 文件直式或橫式 ; Vector
    cp.printExcel(path,"henry test",false,alltable);

    String attribute=" border=1 width=95% class=htable";
    out.println(cp.printHTML(attribute,alltable));

%> 
done!




