<%/*
----------------------------------------------------------------------------------
File Name		: tra134r
Author			: north
Description		: TRA134R_列印統一面授批閱教師需求統計表 - 主要頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		097/07/29	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/titleSetup.jsp"%>
<%@ page import="com.nou.sys.SYSGETSMSDATA"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nou.aut.AUTGETRANGE"%>
<%@ page import="java.util.Vector"%>

<%
	// 預設學年期
	String	keyParam	=	"";
	MyLogger log = new MyLogger("TRA134R");
	DBManager db = new DBManager(log);
	SYSGETSMSDATA sys = new SYSGETSMSDATA(db);
	
	//取得現在的日期,並設定在sys中
	java.util.Calendar cal = java.util.Calendar.getInstance();	
	SimpleDateFormat smipleDate = new SimpleDateFormat("yyyyMMdd");
	String nowDate = smipleDate.format(cal.getTime());
	sys.setSYS_DATE(nowDate);
	sys.setSMS_TYPE("1");  //1.當期 2.前期 3.後期 4.前學年 5.後學年
	
	//在參數中加入學年,學期參數
	int result = sys.execute();
	if(result==1)
	{
		String ayear = sys.getAYEAR();
		String sms = sys.getSMS();
		keyParam		= "?AYEAR="+ayear+"&SMS="+sms;
	}
	
	// 判斷身份別是否有學系身份,有則僅顯示該學系,如無則顯示所有
	String user_id = (String) session.getAttribute("USER_ID");
	AUTGETRANGE aut = new com.nou.aut.AUTGETRANGE();
	aut.initRangeData(user_id);
	
	// 學系行政人員
	Vector facultyVt = aut.getDEP_CODE("2","3");
	
	String facultyCondition = "";
	// 如為學系行政人員,則僅顯示該登入者所擁有的學系
	if( facultyVt.size()>0)
	{
		facultyCondition = "AND FACULTY_CODE IN (''";
		for(int i=0;i<facultyVt.size();i++)
			facultyCondition+=",'"+facultyVt.get(i)+"'";
		facultyCondition+=") ";
	}
	// 如為全校行政人員則顯示所有學系,否則不顯示
	else if(aut.getDEP_CODE("3","3").size()==0)
		facultyCondition = "AND FACULTY_CODE IN ('') ";
	
	// 學期
	session.setAttribute("TRA134R_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='SMS' AND CODE != '3' ORDER BY SELECT_VALUE, SELECT_TEXT ");
	// 學系
	session.setAttribute("TRA134R_02_SELECT", "NOU#SELECT FACULTY_CODE AS SELECT_VALUE, FACULTY_NAME AS SELECT_TEXT FROM SYST003 WHERE 1=1 "+facultyCondition+" ORDER BY SELECT_VALUE, SELECT_TEXT ");
%>


<script>
	top.hideView();
	/** 導向第一個處理的頁面 */
	top.mainFrame.location.href	=	'tra134r_01v1.jsp<%= keyParam %>';
</script>