<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="DB.MUtil" %>
<%@ page import="player.PlayerMgr" %>
<%@ page import="player.PlayerBean" %>

<%
    // POST 데이터 받기
    String selectedPlayerNum = request.getParameter("selectedPlayerNum");

    int playerNum = Integer.parseInt(selectedPlayerNum);
    if (playerNum >= 0) {
        PlayerMgr playerMgr = new PlayerMgr();
        boolean deleteFlag = playerMgr.deletePlayer(playerNum);

        if (deleteFlag) {
            out.println("success");
        } else {
            out.println("fail");
        }
    } else {
        out.println("fail");
    }
%>
