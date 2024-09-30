<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, room.RoomMgr, room.RoomBean" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>객실 정보</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    
    <script>
        function goMain(){
            document.location.href="mainPage.jsp";
        }

        function goList(){
            document.location.href="hotel_main.html";
        }

        function openModal(){
            document.querySelector('.modal').style.display = 'block';
        }

        function closeModal(){
            document.querySelector('.modal').style.display = 'none';
        }
    </script>
</head>
<body>
    <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()"><img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a>
        <div class="login-signup-box">
            <ul>
                <li><a href="login.html" style="font-family: BMJUA; color: black;">로그인</a></li>
                <li><a href="signup.html" style="font-family: BMJUA; color: black;">회원가입</a></li>
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
            String lodgingNumStr = request.getParameter("lodgingNum"); // lodgingNum 파라미터 받아오기
            if (lodgingNumStr != null && !lodgingNumStr.equals("")) {
                int lodgingNum = Integer.parseInt(lodgingNumStr);
                RoomMgr roomMgr = new RoomMgr();
                List<RoomBean> roomList = roomMgr.getRoomsByLodgingNum(lodgingNum); // LODGING_NUM에 맞는 객실 정보 가져오기

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
                        <button class="show-detail" onclick="openModal()">예약하기</button>
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
    

    <!-- 모달 팝업 시작 -->
    <div class="modal">
        <div class="modal-popup">
            <div class="modal-header">
                <h2>예약하기</h2>
                <p style="font-weight: 600; font-size: 22px;">스탠다드 더블룸<br><span style="font-weight: 500; font-size: 18px;">(2인 기준/최대 4인)</span></p>
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
                <div id="reserve_name" name="name" class="modal-item">
                    <span>이름</span>
                    <input type="text" class="input-text">
                </div>
                <div class="modal-item">
                    <span>이메일</span>
                    <div class="email-box">
                        <input style="width: 185px; margin-right: 0px;" type="text" class="input-text">
                        <span>@</span>
                        <select style="width: auto; margin-left: 0px;" name="domain" id="">
                            <option value="naver">naver.com</option>
                        </select>
                    </div>
                </div>
                <div class="modal-item">
                    <span>연락처</span>
                    <input type="text" class="input-text">
                </div>
                <div class="modal-item">
                    <span>결제방법</span>
                    <div class="paytype-box">
                        <button name="toss">토스페이</button>
                        <button name="kakao">카카오페이</button>
                        <button name="naver">네이버페이</button>
                        <button name="credit">신용카드</button>
                    </div>
                </div>
            </div>
            <div class="reserve-box">
                <button class="close-btn" onclick="closeModal()">취소</button>
                <button class="reserve-btn">예약</button>
            </div>
        </div>
    </div>
    <!-- 모달 팝업 끝 -->
    <div class="footer">
        <input type="button" value="목록" onclick="location.href='tripPage_Hotel.jsp'">
    </div>
</body>
</html>