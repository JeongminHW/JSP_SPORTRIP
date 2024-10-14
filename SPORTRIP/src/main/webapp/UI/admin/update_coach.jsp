<%@page import="DB.MUtil"%>
<%@page import="headcoach.HeadcoachMgr"%>
<%@page import="headcoach.HeadcoachBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
    request.setCharacterEncoding("UTF-8");
    String saveDirectory = application.getRealPath("/UI/assets/images/headcoach_img/");
    int maxPostSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
    String encoding = "UTF-8";
    
    MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());

    // POST 데이터 받기
    String coachNum = multi.getParameter("headcoachNum");
    System.out.println("Received coachNum: " + coachNum); // 디버깅 로그
    String headcoachName = multi.getParameter("headcoachName");
    File headcoachImgFile = null;
    
    if(multi.getFile("headcoachImg") != null){
    	headcoachImgFile = multi.getFile("headcoachImg");
    }
    
    System.out.println(headcoachImgFile);
    
    String headcoachImgPath = null;
    if (headcoachImgFile != null) {
        String uniqueFileName = "new" + coachNum + headcoachName + ".png"; 
        File newFile = new File(saveDirectory, uniqueFileName); 

        if (headcoachImgFile.renameTo(newFile)) {
            headcoachImgPath = "../assets/images/headcoach_img/" + uniqueFileName; 
        } else {
            System.out.println("Failed to rename/move the uploaded file. New file: " + newFile.getAbsolutePath());
            out.println("파일을 이동하는 데 실패했습니다. 파일 경로: " + headcoachImgFile.getAbsolutePath());
            headcoachImgPath = "../assets/images/headcoach_img/기본.png"; // 기본 이미지 경로
        }
    } else {
    	headcoachImgPath = ".././assets/images/player_img/기본.png";
        System.out.println("No file uploaded, using default image.");
    }

    HeadcoachMgr headcoachMgr = new HeadcoachMgr();
    HeadcoachBean headcoachBean = new HeadcoachBean();

    // headcoachNum 유효성 검사
    if (coachNum != null && !coachNum.trim().isEmpty()) {
        try {
            headcoachBean.setHEADCOACH_NUM(Integer.parseInt(coachNum));
        } catch (NumberFormatException e) {
            e.printStackTrace(); // 숫자로 변환할 수 없는 경우 로그에 출력
            out.println("headcoachNum은 유효한 숫자가 아닙니다.");
            return; // 프로세스 중단
        }
    } else {
        out.println("headcoachNum 값이 없습니다.");
        return; // 프로세스 중단
    }
    
    headcoachBean.setHEADCOACH_NUM(Integer.parseInt(coachNum));
    headcoachBean.setHEADCOACH_NAME(headcoachName);
    headcoachBean.setHEADCOACH_IMG(headcoachImgPath);
    
    boolean updateStatus = headcoachMgr.updateHeadcoach(headcoachBean);

    if (updateStatus) {
    	response.sendRedirect("admin_player.jsp?success=true"); // 성공 시 리다이렉션
    } else {
        out.println("fail");
    }
%>
