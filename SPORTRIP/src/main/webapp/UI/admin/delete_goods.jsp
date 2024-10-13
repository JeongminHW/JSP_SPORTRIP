<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="DB.MUtil" %>
<%@ page import="md.MDMgr" %>
<%@ page import="md.MDBean" %>

<%
    // POST 데이터 받기
    String selectedGoodsNum = request.getParameter("selectedGoodsNum");

    int mdNum = Integer.parseInt(selectedGoodsNum);
    if (mdNum >= 0) {
    	MDMgr mdMgr = new MDMgr();
        boolean deleteFlag = mdMgr.deleteMD(mdNum);

        if (deleteFlag) {
            out.println("success");
        } else {
            out.println("fail");
        }
    } else {
        out.println("fail");
    }
%>
