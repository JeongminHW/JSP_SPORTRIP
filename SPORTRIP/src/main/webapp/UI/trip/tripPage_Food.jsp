<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, stadium.StadiumMgr, stadium.StadiumBean, restaurant.RestaurantMgr, restaurant.RestaurantBean" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SPORTRIP 맛집</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=8afbb0c0c5d852ce84e4f0f3b93696b6"></script> 
    	
    <script>
        function goMain() {
            document.location.href="mainPage.jsp";
        }
        
        function openModal(restaurantName, restaurantLatitude, restaurantLongitude, stadiumName, stadiumLatitude, stadiumLongitude) {
            const modal = document.getElementById('mapModal');
            modal.style.display = 'block';

            // 모달 제목 설정
            document.getElementById('modalTitle').innerText = `맛집 위치`;

            // 지도 초기화
            const mapContainer = document.getElementById('map');
            const mapOption = {
                center: new kakao.maps.LatLng(restaurantLatitude, restaurantLongitude), // 맛집의 위도와 경도를 중심으로 설정
                level: 5 // 지도의 확대 레벨
            };

            const map = new kakao.maps.Map(mapContainer, mapOption);

            // 마커 이미지 설정 (숙소 마커 이미지)
            const restaurantImageSrc = '.././assets/images/restaurant_marker.png', // 숙소 마커 이미지 경로
            stadiumImageSrc = '.././assets/images/stadium_marker.png',
                imageSize = new kakao.maps.Size(57, 57), // 마커 이미지의 크기
                imageOption = { offset: new kakao.maps.Point(27, 69) }; // 마커 이미지의 옵션 (중심 좌표 조정)

         	// 맛집 마커 이미지 생성
            const restaurantMarkerImage = new kakao.maps.MarkerImage(restaurantImageSrc, imageSize, imageOption);

            // 맛집 마커 기본 설정 
            const restaurantMarker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(restaurantLatitude, restaurantLongitude),
                title: restaurantName,
                image: restaurantMarkerImage
            });
            restaurantMarker.setMap(map);
            
         	// 경기장 마커 이미지 생성
            const stadiumMarkerImage = new kakao.maps.MarkerImage(stadiumImageSrc, imageSize, imageOption);

            // 경기장 마커 기본 설정 
            const stadiumMarker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(stadiumLatitude, stadiumLongitude),
                title: stadiumName,
                image: stadiumMarkerImage
            });
            stadiumMarker.setMap(map);

        }

        function closeModal() {
            document.getElementById('mapModal').style.display = 'none';
        }
        
    </script>
    
    <style>
        /* 모달 스타일 */
        #mapModal {
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        #map {
            width: 100%;
            height: 450px;
        }
    </style>
</head>
<body style="margin: 0; background-color: #EEEEEE;">
    <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()">
            <img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img">
        </a>
        <div class="login-signup-box">
            <ul>
                <li><a href="../user/login.html" style="font-family: BMJUA; color: black;">로그인</a></li>
                <li><a href="../user/signup.html" style="font-family: BMJUA; color: black;">회원가입</a></li>
            </ul>
        </div>
    </header>
	<div class="food_main">
	    <div class="h_top">
	        <div class="item">
	            <button type="button" class="hotel-btn" onclick="location.href='tripPage_Hotel.jsp'">숙소</button>
	            <button type="button" class="food-btn" onclick="location.href='tripPage_Food.jsp'" style="background-color: #236FB5; color: white;">식당</button>
	        </div>
	    </div>
	
		<div class="hotel-info-section">	
		    <div style="float: left;" class="select-box">
		        <form method="POST" action="tripPage_Food.jsp" accept-charset="UTF-8">
			        <div class="custom-select-wrapper">
			            <select name="sportNum" class="select year" onchange="this.form.submit()">
			                <option value="0">스포츠</option>
			                <option value="1" <%= (request.getParameter("sportNum") != null && request.getParameter("sportNum").equals("1")) ? "selected" : "" %>>야구</option>
			                <option value="2" <%= (request.getParameter("sportNum") != null && request.getParameter("sportNum").equals("2")) ? "selected" : "" %>>축구</option>
			                <option value="3" <%= (request.getParameter("sportNum") != null && request.getParameter("sportNum").equals("3")) ? "selected" : "" %>>배구</option>
			            </select>
						<span class="custom-arrow">▼</span>
				    </div>
				    
				    <div class="custom-select-wrapper">
			            <select name="stadium" id="stadiumSelect" class="select month" onchange="this.form.submit()">
			                <option value="0">경기장</option>
			                <% 
			                    String sportNumStr = request.getParameter("sportNum");
			                    if (sportNumStr != null && !sportNumStr.equals("0")) {
			                        int sportNum = Integer.parseInt(sportNumStr);
			                        StadiumMgr stadiumMgr = new StadiumMgr();
			                        List<StadiumBean> stadiumList = stadiumMgr.getStadiumsBySport(sportNum);
			
			                        for (StadiumBean stadium : stadiumList) {
			                %>
			                            <option value="<%= stadium.getSTADIUM_NAME() %>" <%= (request.getParameter("stadium") != null && request.getParameter("stadium").equals(stadium.getSTADIUM_NAME())) ? "selected" : "" %>>
			                                <%= stadium.getSTADIUM_NAME() %>
			                            </option>
			                <%
			                        }
			                    }
			                %>
			            </select>
		        		<span class="custom-arrow">▼</span>
			   	 	</div>
		        </form>
		    </div>
		
		    <div class="search-menu-box">
		        <%
		            String selectedStadium = request.getParameter("stadium");
		        	StadiumBean selectedStadiumBean = null;
		            if (selectedStadium != null && !selectedStadium.equals("0")) {
		            	
		            	// 선택된 경기장 정보를 가져옴
		                StadiumMgr stadiumMgr = new StadiumMgr();
		
		                selectedStadiumBean = stadiumMgr.getStadiumByName(selectedStadium);
		           		
		                //맛집 정보를 가져옴
		                RestaurantMgr restaurantMgr = new RestaurantMgr();
		                List<RestaurantBean> restaurantList = restaurantMgr.getRestaurantsByStadiumName(selectedStadium);
		
		                if (!restaurantList.isEmpty()) {
		                    for (RestaurantBean restaurant : restaurantList) {
		        %>
		            <div class="food-box">
		                <div class="food-img">
		                    <img src="<%= restaurant.getRESTAURANT_IMG() %>" alt="맛집 이미지">
		                </div>
		                <div class="food-info-box">
		                    <section class="info-item">
		                        <span class="title" style="font-size: 24px;"><%= restaurant.getRESTAURANT_NAME() %></span><br>
		                        <p class="address"><%= restaurant.getADDRESS() %></p>
		                        <button class="show-location"
		                        onclick="openModal(
		                                '<%= restaurant.getRESTAURANT_NAME() %>',
		                                <%= restaurant.getLAT() %>, <%= restaurant.getLON() %>, 
		                                '<%= selectedStadiumBean.getSTADIUM_NAME() %>',
		                                <%= selectedStadiumBean.getLAT() %>, 
		                                <%= selectedStadiumBean.getLON() %>)">
		                                <img src=".././assets/images/location_img.png">위치보기</button>
		                    </section>
		                </div>
		            </div>
		        <%
		                    }
		                } else {
		        %>
		                    <p>근처 맛집 정보가 없습니다.</p>
		        <%
		                }
		            }
		        %>
		        
		    </div>
		</div>    
	</div>
    <!-- 모달 팝업 -->
    <div id="mapModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle"></h2>
            <div id="map"></div>
        </div>
    </div>
</body>
</html>
