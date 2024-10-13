<%@page import="DB.MUtil"%>
<%@page import="headcoach.HeadcoachMgr"%>
<%@page import="headcoach.HeadcoachBean"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
	request.setCharacterEncoding("UTF-8");
    // 파일이 저장될 경로 설정 (서버에서 사용할 실제 경로)
    String saveDirectory = application.getRealPath("/UI/assets/images/headcoach_img/");
    int maxPostSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
    String encoding = "UTF-8";

    // MultipartRequest 객체 생성
    MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());
    
    // POST 데이터 받기
    String headcoachName = multi.getParameter("headcoachName");
    
    File headcoachImgFile = null;
    if(multi.getFile("headcoachImg") != null){
    	headcoachImgFile = multi.getFile("headcoachImg");
    }
    int teamNum = Integer.parseInt(multi.getParameter("teamNum")); // 팀 번호 받기
    
    System.out.println(teamNum);
    
    String headcoachImgPath = null; // 감독 이미지 경로 초기화
    if (headcoachImgFile != null) { // 감독 이미지 파일이 존재하는지 확인
        String uniqueFileName = "new" + headcoachName + ".png"; // 고유 파일 이름 생성
        File newFile = new File(saveDirectory, uniqueFileName); // 새 파일 객체 생성

        // 파일 이름 변경 시도
        if (headcoachImgFile.renameTo(newFile)) {
            headcoachImgPath = "../assets/images/headcoach_img/" + uniqueFileName; // 경로 설정
        } else {
            System.out.println("Failed to rename/move the uploaded file.");
        }
    } else {
        headcoachImgPath = ".././assets/images/headcoach_img/기본.png"; // 기본 이미지 경로 설정
    }


    // 데이터베이스에 저장할 때 경로를 포함한 정보를 전달
    HeadcoachMgr headcoachMgr = new HeadcoachMgr();
    HeadcoachBean headcoachBean = new HeadcoachBean();
    headcoachBean.setTEAM_NUM(teamNum);
    headcoachBean.setHEADCOACH_NAME(headcoachName);
    headcoachBean.setHEADCOACH_IMG(headcoachImgPath); 

    boolean isInserted = headcoachMgr.insertHeadcoach(headcoachBean); // 감독 등록 메소드 호출
    
    if (isInserted) {
        response.sendRedirect("admin_player.jsp?success=true"); // 성공 시 리다이렉션
    } else {
        out.print("failure");
    }
%>
