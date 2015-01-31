package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;

public class Delta implements Comparable
{
    public int amount;
    public Date date;
    public int type; // 0: duedate, 1:paiddate

    Delta(int type, int amount, Date date) {
        this.type = type;
        this.amount = amount;
        this.date = date;
    }

    public int compareTo(Object o) {
        return this.date.compareTo(((Delta)o).date);
    }
}
