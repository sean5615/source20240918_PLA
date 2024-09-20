<%/*
----------------------------------------------------------------------------------
File Name		: tra134r
Author			: north
Description		: TRA134R_�C�L�Τ@���§�\�Юv�ݨD�έp�� - �D�n����
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
	// �w�]�Ǧ~��
	String	keyParam	=	"";
	MyLogger log = new MyLogger("TRA134R");
	DBManager db = new DBManager(log);
	SYSGETSMSDATA sys = new SYSGETSMSDATA(db);
	
	//���o�{�b�����,�ó]�w�bsys��
	java.util.Calendar cal = java.util.Calendar.getInstance();	
	SimpleDateFormat smipleDate = new SimpleDateFormat("yyyyMMdd");
	String nowDate = smipleDate.format(cal.getTime());
	sys.setSYS_DATE(nowDate);
	sys.setSMS_TYPE("1");  //1.��� 2.�e�� 3.��� 4.�e�Ǧ~ 5.��Ǧ~
	
	//�b�ѼƤ��[�J�Ǧ~,�Ǵ��Ѽ�
	int result = sys.execute();
	if(result==1)
	{
		String ayear = sys.getAYEAR();
		String sms = sys.getSMS();
		keyParam		= "?AYEAR="+ayear+"&SMS="+sms;
	}
	
	// �P�_�����O�O�_���Ǩt����,���h����ܸӾǨt,�p�L�h��ܩҦ�
	String user_id = (String) session.getAttribute("USER_ID");
	AUTGETRANGE aut = new com.nou.aut.AUTGETRANGE();
	aut.initRangeData(user_id);
	
	// �Ǩt��F�H��
	Vector facultyVt = aut.getDEP_CODE("2","3");
	
	String facultyCondition = "";
	// �p���Ǩt��F�H��,�h����ܸӵn�J�̩Ҿ֦����Ǩt
	if( facultyVt.size()>0)
	{
		facultyCondition = "AND FACULTY_CODE IN (''";
		for(int i=0;i<facultyVt.size();i++)
			facultyCondition+=",'"+facultyVt.get(i)+"'";
		facultyCondition+=") ";
	}
	// �p�����զ�F�H���h��ܩҦ��Ǩt,�_�h�����
	else if(aut.getDEP_CODE("3","3").size()==0)
		facultyCondition = "AND FACULTY_CODE IN ('') ";
	
	// �Ǵ�
	session.setAttribute("TRA134R_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='SMS' AND CODE != '3' ORDER BY SELECT_VALUE, SELECT_TEXT ");
	// �Ǩt
	session.setAttribute("TRA134R_02_SELECT", "NOU#SELECT FACULTY_CODE AS SELECT_VALUE, FACULTY_NAME AS SELECT_TEXT FROM SYST003 WHERE 1=1 "+facultyCondition+" ORDER BY SELECT_VALUE, SELECT_TEXT ");
%>


<script>
	top.hideView();
	/** �ɦV�Ĥ@�ӳB�z������ */
	top.mainFrame.location.href	=	'tra134r_01v1.jsp<%= keyParam %>';
</script>