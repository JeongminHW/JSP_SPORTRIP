<%@page import="DB.MUtil"%>
<%@page import="md.MDMgr"%>
<%@page import="md.MDBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 파일이 저장될 경로 설정 (서버에서 사용할 실제 경로)
    String saveDirectory = application.getRealPath("/UI/assets/images/goods_img/");
    int maxPostSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
    String encoding = "UTF-8";

    // MultipartRequest 객체 생성
    MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());

    // POST 데이터 받기
    String mdNum = multi.getParameter("mdNum");
    String goodsName = multi.getParameter("goodsName");
    String goodsPrice = multi.getParameter("goodsPrice");
    String mdKindOf = multi.getParameter("mdKindOf");

    File goodsImgFile = multi.getFile("goodsImg");
    String goodsImgPath = null;
    
 	// 기존 굿즈 정보 가져오기
    MDMgr mdMgr = new MDMgr();
    MDBean Goods = mdMgr.getMD(Integer.parseInt(mdNum));
    
 	// 이미지 파일 처리
    if(multi.getFile("goodsImg") != null){
        goodsImgFile = multi.getFile("goodsImg");
    }

    // 이미지 파일 처리
    if (goodsImgFile != null) {
        // 이미지 파일 이름을 유니크하게 생성
        String uniqueFileName = "goods_" + mdNum + "_" + goodsName + ".png";
        File newFile = new File(saveDirectory, uniqueFileName);

        // 파일명을 변경하여 저장
        if (goodsImgFile.renameTo(newFile)) {
            goodsImgPath = "../assets/images/goods_img/" + uniqueFileName;
        } else {
            System.out.println("Failed to rename/move the uploaded file.");
            goodsImgPath = "../assets/images/goods_img/noimg.png"; // 실패 시 기본 이미지 사용
        }
    } else {
        // 이미지 수정 안하면 기존 사진 그래도 사용
        goodsImgPath = Goods.getMD_IMG(); 
    }

    // 굿즈 정보를 데이터베이스에 업데이트
    MDBean mdBean = new MDBean();

    mdBean.setMD_NUM(Integer.parseInt(mdNum));  // 번호를 먼저 설정
    mdBean.setMD_NAME(goodsName);
    mdBean.setMD_PRICE(Integer.parseInt(goodsPrice));
    mdBean.setMD_KINDOF(mdKindOf);
    mdBean.setMD_IMG(goodsImgPath);

    boolean updateStatus = mdMgr.updateMD(mdBean);

    // 업데이트 성공 여부에 따라 결과 반환
    if (updateStatus) {
        out.println("success");
    } else {
        out.println("fail");
    }
%>
