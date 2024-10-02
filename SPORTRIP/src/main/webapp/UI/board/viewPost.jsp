<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<jsp:useBean id="boardBean" class="board.BoardBean" />

<%
	// POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	int boardNum = MUtil.parseInt(request, "boardNum", 0);
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	// 팀 정보와 선수 명단 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	BoardBean board = boardMgr.getBoard(boardNum); 

	String teamName = teamInfo.getTEAM_NAME();
	int sportNum = (int)session.getAttribute("sportNum");
	
	 // 댓글 수정 폼에서 넘긴 값을 바로 받아서 처리
    String editedContent = request.getParameter("editComment");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판</title>
    <link rel="stylesheet" href=".././assets/css/style.css">
    <link rel="stylesheet" href=".././assets/css/boardStyle.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css">
	<script type="text/JavaScript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>
	<script type="text/JavaScript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.js"></script>
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
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '.././team/teamPage_player')">선수 명단</a>
        </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '.././team/teamPage_stadium')">경기장 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
		    <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '.././team/teamPage_teamintro')">구단 소개</a>
	    </div>
	    <div class="item" style="background-color: #236FB5;">
           <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '.././team/teamPage_highlight')">하이라이트 경기</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '.././team/teamPage_store')">굿즈샵</a>
        </div>
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, '.././team/teamPage_board')">게시판</a>
		</div>
	</div>
	<div class="list-btn-top">
        <button type="button" onclick="goList()">목록</button>
    </div>

    <div class="post-content-box">
        <div class="post-header">
            <div class="post-title">
                <span style="font-weight: bold; font-size: 22px;"><%=board.getTITLE() %></span>
				<% if (login != null && board.getID().equals(login.getId())) {%> <!-- 본인 게시글만 수정/삭제 -->
				<div class="update-btn">
					<button type="button" onclick="sendboardNum(<%=board.getBOARD_NUM() %>, 'board_post)">수정</button>
					<button type="button" onclick="">삭제</button>
				</div>
				<% } %>
            </div>
            <div class="user-box">
                <div class="userInfo">
                    <span style="font-weight: bold;"><%=board.getID() %></span>
                    <span><%=board.getPOSTDATE() %></span>
                    <span><%=board.getIP() %></span>
                </div>
                <div class="userView">
                    <span>추천 <%=board.getRECOMMAND() %></span>
                    <span>조회 <%=board.getVIEWS() %></span>
                </div>
            </div>
        </div>
		<div class="post-content">	<!-- 이미지 있을 경우에만 출력 -->
			<p><%=board.getCONTENTS() %></p>
		    <% if (board.getBOARD_IMG() != null && !board.getBOARD_IMG().isEmpty()) { %> <!-- 이미지가 존재할 경우에만 출력 -->
		        <p><img src="<%=board.getBOARD_IMG() %>" alt="게시물 이미지"></p>
		    <% } %>
		</div>
		<div class="rec-btn">
			<button type="button" id="rec" onclick="">
				<span><img src=".././assets/images/recommend_img.png" alt=""> <%=board.getRECOMMAND() %></span><br>
				<span>추천</span>
			</button>
			<button type="button" id="nrec" onclick="">
				<span><img src=".././assets/images/notRecommend_img.png" alt=""> <%=board.getNONRECOMMAND() %></span><br>
				<span>비추천</span>
			</button>
		</div>
    </div>
	<!-- 댓글 출력 -->
	<div id="comments-section"></div>
	<!-- 목록 -->
    <div class="list-btn"><button type="button" onclick="goList()">목록</button></div>
    <script>
		function goMain() {
			document.location.href = "mainPage.jsp";
		}
	
	    function postMessage(){
	        document.location.href = "Board_post.jsp";
	    }
	    
	    function goList() {
	    	history.back(); // 이전 페이지로 이동
	    	location.href = document.referrer;	// 새로고침
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
	 	
		// 게시글 번호 전달
		function sendBoardNum(boardNum, page) {
		    // 세션에 값을 설정
		    var form = document.createElement("form");
		    form.setAttribute("method", "POST");
		    form.setAttribute("action", page + ".jsp");
		
		    var boardField = document.createElement("input");
		    boardField.setAttribute("type", "hidden");
		    boardField.setAttribute("name", "boardNum");
		    boardField.setAttribute("value", boardNum);
		    form.appendChild(boardField);
		
		    document.body.appendChild(form);
		    form.submit();
		}
	    
		// 댓글 로딩 함수
        function loadComments() {
        	 $.ajax({
        	        url: 'comments.jsp', // 댓글 폼 불러오기
        	        type: 'GET',
        	        data: { boardNum: '<%= boardNum %>' }, // 게시글 번호 전달
        	        success: function (data) {
        	            $('#comments-section').html(data);
        	        },
        	        error: function () {
        	            alert('댓글을 불러오지 못했습니다.');
        	        }
        	    });
        }

        // 페이지 로딩 시 댓글을 불러옴
        $(document).ready(function() {
            loadComments(); // 댓글 불러오기 호출
        });
	</script>
</body>
</html>