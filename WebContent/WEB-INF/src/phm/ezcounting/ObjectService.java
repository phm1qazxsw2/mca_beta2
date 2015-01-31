package phm.ezcounting;

import dbo.*;
import java.lang.reflect.*;

public class ObjectService
{
    public static Object find(String objName, String cond) 
        throws Exception
    {
        Class c = Class.forName(objName + "Mgr");
        Class[] types1 = {};
        Method m = c.getMethod("getInstance", types1);
        Object[] params1 = {};
        Object o = m.invoke(c, params1);

        Class[] types = { Class.forName("java.lang.String"), Class.forName("java.lang.String") };
        Object[] params = { cond, "" };
        m = c.getMethod("retrieve", types);
        Object o2 = m.invoke(o, params);
        if (o2==null)
            return null;
        Object[] ret = (Object[]) o2;
        if (ret.length>1)
            throw new Exception(objName + " on [" + cond + "] not unique");
        return ret[0];
    }


}
