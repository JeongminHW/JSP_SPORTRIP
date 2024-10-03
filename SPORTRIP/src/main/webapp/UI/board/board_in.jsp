<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />

<%
	//요청 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	int boardNum = Integer.parseInt(request.getParameter("boardNum"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String ip = request.getParameter("ip");
	String id = request.getParameter("id");
	
	// null 체크
	if ( ip == null || id == null) {
	    out.print("fail");
	    return; // 값이 null일 경우 종료
	}
	
	BoardBean board = new BoardBean();
	board.setTITLE(title);
	board.setCONTENTS(content);
	board.setIP(ip);
	board.setID(id);
	
	// 받아와지는 내용 콘솔로 확인
	System.out.println("내용: " + content);
	System.out.println("IP: " + ip);
	System.out.println("ID: " + id);
	System.out.println("게시판 번호: " + boardNum);
	
	boolean result = boardMgr.insertBoard(board);
	
	if (result) {
	    out.print("success");
	} else {
	    out.print("fail");
	}
%>
