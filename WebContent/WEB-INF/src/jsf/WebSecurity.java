package jsf;

import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import java.security.*;
import phm.ezcounting.*;

public class WebSecurity
{
    private final static String loginIdElementName = "_loginid_";
    private final static String passwordElementName = "_password_";
    private final static String currentUserSessionName = "_curuser_";
    private final static String errorMessageName = "_error-message_";
    private final static String doLoginSubmitName = "_dologinsubmit_";
    private final static String gotoUriName = "_session_gotourl_"; 
    private final static String sessionName = "_phm_session_";
    private final static String bunitsessionName = "_phm_bunit_";
    
    PageContext context;

    public static WebSecurity getInstance(PageContext context)
        throws Exception
    {
        return new WebSecurity(context);
    }

    WebSecurity(PageContext context)
        throws Exception
    {
        this.context = context;

        //## 2009/3/18 by peter, add 分校 stuff
        Session s = getSession();
        if (s==null)
            return;
        String nbuId = context.getRequest().getParameter(bunitsessionName);
        BunitHelper bh = new BunitHelper();
        if (nbuId!=null) {
            int bid = Integer.parseInt(nbuId);
            User u = getCurrentUser();
            if (bh.checkAuthorized(u, bid)) {
                s.setBunitId(bid);
                SessionMgr.getInstance().save(s);
            }
        }

        if (s.getBunitId()<0) // 之前查過了沒有預設
            return;
        if (s.getBunitId()==0) {
            User u = getCurrentUser();
            int bunitId = bh.getDefaultBunitId(u);
            if (bunitId>0) {
                s.setBunitId(bunitId);
            }
            else {
                s.setBunitId(-1);
            }
            SessionMgr.getInstance().save(s);
        }
    }

    public Bunit getSessionBunit()
        throws Exception
    {
        int bunitId = getSessionBunitId();
        return new BunitHelper().getBunit(bunitId);
    }

