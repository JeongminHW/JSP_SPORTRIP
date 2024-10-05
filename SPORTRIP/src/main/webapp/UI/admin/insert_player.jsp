<%@page import="DB.MUtil"%>
<%@page import="player.PlayerMgr"%>
<%@page import="player.PlayerBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String playerName = request.getParameter("player_name");
    String playerPosition = request.getParameter("player_position");
    String playerBacknum = request.getParameter("player_backnum");
    String playerImg = request.getParameter("player_img"); 
	int teamNum = MUtil.parseInt(request, "teamNum", 0);
    if (playerName != null && playerPosition != null && playerBacknum != null && playerImg != null) {
        
        PlayerBean playerBean = new PlayerBean();
        playerBean.setTEAM_NUM(teamNum); 
        playerBean.setBIRTH("2000-01-01"); 
        playerBean.setPLAYER_IMG(playerImg); 
        playerBean.setPOSITION(playerPosition);
        playerBean.setUNIFORM_NUM(playerBacknum);

        PlayerMgr playerMgr = new PlayerMgr();
        boolean isInserted = playerMgr.insertPlayer(playerBean);

        if (isInserted) {
            out.println("<script>alert('선수 등록이 성공적으로 완료되었습니다.');</script>");
            response.sendRedirect("admin_player.jsp");
        } else {
            out.println("<script>alert('선수 등록에 실패했습니다. 다시 시도해주세요.');</script>");
        }
    }
%>
