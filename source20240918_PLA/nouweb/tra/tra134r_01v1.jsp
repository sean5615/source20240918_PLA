<%/*
----------------------------------------------------------------------------------
File Name		: tra134r_01v1
Author			: north
Description		: TRA134R_�C�L�Τ@���§�\�Юv�ݨD�έp�� - ��ܭ���
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		097/07/29	north    	Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<html>
<head>
	<%@ include file="/utility/viewpageinit.jsp"%>
	<script src="<%=vr%>script/framework/query3_1_0_2.jsp"></script>
	<script src="tra134r_01c1.jsp"></script>
	<noscript>
		<p>�z���s�������䴩JavaScript�y�k�A���O�ä��v�T�z��������������e</p>
	</noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="�I����" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- �w�q�d�ߪ� Form �_�l -->
<form name="QUERY" method="post" onsubmit="doQuery();" style="margin:0,0,5,0;">
	<input type=hidden name="control_type">


	<!-- �d�ߥ��e���_�l -->
	<TABLE id="QUERY_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="�ƪ��Ϊ��">
		<tr>
			<td width="13"><img src="<%=vr%>images/ap_search_01.jpg" alt="�ƪ��ιϥ�" width="13" height="12"></td>
			<td width="100%"><img src="<%=vr%>images/ap_search_02.jpg" alt="�ƪ��ιϥ�" width="100%" height="12"></td>
			<td width="13"><img src="<%=vr%>images/ap_search_03.jpg" alt="�ƪ��ιϥ�" width="13" height="12"></td>
		</tr>
		<tr>
			<td width="13" background="<%=vr%>images/ap_search_04.jpg" alt="�ƪ��ιϥ�">&nbsp;</td>
			<td width="100%" valign="top" bgcolor="#C5E2C3">
				<!-- ���s�e���_�l -->
				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="�ƪ��Ϊ��">
					<tr class="mtbGreenBg">
						<td align=left>�i�C�L�e���j</td>
						<td align=right>
							<div id="serach_btn">
								<input type=button class="btn" value='�M  ��' onclick='doReset();' onkeypress='doReset();'>
								<input type=submit class="btn" name="PRT_ALL_BTN" value='�C  �L' onclick='doPrint();' onkeypress='doPrint();'>
							</div>
						</td>
					</tr>
				</table>
				<!-- ���s�e������ -->

				<!-- �d�ߵe���_�l -->
				<table id="table1" width="100%" border="0" align="center" cellpadding="2" cellspacing="1" summary="�ƪ��Ϊ��">
					<tr>
						<td align='right'>�Ǧ~��<font color=red>��</font>�G</td>
						<td><input type=text name='AYEAR'>
							<select name='SMS'>
								<script>Form.getSelectFromPhrase("TRA134R_01_SELECT", "", "");</script>
							</select>
						</td>
						<td align='right'>�Ǩt<font color=red>��</font>�G</td>
						<td>
							<select name='FACULTY_CODE'>
								<script>Form.getSelectFromPhrase("TRA134R_02_SELECT", "", "");</script>
							</select>
						</td>
					</tr>
				</table>
				<!-- �d�ߵe������ -->
			</td>
			<td width="13" background="<%=vr%>images/ap_search_06.jpg" alt="�ƪ��ιϥ�">&nbsp;</td>
		</tr>
		<tr>
			<td width="13"><img src="<%=vr%>images/ap_search_07.jpg" alt="�ƪ��ιϥ�" width="13" height="13"></td>
			<td width="100%"><img src="<%=vr%>images/ap_search_08.jpg" alt="�ƪ��ιϥ�" width="100%" height="13"></td>
			<td width="13"><img src="<%=vr%>images/ap_search_09.jpg" alt="�ƪ��ιϥ�" width="13" height="13"></td>
		</tr>
	</table>
	<!-- �d�ߥ��e������ -->
</form>
<!-- �w�q�d�ߪ� Form ���� -->

<!-- ���D�e���_�l -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="�ƪ��Ϊ��">
	<tr>
		<td>
			<table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td background="<%=vr%>images/ap_index_title.jpg" alt="�ƪ��ιϥ�">
						�@�@<span class="title">TRA134R_�C�L�Τ@���§�\�Юv�ݨD�έp��</span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- ���D�e������ -->

<script>
	document.write ("<font color=\"white\">" + document.lastModified + "</font>");
	window.attachEvent("onload", page_init);
	window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>