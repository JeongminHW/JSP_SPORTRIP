<%@page import="team.TeamBean"%>
<%@page import="board.BoardBean"%>
<%@page import="lodging.LodgingBean"%>
<%@page import="reserve.ReserveBean"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="md.MDBean"%>
<%@page import="charge.ChargeBean"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="userMgr" class="user.UserMgr" />
<jsp:useBean id="chargeMgr" class="charge.ChargeMgr" />
<jsp:useBean id="reserveMgr" class="reserve.ReserveMgr" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<jsp:useBean id="lodgingMgr" class="lodging.LodgingMgr" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<%

	request.setCharacterEncoding("UTF-8");
	System.out.println(login.getName());

	//금액 포맷 설정
	DecimalFormat formatter = new DecimalFormat("###,###");

	String id = login.getId();
	String email = login.getEmail();
	String name = login.getName();
	String phone = login.getPhone();
	int zipcode = login.getPostcode();
	String address = login.getAddress();
    String part1 = "";
    String part2 = "";
    Vector<ChargeBean> chargeVlist = null;
    Vector<ReserveBean> reserveVlist = null;
    Vector<BoardBean> boardVlist = null;

    if (login.getId() != null) {
        UserBean userBean = new UserBean();

        userBean.setId(id);
        userBean.setName(name);
        userBean.setAddress(address);
        userBean.setPostcode(zipcode);
        userBean.setPhone(phone);
        userBean.setEmail(email);

        if (address != null && !address.isEmpty()) {
            Pattern pattern = Pattern.compile("^(.*?)(\\((.*)\\))$");
            Matcher matcher = pattern.matcher(address);

            if (matcher.find()) {
                part1 = matcher.group(1).trim();
                part2 = matcher.group(3);
            }
        } else {
            part1 = address;  
        }
    } else {
%>
        <script>
            alert("로그인을 진행하세요.");
            location.href = "login.jsp";
        </script>
<% 
    } 
%>
   
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet"/>
    <link href=".././assets/css/mypageStyle.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" href=".././assets/css/mainhamburger.css">
</head>
<body>
<header class="header">
	<a href=".././sport/sport_main.jsp"><img style="cursor: pointer; " src=".././assets/images/white_sportrip_logo.png" alt="sportrip"></a>
	<input id="toggle" type="checkbox"/>
        <label class="hamburger" for="toggle">
            <div class="top"></div>
            <div class="middle"></div>
            <div class="bottom"></div>
        </label>
