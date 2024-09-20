<%/*
----------------------------------------------------------------------------------
File Name		: tra134r_01m1.jsp
Author			: north
Description		: TRA134R_�C�L�Τ@���§�\�Юv�ݨD�έp�� - �B�z�޿譶��
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
/** �B�z�C�L�\�� */
private void doPrint(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	DBResult rs = null;
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		
		/** ��l�� rptFile */
		RptFile		rptFile	=	new RptFile(session.getId());
		rptFile.setColumn("��_1,��_2,��_3,��_4,��_5,��_6,��_7,��_8,��_9,��_10,��_11,��_12,��_13,��_14,��_15,��_16,��_17,��_18,��_19,��_20,��_21,��_22,��_23,��_24,��_25,��_26,��_27,��_28,��_29,��_30,��_31,��_32,��_33,��_34,��_35,��_36,��_37,��_38,��_39,��_40,��_41,��_42,��_43,��_44,��_45,��_46,��_47,��_48,��_49,��_50,��_51,��_52,��_53");
								
		// �@���h�֬�حn�C�L
		TRAT008GATEWAY	 trat008	=	new  TRAT008GATEWAY(dbManager, conn);
		Vector crsnoData = trat008.getCrsnoCountForTra134r(requestMap);
				
		int[] totalCrsnoCount = new int[3]; // �N�Ҧ���ت����u�H��  �w�u�H��  �����H�� �֥[�_��
		int crsnoCount = 0; // �p��@�C�L�h�ֵ����,�ΨӴ����� 
		int pageRowCount = 7; // �C���h�֬촫��
		// �@�Ӱj���ܤ@�Ӭ��
		for(int j=0; j<crsnoData.size(); j++){
			Hashtable crsnoDataHt = (Hashtable)crsnoData.get(j);
		
			// ���N�Ӭ쪺�Ҧ��Ů��0...JDK��1.4  �ҥH�����int[][]
			String[][] printData = inputZeroToDoubleArray(3,17);  // ���ͤ@�ӹw�]�Ȭ�0��3x15���}�C(��ܤ@�쪺���) 

			// �D�n�C�L���
			System.out.println("i:"+j+"----CRSNO_KIND:"+Utility.nullToSpace(crsnoDataHt.get("CRSNO_KIND")));
			requestMap.put("CRSNO_KIND",Utility.nullToSpace(crsnoDataHt.get("CRSNO_KIND")));
			Vector printMainData = trat008.getDataForTra134r(requestMap, crsnoDataHt.get("CRSNO").toString(),crsnoDataHt.get("JOB_TYPE").toString());
			String crsName = ""; // �ӦC��ئW��
			int[] thisCrsnoCount = new int[3]; // �N�Ӭ�ت����u�H��  �w�u�H��  �����H�� �֥[�_��
			// �N����ƪ�������J�}�C��,�̫��n����N�Ҧ��}�C���Ȫ�����ܩ����			
			for(int i=0; i<printMainData.size(); i++){
				Hashtable content = (Hashtable)printMainData.get(i);
				int centerCode = Integer.parseInt(content.get("CENTER_CODE").toString());
				String planEmpNum = content.get("PLAN_EMP_NUM").toString().equals("")?"0":content.get("PLAN_EMP_NUM").toString(); // ���u�Юv�H��(TRAT008)
				String totalTeacherNum = content.get("TOTAL_TEACHER_NUM").toString().equals("")?"0":content.get("TOTAL_TEACHER_NUM").toString(); // �w�u�Юv�H��(TRAT006)
				// �����H��
				String notEnoughNum = (Integer.parseInt(planEmpNum)-Integer.parseInt(totalTeacherNum))<0?"0":(Integer.parseInt(planEmpNum)-Integer.parseInt(totalTeacherNum))+"";
				crsName = content.get("CRS_NAME").toString(); // �o�Ӱj�餺����ئW�٧��ۦP
				System.out.println("centerCode="+centerCode);
				printData[0][centerCode]=planEmpNum; // ���u,�ե����_
				printData[1][centerCode]=totalTeacherNum; // �w�u,�ե����_
				printData[2][centerCode]=notEnoughNum; // ����,�ե����_
				
				// �֥[�U���ߪ����u �w�u �����H��
				thisCrsnoCount[0]+=Integer.parseInt(planEmpNum);
				thisCrsnoCount[1]+=Integer.parseInt(totalTeacherNum);
				thisCrsnoCount[2]+=Integer.parseInt(notEnoughNum);
			}
			
			// �N�}�C��J����
			rptFile.add(crsName+"&nbsp;"); // ��ئW��
			inputDataToReport(rptFile, printData, thisCrsnoCount); // �D�n��Ƥ��e
			
			 // �i�洫��
			if(crsnoCount%pageRowCount==0&&crsnoCount!=0)
				crsnoCount++;
			
			rptFile.add(crsnoCount);
			
			// �֥[�U�쪺���u �w�u �����H��
			totalCrsnoCount[0]+=thisCrsnoCount[0];
			totalCrsnoCount[1]+=thisCrsnoCount[1];
			totalCrsnoCount[2]+=thisCrsnoCount[2];
		}
	
		if (rptFile.size() == 0)
		{
			out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");</script>");
			return;
		}

		/** ��l�Ƴ����� */
		report		report_	=	new report(dbManager, conn, out, "tra134r_01r1", report.onlineHtmlMode);

		/** �R�A�ܼƳB�z */
		// �Ǩt����
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
		ht.put("���Y_1", ayear);
		ht.put("���Y_2", sms);
		//if (requestMap.get("SMS").equals("3"))
		   ht.put("���Y_3",facultyName+"��\");
		//else
		//   ht.put("���Y_3",facultyName+"���º[���");
		
		ht.put("�������_1",totalCrsnoCount[0]+"");
		ht.put("�������_2",totalCrsnoCount[1]+"");
		ht.put("�������_3",totalCrsnoCount[2]+"");
		
		
		report_.setDynamicVariable(ht);

		/** �}�l�C�L */
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

// �N�}�C��0�@���w�]��   row-->�h�֦C�C    col-->�h�����
private String[][] inputZeroToDoubleArray(int row, int col)throws Exception{
	String[][] result = new String[row][col] ;
	
	// ����
	for(int i=0; i<result.length; i++){
		// �Y�C������
		for(int j=0; j<result[i].length; j++)
			result[i][j]="0";
	}
	
	return result;
}

// �N��@��ت��}�C��J����
private void inputDataToReport(RptFile reportFile, String[][] eachCrsno, int[] eachCrsnoNum)throws Exception{
	// �C����ܪ�����(3��--���u-�w�u-����)
	for(int i=0; i<eachCrsno.length; i++){
		// �Y�C������
		for(int j=0; j<eachCrsno[i].length; j++){
			// �Ӭ��`�p
			if(j==eachCrsno[i].length-1)
				reportFile.add(eachCrsnoNum[i]);
			else
				reportFile.add(eachCrsno[i][j]);  // �N�U���߸Ӭ�ت����u �w�u �����H�Ʃ�J����
		}
	}
}

%>