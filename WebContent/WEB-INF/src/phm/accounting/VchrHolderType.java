package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VchrHolderType extends VchrHolder
{

    private int   	srcType;


    public VchrHolderType() {}


    public int   	getSrcType   	() { return srcType; }


    public void 	setSrcType   	(int srcType) { this.srcType = srcType; }

}
