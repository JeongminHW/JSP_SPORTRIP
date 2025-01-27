<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.List"%>
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
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	
	// 팀 정보 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	String teamName = teamInfo.getTEAM_NAME();
    
	// 게시글 정보 가져오기
	Vector<BoardBean> boardInfo = boardMgr.listBoard(teamNum);
	// NullPointerException 방지
	if (boardInfo == null) {
		boardInfo = new Vector<>();
	}
	
	// 관리자가 작성한 글을 따로 저장할 리스트
    Vector<BoardBean> adminPosts = new Vector<>();
    Vector<BoardBean> otherPosts = new Vector<>();

    // 게시글을 관리자와 일반 사용자로 구분
    for (BoardBean board : boardInfo) {
        if ("root".equals(board.getID())) {
        	adminPosts.add(board); // 관리자가 작성한 글
        } else {
            otherPosts.add(board); // 일반 사용자가 작성한 글
        }
    }
	
	// 검색어 처리 (제목, 작성자, 작성일에 대한 검색 조건 추가)
    String searchType = request.getParameter("type");
    String searchText = request.getParameter("searchText");
    
    Vector<BoardBean> searchResults = new Vector<>();
    
    if (searchText != null && !searchText.trim().isEmpty()) {
        for (BoardBean board : otherPosts) { // otherPosts만 검색
            if ("제목".equals(searchType) && board.getTITLE().contains(searchText)) {
                searchResults.add(board);
            } else if ("작성자".equals(searchType) && board.getID().contains(searchText)) {
                searchResults.add(board);
            } else if ("작성일".equals(searchType) && board.getPOSTDATE().contains(searchText)) {
                searchResults.add(board);
            }
        }
    } else {
        // 검색어가 없을 경우 모든 게시글 출력
        searchResults = otherPosts;
    }
%>

<jsp:include page="../header.jsp" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<div class="table-list-box">

<div class="write-btn">
    <% if (login.getId() != null) { %>
    	<button onclick="postMessage()">글쓰기</button>
    <% } %>
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
				<!-- 관리자가 작성한 게시글을 최상단에 출력 -->
                <% if (adminPosts != null && !adminPosts.isEmpty()) { %>
                    <% for (BoardBean board : adminPosts) { %>
                    <tr style="font-weight:bold;">
                        <td><button class="notice">공지</button></td>
                        <td><a href="#" onclick="sendBoardNum(<%=board.getBOARD_NUM()%>, '.././board/viewPost')">
                            <%=board.getTITLE()%></a></td>
                        <td>관리자</td> <!-- "관리자"로 표시 -->
                        <td><%=board.getPOSTDATE()%></td>
                        <td><%=board.getVIEWS()%></td>
                        <td><%=board.getRECOMMAND()%></td>
                    </tr>
                    <% } %>
                <% } %>
                
                <!-- 일반 사용자가 작성한 게시글 출력 -->
                <% int index = 1; %>
                <% if (otherPosts != null && !otherPosts.isEmpty()) { %>
                    <% for (BoardBean board : otherPosts) { %>
                    <tr>
                        <td><%=index++%></td>
                        <td><a href="#" onclick="sendBoardNum(<%=board.getBOARD_NUM()%>, '.././board/viewPost')">
                            <%=board.getTITLE()%></a></td>
                        <td><%=board.getID()%></td>
                        <td><%=board.getPOSTDATE()%></td>
                        <td><%=board.getVIEWS()%></td>
                        <td><%=board.getRECOMMAND()%></td>
                    </tr>
                    <% } %>
                <% } else { %>
                <tr>
                    <td colspan="6">게시글이 없습니다.</td>
                </tr>
                <% } %>
            </tbody>
		</table>
	</div>
</div>
<!-- 검색 박스 -->
<div class="board-search-box">
    <select name="type" id="searchType">
        <option value="제목">제목</option>
        <option value="작성자">작성자</option>
        <option value="작성일">작성일</option>
    </select>
    <input id="searchText" type="text" placeholder="검색어를 입력하세요.">
    <button type="button" onclick="searchPosts()">검색</button>
</div>
<script>
	function postMessage() {
		document.location.href = ".././board/board_post.jsp"; // 게시글 작성 페이지로 이동
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
    
    function searchPosts() {
        // 검색 타입과 검색어 가져오기
        var searchType = document.getElementById('searchType').value;
        var searchText = document.getElementById('searchText').value;
        var teamNum = "<%=teamNum%>";  // teamNum은 서버에서 가져온 값

        // 검색어가 비어 있으면 원래의 게시글 유지
        if (searchText.trim() === "") {
            alert("검색어를 입력하세요.");
            return;
        }

        $.ajax({
            type: "GET",
            url: "../board/board_search.jsp",
            data: {
                type: searchType,
                searchText: searchText,
                teamNum: teamNum
            },
            success: function(response) {
                if (response.trim().length === 0) {
                    // 검색 결과가 없을 때 메시지 출력
                    $('.table-list tbody').html('<tr><td colspan="6">검색 결과가 없습니다.</td></tr>');
                } else {
                    // 검색 결과가 있을 때만 업데이트
                    $('.table-list tbody').html(response);
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX error: " + error);
            }
        });
    }
</script>