<%@page import="DB.MUtil"%>
<%@page import="board.BoardMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="boardMgr" class="board.BoardMgr" />

<%
	//int boardNum = MUtil.parseInt(request, "boardNum", 0);
	String boardNum = request.getParameter("boardNum");
	
	if (boardNum != null) {
	    boolean result = boardMgr.deleteBoard(Integer.parseInt(boardNum));
	    if (result) {
	        out.print("success");
	    } else {
	        out.print("fail");
	    }
	} else {
	    out.print("fail");
	}
%>
