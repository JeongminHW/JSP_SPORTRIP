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
	
	// null 체크
	if (content == null || ip == null || id == null) {
	    out.print("fail");
	    return; // 값이 null일 경우 종료
	}
	
	CommentBean comment = new CommentBean();
	comment.setCONTENTS(content);
	comment.setIP(ip);
	comment.setID(id);
	comment.setBOARD_NUM(boardNum);

	boolean result = commentMgr.postComment(comment);
	
	if (result) {
	    out.print("success");
	} else {
	    out.print("fail");
	}
%>
