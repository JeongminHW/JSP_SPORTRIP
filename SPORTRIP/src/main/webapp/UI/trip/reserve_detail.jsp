<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="reserve.ReserveBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page import="lodging.LodgingMgr"%> <!-- LodgingMgr 추가 -->
<%@page import="room.RoomMgr"%> <!-- RoomMgr 추가 -->
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="reserveMgr" class="reserve.ReserveMgr" />
<jsp:useBean id="lodgingMgr" class="lodging.LodgingMgr" /> <!-- LodgingMgr 사용 -->
<jsp:useBean id="roomMgr" class="room.RoomMgr" /> <!-- RoomMgr 사용 -->

<%
    request.setCharacterEncoding("UTF-8");
    
    // 로그인 정보 확인
    if (login == null) {
        out.println("로그인 정보가 없습니다.");
        return;
    }

    // 예약 내역 가져오기
    String userId = login.getId(); // 현재 로그인한 사용자 ID
    Vector<ReserveBean> reserveList = reserveMgr.getAllReserves(userId);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>숙소 예약 내역</title>
    <link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet"/>
    <link href=".././assets/css/reserve_detail.css" rel="stylesheet" type="text/css"/>
</head>
<body>
    <div class="reserve-detail">
        <div class="reserve-info-section">
            <header class="reserve-info-header">
                <span>숙소 예약 내역</span>
            </header>
            <div class="reserve-info-content">
                <table>
                    <tr>
                        <th>예약번호</th>
                        <th>숙소명</th>
                        <th>객실 이미지</th> <!-- 객실 이미지 추가 -->
                        <th>객실번호</th>
                        <th>인원수</th>
                        <th>예약금액</th>
                        <th>체크인</th>
                        <th>체크아웃</th>
                        <th>취소</th>
                    </tr>
                    <%
                        for (ReserveBean reserve : reserveList) {
                            String lodgingName = lodgingMgr.getLodgingName(reserve.getLODGING_NUM()); // 숙소명 가져오기
                            String roomImage = roomMgr.getRoomImage(reserve.getROOM_NUM()); // 객실 이미지 가져오기
                    %>
                    <tr class="item-row">
                        <td><%= reserve.getRESERVE_NUM() %></td>
                        <td><%= lodgingName %></td> <!-- 숙소명 출력 -->
                        <td><img src="<%= roomImage %>" alt="객실 이미지" style="width:100px;height:auto;"/></td> <!-- 객실 이미지 출력 -->
                        <td><%= reserve.getROOM_NUM() %></td>
                        <td><%= reserve.getHEADCOUNT() %></td>
                        <td><%= reserve.getRESERVE_PRICE() %>원</td>
                        <td><%= sdf.format(reserve.getCHECK_IN()) %></td>
                        <td><%= sdf.format(reserve.getCHECK_OUT()) %></td>
                        <td>
                            <button type="button" class="cancel-reserve" onclick="cancelReserve('<%= reserve.getRESERVE_NUM() %>')">취소</button>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
        </div>
    </div>

    <script>
        function cancelReserve(reserveNum) {
            if (confirm("정말로 예약을 취소하시겠습니까?")) {
                const params = new URLSearchParams();
                params.append('reserveNum', reserveNum);

                fetch('cancel_reserve.jsp?' + params.toString(), {
                    method: 'GET',
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes("success")) {
                        alert('예약이 취소되었습니다.');
                        location.reload(); // 페이지 새로고침
                    } else {
                        alert('예약 취소에 실패했습니다.');
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }
    </script>

</body>
</html>
