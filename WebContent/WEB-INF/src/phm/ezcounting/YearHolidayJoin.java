package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class YearHolidayJoin
{

    private int   	id;
    private Date   	created;
    private String   	name;
    private Date   	startDate;
    private Date   	endDate;
    private int   	membrId;
    private int   	yearHolidayId;
    private int   	mins;
    private int   	overtime;
    private int   	userId;


    public YearHolidayJoin() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public String   	getName   	() { return name; }
    public Date   	getStartDate   	() { return startDate; }
    public Date   	getEndDate   	() { return endDate; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getYearHolidayId   	() { return yearHolidayId; }
    public int   	getMins   	() { return mins; }
    public int   	getOvertime   	() { return overtime; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStartDate   	(Date startDate) { this.startDate = startDate; }
    public void 	setEndDate   	(Date endDate) { this.endDate = endDate; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setYearHolidayId   	(int yearHolidayId) { this.yearHolidayId = yearHolidayId; }
    public void 	setMins   	(int mins) { this.mins = mins; }
    public void 	setOvertime   	(int overtime) { this.overtime = overtime; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

}
