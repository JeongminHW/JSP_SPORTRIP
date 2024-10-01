<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, reserve.ReserveBean, reserve.ReserveMgr, room.RoomMgr, room.RoomBean, java.sql.Date" %>

<%
    // 입력받은 데이터 파라미터 받기
    String headcountStr = request.getParameter("headcount");
    String checkInStr = request.getParameter("checkIn");
    String checkOutStr = request.getParameter("checkOut");

    // 디버깅 로그 추가
    System.out.println("lodgingNum: " + request.getParameter("lodgingNum"));
    System.out.println("roomNum: " + request.getParameter("roomNum"));
    System.out.println("headcount: " + headcountStr);
    System.out.println("checkIn: " + checkInStr);
    System.out.println("checkOut: " + checkOutStr);
    
    // 현재 로그인한 사용자 ID 가져오기 (세션에서)
    String userID = (String) session.getAttribute("userID");

    // 사용자 ID가 null일 경우 임시로 "a"로 설정
    if (userID == null) {
        userID = "a"; // 임시 사용자 ID 설정
        System.out.println("임시 사용자 ID: " + userID); // 로그에 출력
    } else {
        System.out.println("사용자 ID: " + userID); // ID 출력
    }

    int lodgingNum = 0;
    int roomNum = 0;
    int roomPrice = 0;

    StringBuilder errorMsg = new StringBuilder();
    if (session == null || userID.isEmpty()) {
        errorMsg.append("세션이 만료되었습니다. 다시 로그인 해주세요. ");
    }

    try {
        lodgingNum = Integer.parseInt(request.getParameter("lodgingNum"));
    } catch (NumberFormatException e) {
        errorMsg.append("숙소 번호는 숫자여야 합니다. ");
    }

    try {
        roomNum = Integer.parseInt(request.getParameter("roomNum"));
    } catch (NumberFormatException e) {
        errorMsg.append("객실 번호는 숫자여야 합니다. ");
    }

    if (headcountStr == null || headcountStr.isEmpty()) {
        errorMsg.append("인원 수가 비어있습니다. ");
    } else {
        try {
            Integer.parseInt(headcountStr); // 숫자로 변환하여 유효성 검증
        } catch (NumberFormatException e) {
            errorMsg.append("인원 수는 숫자여야 합니다. ");
        }
    }
    if (checkInStr == null || checkInStr.isEmpty()) {
        errorMsg.append("체크인 날짜가 비어있습니다. ");
    }
    if (checkOutStr == null || checkOutStr.isEmpty()) {
        errorMsg.append("체크아웃 날짜가 비어있습니다. ");
    }

    Date checkInDate = null;
    Date checkOutDate = null;
    try {
        checkInDate = Date.valueOf(checkInStr);
        checkOutDate = Date.valueOf(checkOutStr);
    } catch (IllegalArgumentException e) {
        errorMsg.append("날짜 형식이 잘못되었습니다. ");
    }

    // 오류가 있을 경우 메시지 박스 출력
    if (errorMsg.length() > 0) {
        out.println("<script>alert('예약에 실패했습니다: " + errorMsg.toString() + "');</script>");
    } else {
        // RoomMgr를 사용하여 객실 목록 조회
        RoomMgr roomMgr = new RoomMgr();
        List<RoomBean> roomList = roomMgr.getRoomsByLodgingNum(lodgingNum); // 숙소 번호로 객실 리스트 가져오기

        if (roomList.isEmpty()) {
            System.out.println("해당 숙소의 객실이 없습니다.");
        } else {
            // 선택한 객실의 가격 가져오기
            boolean roomFound = false;
            for (RoomBean room : roomList) {
                if (room.getROOM_NUM() == roomNum) {
                    roomPrice = room.getROOM_PRICE(); // 해당 객실의 가격 설정
                    roomFound = true;
                    break;
                }
            }
            
            if (!roomFound) {
                System.out.println("선택한 객실 번호가 존재하지 않습니다.");
            } else {
                System.out.println("RESERVE_PRICE: " + roomPrice);
            }
        }

        // ReserveBean에 데이터 설정
        ReserveBean reserveBean = new ReserveBean();
        reserveBean.setID(userID);
        reserveBean.setLODGING_NUM(lodgingNum);
        reserveBean.setROOM_NUM(roomNum);
        reserveBean.setHEADCOUNT(Integer.parseInt(headcountStr));
        reserveBean.setRESERVE_PRICE(roomPrice);
        reserveBean.setCHECK_IN(checkInDate);
        reserveBean.setCHECK_OUT(checkOutDate);

        // 예약 데이터 저장
        ReserveMgr reserveMgr = new ReserveMgr();
        String resultMessage = reserveMgr.saveReserve(reserveBean);

        if (resultMessage == null) {
            out.println("<script>alert('예약이 성공적으로 완료되었습니다.');</script>");
        } else {
            out.println("<script>alert('예약 저장에 실패했습니다: " + resultMessage + "');</script>");
        }
    }
%>
