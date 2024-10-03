<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, stadium.StadiumMgr, stadium.StadiumBean, lodging.LodgingMgr, lodging.LodgingBean" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SPORTRIP 숙박</title>
    <link rel="stylesheet" href=".././assets/css/style.css">

    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=8afbb0c0c5d852ce84e4f0f3b93696b6"></script> <!-- 카카오 지도 API 스크립트 -->

    <script>
    function openModal(lodgingName, lodgingLatitude, lodgingLongitude, stadiumName, stadiumLatitude, stadiumLongitude ) {
    	const modal = document.getElementById('mapModal');
        modal.style.display = 'block';

        // 모달 제목 설정
        document.getElementById('modalTitle').innerText = `숙소 위치`;

        // 지도 초기화
        const mapContainer = document.getElementById('map'); // 지도를 표시할 div
        const mapOption = {
            center: new kakao.maps.LatLng(lodgingLatitude, lodgingLongitude), // 숙소의 위도와 경도를 중심으로 설정
            level: 6 // 지도의 확대 레벨
        };

        const map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

        // 숙소 마커 생성
        const lodgingMarker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(lodgingLatitude, lodgingLongitude),
            title: lodgingName,
        });
        lodgingMarker.setMap(map);
        
     	// 경기장 마커 생성
        const stadiumMarker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(stadiumLatitude, stadiumLongitude),
            title: stadiumName,
        });
        stadiumMarker.setMap(map);
        
     // 콘솔에 위도, 경도 출력
        console.log("숙소 위도:", lodgingLatitude, "숙소 경도:", lodgingLongitude);
        console.log("경기장 위도:", stadiumLatitude, "경기장 경도:", stadiumLongitude);

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
<body>
    <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()">
            <img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img">
        </a>
        <div class="login-signup-box">
            <ul>
                <li><a href="../user/login.jsp" style="font-family: BMJUA; color: black;">로그인</a></li>
                <li><a href="../user/signup.jsp" style="font-family: BMJUA; color: black;">회원가입</a></li>
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

    <div style="float: left;" class="select-box">
        <form method="POST" action="tripPage_Hotel.jsp" accept-charset="UTF-8">
            <select name="sportNum" class="select year" onchange="this.form.submit()">
                <option value="0">스포츠</option>
                <option value="1" <%= (request.getParameter("sportNum") != null && request.getParameter("sportNum").equals("1")) ? "selected" : "" %>>야구</option>
                <option value="2" <%= (request.getParameter("sportNum") != null && request.getParameter("sportNum").equals("2")) ? "selected" : "" %>>축구</option>
                <option value="3" <%= (request.getParameter("sportNum") != null && request.getParameter("sportNum").equals("3")) ? "selected" : "" %>>배구</option>
            </select>

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
   
        
        // 숙소 정보를 가져옴
        LodgingMgr lodgingMgr = new LodgingMgr();
        List<LodgingBean> lodgingList = lodgingMgr.getLodgingsByStadiumName(selectedStadium);

        if (!lodgingList.isEmpty()) {
            for (LodgingBean lodging : lodgingList) {
%>
                <div class="hotel-box">
                    <div class="hotel-img">
                        <img src="<%= lodging.getLODGING_IMG() %>" alt="호텔 이미지">
                    </div>
                    <div class="hotel-info-box">
                        <section class="info-item">
                            <span class="title" style="font-size: 24px;"><%= lodging.getLODGING_NAME() %></span><br>
                            <p class="address"><%= lodging.getADDRESS() %></p>
                            <%
                            	System.out.println("selectedStadiumBean"+selectedStadiumBean.getLAT());
                            %>
                            <button class="show-location" 
                                onclick="openModal(
                                '<%= lodging.getLODGING_NAME() %>',
                                <%= lodging.getLAT() %>, <%= lodging.getLON() %>, 
                                '<%= selectedStadiumBean.getSTADIUM_NAME() %>',
                                <%= selectedStadiumBean.getLAT() %>, 
                                <%= selectedStadiumBean.getLON() %>)">
                                <img src=".././assets/images/location_img.png"> 위치보기
                            </button>
                        </section>
                        <section class="info-item">
                            <p><%= (lodging.getGRADE() != null) ? lodging.getGRADE() : "별점 없음" %></p>
                            <button class="show-detail" onclick="location.href='hotel_sub.jsp?lodgingNum=<%= lodging.getLODGING_NUM() %>'">객실 보기</button>
                        </section>
                    </div>
                </div>
<%
            }
        } else {
%>
            <p>근처 숙소 정보가 없습니다.</p>
<%
        }
    }
%>

        
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
