<%@page import="DB.MUtil"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<%
    request.setCharacterEncoding("UTF-8");
	// 파라미터로 넘어온 값
	String command = request.getParameter("command");
	int boardNum = Integer.parseInt(request.getParameter("boardNum"));

	// BoardMgr 호출
	boolean success = boardMgr.updateCommand(command, boardNum);
	
	// 업데이트된 추천/비추천 수 가져오기
	int updatedCount = 0;
	if (success) {
	    if (command.equals("RECOMMAND")) {
	        updatedCount = boardMgr.getBoard(boardNum).getRECOMMAND();
	    } else if (command.equals("NONRECOMMAND")) {
	        updatedCount = boardMgr.getBoard(boardNum).getNONRECOMMAND();
	    }
	}
	
	// 결과 반환
	out.print(updatedCount);
%>
