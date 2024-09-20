package com.nou.tra.dao;

import com.acer.db.DBManager;
import com.acer.db.query.DBResult;
import com.acer.util.Utility;
import com.acer.apps.Page;

import java.sql.Connection;
import java.util.Vector;
import java.util.Hashtable;

/*
 * (TRAT008) Gateway/*
 *-------------------------------------------------------------------------------*
 * Author    : 國長      2007/05/04
 * Modification Log :
 * Vers     Date           By             Notes
 *--------- -------------- -------------- ----------------------------------------
 * V0.0.1   2007/05/04     國長           建立程式
 *                                        新增 getTrat008ForUse(Hashtable ht)
 * V0.0.2   2007/06/21     國長           新增 getTRA002M_QUERY(Hashtable ht)
 *--------------------------------------------------------------------------------
 */
public class TRAT008GATEWAY {

    /** 資料排序方式 */
    private String orderBy = "";
    private DBManager dbmanager = null;
    private Connection conn = null;
    /* 頁數 */
    private int pageNo = 0;
    /** 每頁筆數 */
    private int pageSize = 0;

    /** 記錄是否分頁 */
    private boolean pageQuery = false;

    /** 用來存放 SQL 語法的物件 */
    private StringBuffer sql = new StringBuffer();

    /** <pre>
     *  設定資料排序方式.
     *  Ex: "AYEAR, SMS DESC"
     *      先以 AYEAR 排序再以 SMS 倒序序排序
     *  </pre>
     */
    public void setOrderBy(String orderBy) {
        if(orderBy == null) {
            orderBy = "";
        }
        this.orderBy = orderBy;
    }

    /** 取得總筆數 */
    public int getTotalRowCount() {
        return Page.getTotalRowCount();
    }

    /** 不允許建立空的物件 */
    private TRAT008GATEWAY() {}

    /** 建構子，查詢全部資料用 */
    public TRAT008GATEWAY(DBManager dbmanager, Connection conn) {
        this.dbmanager = dbmanager;
        this.conn = conn;
    }

    /** 建構子，查詢分頁資料用 */
    public TRAT008GATEWAY(DBManager dbmanager, Connection conn, int pageNo, int pageSize) {
        this.dbmanager = dbmanager;
        this.conn = conn;
        this.pageNo = pageNo;
        this.pageSize = pageSize;
        pageQuery = true;
    }

