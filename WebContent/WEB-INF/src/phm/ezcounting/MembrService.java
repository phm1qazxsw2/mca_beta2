package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrService
{

    private int   	id;
    private Date   	clientServiceDate;
    private Date   	modified;
    private int   	clientServiceMembrId;
    private int   	clientServiceUserId;
    private int   	clientServiceStatus;
    private int   	clientServiceStar;
    private int   	clientServiceProcess;
    private int   	clientServiceType;
    private String   	clientServiceTitle;
    private String   	clientServiceContent;
    private int   	clientServiceLogId;
    private Date   	clientServiceWarningDate;
    private int   	clientServiceWarningStatus;


    public MembrService() {}


    public int   	getId   	() { return id; }
    public Date   	getClientServiceDate   	() { return clientServiceDate; }
    public Date   	getModified   	() { return modified; }
    public int   	getClientServiceMembrId   	() { return clientServiceMembrId; }
    public int   	getClientServiceUserId   	() { return clientServiceUserId; }
    public int   	getClientServiceStatus   	() { return clientServiceStatus; }
    public int   	getClientServiceStar   	() { return clientServiceStar; }
    public int   	getClientServiceProcess   	() { return clientServiceProcess; }
    public int   	getClientServiceType   	() { return clientServiceType; }
    public String   	getClientServiceTitle   	() { return clientServiceTitle; }
    public String   	getClientServiceContent   	() { return clientServiceContent; }
    public int   	getClientServiceLogId   	() { return clientServiceLogId; }
    public Date   	getClientServiceWarningDate   	() { return clientServiceWarningDate; }
    public int   	getClientServiceWarningStatus   	() { return clientServiceWarningStatus; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setClientServiceDate   	(Date clientServiceDate) { this.clientServiceDate = clientServiceDate; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClientServiceMembrId   	(int clientServiceMembrId) { this.clientServiceMembrId = clientServiceMembrId; }
    public void 	setClientServiceUserId   	(int clientServiceUserId) { this.clientServiceUserId = clientServiceUserId; }
    public void 	setClientServiceStatus   	(int clientServiceStatus) { this.clientServiceStatus = clientServiceStatus; }
    public void 	setClientServiceStar   	(int clientServiceStar) { this.clientServiceStar = clientServiceStar; }
    public void 	setClientServiceProcess   	(int clientServiceProcess) { this.clientServiceProcess = clientServiceProcess; }
    public void 	setClientServiceType   	(int clientServiceType) { this.clientServiceType = clientServiceType; }
    public void 	setClientServiceTitle   	(String clientServiceTitle) { this.clientServiceTitle = clientServiceTitle; }
    public void 	setClientServiceContent   	(String clientServiceContent) { this.clientServiceContent = clientServiceContent; }
    public void 	setClientServiceLogId   	(int clientServiceLogId) { this.clientServiceLogId = clientServiceLogId; }
    public void 	setClientServiceWarningDate   	(Date clientServiceWarningDate) { this.clientServiceWarningDate = clientServiceWarningDate; }
    public void 	setClientServiceWarningStatus   	(int clientServiceWarningStatus) { this.clientServiceWarningStatus = clientServiceWarningStatus; }

}
