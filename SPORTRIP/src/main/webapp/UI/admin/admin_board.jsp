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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%
	// POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	int teamNum = MUtil.parseInt(request, "teamNum", 1); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	// 팀 정보 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	// 게시글 정보 가져오기
	Vector<BoardBean> boardInfo = boardMgr.listBoard(teamNum);
	// NullPointerException 방지
	if (boardInfo == null) {
		boardInfo = new Vector<>();
	}
	
	String teamName = teamInfo.getTEAM_NAME();
	int sportNum = (int) session.getAttribute("sportNum");
%>
<jsp:include page="admin_header.jsp" />
<!-- 게시글 -->
<div class="table-list-box">
	<div class="write-btn">
		<button onclick="postMessage()">관리자 글쓰기</button>
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
			<tbody>
				<% int index = 1; %>
				<% if (boardInfo != null && !boardInfo.isEmpty()) {	%>
				<% for (BoardBean board : boardInfo) { %>
				<tr>
					<td><%=index++%></td>
					<td><a href="#"
						onclick="sendBoardNum(<%=board.getBOARD_NUM()%>,'.././board/viewPost')"><%=board.getTITLE()%></a></td>
					<td><%=board.getID()%></td>
					<td><%=board.getPOSTDATE()%></td>
					<td><%=board.getVIEWS()%></td>
					<td><%=board.getRECOMMAND()%></td>
				</tr>
				<% }} else { %>
				<tr>
					<td colspan="6">게시글이 없습니다.</td>
				</tr>
				<% } %>
			</tbody>
		</table>
	</div>
</div>
<div class="board-search-box">
	<select name="type" id="">
		<option value="제목">제목</option>
		<option value="작성자">작성자</option>
		<option value="작성자">작성일</option>
	</select> <input name="searchText" type="text" placeholder="검색어를 입력하세요.">
	<button>검색</button>
</div>
<script>
    function postMessage() {
        document.location.href = "admin_addBoard.jsp";
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

	// 페이지 로드 시 체크박스 해제
	window.addEventListener('load', function() {
       const toggle = document.getElementById('toggle');
       toggle.checked = false; // 체크박스 해제
   	});
       
    // 햄버거 메뉴
    document.getElementById('toggle').addEventListener('change', function() {
        const menu = document.querySelector('.menu');
        const overlay = document.getElementById('overlay');
        
        menu.classList.toggle('open');
        overlay.classList.toggle('open');
    });

    // 클릭 시 메뉴 닫기
    overlay.addEventListener('click', function() {
        document.getElementById('toggle').checked = false; // 체크박스 해제
        const menu = document.querySelector('.menu');
        menu.classList.remove('open'); // 메뉴 숨김
        overlay.classList.remove('open'); // 배경 숨김
    });
</script>