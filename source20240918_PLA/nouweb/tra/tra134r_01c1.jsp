<%/*
----------------------------------------------------------------------------------
File Name		: tra134r_01c1
Author			: north
Description		: TRA134R_�C�L�Τ@���§�\�Юv�ݨD�έp�� - ����� (javascript)
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		097/07/29	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** �פJ javqascript Class */
doImport ("ErrorHandle.js, LoadingBar_0_2.js, Form.js");

/** ��l�]�w������T */
var	printPage		=	"tra134r_01p1.jsp";	//�C�L����
var	_privateMessageTime	=	-1;			//�T����ܮɶ�(���ۭq�� -1)
var	controlPage		=	"tra134r_01c2.jsp";
var	noPermissAry		=	new Array();		//�S���v�����}�C

/** ������l�� */
function page_init()
{
	page_init_start();
	
	iniMasterKeyColumn();
	
	/** �v���ˮ� */
	securityCheck();

	/** === ��l���]�w === */
	/** ��l�C�L��� */
	Form.iniFormSet('QUERY', 'AYEAR', 'S', 3, 'N1', 'M',  3, 'A', 'F', 3);
	Form.iniFormSet('QUERY', 'SMS', 'M',  1, 'A');
	
	/** ================ */

	/** === �]�w�ˮֱ��� === */
	/** �C�L��� */
	Form.iniFormSet('QUERY', 'AYEAR', 'AA', 'chkForm', '�Ǧ~');
	Form.iniFormSet('QUERY', 'SMS', 'AA', 'chkForm', '�Ǵ�');
	Form.iniFormSet('QUERY', 'FACULTY_CODE', 'AA', 'chkForm', '�Ǩt');

	/** ================ */

	page_init_end();
}

/** ��l�W�h�a�Ӫ� Key ��� */
function iniMasterKeyColumn()
{
	/** �D Detail �������B�z */
	if (typeof(keyObj) == "undefined")
		return;
	/** ��� */
	for (keyName in keyObj)
	{
		try {Form.iniFormSet("QUERY", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
		try {Form.iniFormSet("EDIT", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
	}
	Form.iniFormColor();
}


/** �B�z�C�L�ʧ@ */
function doPrint()
{
	doPrint_start();
	
	/** === �۩w�ˬd === */
	/* === LoadingBar === */
	/** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	//if (Form.getInput("QUERY", "SYS_CD") == "")
	//	Form.errAppend("�t�νs�����i�ť�!!");
	/** ================ */
	
	doPrint_end();
}

/** ============================= ���ץ��{����m�� ======================================= */
/** �]�w�\���v�� */
function securityCheck()
{
	try
	{
		/** �C�L */
		if (!<%=AUTICFM.securityCheck (session, "PRT")%>)
		{
			noPermissAry[noPermissAry.length]	=	"PRT";
			try{Form.iniFormSet("QUERY", "PRT_ALL_BTN", "D", 1);}catch(ex){}
		}
	}
	catch (ex)
	{
	}
}

/** �ˬd�v�� - ���v��/�L�v��(true/false) */
function chkSecure(secureType)
{
	if (noPermissAry.toString().indexOf(secureType) != -1)
		return false;
	else
		return true
}
/** ====================================================================================== */