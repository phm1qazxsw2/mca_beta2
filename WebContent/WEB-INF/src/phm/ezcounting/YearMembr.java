package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class YearMembr
{

    private int   	id;
    private Date   	created;
    private int   	membrId;
    private int   	yearHolidayId;
    private int   	mins;
    private int   	overtime;
    private int   	userId;


    public YearMembr() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getYearHolidayId   	() { return yearHolidayId; }
    public int   	getMins   	() { return mins; }
    public int   	getOvertime   	() { return overtime; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setYearHolidayId   	(int yearHolidayId) { this.yearHolidayId = yearHolidayId; }
    public void 	setMins   	(int mins) { this.mins = mins; }
    public void 	setOvertime   	(int overtime) { this.overtime = overtime; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

}
