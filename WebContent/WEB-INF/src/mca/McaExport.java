package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaExport
{

    private int   	id;
    private Date   	exportTime;


    public McaExport() {}


    public int   	getId   	() { return id; }
    public Date   	getExportTime   	() { return exportTime; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setExportTime   	(Date exportTime) { this.exportTime = exportTime; }

}
