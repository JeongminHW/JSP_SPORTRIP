<%@page import="comment.CommentBean"%>
<%@page import="comment.CommentMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="commentMgr" class="comment.CommentMgr" />

<%
	//요청 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	int boardNum = Integer.parseInt(request.getParameter("boardNum"));
	String content = request.getParameter("content");
	String ip = request.getParameter("ip");
	String id = request.getParameter("id");
	int replynum = Integer.parseInt(request.getParameter("replynum"));

	// null 체크
	if (content == null || ip == null || id == null) {
	    out.print("fail");
	    return; // 값이 null일 경우 종료
	}
	
	CommentBean comment = new CommentBean();
	comment.setREPLY_NUM(replynum);
	comment.setCONTENTS(content);
	comment.setIP(ip);
	comment.setID(id);
	comment.setBOARD_NUM(boardNum);
	
	// 받아와지는 내용 콘솔로 확인
	System.out.println("내용: " + replynum);
	System.out.println("내용: " + content);
	System.out.println("IP: " + ip);
	System.out.println("ID: " + id);
	System.out.println("게시판 번호: " + boardNum);
	
	boolean result = commentMgr.postReply(comment);
	
	if (result) {
	    out.print("success");
	} else {
	    out.print("fail");
	}
%>
