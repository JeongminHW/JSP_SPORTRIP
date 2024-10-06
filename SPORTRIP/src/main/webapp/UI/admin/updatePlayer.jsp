<%@page import="player.PlayerBean"%>
<%@page import="player.PlayerMgr"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String playerName = request.getParameter("player_name");
    int playerNum = MUtil.parseInt(request, "player_num");
    String playerPosition = request.getParameter("player_position");
    String playerBacknum = request.getParameter("player_backnum");
    
    String playerImg = request.getParameter("player_img"); 

    PlayerMgr playerMgr = new PlayerMgr();
    PlayerBean playerBean = new PlayerBean();
    
    playerBean.setPLAYER_NUM(playerNum);
    playerBean.setPLAYER_NAME(playerName);
    playerBean.setPOSITION(playerPosition);
    playerBean.setUNIFORM_NUM(playerBacknum);
    playerBean.setPLAYER_IMG(playerImg);
    
    boolean updateStatus = playerMgr.updatePlayer(playerBean);

    if (updateStatus) {
        out.println("<script>alert('선수 정보가 성공적으로 수정되었습니다.'); location.href='admin_player.jsp';</script>");
    } else {
        out.println("<script>alert('선수 정보 수정에 실패하였습니다.'); history.back();</script>");
    }
%>
