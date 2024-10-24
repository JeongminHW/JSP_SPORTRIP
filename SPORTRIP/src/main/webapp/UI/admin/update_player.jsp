<%@page import="DB.MUtil"%>
<%@page import="player.PlayerMgr"%>
<%@page import="player.PlayerBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
	request.setCharacterEncoding("UTF-8");
    // 파일이 저장될 경로 설정 (서버에서 사용할 실제 경로)
    String saveDirectory = application.getRealPath("/UI/assets/images/player_img/");
    int maxPostSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
    String encoding = "UTF-8";

    // MultipartRequest 객체 생성
    MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());
    
    // POST 데이터 받기
    String playerNum = multi.getParameter("playerNum");
    String playerName = multi.getParameter("playerName");
    String playerBirthday = multi.getParameter("playerBirthday");
    String playerPosition = multi.getParameter("playerPosition");
    String playerBacknum = multi.getParameter("playerBacknum");
    File playerImgFile = null;
    
    if(multi.getFile("playerImg") != null){
    	playerImgFile = multi.getFile("playerImg");
    }
    
    System.out.println(playerImgFile);
    
    String playerImgPath = null;
    if (playerImgFile != null) {
        String uniqueFileName = "newPlayer" + playerBacknum + playerName + ".png"; 
        File newFile = new File(saveDirectory, uniqueFileName); 

        if (playerImgFile.renameTo(newFile)) {
            playerImgPath = "../assets/images/player_img/" + uniqueFileName; 
        } else {
            System.out.println("Failed to rename/move the uploaded file.");
        }
    } else {
    	playerImgPath = ".././assets/images/player_img/기본.png";
    }

    PlayerMgr playerMgr = new PlayerMgr();
    PlayerBean playerBean = new PlayerBean();
    
    playerBean.setPLAYER_NUM(Integer.parseInt(playerNum));
    playerBean.setPLAYER_NAME(playerName);
    playerBean.setBIRTH(playerBirthday);
    playerBean.setPOSITION(playerPosition);
    playerBean.setUNIFORM_NUM(playerBacknum);
    playerBean.setPLAYER_IMG(playerImgPath);
    
    boolean updateStatus = playerMgr.updatePlayer(playerBean);

    if (updateStatus) {
        out.println("success");
    } else {
        out.println("fail");
    }
%>
