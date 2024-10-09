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
<body style="margin: 0; background-color: #EEEEEE;">
    <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
        <div class="login-signup-box">
            <ul>
                <li><a href="login.jsp" style="font-family: BMJUA; color: black;">로그인</a></li>
                <li><a href="signup.jsp" style="font-family: BMJUA; color: black;">회원가입</a></li>
            </ul>
        </div>
    </header>
    <div class="room_main">
	    <div class="h_top">
	        <div class="item">
	            <button type="button" class="hotel-btn" onclick="location.href='tripPage_Hotel.jsp'" style="background-color: #236FB5; color: white;">숙소</button>
	            <button type="button" class="food-btn" onclick="location.href='tripPage_Food.jsp'">식당</button>
	        </div>
	    </div>
	
		<div class="room-info-section">
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
		            <div class="room-box">
					<div class="room-img">
						<img src="<%=room.getROOM_IMG()%>" alt="객실 이미지">
						<div class="original-img">
							<img src="<%=room.getROOM_IMG()%>" alt="원본 이미지">
						</div>
					</div>
					<div class="info-item">
		                    <span class="title" style="font-size: 24px;"><%= room.getROOM_NAME() %></span><br>
		                    <p class="service">
		                        <img src=".././assets/images/service_img.png" alt="서비스 이미지">수용 인원: <%= room.getSEAT_CAPACITY_R() %>명
		                    </p>
		                </div>
		                <div class="info-item-button">
		                    <p><%= room.getROOM_PRICE() %>원</p>
		                    <button class="show-detail" onclick="openModal(<%= lodgingNum %>, <%= room.getROOM_NUM() %>, <%= room.getROOM_PRICE() %>, <%= room.getSEAT_CAPACITY_R() %>)">예약하기</button>
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
	    </div>
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
                    <input type="date" id="check_in_date" class="input-text start-date" name="checkIn" onchange="updateCheckoutDate()" min="">
                </div>
                <div class="modal-item">
                    <span>체크아웃 날짜</span>
                    <input type="date" id="check_out_date" class="input-text end-date" name="checkOut" min="">
                </div>
            </div>
            <div class="reserve-box">
                <button class="close-btn" onclick="closeModal()">취소</button>
                <button class="reserve-btn" onclick="submitReservation()">예약</button>
            </div>
        </div>
    </div>

    <div class="footer">
        <button type="button"onclick="location.href='tripPage_Hotel.jsp'" class="list_btn">목록</button>
    </div>
    
    <script>
    let selectedSport; // 선택된 스포츠
    let selectedStadium; // 선택된 경기장
    let selectedLodgingNum; // 선택된 숙소 번호
    let selectedRoomNum; // 선택된 객실 번호
    let roomPrice; // 객실 가격

    function goMain(){
        document.location.href=".././sport/mainPage.jsp";
    }

    function openModal(lodgingNum, roomNum, price, capacity){
    	
    	selectedLodgingNum = lodgingNum; // 선택된 숙소 번호 저장
        selectedRoomNum = roomNum; // 선택된 객실 번호 저장
        roomPrice = price; // 객실 가격 저장
        document.querySelector('.modal').style.display = 'block';
        
        
        // 인원 수 선택 옵션 초기화
        const selectPerson = document.getElementById("select-person");
        selectPerson.innerHTML = ''; // 기존 옵션을 비웁니다.

        // 수용 인원에 맞게 옵션 생성
        for (let i = 1; i <= capacity; i++) {
            const option = document.createElement("option");
            option.value = i;
            option.innerText = i; 
            selectPerson.appendChild(option);
        }
        document.querySelector('.modal').style.display = 'block';
    }

    function closeModal(){
        document.querySelector('.modal').style.display = 'none';
        document.getElementById("select-person").value = "1"; 
        document.getElementById("reserve_name").value = "";
        document.getElementById("contact").value = "";
        document.getElementById("check_in_date").value = "";
        document.getElementById("check_out_date").value = "";
    }
    
 	// 현재 날짜 이후 선택 가능하게 설정하는 함수
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('check_in_date').setAttribute('min', today);

    function getSelectedStadium() {
        // 현재 선택된 경기장 정보를 가져오는 로직 구현
        return "someStadium"; // 선택된 경기장 이름을 반환
    }

    function updateCheckoutDate() {
        const checkInDate = document.getElementById('check_in_date').value;
        // 체크인 날짜 이후부터 체크아웃 날짜 선택 가능하게 설정
        document.getElementById('check_out_date').setAttribute('min', checkInDate);
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
        const IMP = window.IMP; 
        IMP.init('imp13042654');

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
                // 결제 성공
                alert("결제가 완료되었습니다.");
                closeModal(); // 모달 닫기
                // 데이터베이스에 예약 정보 저장 요청
                saveReservation(paymentData);
            } else {
                // 결제 실패
                alert("결제에 실패하였습니다. 에러: " + response.error_msg);
            }
        });
    }

    function saveReservation(data) {
        // AJAX 호출 등으로 서버에 예약 정보 저장
        // 예시:
        $.ajax({
            url: 'saveReserve.jsp', // 서버로의 요청 URL
            type: 'POST',
            data: data,
            success: function(response) {
                alert("예약이 완료되었습니다.");
                location.reload(); // 페이지 새로고침
            },
            error: function(xhr, status, error) {
                alert("예약 저장에 실패했습니다. 에러: " + error);
            }
        });
    }
    </script>
</body>
</html>
