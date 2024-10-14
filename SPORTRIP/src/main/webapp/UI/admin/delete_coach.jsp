<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="DB.MUtil" %>
<%@ page import="headcoach.HeadcoachMgr" %>
<%@ page import="headcoach.HeadcoachBean" %>

<%
    // POST 데이터 받기
    String selectedCoachNum = request.getParameter("selectedCoachNum");
	
	if (selectedCoachNum == null) {
	    out.print("fail"); // null일 경우 처리
	    return;
	}

	int coachNum;
	try {
	    coachNum = Integer.parseInt(selectedCoachNum);
	} catch (NumberFormatException e) {
	    out.print("fail"); // 숫자로 변환할 수 없는 경우 처리
	    return;
	}
	
    if (coachNum  >= 0) {
    	HeadcoachMgr headcoachMgr = new HeadcoachMgr();
        boolean deleteFlag = headcoachMgr.deleteHeadcoach(coachNum);

        if (deleteFlag) {
            out.println("success");
        } else {
            out.println("fail");
        }
    } else {
        out.println("fail");
    }
%>




