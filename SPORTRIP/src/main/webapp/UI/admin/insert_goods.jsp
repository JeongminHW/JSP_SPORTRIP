<%@page import="md.MDBean"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<%
    // 파일이 저장될 경로 설정 (서버에서 사용할 실제 경로)
    String saveDirectory = application.getRealPath("/UI/assets/images/goods_img/");
    int maxPostSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
    String encoding = "UTF-8";

    // MultipartRequest 객체 생성
    MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());
    
    // POST 데이터 받기
    String goodsName = multi.getParameter("goodsName");
    int goodsPrice = Integer.parseInt(multi.getParameter("goodsPrice"));
    String category = multi.getParameter("category");
    
    File goodsImgFile = null;
    if(multi.getFile("playerImg") != null){
    	goodsImgFile = multi.getFile("playerImg");
    }
    
    int teamNum = Integer.parseInt(multi.getParameter("teamNum")); // 팀 번호 받기
    int sportNum = Integer.parseInt(multi.getParameter("sportNum")); // 팀 번호 받기

    String goodsImgPath = null;
    if (goodsImgFile != null) {
        String uniqueFileName = goodsName + ".png"; 
        File newFile = new File(saveDirectory, uniqueFileName); 

        if (goodsImgFile.renameTo(newFile)) {
        	goodsImgPath = "../assets/images/goods_img/" + uniqueFileName; 
        } else {
            System.out.println("Failed to rename/move the uploaded file.");
        }
    } else {
    	goodsImgPath = ".././assets/images/goods_img/noimg.png";
    }

    // 데이터베이스에 저장할 때 경로를 포함한 정보를 전달
   
    MDBean mdBean = new MDBean();
    mdBean.setMD_NAME(goodsName);
    mdBean.setMD_PRICE(goodsPrice);
    mdBean.setMD_IMG(goodsImgPath);
    mdBean.setTEAM_NUM(teamNum);
    mdBean.setMD_KINDOF(category);
    mdBean.setSPORT_NUM(sportNum);

    boolean isInserted = mdMgr.insertMD(mdBean);
    if (isInserted) {
        out.print("success");
    } else {
        out.print("failure");
    }
%>
