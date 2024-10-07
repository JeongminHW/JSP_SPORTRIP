<%@page import="comment.CommentBean"%>
<%@page import="comment.CommentMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="commentMgr" class="comment.CommentMgr" />

<%
	//요청 인코딩 설정
	request.setCharacterEncoding("UTF-8");
    int commentNum = Integer.parseInt(request.getParameter("commentNum"));
    String content = request.getParameter("content");

    if (commentNum != 0 && content != null) {
        CommentBean comment = new CommentBean();
        comment.setCONTENTS(content);
	    comment.setCOMMENT_NUM(commentNum);

        boolean result = commentMgr.updateComment(comment);

        if (result) {
            out.print("success");
        } else {
            out.print("fail");
        }
    } else {
        out.print("fail");
    }
%>
