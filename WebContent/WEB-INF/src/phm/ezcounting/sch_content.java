package phm.ezcounting;

import java.util.*;

public class sch_content 
{
    public int[] days;
    public int startHr;
    public int startMin;
    public int endHr;
    public int endMin;
    public int offtime;
    public int buffer;

    // ## for flexible time ##
    public int type;
    public ArrayList<int[]> flexTime;

    public final static int TYPE_NORMAL = 0;
    public final static int TYPE_FLEXIBLE = 1;

    sch_content(String line, int schdefId, Map<String, sch_content> dayMap) {
        // 1-2-3-4-5,0800-1700,60,10 -> 一～五,8am-5pm, 中間60分鐘休息, 遲到buffer 10分鐘
        // 1-2-3-4-5,(0800-1700 or 0900-1800 or ...),60,10 -> 一～五,8am-5pm, 中間60分鐘休息, 遲到buffer 10分鐘, 彈性時段
        String[] tokens = line.trim().split(",");
        if (tokens[0].length()>0) { // TYPE_DAY_OF_WEEK/MONTH
            String[] day_tokens = tokens[0].split("-");
            days = new int[day_tokens.length];
            for (int i=0; i<day_tokens.length; i++) {
                days[i] = Integer.parseInt(day_tokens[i]);
                String key = schdefId + "#" + days[i];
                dayMap.put(key, this);
            }
        }

        if (tokens[1].charAt(0)=='(') {
            type = TYPE_FLEXIBLE;
            String[] strs = tokens[1].replace("(", "").replace(")","").replace("or","#").replace(" ","").split("#");
            flexTime = new ArrayList<int[]>();
            for (int i=0; i<strs.length; i++) {
                String[] time_tokens = strs[i].split("-");
                int[] tmp = new int[4];
                tmp[0] = Integer.parseInt(time_tokens[0].substring(0,2));
                tmp[1] = Integer.parseInt(time_tokens[0].substring(2));
                tmp[2] = Integer.parseInt(time_tokens[1].substring(0,2));
                tmp[3] = Integer.parseInt(time_tokens[1].substring(2));
                if (i==0) {
                    startHr = tmp[0];
                    startMin = tmp[1];
                    endHr = tmp[2];
                    endMin = tmp[3];
                }
                flexTime.add(tmp);
            }
        }
        else {
            type = TYPE_NORMAL;
            String[] time_tokens = tokens[1].split("-");
            startHr = Integer.parseInt(time_tokens[0].substring(0,2));
            startMin = Integer.parseInt(time_tokens[0].substring(2));
            endHr = Integer.parseInt(time_tokens[1].substring(0,2));
            endMin = Integer.parseInt(time_tokens[1].substring(2));
        }

        offtime = Integer.parseInt(tokens[2]);
        buffer = Integer.parseInt(tokens[3]);
    }
}


