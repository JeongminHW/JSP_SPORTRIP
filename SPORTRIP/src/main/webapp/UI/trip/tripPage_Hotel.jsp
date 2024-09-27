<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, stadium.StadiumMgr, stadium.StadiumBean, lodging.LodgingMgr, lodging.LodgingBean" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SPORTRIP 숙박</title>
    <link rel="stylesheet" href=".././assets/css/style.css">

    <script>
        function goMain() {
            document.location.href="mainPage.jsp";
        }

        function showLodging() {
            document.location.href="lodging_sub.html";
        }
    </script>
</head>
<body>
    <header class="header header_logo">
        <a style="cursor: pointer" onclick="goMain()">
            <img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img">
        </a>
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
            <a href="food_main.html">맛집</a>
        </div>
    </div>

    <div class="search-box">
        <input name="searchText" type="text" placeholder="경기장을 검색하세요">
        <button><img src=".././assets/images/search_icon.png" alt="검색" title="검색"></button>
    </div>

    <div style="float: left;" class="select-box">
        <form method="POST" action="tripPage_Hotel.jsp" accept-charset="UTF-8">
            <select name="sportNum" class="select year" onchange="this.form.submit()">
                <option value="0">종류</option>
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
            <!-- 검색 버튼 제거 -->
        </form>
    </div>

    <div class="search-menu-box">
        <%
            String selectedStadium = request.getParameter("stadium");
            if (selectedStadium != null && !selectedStadium.equals("0")) {
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
                        <button class="show-location"><img src=".././assets/images/location_img.png"> 위치보기</button>
                    </section>
                    <section class="info-item">
                        <p><%= lodging.getGRADE() %></p>
                        <button class="show-detail" onclick="showLodging()">객실 보기</button>
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
</body>
</html>
