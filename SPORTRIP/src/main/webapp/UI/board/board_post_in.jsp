<%@page import="DB.MUtil"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<%
    request.setCharacterEncoding("UTF-8");

    String title = request.getParameter("title"); 
    String content = request.getParameter("postediter"); 
    String id = login.getId(); 
    String ipAddress = request.getRemoteAddr();

    int teamNum = MUtil.parseInt(request, "teamNum", 0); 

    if (teamNum == 0) {
        teamNum = (Integer) session.getAttribute("teamNum"); 
    } else {
        session.setAttribute("teamNum", teamNum); 
    }

    // Handle IPv6 local host cases
    if ("0:0:0:0:0:0:0:1".equals(ipAddress) || "::1".equals(ipAddress)) {
        ipAddress = "127.0.0.1";
    } else if (ipAddress.startsWith("::ffff:")) {
        ipAddress = ipAddress.substring(7);
    }

    BoardBean board = new BoardBean();
    board.setTITLE(title); // Set title
    board.setCONTENTS(content); // Set content (including images)
    board.setIP(ipAddress); // Set IP address
    board.setID(id); // Set user ID
    board.setTEAM_NUM(teamNum); // Set team number
    
    if (ipAddress == null || id == null || title == null || content == null) {
        out.print("fail");
        return;
    }
    
    boolean result = boardMgr.insertBoard(board);

    if (result) {
        out.print("success");
    } else {
        out.print("fail");
    }
    
    try {
        // Existing code for handling the post
    } catch (Exception e) {
        out.println("Error: " + e.getMessage()); // Output error message
        e.printStackTrace(); // Log the full stack trace
    }
%>
