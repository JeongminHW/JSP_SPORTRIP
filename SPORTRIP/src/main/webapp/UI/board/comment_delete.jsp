<%@page import="comment.CommentMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="commentMgr" class="comment.CommentMgr" />

<%
	String commentNum = request.getParameter("commentNum");
	
	if (commentNum != null) {
	    boolean result = commentMgr.deleteComment(Integer.parseInt(commentNum));
	    if (result) {
	        out.print("success");
	    } else {
	        out.print("fail");
	    }
	} else {
	    out.print("fail");
	}
%>
