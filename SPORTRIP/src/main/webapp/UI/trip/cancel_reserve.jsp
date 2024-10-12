<%@page import="reserve.ReserveMgr"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // POST 데이터 받기
    String reserveNumParam = request.getParameter("reserveNum");

    if (reserveNumParam != null) {
        ReserveMgr reserveMgr = new ReserveMgr();
        boolean deleteFlag = reserveMgr.cancelReserve(Integer.parseInt(reserveNumParam)); // 예약 취소

        if (deleteFlag) {
            out.println("success"); // 예약 취소 성공
        } else {
            out.println("fail"); // 예약 취소 실패
        }
    } else {
        out.println("fail"); // 예약 번호가 없을 때
    }
%>
