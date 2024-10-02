<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, room.RoomMgr, room.RoomBean" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>객실 정보</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
</head>
<body>
    <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
        <div class="login-signup-box">
            <ul>
                <li><a href="login.jsp" style="font-family: BMJUA; color: black;">로그인</a></li>
                <li><a href="signup.jsp" style="font-family: BMJUA; color: black;">회원가입</a></li>
            </ul>
        </div>
    </header>
    <div class="h_top">
        <div class="item" style="background-color: #083660;">
            <a href="tripPage_Hotel.jsp">호텔</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="tripPage_Food.jsp">맛집</a>
        </div>
    </div>
    <div class="search-box">
        <input name="searchText" type="text" placeholder="경기장을 검색하세요">
        <button><img src=".././assets/images/search_icon.png" alt="검색" title="검색"></button>
    </div>
    <div style="float: left;" class="date-box">
        <span>여행 날짜</span>
        <input type="date" class="start-date">
        <span style="margin-left: 10px;">~</span>
        <input type="date" class="end-date">
    </div>

    <div class="search-menu-box">
        <% 
            String lodgingNumStr = request.getParameter("lodgingNum");
            if (lodgingNumStr != null && !lodgingNumStr.equals("")) {
                int lodgingNum = Integer.parseInt(lodgingNumStr);
                RoomMgr roomMgr = new RoomMgr();
                List<RoomBean> roomList = roomMgr.getRoomsByLodgingNum(lodgingNum);

                if (!roomList.isEmpty()) {
                    for (RoomBean room : roomList) {
        %>
            <div class="hotel-box">
                <div class="hotel-img">
                    <img src="<%= room.getROOM_IMG() %>" alt="객실 이미지" style="width: 100%; height: auto;">
                </div>
                <div class="hotel-info-box">
                    <section class="info-item">
                        <span class="title" style="font-size: 24px;"><%= room.getROOM_NAME() %></span><br>
                        <p class="service">
                            <img src=".././assets/images/service_img.png" alt="서비스 이미지"> 
                            수용 인원: <%= room.getSEAT_CAPACITY_R() %>명
                        </p>
                    </section>
                    <section class="info-item">
                        <p><%= room.getROOM_PRICE() %>원</p>
                        <button class="show-detail" onclick="openModal(<%= lodgingNum %>, <%= room.getROOM_NUM() %>, <%= room.getROOM_PRICE() %>)">예약하기</button>
                    </section>
                </div>
            </div>
        <%
                    }
                } else {
        %>
                    <p>해당 숙소에 객실 정보가 없습니다.</p>
        <%
                }
            } else {
        %>
                <p>숙소 정보가 제공되지 않았습니다.</p>
        <%
            }
        %>
    </div>

    <div class="modal">
        <div class="modal-popup">
            <div class="modal-header">
                <h2>예약하기</h2>
            </div>
            <div class="modal-content">
                <div class="modal-item">
                    <span>인원 수</span>
                    <select name="person" id="select-person">
                        <option value="1">1명</option>
                        <option value="2">2명</option>
                        <option value="3">3명</option>
                        <option value="4">4명</option>
                    </select>
                </div>
                <div class="modal-item">
                    <span>이름</span>
                    <input type="text" id="reserve_name" class="input-text" name="name">
                </div>
                <div class="modal-item">
                    <span>연락처</span>
                    <input type="text" id="contact" class="input-text" name="contact">
                </div>
                <div class="modal-item">
                    <span>체크인 날짜</span>
                    <input type="date" id="check_in_date" class="input-text start-date" name="checkIn">
                </div>
                <div class="modal-item">
                    <span>체크아웃 날짜</span>
                    <input type="date" id="check_out_date" class="input-text end-date" name="checkOut">
                </div>
            </div>
            <div class="reserve-box">
                <button class="close-btn" onclick="closeModal()">취소</button>
                <button class="reserve-btn" onclick="submitReservation()">예약</button>
            </div>
        </div>
    </div>

    <div class="footer">
        <input type="button" value="목록" onclick="location.href='tripPage_Hotel.jsp'">
    </div>

    <script>
        let selectedLodgingNum; // 선택된 숙소 번호
        let selectedRoomNum; // 선택된 객실 번호
        let roomPrice; // 객실 가격

        function goMain(){
            document.location.href="mainPage.jsp";
        }

        function openModal(lodgingNum, roomNum, price){
            selectedLodgingNum = lodgingNum; // 선택된 숙소 번호 저장
            selectedRoomNum = roomNum; // 선택된 객실 번호 저장
            roomPrice = price; // 객실 가격 저장
            document.querySelector('.modal').style.display = 'block';
        }

        function closeModal(){
            document.querySelector('.modal').style.display = 'none';
            document.getElementById("select-person").value = "1"; // 기본값
            document.getElementById("reserve_name").value = "";
            document.getElementById("contact").value = "";
            document.getElementById("check_in_date").value = "";
            document.getElementById("check_out_date").value = "";
        }
        
        function submitReservation() {
            const headcount = document.getElementById("select-person").value;
            const name = document.getElementById("reserve_name").value;
            const contact = document.getElementById("contact").value;
            const checkIn = document.getElementById("check_in_date").value;
            const checkOut = document.getElementById("check_out_date").value;

            // 유효성 검사
            if (!headcount || !name || !contact || !checkIn || !checkOut) {
                alert('모든 필드를 입력해 주세요.');
                return;
            }

            // 결제 요청을 위한 데이터 객체
            const paymentData = {
                lodgingNum: selectedLodgingNum,
                roomNum: selectedRoomNum,
                headcount: headcount,
                name: name,
                contact: contact,
                checkIn: checkIn,
                checkOut: checkOut,
                price: roomPrice
            };

            // 결제 API 호출
            requestPayment(paymentData);
        }

        function requestPayment(paymentData) {
            const IMP = window.IMP; // 생략 가능
            IMP.init('imp13042654'); // IAMPORT에서 발급받은 가맹점 ID로 변경하세요

            IMP.request_pay({
                pg: "kakaopay.TC0ONETIME",
                pay_method: "card",
                merchant_uid: "order_" + new Date().getTime(),
                name: "호텔 예약",
                amount: paymentData.price,
                buyer_name: paymentData.name,
                buyer_tel: paymentData.contact,
                buyer_email: "user@example.com",
                // 추가 결제 정보
            }, function (response) {
                if (response.success) {
                    // 결제 성공 처리
                    alert("결제가 완료되었습니다.");
                    // 여기서 데이터베이스에 예약 정보 저장 로직 추가
                    saveReservation(paymentData);
                } else {
                    // 결제 실패 처리
                    alert("결제에 실패하였습니다. 에러 메시지: " + response.error_msg);
                }
            });
        }

        function saveReservation(paymentData) {
            $.ajax({
                type: 'POST',
                url: 'saveReserve.jsp', // 예약 정보를 저장할 JSP 파일
                data: {
                    lodgingNum: paymentData.lodgingNum,
                    roomNum: paymentData.roomNum,
                    headcount: paymentData.headcount,
                    name: paymentData.name,
                    contact: paymentData.contact,
                    checkIn: paymentData.checkIn,
                    checkOut: paymentData.checkOut,
                },
                success: function(response) {
                    alert("예약이 완료되었습니다.");
                    closeModal(); // 모달 닫기
                    location.reload(); // 페이지 새로 고침
                },
                error: function() {
                    alert("예약 저장 중 오류가 발생했습니다.");
                }
            });
        }
    </script>
</body>
</html>