</header>
	<jsp:include page="../hamburger.jsp"/>
	<div class="mypage">
		<div class="member-info">
			<div class="info">
				<span><%=name %>님</span>
				<button type="button" class="modify-button" onclick="openPopup()">회원 정보 수정</button>
				<a href=".././md/shoppingPage_basket.jsp">
				    <img alt="장바구니" src=".././assets/images/basket_icon.png" class="basket-icon">
				</a>

			</div>
		</div>
		<div class="popup-background">
			<div class="modify-popup">
				<div class="popup-header">
					<button type="button" onclick="closeWindow()" style="background: transparent; border: none; padding: 0; cursor: pointer;">
					    <img src=".././assets/images/close.png" alt="닫기" style="width: 24px; height: 24px; margin-right: 8px;">
					</button>
					<span>회원 정보 수정</span>
					<a href="#" onclick="logoutFun()">로그아웃</a>
					
				</div>
				<div class="popup-content">
					<div class="member-info-section">
						<div class="modify_form">
							<form id="modifyForm" action="" method="POST">
								<div class="input_box">
									<span>아이디</span>
									<input type="text" name="id" id="id" readonly value="<%=id%>" style="background-color: #ccc">
								</div>
								<div class="input_box">
									<span>이메일</span>
									<input type="text" name="email" id="email" value="<%=email%>">
								</div>
								<div class="input_box">
									<span>이름</span>
									<input type="text" name="name" id="name" value="<%=name%>">
								</div>
								<div class="input_box">
									<span>휴대폰 번호</span>
									<input style="margin: 0;" type="text" name="phone" id="phone" value="<%=phone%>">
								</div>
								<div class="input_box">
									<span>우편번호</span>
									<input type="text" name="zipcode" id="zipcode" value="<%=zipcode%>">
									<div class="input_label">
										<button type="button" onclick="search_address()">검색</button>
									</div>
								</div>
								<div class="input_box">
									<span>주소</span>
									<input type="text" name="address" id="address" value="<%=part1%>">
								</div>
								<div class="input_box" id="extraAddr">
									<input type="text" name="extraAddr" value="<%=part2%>">
								</div>
							</form>
						</div>
						<div class="secession">
							<a onclick="deleteUser()">탈퇴하기</a>
							<button type="button" class="save-button" onclick="updateUser()">저장하기</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="myorder-area">
			<div class="arrow arrow-left" id="arrow-left"
				onclick="slideContent(-1)">&#60;</div>
			<div class="myorder-section">
				<div class="myorder-title">
					<span>굿즈 주문 내역</span>
				</div>
				<div class="sports-button">
					<button class="order-tab-button"
						onclick="openOrderTab(event, 'baseball')">야구</button>
					<button class="order-tab-button"
						onclick="openOrderTab(event, 'soccer')">축구</button>
					<button class="order-tab-button"
						onclick="openOrderTab(event, 'volleyball')">배구</button>
				</div>

				<div class="tab-content-wrapper">
					<div class="tab-content-container" id="tab-content-container">
						<div id="baseball" class="tab-content" style="display: none;">
							<div class="myorder-list">
								<%
								    
									chargeVlist = chargeMgr.findSportCharge(id, 1);
									for(ChargeBean chargeBean : chargeVlist){
										MDBean mdBean = mdMgr.getMD(chargeBean.getMD_NUM());
								%>
								<div class="myorder-content">
									<img alt="상품사진" src="<%=mdBean.getMD_IMG() %>">
									<div class="goods-info">
										<span class="goods-price"><%=formatter.format(chargeBean.getPRICE()) %>원</span> 
										<span class="goods-name"><a href=".././md/shoppingPage_paymentDetail.jsp?orderNumber=<%=chargeBean.getORDER_NUM()%>"><%=mdBean.getMD_NAME() %></a></span>
									</div>
								</div>
								<%
									}
								%>
								
							</div>
						</div>
						<div id="soccer" class="tab-content" style="display: none;">
							<div class="myorder-list">
								<%
									chargeVlist = chargeMgr.findSportCharge(id, 2);
									for(ChargeBean chargeBean : chargeVlist){
										MDBean mdBean = mdMgr.getMD(chargeBean.getMD_NUM());
								%>
								<div class="myorder-content">
									<img alt="상품사진" src="<%=mdBean.getMD_IMG() %>">
									<div class="goods-info">
										<span class="goods-price"><%=formatter.format(chargeBean.getPRICE()) %>원</span>
										<span class="goods-name"><a href=".././md/shoppingPage_paymentDetail.jsp?orderNumber=<%=chargeBean.getORDER_NUM()%>"><%=mdBean.getMD_NAME() %></a></span>
									</div>
								</div>
								<%
									}
								%>
								
							</div>
						</div>
						<div id="volleyball" class="tab-content" style="display: none;">
							<div class="myorder-list">
								<%
									chargeVlist = chargeMgr.findSportCharge(id, 3);
									for(ChargeBean chargeBean : chargeVlist){
										MDBean mdBean = mdMgr.getMD(chargeBean.getMD_NUM());
								%>
								<div class="myorder-content">
									<img alt="상품사진" src="<%=mdBean.getMD_IMG() %>">
									<div class="goods-info">
										<span class="goods-price"><%=formatter.format(chargeBean.getPRICE()) %>원</span> 
										<span class="goods-name"><a href=".././md/shoppingPage_paymentDetail.jsp?orderNumber=<%=chargeBean.getORDER_NUM()%>"><%=mdBean.getMD_NAME() %></a></span>
									</div>
								</div>
								<%
									}
								%>
								
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="arrow arrow-right" id="arrow-right"
				onclick="slideContent(1)">&#62;</div>
		</div>

		<div class="myhotel-area">
			<div class="arrow arrow-left" id="hotel-arrow-left"
				onclick="slideHotelContent(-1)">&#60;</div>
			<div class="myhotel-section">
				<div class="myhotel-title">
					<span>숙소 예약 내역</span>
				</div>
				<div class="hotel-button">
					<button class="hotel-tab-button"
						onclick="openHotelTab(event, 'reservation')">이용예정</button>
					<button class="hotel-tab-button"
						onclick="openHotelTab(event, 'completed')">이용완료</button>
				</div>

				<div class="tab-content-wrapper">
					<div class="tab-content-container" id="hotel-tab-content-container">
						<div id="reservation" class="tab-content" style="display: none;">
							<div class="myhotel-list">
								<%
									// 현재 날짜보다 이후
									reserveVlist = reserveMgr.soonListReserve(id);
									if(reserveVlist !=null){
										for(ReserveBean reserveBean : reserveVlist){
											LodgingBean lodgingbean = lodgingMgr.getLodging(reserveBean.getLODGING_NUM());
									
									
								%>
										<div class="myhotel-content">
											<img class="mypage-hotel-img" alt="호텔 사진" src="<%=lodgingbean.getLODGING_IMG()%>">
											<div class="hotel-info">
												<span class="hotel-price"><%=formatter.format(reserveBean.getRESERVE_PRICE()) %>원</span> 
												<span class="hotel-name"><a href=".././trip/reserve_detail.jsp?reserveNum=<%=reserveBean.getRESERVE_NUM()%>"><%=lodgingbean.getLODGING_NAME()%></a></span>
												<p style="font-size: 14px;"><%=reserveBean.getCHECK_IN()%> ~ <%=reserveBean.getCHECK_OUT()%></p>
											</div>
										</div>
								<%
										}}
								%>

							</div>
						</div>
						<div id="completed" class="tab-content" style="display: none;">
							<div class="myhotel-list">
								<%
								reserveVlist = reserveMgr.endListReserve(id);
								if(reserveVlist !=null){
									for(ReserveBean reserveBean : reserveVlist){
										LodgingBean lodgingbean = lodgingMgr.getLodging(reserveBean.getLODGING_NUM());
								
								
							%>
									<div class="myhotel-content">
										<img class="mypage-hotel-img" alt="호텔 사진" src="<%=lodgingbean.getLODGING_IMG()%>">
										<div class="hotel-info">
											<span class="hotel-price"><%=formatter.format(reserveBean.getRESERVE_PRICE()) %>원</span> 
											<span class="hotel-name"><a href=".././trip/reserve_detail.jsp?reserveNum=<%=reserveBean.getRESERVE_NUM()%>"><%=lodgingbean.getLODGING_NAME()%></a></span>
											<p style="font-size: 13px;"><%=reserveBean.getCHECK_IN()%> ~ <%=reserveBean.getCHECK_OUT()%></p>
										</div>
									</div>
							<%
									}}
							%>

							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="arrow arrow-right" id="hotel-arrow-right"
				onclick="slideHotelContent(1)">&#62;</div>
		</div>

		<div class="myboard-area">
			<div class="myboard-section">
				<div class="myboard-header">
					<span>작성글</span>
				</div>
				<table class="myboard-list">
					<thead>
						<tr>
							<td>팀</td>
							<td>제목</td>
							<td>조회수</td>
							<td>작성일</td>
						</tr>
					</thead>
					<tbody id="myboard-list-body">
					    <%
					        boardVlist = boardMgr.findIdBoard(id);
					        if(boardVlist != null) {
					            for(BoardBean boardBean : boardVlist) {
					            	TeamBean teamInfo = teamMgr.getTeam(boardBean.getTEAM_NUM());
					    %>
					                <tr class="myboard__list__detail" onclick="">
					                    <td class="team">
					                        <span class="myboard-team"><%=teamInfo.getTEAM_NAME() %></span>
					                    </td>
					                    <td class="title">
					                        <a href="#" onclick="sendBoardNum(<%=boardBean.getBOARD_NUM()%>,<%=teamInfo.getTEAM_NUM()%>,'.././board/viewPost')"><span class="myboard-title"><%=boardBean.getTITLE() %></span></a>
					                    </td>
					                    <td class="view">
					                        <span class="myboard-view"><%=boardBean.getVIEWS() %></span>
					                    </td>
					                    <td class="date">
					                        <span class="myboard-date"><%=boardBean.getPOSTDATE() %></span>
					                    </td>
					                </tr>
					    <%
					            }
					        }
					    %>
				</tbody>
				</table>
				<div class="load-more-container">
					<div>
					    <button id="load-more">더보기</button>
					    <img id="down-arrow" src=".././assets/images/down-arrow.png" alt="화살표">
				    </div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript"> //굿즈 스크립트
    let currentIndex = 0;
    const itemsToShow = 5; // 한 번에 보여줄 아이템 수
    const itemWidth = 210; // 각 탭 콘텐츠의 너비

    function slideContent(direction) {
        const container = document.getElementById('tab-content-container');
        const visibleTabs = Array.from(document.querySelectorAll('.tab-content')).filter(tab => tab.style.display !== 'none'); // 현재 보이는 탭 콘텐츠
        const totalItems = visibleTabs[0].querySelectorAll('.myorder-content').length; // 선택된 탭의 콘텐츠 수
        const maxIndex = totalItems - itemsToShow; // 마지막 항목을 넘지 않도록 설정

        // 방향에 따른 현재 인덱스 조정
        if (direction === 1 && currentIndex < maxIndex) { // 오른쪽으로 슬라이드
            currentIndex++;
        } else if (direction === -1 && currentIndex > 0) { // 왼쪽으로 슬라이드
            currentIndex--;
        }

        const newTransformValue = -(currentIndex * itemWidth);
        container.style.transform = 'translateX(' + newTransformValue + 'px)';

        // 버튼 활성화 상태 업데이트
        updateArrowButtons(maxIndex);
    }

    function updateArrowButtons(maxIndex) {
        const leftArrow = document.getElementById('arrow-left');
        const rightArrow = document.getElementById('arrow-right');

        // 왼쪽 화살표 비활성화
        leftArrow.style.display = currentIndex === 0 ? 'none' : 'block';
        // 오른쪽 화살표 비활성화
        rightArrow.style.display = currentIndex >= maxIndex ? 'none' : 'block';
    }

    // 기본적으로 화살표 버튼을 숨기기
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById('arrow-left').style.display = 'none';
        document.getElementById('arrow-right').style.display = 'none';
        document.getElementById('hotel-arrow-left').style.display = 'none';
        document.getElementById('hotel-arrow-right').style.display = 'none';
        
        // 기본적으로 모든 탭 콘텐츠를 숨김
        const allTabs = document.querySelectorAll('.tab-content');
        allTabs.forEach(tab => tab.style.display = 'none');
    });
     
    function openOrderTab(evt, tabName) {
        const allTabs = document.querySelectorAll('.tab-content');
        const container = document.getElementById('tab-content-container');

        // 모든 탭을 숨기고 선택된 탭만 보이도록 설정
        allTabs.forEach(tab => {
            tab.style.display = (tab.id === tabName) ? 'block' : 'none';
        });

        currentIndex = 0;
        container.style.transform = 'translateX(0)'; // 여기에 작은 수정 추가

        // 모든 order-tab-button의 active 클래스 제거
        const orderTabButtons = document.getElementsByClassName("order-tab-button");
        for (let i = 0; i < orderTabButtons.length; i++) {
            orderTabButtons[i].className = orderTabButtons[i].className.replace(" active", "");
        }
        evt.currentTarget.className += " active";

        // 호텔 탭 버튼의 active 클래스 제거 (굿즈 탭을 눌렀을 때)
        const hotelTabButtons = document.getElementsByClassName("hotel-tab-button");
        for (let i = 0; i < hotelTabButtons.length; i++) {
            hotelTabButtons[i].className = hotelTabButtons[i].className.replace(" active", "");
        }
        
        // 화살표 버튼 상태 업데이트
        const visibleTabs = Array.from(document.querySelectorAll('.tab-content')).filter(tab => tab.style.display !== 'none');
        const visibleItems = visibleTabs[0].querySelectorAll('.myorder-content').length; // 선택된 탭의 콘텐츠 수

        // 굿즈 주문 내역 화살표 버튼의 상태 업데이트
        updateArrowButtons(visibleItems - itemsToShow);

        // 숙소 예약 내역의 화살표 버튼 숨기기
        document.getElementById('hotel-arrow-left').style.display = 'none';
        document.getElementById('hotel-arrow-right').style.display = 'none';
    }
