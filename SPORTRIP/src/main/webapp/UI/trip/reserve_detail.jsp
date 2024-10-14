<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="reserve.ReserveBean"%>
<%@page import="java.text.DecimalFormat"%>
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
    
	// 금액 포맷 설정
	DecimalFormat formatter = new DecimalFormat("###,###");

    // 로그인 정보 확인
    if (login == null) {
        out.println("로그인 정보가 없습니다.");
        return;
    }

    // 현재 로그인한 사용자 ID
    String userId = login.getId(); 
    
    // 예약 내역 가져오기
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
                <span>주문/결제내역</span>
            </header>
            <div class="reserve-info-content">
                <%
                    for (ReserveBean reserve : reserveList) {
                        String lodgingName = lodgingMgr.getLodgingName(reserve.getLODGING_NUM()); // 숙소명 가져오기
                        String roomImage = roomMgr.getRoomImage(reserve.getROOM_NUM()); // 객실 이미지 가져오기
                %>
                <div class="reserve-info">
			        <!-- 왼쪽: 주문번호와 호텔 이름 -->
			        <div class="order-details">
			            <span class="reserve-number">주문번호: <%= reserve.getRESERVE_NUM() %></span>
			            <span class="reserve-name"><%= lodgingName %></span>
			        </div>
			
			        <!-- 중간: 가격과 결제 방식 -->
			        <div class="price-method">
			            <span class="reserve-price"><%= formatter.format(reserve.getRESERVE_PRICE()) %>원</span>
			            <span class="reserve-method">카카오페이</span>
			        </div>
			
			        <!-- 오른쪽: 결제 완료, 결제 취소 -->
			        <div class="status-info">
			            <div class="complete-cancel">
			                <span class="reserve-complete">결제완료</span>
			                <button type="button" class="reserve-cancel" onclick="cancelReserve('<%= reserve.getRESERVE_NUM() %>')">결제취소</button>
			            </div>
			            <span class="cancel-info">언제든 취소 가능</span>
			        </div>
    			</div>
                <%
                    } // for 문 닫기
                %>
            </div>
        </div>

        <div class="reserve-detail-section">
            <header class="reserve-info-header">
                <span>숙소 예약 내역</span>
            </header>
            <div class="reserve-info-content">
                <%
                    for (ReserveBean reserve : reserveList) {
                        String lodgingName = lodgingMgr.getLodgingName(reserve.getLODGING_NUM()); // 숙소명 가져오기
                        String roomImage = roomMgr.getRoomImage(reserve.getROOM_NUM()); // 객실 이미지 가져오기
                %>
                <table>
                    <tr>
                        <th>예약번호</th>
                        <td colspan="3"><%= reserve.getRESERVE_NUM() %></td>
                    </tr>
                    <tr>
                        <th>현재구매상태</th>
                        <td colspan="3">결제완료</td>
                    </tr>
                    <tr>
                        <th>결제방식</th>
                        <td colspan="3">카카오페이</td>
                    </tr>
                    <tr>    
                        <th>숙소명</th>
                        <td colspan="3"><%= lodgingName %></td>
                    </tr>                                              
                    <tr>
                        <th>객실 이미지</th>
                        <td colspan="3"><img src="<%= roomImage %>" alt="객실 이미지" style="width:150px;height:auto;"/></td>
                    </tr>
                    <tr>    
                        <th>객실번호</th>
                        <td colspan="3"><%= reserve.getROOM_NUM() %></td>
                    </tr>
                    <tr>                            
                        <th>인원수</th>
                        <td colspan="3"><%= reserve.getHEADCOUNT() %></td>
                    </tr>
                    <tr>    
                        <th>예약금액</th>
                        <td colspan="3"><%= formatter.format(reserve.getRESERVE_PRICE()) %>원</td>                        
                    </tr>
                    <tr>      
                        <th>체크인</th>
                        <td colspan="3"><%= sdf.format(reserve.getCHECK_IN()) %></td>
                    </tr>   
                    <tr> 
                        <th>체크아웃</th>
                        <td colspan="3"><%= sdf.format(reserve.getCHECK_OUT()) %></td>
                    </tr> 
                    <tr>
                        <th>취소</th>
                        <td colspan="3"><button type="button" class="reserve-cancel" onclick="cancelReserve('<%= reserve.getRESERVE_NUM() %>')">예약취소</button></td>                        
                    </tr>
                </table>
                <%
                    } // for 문 닫기
                %>
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
                        location.href = ".././trip/tripPage_hotel.jsp";
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
