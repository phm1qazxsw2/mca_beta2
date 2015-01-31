package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class AdditionalFee
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	additionalFeeOriginal;
    private int   	additionalFeeAddition;
    private int   	additionalFeeActive;
    private String   	additionalFeePs;


    public AdditionalFee() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	additionalFeeOriginal,
        int	additionalFeeAddition,
        int	additionalFeeActive,
        String	additionalFeePs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.additionalFeeOriginal 	 = additionalFeeOriginal;
        this.additionalFeeAddition 	 = additionalFeeAddition;
        this.additionalFeeActive 	 = additionalFeeActive;
        this.additionalFeePs 	 = additionalFeePs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getAdditionalFeeOriginal   	() { return additionalFeeOriginal; }
    public int   	getAdditionalFeeAddition   	() { return additionalFeeAddition; }
    public int   	getAdditionalFeeActive   	() { return additionalFeeActive; }
    public String   	getAdditionalFeePs   	() { return additionalFeePs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAdditionalFeeOriginal   	(int additionalFeeOriginal) { this.additionalFeeOriginal = additionalFeeOriginal; }
    public void 	setAdditionalFeeAddition   	(int additionalFeeAddition) { this.additionalFeeAddition = additionalFeeAddition; }
    public void 	setAdditionalFeeActive   	(int additionalFeeActive) { this.additionalFeeActive = additionalFeeActive; }
    public void 	setAdditionalFeePs   	(String additionalFeePs) { this.additionalFeePs = additionalFeePs; }
}
