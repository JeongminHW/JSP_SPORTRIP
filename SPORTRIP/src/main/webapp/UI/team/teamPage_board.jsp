<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />

<%
	// POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	// 팀 정보 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	
	String teamName = teamInfo.getTEAM_NAME();
	int sportNum = (int)session.getAttribute("sportNum");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>게시판</title>
	<link rel="stylesheet" href=".././assets/css/style.css">
	<link rel="stylesheet" href=".././assets/css/boardStyle.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
	<header class="header header_logo">
		<a style="cursor: pointer" onclick="goMain()">
			<img src=".././assets/images/sportrip_logo.png" alt="sportrip 로고" id="logo_img"></a> 
		<a href=".././sport/sport_main.jsp" style="margin-left: 20px; margin-right: 20px;"> 
			<img src=".././assets/images/sport_logo<%=teamInfo.getSPORT_NUM()%>.svg" alt="리그" id="league_logo_img"></a>
		<div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
			<img src="<%=teamInfo.getLOGO()%>" alt="로고" class="team_logo_img">
		</div>
		<a href=".././md/shopping_cart.html">	<%-- md --%>
			<img src=".././assets/images/cart_icon.png" alt="장바구니" class="cart"></a>
		<div class="login-signup-box">
			<ul>
				<li><a href=".././user/login.jsp" style="font-family: BMJUA; color: black;">로그인</a></li>
				<li><a href=".././user/signup.jsp"	style="font-family: BMJUA; color: black;">회원가입</a></li>
			</ul>
		</div>
	</header>
    <div class="t_top">
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_player')">선수 명단</a>
        </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_stadium')">경기장 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_teamintro')">구단 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
           <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_highlight')">하이라이트 경기</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
        </div>
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
		</div>
	</div>
    <div class="table-list-box">
        <div class="write-btn">
            <button onclick="postMessage()">글쓰기</button>
        </div>
        <div class="table-list">
            <table>
                <colgroup>
                    <col class="size01" data-alias="num">
                    <col class="size02" data-alias="title">
                    <col class="size03" data-alias="writer">
                    <col class="size04" data-alias="date">
                    <col class="size05" data-alias="view">
                    <col class="size06" data-alias="recommend">
                </colgroup>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>조회</th>
                        <th>추천</th>
                    </tr>
                </thead>
                <tr>
                    <td>1</td>
                    <td><a href="viewPost.jsp">dsfjqlwkefj;lkadjf;lwkefjlwkjflskdjflksjdlfkj</a></td>
                    <td>작성자1</td>
                    <td>2024.09.24</td>
                    <td>1000</td>
                    <td>100</td>
                </tr>
                <tr>
                    <td>2</td>
                    <td><a href="">dsfjqlwkefj;lkadjf;lwkefjlwkjflskdjflksjdlfkj</a></td>
                    <td>작성자1</td>
                    <td>2024.09.24</td>
                    <td>1000</td>
                    <td>100</td>
                </tr>
                <tr>
                    <td>3</td>
                    <td><a href="">dsfjqlwkefj;lkadjf;lwkefjlwkjflskdjflksjdlfkj</a></td>
                    <td>작성자1</td>
                    <td>2024.09.24</td>
                    <td>1000</td>
                    <td>100</td>
                </tr>
                <tr>
                    <td>4</td>
                    <td><a href="">dsfjqlwkefj;lkadjf;lwkefjlwkjflskdjflksjdlfkj</a></td>
                    <td>작성자1</td>
                    <td>2024.09.24</td>
                    <td>1000</td>
                    <td>100</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="board-search-box">
        <select name="type" id="">
            <option value="제목">제목</option>
            <option value="작성자">작성자</option>
            <option value="작성자">작성일</option>
        </select>
        <input name="searchText" type="text" placeholder="검색어를 입력하세요.">
        <button>검색</button>
    </div>
    <script>
	    function goMain(){
	        document.location.href=".././sport/mainPage.jsp";
	    }
	    
	    function postMessage(){
	        document.location.href = ".././team/board_post.jsp";
	    }
	    
	 	// 팀 번호 전달
		function sendTeamNum(teamNum, page) {
		    // 세션에 값을 설정
		    var form = document.createElement("form");
		    form.setAttribute("method", "POST");
		    form.setAttribute("action", page + ".jsp");
		
		    var teamField = document.createElement("input");
		    teamField.setAttribute("type", "hidden");
		    teamField.setAttribute("name", "teamNum");
		    teamField.setAttribute("value", teamNum);
		    form.appendChild(teamField);
		
		    document.body.appendChild(form);
		    form.submit();
		}
    </script>
</body>
</html>