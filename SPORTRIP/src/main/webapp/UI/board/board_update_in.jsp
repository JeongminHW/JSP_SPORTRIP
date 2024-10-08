<%@page import="DB.MUtil"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<%
    request.setCharacterEncoding("UTF-8");

    int boardNum = MUtil.parseInt(request, "boardNum", 0);
    String title = request.getParameter("title");
    String content = request.getParameter("postediter");

    BoardBean board = new BoardBean();
    board.setTITLE(title);
    board.setCONTENTS(content);
    board.setBOARD_NUM(boardNum);
  
    if (title == null || content == null || boardNum == 0) {
        out.print("게시물 수정을 실패하였습니다.");
        return;
    }

    boolean isUpdated = boardMgr.updateBoard(board); // 게시글 수정

    if (isUpdated) {
        out.print("success");
    } else {
        out.print("fail");
    }
    try {
        // 필요 시 추가적인 처리
    } catch (Exception e) {
        out.println("Error: " + e.getMessage()); // 에러 메시지 출력
        e.printStackTrace(); // 스택 트레이스 출력
    }
%>
