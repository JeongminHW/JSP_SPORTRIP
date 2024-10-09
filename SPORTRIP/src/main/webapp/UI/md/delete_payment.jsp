<%@page import="charge.ChargeMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // POST 데이터 받기
    String orderNumber = request.getParameter("orderNumber");

    if (orderNumber != null) {
        ChargeMgr chargeMgr = new ChargeMgr();
        boolean deleteFlag = chargeMgr.canclePayMD(orderNumber);

        if (deleteFlag) {
            out.println("success");
        } else {
            out.println("fail");
        }
    } else {
        out.println("fail");
    }
%>