    /**
     *
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getTrat008ForUse(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
            "SELECT T08.AYEAR, T08.SMS, T08.CENTER_CODE, T08.CRSNO, T08.FACULTY_CODE, T08.PLAN_EMP_NUM, T08.UPD_USER_ID, T08.UPD_DATE, T08.UPD_TIME, T08.UPD_MK, T08.ROWSTAMP " +
            "FROM TRAT008 T08 " +
            "WHERE 1 = 1 "
        );
        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append("AND T08.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append("AND T08.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append("AND T08.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRSNO")).equals("")) {
            sql.append("AND T08.CRSNO = '" + Utility.nullToSpace(ht.get("CRSNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("FACULTY_CODE")).equals("")) {
            sql.append("AND T08.FACULTY_CODE = '" + Utility.nullToSpace(ht.get("FACULTY_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PLAN_EMP_NUM")).equals("")) {
            sql.append("AND T08.PLAN_EMP_NUM = '" + Utility.nullToSpace(ht.get("PLAN_EMP_NUM")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_USER_ID")).equals("")) {
            sql.append("AND T08.UPD_USER_ID = '" + Utility.nullToSpace(ht.get("UPD_USER_ID")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_DATE")).equals("")) {
            sql.append("AND T08.UPD_DATE = '" + Utility.nullToSpace(ht.get("UPD_DATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_TIME")).equals("")) {
            sql.append("AND T08.UPD_TIME = '" + Utility.nullToSpace(ht.get("UPD_TIME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_MK")).equals("")) {
            sql.append("AND T08.UPD_MK = '" + Utility.nullToSpace(ht.get("UPD_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ROWSTAMP")).equals("")) {
            sql.append("AND T08.ROWSTAMP = '" + Utility.nullToSpace(ht.get("ROWSTAMP")) + "' ");
        }

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "T08." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }

        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                result.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return result;
    }

    /**
     *
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getTRA002M_QUERY(Hashtable ht) throws Exception {
        if(ht == null) 
            ht = new Hashtable();

        Vector result = new Vector();
        if(sql.length() > 0)
            sql.delete(0, sql.length());
        
		sql.append("SELECT DISTINCT C01.PLAN_FACULTY_CODE as FACULTY_CODE,C01.AYEAR,C01.SMS,S01.CODE_NAME AS SMS_NAME,C01.CRSNO,C01.OPEN1, "
				+ "	C02.CRS_NAME || DECODE('"
				+ Utility.dbStr(ht.get("JOB_TYPE"))
				+ "','51','','71','','(實習)') || DECODE(C01.open1||C01.open3,'YN','','YY','　(含多次面授)','NY','　(多次面授)')  AS CRS_NAME, "
				+ "	T08.PLAN_EMP_NUM, T09.PSN_NUM, T08.CENTER_CODE, S02.CENTER_NAME,R01.SEL_NUM "
				+ "FROM COUT001 C01 "
				+ "JOIN COUT002 C02 ON C01.CRSNO=C02.CRSNO "
				+ "LEFT JOIN TRAT008 T08 ON C01.AYEAR=T08.AYEAR AND C01.SMS=T08.SMS AND C01.CRSNO=T08.CRSNO AND T08.CENTER_CODE='"
				+ Utility.nullToSpace(ht.get("CENTER_CODE"))
				+ "' "
				+ "JOIN SYST001 S01 ON S01.KIND='SMS' AND C01.SMS=S01.CODE "
				+ "LEFT JOIN SYST002 S02 ON T08.CENTER_CODE=S02.CENTER_CODE "
				+ "LEFT JOIN  ( "
				+ "	SELECT CRSNO, COUNT(1) AS PSN_NUM "
				+ "	FROM TRAT009 "
				+ "	WHERE 	AYEAR = '"
				+ Utility.nullToSpace(ht.get("AYEAR"))
				+ "' 	AND SMS = '"
				+ Utility.nullToSpace(ht.get("SMS"))
				+ "' 	AND CENTER_CODE = '"
				+ Utility.nullToSpace(ht.get("CENTER_CODE"))
				+ "' 	AND JOB_TYPE = '"
				+ Utility.nullToSpace(ht.get("JOB_TYPE"))
				+ "' GROUP BY CRSNO "
				+ ") T09 ON C01.CRSNO=T09.CRSNO "
				+ "LEFT JOIN ( "
				+ "	SELECT REGT007.CRSNO ,COUNT(1) AS SEL_NUM "
				+ " 	FROM REGT007,STUT003 "
				+ " 	WHERE  "
				+ "		REGT007.AYEAR = '"
				+ Utility.nullToSpace(ht.get("AYEAR"))
				+ "'  	AND REGT007.SMS = '"
				+ Utility.nullToSpace(ht.get("SMS"))
				+ "'   	AND STUT003.STNO = REGT007.STNO  "
				+ " 	AND STUT003.CENTER_CODE = '"
				+ Utility.nullToSpace(ht.get("CENTER_CODE"))
				+ "'  	GROUP BY REGT007.CRSNO "
				+ ") R01 ON C01.CRSNO=R01.CRSNO "
				+ "WHERE 1=1 "
				//+ "	 C01.EST_RESULT_MK = 'Y'  "
				+ "AND C01.CRS_STATUS = '5'  "
				+ "AND C01.AYEAR = '"
				+ Utility.nullToSpace(ht.get("AYEAR"))
				+ "' AND C01.SMS = '"
				+ Utility.nullToSpace(ht.get("SMS"))
				+ "' ");

        if(!Utility.checkNull(ht.get("FACULTY_CODE"), "").equals(""))
			sql.append("AND C01.PLAN_FACULTY_CODE = '"
					+ Utility.dbStr(ht.get("FACULTY_CODE")) + "'  ");
        if(!Utility.checkNull(ht.get("CRSNO"), "").equals(""))
			sql.append("AND C02.CRSNO = '" + Utility.dbStr(ht.get("CRSNO"))
					+ "'  ");
        if(!Utility.checkNull(ht.get("JOB_TYPE"), "").equals(""))
			sql.append("AND (T08.JOB_TYPE = '"
					+ Utility.dbStr(ht.get("JOB_TYPE"))
					+ "' OR T08.JOB_TYPE IS NULL)  ");
                    
        // 工作類別  51:面授教師/批閱教師(即COUT001面授次數>0)  實習教師(COUT001實習次數>0)  71:批閱教師(or COUT001統一面授教學=34)
        if(ht.get("JOB_TYPE").toString().equals("51"))
			sql.append("AND C01.TUT_TIMES > 0  ");
        else if(ht.get("JOB_TYPE").toString().equals("52"))
			sql.append("AND C01.LAB_TIMES > 0  ");
        else if(ht.get("JOB_TYPE").toString().equals("71"))
			sql.append("OR C01.TEACHING_TYPE_NAME = '34'   ");
      /**  
        sql.append(" UNION ALL  ");
		sql.append("SELECT DISTINCT C01.PLAN_FACULTY_CODE as FACULTY_CODE,C01.AYEAR,C01.SMS,S01.CODE_NAME AS SMS_NAME,C01.CRSNO,  "
				+ "	C02.CRS_NAME || '(二軌)' AS CRS_NAME, T08.PLAN_EMP_NUM, T09.PSN_NUM, T08.CENTER_CODE, S02.CENTER_NAME,R01.SEL_NUM  "
				+ "FROM COUT001 C01  "
				+ "JOIN COUT002 C02 ON C01.CRSNO=C02.CRSNO  "
				+ "LEFT JOIN TRAT008 T08 ON C01.AYEAR=T08.AYEAR AND C01.SMS=T08.SMS AND C01.CRSNO=T08.CRSNO AND T08.CENTER_CODE='"
				+ Utility.nullToSpace(ht.get("CENTER_CODE"))
				+ "' "
				+ "LEFT JOIN SYST002 S02 ON T08.CENTER_CODE=S02.CENTER_CODE "
				+ "LEFT JOIN "
				+ "( "
				+ "	SELECT CRSNO, COUNT(1) AS PSN_NUM "
				+ "	FROM TRAT009 "
				+ "	WHERE 		AYEAR = '"
				+ Utility.nullToSpace(ht.get("AYEAR"))
				+ "' 	AND SMS = '"
				+ Utility.nullToSpace(ht.get("SMS"))
				+ "' 	AND CENTER_CODE = '"
				+ Utility.nullToSpace(ht.get("CENTER_CODE"))
				+ "' 	AND JOB_TYPE = '"
				+ Utility.nullToSpace(ht.get("JOB_TYPE"))
				+ "' 	GROUP BY CRSNO "
				+ ") T09 ON C01.CRSNO=T09.CRSNO "
				+ "JOIN SYST001 S01 ON S01.KIND='SMS' AND C01.SMS=S01.CODE "
				+ "LEFT JOIN "
				+ "( 	SELECT REGT007.CRSNO ,COUNT(1) AS SEL_NUM "
				+ " 	FROM REGT007,STUT003 "
				+ " 	WHERE  "
				+ "		REGT007.AYEAR = '"
				+ Utility.nullToSpace(ht.get("AYEAR"))
				+ "'   	AND REGT007.SMS = '"
				+ Utility.nullToSpace(ht.get("SMS"))
				+ "'   	AND STUT003.STNO = REGT007.STNO  "
				+ " 	AND STUT003.CENTER_CODE = '"
				+ Utility.nullToSpace(ht.get("CENTER_CODE"))
				+ "'   	GROUP BY REGT007.CRSNO "
				+ ") R01 ON C01.CRSNO=R01.CRSNO "
				+ "WHERE "
				+ "	 C01.EST_RESULT_MK = 'Y' "
				+ "AND C01.CRS_STATUS = '5' "
				+ "AND C01.AYEAR = '"
				+ Utility.nullToSpace(ht.get("AYEAR"))
				+ "' "
				+ "AND C01.SMS = '"
				+ Utility.nullToSpace(ht.get("SMS"))
				+ "' ");
        
        if(!Utility.checkNull(ht.get("FACULTY_CODE"), "").equals(""))
			sql.append("AND C01.PLAN_FACULTY_CODE = '"
					+ Utility.dbStr(ht.get("FACULTY_CODE")) + "' ");
        if(!Utility.checkNull(ht.get("CRSNO"), "").equals(""))
			sql.append("AND C02.CRSNO = '" + Utility.dbStr(ht.get("CRSNO"))
					+ "' ");
        if(!Utility.checkNull(ht.get("JOB_TYPE"), "").equals(""))
			sql.append("AND (T08.JOB_TYPE = '"
					+ Utility.dbStr(ht.get("JOB_TYPE"))
					+ "' OR T08.JOB_TYPE IS NULL) ");
                
        // 工作類別  51:面授教師(即COUT001面授次數>0)  實習教師(COUT001實習次數>0)
        if(ht.get("JOB_TYPE").toString().equals("51"))
			sql.append("AND C01.OPEN3 = 'Y' ");
        else
			sql.append("AND C01.OPEN3 is null ");
        */
		sql.append("ORDER BY C01.OPEN1 desc,5 ");
        
        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                result.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return result;
    }
    
    /**
    *
    * @param ht 條件值
    * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
    *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
    *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
    * @throws Exception
    */
   public Vector getDataForTra127r(Hashtable ht, String crsno, String job_type) throws Exception {
	   Vector result = new Vector();

       if(sql.length() > 0)
           sql.delete(0, sql.length());

       sql.append(
    		   "select a.crsno,b.CRS_NAME , a.PLAN_EMP_NUM, a.CENTER_CODE,D.TOTAL_TEACHER_NUM,'1' as ORDER_SELECT "+
    		   "from trat008 a, cout002 b,cout001 e,"+
    		   "(select C.CENTER_CODE,C.CRSNO,C.JOB_TYPE,count(1) AS TOTAL_TEACHER_NUM from trat009 C"+
    		   " where c.AYEAR='"+ht.get("AYEAR")+"' "+
    		   " and   c.SMS='"+ht.get("SMS")+"' "+
    		   " and   c.DUTY_CODE=decode(C.sms,'3','07','05') "+
    		   " and   c.TCH_AUDIT_RESULT = '2' "+
    		   " group by  C.CENTER_CODE,C.CRSNO,C.JOB_TYPE) D  "+
    		   "where "+
	    		   "a.AYEAR='"+ht.get("AYEAR")+"' and " +
	    		   "a.SMS='"+ht.get("SMS")+"' and " +
	    		   "a.CRSNO='"+crsno+"' and "+
	    		   "a.JOB_TYPE='"+job_type+"' and "+ 
	    		   "a.JOB_TYPE = decode(a.sms,'3','71','51') AND "+
	    		   "e.AYEAR = a.AYEAR and "+
	    		   "e.SMS = a.SMS and "+
	    		   "e.crsno = a.crsno and "+	    		   
	    		   "e.PLAN_FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' and "+	 
	    		   "e.OPEN3 = 'N' and "+
	    		   "b.CRSNO=a.CRSNO and "+
	    		   "d.CENTER_CODE(+) = a.CENTER_CODE and "+
	    		   "d.crsno(+) = a.crsno and "+
	    		   "d.job_type(+) = a.job_type "
    		   
       );
       
       sql.append(" UNION ALL ");
       
       sql.append(
       "select a.crsno,b.CRS_NAME || '(實習)' AS CRS_NAME, a.PLAN_EMP_NUM, a.CENTER_CODE,D.TOTAL_TEACHER_NUM,'2' as ORDER_SELECT "+
	   "from trat008 a, cout002 b,cout001 e,"+
	   "(select C.CENTER_CODE,C.CRSNO,C.JOB_TYPE,count(1) AS TOTAL_TEACHER_NUM from trat009 C"+
	   " where c.AYEAR='"+ht.get("AYEAR")+"' "+
	   " and   c.SMS='"+ht.get("SMS")+"' "+
	   " and   c.DUTY_CODE=decode(C.sms,'3','07','05') "+
	   " and   c.TCH_AUDIT_RESULT = '2' "+
	   " group by  C.CENTER_CODE,C.CRSNO,C.JOB_TYPE) D  "+
	   "where "+
		   "a.AYEAR='"+ht.get("AYEAR")+"' and " +
		   "a.SMS='"+ht.get("SMS")+"' and " +
		   "a.CRSNO='"+crsno+"' and "+
		   "a.JOB_TYPE='"+job_type+"' and "+
		   "A.JOB_TYPE = '52' AND "+
		   "e.AYEAR = a.AYEAR and "+
		   "e.SMS = a.SMS and "+
		   "e.crsno = a.crsno and "+	    		   
		   "e.PLAN_FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' and "+	 
		   "e.OPEN3 = 'N' and "+
		   "b.CRSNO=a.CRSNO and "+
		   "d.CENTER_CODE(+) = a.CENTER_CODE and "+
		   "d.crsno(+) = a.crsno and "+
		   "d.job_type(+) = a.job_type "	   
       );
       
       sql.append(" UNION ALL ");
       
       if(Utility.nullToSpace(ht.get("CRSNO_KIND")).equals("")){
	       sql.append(
	    		   "select a.crsno,b.CRS_NAME || '(多次面授)' AS CRS_NAME, a.PLAN_EMP_NUM, a.CENTER_CODE,NVL(D.TOTAL_TEACHER_NUM,'0') AS TOTAL_TEACHER_NUM,'3' as ORDER_SELECT "+
	    		   "from trat008 a, cout002 b,cout001 e,"+
	    		   "(select C.CENTER_CODE,C.CRSNO,C.JOB_TYPE,count(1) AS TOTAL_TEACHER_NUM from trat009 C"+
	    		   " where c.AYEAR='"+ht.get("AYEAR")+"' "+
	    		   " and   c.SMS='"+ht.get("SMS")+"' "+
	    		   " and   c.DUTY_CODE=decode(C.sms,'3','07','05') "+
	    		   " and   c.TCH_AUDIT_RESULT = '2' "+
	    		   " group by  C.CENTER_CODE,C.CRSNO,C.JOB_TYPE) D  "+
	    		   "where "+
		    		   "a.AYEAR='"+ht.get("AYEAR")+"' and " +
		    		   "a.SMS='"+ht.get("SMS")+"' and " +
		    		   "a.CRSNO='"+crsno+"' and "+
		    		   "a.JOB_TYPE='"+job_type+"' and "+
		    		   "a.JOB_TYPE = decode(a.sms,'3','71','51') AND "+
		    		   "e.AYEAR = a.AYEAR and "+
		    		   "e.SMS = a.SMS and "+
		    		   "e.crsno = a.crsno and "+	    		   
		    		   "e.PLAN_FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' and "+	 
		    		   "e.OPEN3 = 'Y' and "+
		    		   "b.CRSNO=a.CRSNO and "+
		    		   "d.CENTER_CODE(+) = a.CENTER_CODE and "+
		    		   "d.crsno(+) = a.crsno and "+
		    		   "d.job_type(+) = a.job_type and "+
		    		   "a.CRSNO_KIND is null "
	       );
       }else{
	       sql.append(
	    		   "select a.crsno,b.CRS_NAME||'('||f.CODE_NAME||')' AS CRS_NAME, a.PLAN_EMP_NUM, a.CENTER_CODE,NVL(D.TOTAL_TEACHER_NUM,'0') AS TOTAL_TEACHER_NUM,'4' as ORDER_SELECT "+
	    		   "from trat008 a " +
	    		   "join cout002 b on a.crsno=b.crsno "+
	    		   "join cout001 e on a.ayear=e.ayear and a.sms=e.sms and a.crsno=e.crsno and e.OPEN3='Y' "+    		   
	    		   "left join " +
	    		   "	(" +
	    		   "		select C.CENTER_CODE,C.CRSNO,C.JOB_TYPE,count(1) AS TOTAL_TEACHER_NUM " +
	    		   "		from trat009 C"+
	    		   " 		where c.AYEAR='"+ht.get("AYEAR")+"' "+
	    		   " 		and   c.SMS='"+ht.get("SMS")+"' "+
	    		   " 		and   c.DUTY_CODE=decode(C.sms,'3','07','05') "+
	    		   " 		and   c.TCH_AUDIT_RESULT = '2' "+
	    		   " 		group by  C.CENTER_CODE,C.CRSNO,C.JOB_TYPE" +
	    		   "	) D on a.center_code=d.center_code and a.crsno=d.crsno and a.job_type=d.job_type "+
	    		   "join syst001 f on f.kind='CRSNO_KIND' and a.CRSNO_KIND=f.CODE "+
	    		   "where "+
		    	   "	a.AYEAR='"+ht.get("AYEAR")+"' and " +
		    	   "	a.SMS='"+ht.get("SMS")+"' and " +
		    	   "	a.CRSNO='"+crsno+"' and "+
		    	   "	a.JOB_TYPE='"+job_type+"' and "+
		    	   "	a.JOB_TYPE = decode(a.sms,'3','71','51') AND "+	    
		    	   "    a.plan_emp_num > 0 and "+
		    	   "	e.PLAN_FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' and "+	    		   
		    	   "	a.CRSNO_KIND is not null "
	       );
       }
       sql.append(" ORDER BY 6,4,1 ");
     
       DBResult rs = null;
       try {
    	   rs = dbmanager.getSimpleResultSet(conn);
           rs.open();
           rs.executeQuery(sql.toString());
           
           Hashtable rowHt = null;
           while (rs.next()) {
               rowHt = new Hashtable();
               /** 將欄位抄一份過去 */
               for (int i = 1; i <= rs.getColumnCount(); i++)
                   rowHt.put(rs.getColumnName(i), rs.getString(i));
               result.add(rowHt);
           }
       } catch (Exception e) {
           throw e;
       } finally {
           if(rs != null) {
               rs.close();
           }
       }
       return result;
   }
   
  public Vector getCrsnoCountForTra127r(Hashtable ht) throws Exception {
      Vector result = new Vector();
      
      if(sql.length() > 0)
          sql.delete(0, sql.length());
      
      sql.append(
    	  // CRSNO_KIND IS NULL (原來的)
    	  "select distinct a.CRSNO, a.JOB_TYPE, DECODE(b.OPEN1,'Y','-1','0') as ORDER_SELECT, a.CRSNO_KIND "+ 
    	  "from trat008 a "+
    	  "join cout001 b on a.AYEAR=b.AYEAR and a.SMS=b.SMS and a.CRSNO=b.CRSNO "+
    	  "where "+
    	  "    a.ayear='"+ht.get("AYEAR")+"' "+
    	  "and a.sms='"+ht.get("SMS")+"' "+
    	  "and a.FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' "+
    	  "and a.CRSNO_KIND IS NULL "+
    	  "and a.plan_emp_num > 0 "+
    	  "union "+
    	  "select distinct a.CRSNO, a.JOB_TYPE, TO_CHAR(a.CRSNO_KIND) AS ORDER_SELECT, a.CRSNO_KIND "+ 
    	  "from trat008 a "+
    	  "join cout001 b on a.AYEAR=b.AYEAR and a.SMS=b.SMS and a.CRSNO=b.CRSNO "+
    	  "where "+
    	  "    a.ayear='"+ht.get("AYEAR")+"' "+
    	  "and a.sms='"+ht.get("SMS")+"' "+
    	  "and a.FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' "+
    	  "and a.CRSNO_KIND IS NOT NULL "+
    	  "and a.plan_emp_num > 0 "+
    	  "order by ORDER_SELECT, CRSNO, JOB_TYPE "
      );
      
      System.out.println(sql.toString());
      
      DBResult rs = null;
      try {
    	  rs = dbmanager.getSimpleResultSet(conn);
          rs.open();
          rs.executeQuery(sql.toString());

          Hashtable rowHt = null;
          while (rs.next()) {
              rowHt = new Hashtable();
              /** 將欄位抄一份過去 */
              for (int i = 1; i <= rs.getColumnCount(); i++)
                  rowHt.put(rs.getColumnName(i), rs.getString(i));

              result.add(rowHt);
          }
      } catch (Exception e) {
          throw e;
      } finally {
          if(rs != null)
              rs.close();          
      }
      return result;
  }
  
  public Vector getCrsnoCountForTra134r(Hashtable ht) throws Exception {
      Vector result = new Vector();
      
      if(sql.length() > 0)
          sql.delete(0, sql.length());
      
      sql.append(
    	  // CRSNO_KIND IS NULL (原來的)
    	  "select distinct a.CRSNO, TO_CHAR('71') as JOB_TYPE, DECODE(b.OPEN1,'Y','-1','0') AS ORDER_SELECT, a.CRSNO_KIND "+ 
    	  "from trat008 a "+
    	  "join cout001 b on a.AYEAR=b.AYEAR and a.SMS=b.SMS and a.CRSNO=b.CRSNO and b.teaching_type_name = '34' "+
    	  "where "+
    	  "    a.ayear='"+ht.get("AYEAR")+"' "+
    	  "and a.sms='"+ht.get("SMS")+"' "+
    	  "and a.FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' "+
    	  "and a.plan_emp_num > 0 "+  
    	  "order by ORDER_SELECT, CRSNO, JOB_TYPE "
      );
      
      System.out.println(sql.toString());
      
      DBResult rs = null;
      try {
    	  rs = dbmanager.getSimpleResultSet(conn);
          rs.open();
          rs.executeQuery(sql.toString());

          Hashtable rowHt = null;
          while (rs.next()) {
              rowHt = new Hashtable();
              /** 將欄位抄一份過去 */
              for (int i = 1; i <= rs.getColumnCount(); i++)
                  rowHt.put(rs.getColumnName(i), rs.getString(i));

              result.add(rowHt);
          }
      } catch (Exception e) {
          throw e;
      } finally {
          if(rs != null)
              rs.close();          
      }
      return result;
  }  
  
  /**
  *
  * @param ht 條件值
  * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
  *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
  *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
  * @throws Exception
  */
 public Vector getDataForTra134r(Hashtable ht, String crsno, String job_type) throws Exception {
	   Vector result = new Vector();

     if(sql.length() > 0)
         sql.delete(0, sql.length());

     sql.append(
     "select a.crsno,b.CRS_NAME, (a.total_class_num-a.PLAN_EMP_NUM) as PLAN_EMP_NUM, a.CENTER_CODE,D.TOTAL_TEACHER_NUM,'4' as ORDER_SELECT "+
	   "from trat008 a "+
	   "left join cout002 b on b.CRSNO=a.CRSNO "+
	   "left join cout001 e on e.AYEAR = a.AYEAR and e.SMS = a.SMS and e.crsno = a.crsno and e.teaching_type_name = '34' "+
	   "left join (select C.CENTER_CODE,C.CRSNO,C.JOB_TYPE,count(1) AS TOTAL_TEACHER_NUM from trat009 C "+
	   " where c.AYEAR='"+ht.get("AYEAR")+"' "+
	   " and   c.SMS='"+ht.get("SMS")+"' "+
	   " and   c.DUTY_CODE= '05' "+
	   " and   c.job_type = '71' "+
	   " and   c.TCH_AUDIT_RESULT = '2' "+
	   " group by  C.CENTER_CODE,C.CRSNO,C.JOB_TYPE) D on d.CENTER_CODE = a.CENTER_CODE and d.crsno = a.crsno "+
	   "where "+
		   "a.AYEAR='"+ht.get("AYEAR")+"' and " +
		   "a.SMS='"+ht.get("SMS")+"' and " +
		   "a.CRSNO='"+crsno+"' and "+
		   "A.JOB_TYPE = '51' and "+	    		   
		   "e.PLAN_FACULTY_CODE='"+ht.get("FACULTY_CODE")+"' and "+	 
		   "a.CENTER_CODE='00' and "+	 
		   "e.OPEN3 = 'N'  "	   
     );

     sql.append(" ORDER BY 6,4,1 ");
   
     DBResult rs = null;
     try {
  	   rs = dbmanager.getSimpleResultSet(conn);
         rs.open();
         rs.executeQuery(sql.toString());
         
         Hashtable rowHt = null;
         while (rs.next()) {
             rowHt = new Hashtable();
             /** 將欄位抄一份過去 */
             for (int i = 1; i <= rs.getColumnCount(); i++)
                 rowHt.put(rs.getColumnName(i), rs.getString(i));
             result.add(rowHt);
         }
     } catch (Exception e) {
         throw e;
     } finally {
         if(rs != null) {
             rs.close();
         }
     }
     return result;
 }  
}