</script>


	<script type="text/javascript"> // 호텔 스크립트
        // myhotel-area 슬라이드 기능
        let hotelCurrentIndex = 0;
        const hotelItemsToShow = 5;
        const hotelItemWidth = 210;

        function slideHotelContent(direction) {
            const hotelContainer = document.getElementById('hotel-tab-content-container');
            const visibleHotelTabs = Array.from(document.querySelectorAll('.tab-content')).filter(tab => tab.style.display !== 'none');
            const totalHotelItems = visibleHotelTabs[0].querySelectorAll('.myhotel-content').length; // 선택된 탭의 콘텐츠 수
            const hotelMaxIndex = totalHotelItems - hotelItemsToShow;

            // 방향에 따른 현재 인덱스 조정
            if (direction === 1 && hotelCurrentIndex < hotelMaxIndex) { // 오른쪽으로 슬라이드
            	hotelCurrentIndex++;
            } else if (direction === -1 && hotelCurrentIndex > 0) { // 왼쪽으로 슬라이드
            	hotelCurrentIndex--;
            }
            
            const newTransformValue = -(hotelCurrentIndex * hotelItemWidth);
            hotelContainer.style.transform = 'translateX(' + newTransformValue + 'px)';

            // 버튼 활성화 상태 업데이트
            updateHotelArrowButtons(hotelMaxIndex);
        }

        function updateHotelArrowButtons(hotelMaxIndex) {
            const hotelLeftArrow = document.getElementById('hotel-arrow-left');
            const hotelRightArrow = document.getElementById('hotel-arrow-right');

            hotelLeftArrow.style.display = hotelCurrentIndex === 0 ? 'none' : 'block';
            hotelRightArrow.style.display = hotelCurrentIndex >= hotelMaxIndex ? 'none' : 'block';
        }
        
        function openHotelTab(evt, hotelTabName) {
            const allHotelTabs = document.querySelectorAll('.tab-content');
            const hotelContainer = document.getElementById('hotel-tab-content-container');

            // 모든 탭을 숨기고 선택된 탭만 보이도록 설정
            allHotelTabs.forEach(tab => {
                tab.style.display = (tab.id === hotelTabName) ? 'block' : 'none';
            });

            hotelCurrentIndex = 0;
            hotelContainer.style.transform = 'translateX(0)'; // 여기에 작은 수정 추가

            // 모든 hotel-tab-button의 active 클래스 제거
            const hotelTabButtons = document.getElementsByClassName("hotel-tab-button");
            for (let i = 0; i < hotelTabButtons.length; i++) {
                hotelTabButtons[i].className = hotelTabButtons[i].className.replace(" active", "");
            }
            evt.currentTarget.className += " active";

            // 굿즈 탭 버튼의 active 클래스 제거 (호텔 탭을 눌렀을 때)
            const orderTabButtons = document.getElementsByClassName("order-tab-button");
            for (let i = 0; i < orderTabButtons.length; i++) {
                orderTabButtons[i].className = orderTabButtons[i].className.replace(" active", "");
            }

            // 숙소 예약 내역 화살표 버튼 상태 업데이트
            const visibleHotelTabs = Array.from(document.querySelectorAll('.tab-content')).filter(tab => tab.style.display !== 'none');
            const visibleHotelItems = visibleHotelTabs[0].querySelectorAll('.myhotel-content').length; // 선택된 탭의 콘텐츠 수

            // 숙소 예약 내역 화살표 버튼의 상태 업데이트
            updateHotelArrowButtons(visibleHotelItems - hotelItemsToShow);

            // 굿즈 주문 내역의 화살표 버튼 숨기기
            document.getElementById('arrow-left').style.display = 'none';
            document.getElementById('arrow-right').style.display = 'none';
        }
    </script>

	<script> //게시판 스크립트
	  document.addEventListener("DOMContentLoaded", function () {
	    var contents = document.querySelectorAll(".myboard-content");
	
	    contents.forEach(function (content) {
	      var text = content.innerText;
	
	      // 글자 수가 25자를 넘으면 뒤를 생략하고 '...' 붙이기
	      if (text.length > 20) {
	        content.innerText = text.slice(0, 25) + "...";
	      }
	    });
	  });
	  
	  document.addEventListener("DOMContentLoaded", function () {
		    const boardDetails = document.querySelectorAll(".myboard__list__detail");
		    const loadMoreBtn = document.getElementById("load-more");
		    const downarrowBtn = document.getElementById("down-arrow");
		    const boardArea = document.querySelector(".myboard-area");
		    const maxVisibleItems = 3; // 최대 보이는 항목 수
		    let isExpanded = false;

		    // 초기 높이 설정
		    adjustBoardHeight();

		    // 처음에 3개만 표시하고 나머지는 숨김
		    boardDetails.forEach((detail, index) => {
		        if (index >= maxVisibleItems) {
		            detail.classList.add("hidden"); // 숨김 클래스 추가
		        } else {
		            detail.classList.remove("hidden"); // 첫 3개는 표시
		        }
		    });

		    // 숨겨진 요소가 있을 때 "더보기" 버튼을 표시
		    if (boardDetails.length > maxVisibleItems) {
		        loadMoreBtn.style.display = "inline-block";
		    }

		    // 더보기/숨기기 버튼 클릭 시 동작
		    loadMoreBtn.addEventListener("click", function () {
		        if (!isExpanded) {
		            // 숨겨진 요소 표시 (더보기)
		            const hiddenItems = Array.from(boardDetails).slice(maxVisibleItems);

		            hiddenItems.forEach((detail, index) => {
		                setTimeout(() => {
		                    detail.classList.remove("hidden"); // 숨김 해제
		                    adjustBoardHeight(); // 높이 재조정
		                }, index * 50); // 애니메이션 속도를 50ms로 변경
		            });

		            // 버튼을 "숨기기"로 변경
		            loadMoreBtn.textContent = "숨기기";
		            isExpanded = true;
		        } else {
		            // 요소 숨기기 (숨기기)
		            const visibleItems = Array.from(boardDetails).slice(maxVisibleItems);

		            visibleItems.reverse().forEach((detail, index) => {
		                setTimeout(() => {
		                    detail.classList.add("hidden"); // 다시 숨김
		                    adjustBoardHeight(); // 높이 재조정
		                }, index * 50); // 애니메이션 속도를 50ms로 변경
		            });

		            // 버튼을 "더보기"로 변경
		            loadMoreBtn.textContent = "더보기";
		            isExpanded = false;
		        }
		    });

		    // 높이 자동 조정을 위한 함수
		    function adjustBoardHeight() {
		        const visibleItems = Array.from(boardDetails).filter(detail => !detail.classList.contains("hidden"));
		        const totalHeight = visibleItems.reduce((height, item) => height + item.offsetHeight, 0);
		        
		        // thead, header 및 load-more 버튼의 높이 포함
		        const headerHeight = document.querySelector(".myboard-header").offsetHeight; // myboard-header의 높이
		        const theadHeight = document.querySelector("thead").offsetHeight; // thead의 높이
		        const loadMoreBtnHeight = loadMoreBtn.offsetHeight; // load-more 버튼의 높이
		        
		        // myboard-area의 padding 값
		        const boardAreaStyle = window.getComputedStyle(boardArea);
		        const paddingTop = parseFloat(boardAreaStyle.paddingTop);
		        const paddingBottom = parseFloat(boardAreaStyle.paddingBottom);

		        // myboard-area 높이 조정
		        const newHeight = headerHeight + theadHeight + totalHeight + loadMoreBtnHeight + paddingTop + paddingBottom + 30; // 여유 공간 포함
		        boardArea.style.height = newHeight + "px"; // 높이 설정
		    }

		    // 초기 높이 조정
		    window.addEventListener("load", adjustBoardHeight);
		    
		    // 창 크기 변경 시 높이 자동 조정
		    window.addEventListener("resize", adjustBoardHeight);
		});
	  
		// 더보기 버튼과 화살표의 초기 상태 설정
	    document.addEventListener("DOMContentLoaded", function() {
	        const loadMoreButton = document.getElementById('load-more');
	        const downArrow = document.getElementById('down-arrow');
	        const trElements = document.querySelectorAll('#myboard-list-body tr');
	
	        // tr 요소가 3개 이상인지 확인
	        if (trElements.length < 4) {
	            loadMoreButton.style.display = 'none'; // 더보기 버튼 숨기기
	            downArrow.style.display = 'none'; // 화살표 이미지 숨기기
	        } else {
	            loadMoreButton.style.display = 'block'; // 더보기 버튼 보이기
	            downArrow.style.display = 'inline'; // 화살표 이미지 보이기
	        }
	
	        // 더보기 버튼 클릭 시 화살표 회전
	        loadMoreButton.addEventListener('click', function() {
	            downArrow.classList.toggle('rotate');
	        });
	    });
	
	    // 숨기기 버튼 클릭 시 화살표 원래대로
	    function hideContent() {
	        const downArrow = document.getElementById('down-arrow');
	        downArrow.classList.remove('rotate');
	    }
	</script>

	<script> //팝업 스크립트
		// 팝업 열기
		function openPopup() {
		    document.querySelector('.popup-background').style.display = 'flex';
		}
	
		function closeWindow() {
	        const popupBackground = document.querySelector('.popup-background');
	        popupBackground.style.display = 'none';
		}
		
		// 저장
	    function updateUser() {
	    	// 데이터를 수집
	    	let id = document.getElementById('id').value;
	    	let email = document.getElementById('email').value;
	    	let name = document.getElementById('name').value; 
	    	let phone = document.getElementById('phone').value;
	    	let zipcode = document.getElementById('zipcode').value;
	    	let address = document.getElementById('address').value;
	    	let extraAddr = document.querySelector('[name="extraAddr"]').value;
	    	address = address + "(" + extraAddr + ")";
	    	
		    const params = new URLSearchParams();

		    params.append('id', id);
		    params.append('email', email);
	    	params.append('name', name);
	    	params.append('phone', phone);
	    	params.append('zipcode', zipcode);
	    	params.append('address', address);

		    fetch('update_user.jsp', {
		        method: 'POST',
		        headers: {
		            'Content-Type': 'application/x-www-form-urlencoded'
		        },
		        body: params.toString() // 쿼리 스트링으로 변환하여 보냄
		    })
	    	.then(response => response.text())
	    	.then(data => {
	    	    if (data.includes("success")) { 
	    	        alert("수정사항이 저장되었습니다.");
	    	        closeWindow();
	    	        location.href="myPage.jsp";
	    	    } else {
	    	        alert('수정사항이 저장되지 않았습니다.');
	    	    }
	    	})
	    	.catch(error => console.error('Error:', error));
		}
		
	    function deleteUser() {
	    	// 데이터를 수집
	    	let id = document.getElementById('id').value;
	    	
		    const params = new URLSearchParams();

		    params.append('id', id);

		    fetch('delete_user.jsp', {
		        method: 'POST',
		        headers: {
		            'Content-Type': 'application/x-www-form-urlencoded'
		        },
		        body: params.toString() // 쿼리 스트링으로 변환하여 보냄
		    })
	    	.then(response => response.text())
	    	.then(data => {
	    	    if (data.includes("success")) { 
	    	        alert("탈퇴가 완료되었습니다.");
	    	        closeWindow();
	    	        location.href = ".././sport/sport_main.jsp";
	    	    }else{
	    	        alert("탈퇴가 실패하였습니다.");
	    	    }
	    	})
	    	.catch(error => console.error("Error:", error));
		}
	</script>


	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
		function search_address() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var addr = ''; // 주소 변수
							var extraAddr = ''; // 참고항목 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}

							// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
							if (data.userSelectedType === 'R') {
								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
								}
							} else {
								document.getElementById("address").value = '';
							}

							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							document.getElementById("zipcode").value = data.zonecode;
							document.getElementById("address").value = addr;
							// 커서를 상세주소 필드로 이동한다.
							document.getElementById("address").focus();
						}
					}).open();
		}
		
		// 게시글 번호 전달
		function sendBoardNum(boardNum,teamNum, page) {
		    // 세션에 값을 설정
		    var form = document.createElement("form");
		    form.setAttribute("method", "POST");
		    form.setAttribute("action", page + ".jsp");
		
		    var boardField = document.createElement("input");
		    boardField.setAttribute("type", "hidden");
		    boardField.setAttribute("name", "boardNum");
		    boardField.setAttribute("value", boardNum);
		    form.appendChild(boardField);
		
		    var teamNumField = document.createElement("input");
		    teamNumField.setAttribute("type", "hidden");
		    teamNumField.setAttribute("name", "teamNum");
		    teamNumField.setAttribute("value", teamNum);
		    form.appendChild(teamNumField);
		
		    document.body.appendChild(form);
		    form.submit();
		}

		
		function logoutFun() {
	    	let id = document.getElementById('id').value;
	    	
		    const params = new URLSearchParams();

		    params.append('id', id);

		    fetch('logout.jsp', {
		        method: 'POST',
		        headers: {
		            'Content-Type': 'application/x-www-form-urlencoded'
		        },
		        body: params.toString() // 쿼리 스트링으로 변환하여 보냄
		    })
	    	.then(response => response.text())
	    	.then(data => {
	    	    if (data.includes("success")) { 
	    	        alert("로그아웃이 완료되었습니다.");
	    	        closeWindow();
	    	        location.href = ".././sport/sport_main.jsp";
	    	    }else{
	    	        alert("로그아웃이 실패하였습니다.");
	    	    }
	    	})
	    	.catch(error => console.error("Error:", error));
		}
	</script>
</body>
</html>