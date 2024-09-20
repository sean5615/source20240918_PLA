<%/*
----------------------------------------------------------------------------------
File Name		: tra134r_01m1.jsp
Author			: north
Description		: TRA134R_列印統一面授批閱教師需求統計表 - 處理邏輯頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		097/07/29	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@page import="com.nou.tra.dao.*"%>
<%@page import="com.nou.sys.dao.*"%>

<%!
/** 處理列印功能 */
private void doPrint(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	DBResult rs = null;
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		
		/** 初始化 rptFile */
		RptFile		rptFile	=	new RptFile(session.getId());
		rptFile.setColumn("表身_1,表身_2,表身_3,表身_4,表身_5,表身_6,表身_7,表身_8,表身_9,表身_10,表身_11,表身_12,表身_13,表身_14,表身_15,表身_16,表身_17,表身_18,表身_19,表身_20,表身_21,表身_22,表身_23,表身_24,表身_25,表身_26,表身_27,表身_28,表身_29,表身_30,表身_31,表身_32,表身_33,表身_34,表身_35,表身_36,表身_37,表身_38,表身_39,表身_40,表身_41,表身_42,表身_43,表身_44,表身_45,表身_46,表身_47,表身_48,表身_49,表身_50,表身_51,表身_52,表身_53");
								
		// 共有多少科目要列印
		TRAT008GATEWAY	 trat008	=	new  TRAT008GATEWAY(dbManager, conn);
		Vector crsnoData = trat008.getCrsnoCountForTra134r(requestMap);
				
		int[] totalCrsnoCount = new int[3]; // 將所有科目的擬聘人數  已聘人數  不足人數 累加起來
		int crsnoCount = 0; // 計算共列印多少筆資料,用來換頁的 
		int pageRowCount = 7; // 每頁多少科換頁
		// 一個迴圈表示一個科目
		for(int j=0; j<crsnoData.size(); j++){
			Hashtable crsnoDataHt = (Hashtable)crsnoData.get(j);
		
			// 先將該科的所有空格塞0...JDK為1.4  所以不能用int[][]
			String[][] printData = inputZeroToDoubleArray(3,17);  // 產生一個預設值為0的3x15的陣列(表示一科的資料) 

			// 主要列印資料
			System.out.println("i:"+j+"----CRSNO_KIND:"+Utility.nullToSpace(crsnoDataHt.get("CRSNO_KIND")));
			requestMap.put("CRSNO_KIND",Utility.nullToSpace(crsnoDataHt.get("CRSNO_KIND")));
			Vector printMainData = trat008.getDataForTra134r(requestMap, crsnoDataHt.get("CRSNO").toString(),crsnoDataHt.get("JOB_TYPE").toString());
			String crsName = ""; // 該列科目名稱
			int[] thisCrsnoCount = new int[3]; // 將該科目的擬聘人數  已聘人數  不足人數 累加起來
			// 將有資料的部份放入陣列中,最後放好之後將所有陣列的值直接顯示於報表中			
			for(int i=0; i<printMainData.size(); i++){
				Hashtable content = (Hashtable)printMainData.get(i);
				int centerCode = Integer.parseInt(content.get("CENTER_CODE").toString());
				String planEmpNum = content.get("PLAN_EMP_NUM").toString().equals("")?"0":content.get("PLAN_EMP_NUM").toString(); // 擬聘教師人數(TRAT008)
				String totalTeacherNum = content.get("TOTAL_TEACHER_NUM").toString().equals("")?"0":content.get("TOTAL_TEACHER_NUM").toString(); // 已聘教師人數(TRAT006)
				// 不足人數
				String notEnoughNum = (Integer.parseInt(planEmpNum)-Integer.parseInt(totalTeacherNum))<0?"0":(Integer.parseInt(planEmpNum)-Integer.parseInt(totalTeacherNum))+"";
				crsName = content.get("CRS_NAME").toString(); // 這個迴圈內的科目名稱均相同
				System.out.println("centerCode="+centerCode);
				printData[0][centerCode]=planEmpNum; // 擬聘,校本部起
				printData[1][centerCode]=totalTeacherNum; // 已聘,校本部起
				printData[2][centerCode]=notEnoughNum; // 不足,校本部起
				
				// 累加各中心的擬聘 已聘 不足人數
				thisCrsnoCount[0]+=Integer.parseInt(planEmpNum);
				thisCrsnoCount[1]+=Integer.parseInt(totalTeacherNum);
				thisCrsnoCount[2]+=Integer.parseInt(notEnoughNum);
			}
			
			// 將陣列放入報表中
			rptFile.add(crsName+"&nbsp;"); // 科目名稱
			inputDataToReport(rptFile, printData, thisCrsnoCount); // 主要資料內容
			
			 // 進行換頁
			if(crsnoCount%pageRowCount==0&&crsnoCount!=0)
				crsnoCount++;
			
			rptFile.add(crsnoCount);
			
			// 累加各科的擬聘 已聘 不足人數
			totalCrsnoCount[0]+=thisCrsnoCount[0];
			totalCrsnoCount[1]+=thisCrsnoCount[1];
			totalCrsnoCount[2]+=thisCrsnoCount[2];
		}
	
		if (rptFile.size() == 0)
		{
			out.println("<script>top.close();alert(\"無符合資料可供列印!!\");</script>");
			return;
		}

		/** 初始化報表物件 */
		report		report_	=	new report(dbManager, conn, out, "tra134r_01r1", report.onlineHtmlMode);

		/** 靜態變數處理 */
		// 學系中文
		SYST003DAO syst003 = new SYST003DAO(dbManager,conn);
		syst003.setResultColumn("FACULTY_NAME");
		syst003.setASYS("1");
		syst003.setFACULTY_CODE(requestMap.get("FACULTY_CODE").toString());
		rs = syst003.query();
		
		String facultyName = "";
		if(rs.next())
			facultyName = rs.getString("FACULTY_NAME");
		rs.close();
		
		SYST001GATEWAY syst001 = new SYST001GATEWAY(dbManager, conn);
		String ayear = Integer.parseInt(Utility.checkNull(requestMap.get("AYEAR"), ""))+"";	
		String sms = syst001.getCodeAndCodeNameForUse("SMS", Utility.checkNull(requestMap.get("SMS"), ""));
		
		Hashtable	ht	=	new Hashtable();
		ht.put("表頭_1", ayear);
		ht.put("表頭_2", sms);
		//if (requestMap.get("SMS").equals("3"))
		   ht.put("表頭_3",facultyName+"批閱");
		//else
		//   ht.put("表頭_3",facultyName+"面授暨實習");
		
		ht.put("末頁表尾_1",totalCrsnoCount[0]+"");
		ht.put("末頁表尾_2",totalCrsnoCount[1]+"");
		ht.put("末頁表尾_3",totalCrsnoCount[2]+"");
		
		
		report_.setDynamicVariable(ht);

		/** 開始列印 */
		report_.genReport(rptFile);
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		if(rs!=null)
			rs.close();
		dbManager.close();
	}
}

// 將陣列塞0作為預設值   row-->多少列列    col-->多少欄位
private String[][] inputZeroToDoubleArray(int row, int col)throws Exception{
	String[][] result = new String[row][col] ;
	
	// 高度
	for(int i=0; i<result.length; i++){
		// 某列的欄位數
		for(int j=0; j<result[i].length; j++)
			result[i][j]="0";
	}
	
	return result;
}

// 將單一科目的陣列塞入報表中
private void inputDataToReport(RptFile reportFile, String[][] eachCrsno, int[] eachCrsnoNum)throws Exception{
	// 每科顯示的高度(3個--擬聘-已聘-不足)
	for(int i=0; i<eachCrsno.length; i++){
		// 某列的欄位數
		for(int j=0; j<eachCrsno[i].length; j++){
			// 該科總計
			if(j==eachCrsno[i].length-1)
				reportFile.add(eachCrsnoNum[i]);
			else
				reportFile.add(eachCrsno[i][j]);  // 將各中心該科目的擬聘 已聘 不足人數放入報表中
		}
	}
}

%>