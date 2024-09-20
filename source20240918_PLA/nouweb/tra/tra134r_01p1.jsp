<%/*
----------------------------------------------------------------------------------
File Name		: tra134r_01m1.jsp
Author			: north
Description		: TRA134R_列印統一面授批閱教師需求統計表 - 列印頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		097/07/29	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/printpageinit.jsp"%>
<%@ include file="tra134r_01m1.jsp"%>

<%
try
{
	/** 起始 Log */
	logger		=	new MyLogger(request.getRequestURI().toString() + "(PRINT_MODE)");
	logger.iniUserInfo(Log4jInit.getIP(request));
	
	/** 起始 DBManager Container */
	dbManager	=	new DBManager(logger);
	
	/** 處理列印 */
	doPrint(out, dbManager, requestMap, session);
}
catch(Exception ex)
{
	logErrMessage(ex, logger);
	throw ex;
}
finally
{
	try
	{
		com.nou.aut.AUTLOG	autlog	=	new com.nou.aut.AUTLOG(dbManager);
		autlog.setUSER_ID((String)session.getAttribute("USER_ID"));
		autlog.setPROG_CODE("tra134r");
		autlog.setUPD_MK("5");
		autlog.setIP_ADDR(Log4jInit.getIP(request));
		autlog.execute();
		
		dbManager.close();
	}
	catch(Exception ex)
	{
		logErrMessage(ex, logger);
		throw ex;
	}
	
	if (logger != null)
	{
		long	endTime	=	System.currentTimeMillis();
		logger.append("全部執行時間：" + String.valueOf(endTime - startTime) + " ms");
		logger.log();
	}
	
	requestMap	=	null;
	logger		=	null;
}
%>