    public int getSessionStudentBunitId()
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            return bh.getStudentBunitId(s.getBunitId());
        }
        return 0;
    }

    public int getSessionMetaBunitId()
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            return bh.getMetaBunitId(s.getBunitId());
        }
        return 0;
    }

    public int getSessionAcodeBunitId()
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            return bh.getAcodeBunitId(s.getBunitId());
        }
        return 0;
    }

    public int getSessionBunitId()
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0)
            return s.getBunitId();
        return 0;
    }

    public String getStudentBunitSpace(String fieldName)
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            return fieldName + "=" + bh.getStudentBunitId(s.getBunitId());
        }
        return null;
    }

    public String getAcodeBunitSpace(String fieldName)
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            return fieldName + "=" + bh.getAcodeBunitId(s.getBunitId());
        }
        return null;
    }

    public String getMetaBunitSpace(String fieldName)
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            return fieldName + "=" + bh.getMetaBunitId(s.getBunitId());
        }
        return null;
    }

    // 自己加上 cover 單位的 bunit if any
    public String getAcrossBillBunitSpace(String fieldName)
        throws Exception
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0) {
            BunitHelper bh = new BunitHelper();
            int unpaidBunitId = bh.getUnpaidBunitId(s.getBunitId());
            if (unpaidBunitId>0)
                return fieldName + " in (" + s.getBunitId() + "," + unpaidBunitId + ")";
            else
                return fieldName + "=" + s.getBunitId();
        }
        return null;
    }

    public String getBunitSpace(String fieldName)
    {
        Session s = getSession();
        if (s!=null && s.getBunitId()>0)
            return fieldName + "=" + s.getBunitId();
        return null;
    }

    public String getBunitSelector()
        throws Exception
    {
        BunitHelper bh = new BunitHelper();
        User u = getCurrentUser();
        if (u==null)
            return "";
        ArrayList<Bunit> bunits = bh.getMyBunits(u);
        if (bunits==null || bunits.size()<=1) // 一個也不用畫 selector
            return "";
            
        StringBuffer sb = new StringBuffer();
        Enumeration e = context.getRequest().getParameterNames();
        while (e.hasMoreElements()) {
            String name = (String) e.nextElement();
            if (name.equals(bunitsessionName))
                continue;
            sb.append("<input type=hidden name=\""+name+"\" value=\""+context.getRequest().getParameter(name)+"\">");
            sb.append("\n");
        }

        sb.append("<select name=\""+bunitsessionName+"\" onchange=\"this.form.submit()\">");
        Session s = getSession();
        int sbuId = s.getBunitId();
        for (int i=0; i<bunits.size(); i++) {
            int bid = bunits.get(i).getId();
            sb.append("\n<option value=\""+bid+"\""+((bid==sbuId)?" selected":"")+">" + bunits.get(i).getLabel());
        }
        sb.append("\n</select>");
        return sb.toString();
    }

    public boolean doAuthenticate(String loginURI)
        throws Exception
    {
        String tmp;
        
        if (getSession()!=null)
            return true;
        
        String loginId = context.getRequest().getParameter(loginIdElementName);
        String password = context.getRequest().getParameter(passwordElementName);
        boolean loginSubmit = (context.getRequest().getParameter(doLoginSubmitName)!=null);
       
       	UserlogMgr ulogm=UserlogMgr.getInstance();
       	Userlog ul = new Userlog();
        
        UserMgr umgr = UserMgr.getInstance();
        User u = umgr.findLoginId(loginId);
        if (u==null)
        {
            if (loginSubmit)
            {
                context.getSession().setAttribute(errorMessageName, "沒有此使用者");            
            }
            
            if(loginId !=null)
            {
				ul.setUserlogUserId(0);
				ul.setUserlogDate(new Date());
				ul.setUserlogIP(context.getRequest().getRemoteAddr());
				ul.setUserlogHost(context.getRequest().getRemoteHost());
				String logps="嘗試登入帳號:"+loginId+" error:沒有此使用者"; // +" 嘗試登入密碼:"+password
				ul.setUserlogOutPs(logps);
				ulogm.createWithIdReturned(ul);
	    	}
	     	redo_auth(loginURI);       
            return false;
        }
        if (!u.getUserPassword().equals(password))
        {
            context.getSession().setAttribute(errorMessageName, "密碼不正確");
		
			ul.setUserlogUserId(0);
			ul.setUserlogDate(new Date());
			ul.setUserlogIP(context.getRequest().getRemoteAddr());
			ul.setUserlogHost(context.getRequest().getRemoteHost());
			String logps="嘗試登入帳號:"+loginId +" error:密碼不正確"; // +" 嘗試登入密碼:"+password
			ul.setUserlogOutPs(logps);
			ulogm.createWithIdReturned(ul);

            redo_auth(loginURI);
            return false;
        }


        ul.setUserlogUserId(u.getId());
        ul.setUserlogDate   	(new Date());
        ul.setUserlogIP(context.getRequest().getRemoteAddr());
        ul.setUserlogHost(context.getRequest().getRemoteHost());
        userLogin(u);
        Session s = getSession();
        ul.setBunitId(s.getBunitId());
        ulogm.createWithIdReturned(ul);
        return true;
    }

    private String getBase65Md5(String content)
    {
        MessageDigest md = null;
        try
        {
            md = MessageDigest.getInstance("MD5");
        }
        catch (java.security.NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }
        byte[] md5bytes = md.digest(content.getBytes());
        return util.Base64.encodeBytes(md5bytes);        
    }    

    public void userLogin(User u)
    {
        SessionMgr smgr = SessionMgr.getInstance();
        Session s = new Session();
        s.setId(getBase65Md5(u.getId() + "_" + new Date().getTime()));
        s.setUserId(u.getId());
        int bunitId = 0;
        try { bunitId = new BunitHelper().getDefaultBunitId(u); } catch (Exception e) {}
        s.setBunitId(bunitId);
        smgr.create(s);
        setSession(s);
    }

    protected String _getCurrentUrl()
    {
        HttpServletRequest req = (HttpServletRequest) context.getRequest();
        String currentUrl = req.getRequestURI();
        String qstr = req.getQueryString();
        if (qstr!=null)
            currentUrl += "?" + qstr;  
        return currentUrl;
    }
    
    protected void redo_auth(String loginURI)
        throws Exception
    {
        String currentUrl = _getCurrentUrl();    
        setGotoURI(currentUrl);
        context.forward(loginURI);           
    }

    /*
     * get goto uri
     * retrive it from jsp session if same request
     * retrive it from cookie in later requests
     */    
    public String getGotoUri()
    {
        String ret = (String) context.getAttribute(gotoUriName, context.REQUEST_SCOPE);
        if (ret!=null)
            return ret;            
        Cookie[] cks = ((HttpServletRequest)context.getRequest()).getCookies();
        for (int i=0; cks!=null && i<cks.length; i++)
        {
            if (cks[i].getName().equals(gotoUriName))
            {
                ret = cks[i].getValue();
                break;                
            }
        }        
        return ret;
    }

    /**
     * set the goto uri 
     * set it in jsp session in same request
     * also set it in cookies for retrieval in later requests.
     */    
    protected void setGotoURI(String uri)
    {
        Cookie gotoUri = new Cookie(gotoUriName, uri);
        // this is for new requests to the site
        ((HttpServletResponse)context.getResponse()).addCookie(gotoUri);
        // this is for same request 
        context.setAttribute(gotoUriName, uri, context.REQUEST_SCOPE);               
    }
    
    /*
     * get current session
     * retrive it from jsp session if same request
     * retrive it from db in later requests. (session id in cookie, session in db)
     */
    private Session _s = null;
    public Session getSession()
    {  
        if (_s!=null)
            return _s;

        Session ret = (Session) 
            context.getAttribute(sessionName, context.REQUEST_SCOPE);
        if (ret!=null) {
            _s = ret;
            return ret;
        }
            
        Cookie[] cks = ((HttpServletRequest)context.getRequest()).getCookies();
        for (int i=0; cks!=null && i<cks.length; i++)
        {
            if (cks[i].getName().equals(sessionName))
            {
                // try to get session back from db
                String sid = cks[i].getValue();
                SessionMgr smgr = SessionMgr.getInstance();
                ret = findSession(sid);
                break;
            }
        }
        _s = ret;
        return _s;
    }  
    
    Session findSession(String session_id)
    {
        try {
            SessionMgr smgr = SessionMgr.getInstance();
            return smgr.find("id='" + dbo.ServerTool.escapeString(session_id) + "'");
        }
        catch (Exception e) {
            return null;
        }
    }

    public void clearSession()
    { 
        Session s = getSession();
        if (s==null)
            return;
        Object[] objs = { s };
        SessionMgr.getInstance().remove(objs);
        /*
        Cookie sc = new Cookie(sessionName,"");
        sc.setMaxAge(0);
        // this is for new requests to the site
        ((HttpServletResponse)context.getResponse()).addCookie(sc);        
        // this is for same request 
        context.setAttribute(sessionName,null, context.REQUEST_SCOPE);        
        */
    }    

    /**
     * set the session 
     * set it in jsp session in same request
     * also create a session in db for retrieval in later requests.
     */
    protected void setSession(Session s)
    {
        HttpServletRequest req = (HttpServletRequest) context.getRequest();
        String currentUrl = req.getRequestURI();
        String webappPath = "/";
        int c = currentUrl.indexOf("/", 1);
        if (c>0)
            webappPath = currentUrl.substring(0, c);

        Cookie sessionId = new Cookie(sessionName, s.getId());
        sessionId.setPath(webappPath);
        // this is for new requests to the site
        ((HttpServletResponse)context.getResponse()).addCookie(sessionId);        
        // this is for same request 
        context.setAttribute(sessionName, s, context.REQUEST_SCOPE);        
    }
            
    private User _u = null;
    public User getCurrentUser()
    {
        if (_u!=null)
            return _u;
        Session s = getSession();
        if (s==null)
            return null;
        UserMgr umgr = UserMgr.getInstance();
        Object[] objs = umgr.retrieve("id=" + s.getUserId(), "");
        if (objs==null)
            return null;
        _u = (User) objs[0];
        return _u;
    }
    
    public static String getLoginIdElementName()
    {
        return loginIdElementName;
    }
    
    public static String getPasswordElementName()
    {
        return passwordElementName;
    }
    
    public static String getDoLoginSubmitName()
    {
        return doLoginSubmitName;   
    }
    
    public String getErrorMessage()
    {
        return (String) context.getSession().getAttribute(errorMessageName);   
    }

    public void setBookmark(User user, String name)
    {
        BookmarkMgr bmgr = BookmarkMgr.getInstance();
        Bookmark bm = new Bookmark();
        bm.setUserId(user.getId());
        if (name.length()>20) {
            name = name.substring(0,19);
        }
        bm.setName(name);
        bm.setUrl(_getCurrentUrl());
        bmgr.create(bm);
    }
}
