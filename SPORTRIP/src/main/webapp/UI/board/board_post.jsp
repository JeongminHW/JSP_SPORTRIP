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
    <div class="post-box">
        <form action="" name="postForm">
            <!-- 글 작성 테이블 -->
            <table class="post-table">
                <colgroup>
                    <col width="10%">
                    <col width="80%">
                </colgroup>
                <tr>
                    <th>제목</th>
                    <td><input type="text" name="title" placeholder="제목을 입력해주세요."></td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td><input type="text" name="writer" value="<%=login.getId() %>" readonly></td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td style="text-align: left;"><textarea name="postediter" id="summernote"></textarea></td>
                </tr>
            </table>
        </form>
    </div>

    <div class="post-btn-box">
        <button type="button" class="post-btn" onclick="postboard()">등록</button>
        <button type="button" class="post-btn" onclick="goList()">목록</button>
    </div>
    <script>
	    function goMain(){
	        document.location.href=".././sport/mainPage.jsp";
	    }
	    
	    function postMessage(){
	        document.location.href = ".././team/board_post.jsp";
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
	 	
	 	function postboard() {
	 		
	 	} 
	 	
		jQuery(document).ready(function() {
            jQuery("#summernote").summernote({
                  height : 550  // 에디터 높이
                , minHeight : null  // 최소 높이
                , maxHeight : null  // 최대 높이
                , focus : true  // 에디터 로딩후 포커스를 맞출지 여부( true, false )
                , lang : "ko-KR"    // 한글 설정
                , placeholder : "내용을 입력하세요."    //placeholder 설정
                , fontNames : [ "맑은 고딕", "궁서", "굴림체", "굴림", "돋움체", "바탕체", "Arial", "Arial Black", "Comic Sans MS", "Courier New" ]
                , fontNamesIgnoreCheck : ["맑은 고딕"]  // 기본 폰트 설정( 2024-01-28 동작하지 않음, `sans-serif` 자동선택 )
                , fontSizes : [ "8", "9", "10", "11", "12", "14", "16", "18", "20", "22", "24", "28", "30", "36", "50", "72" ]
                , toolbar: [
					    // [groupName, [list of button]]
					    ['fontname', ['fontname']],
					    ['fontsize', ['fontsize']],
					    ['color', ['color']],
					    ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
					    ['para', ['ul', 'ol', 'paragraph']],
					    ['height', ['height']]
  					]
            });
        });
    </script>
</body>
</html>