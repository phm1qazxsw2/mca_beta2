package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VitemSum
{

    private int   	total;
    private int   	realized;


    public VitemSum() {}


    public int   	getTotal   	() { return total; }
    public int   	getRealized   	() { return realized; }


    public void 	setTotal   	(int total) { this.total = total; }
    public void 	setRealized   	(int realized) { this.realized = realized; }

}
