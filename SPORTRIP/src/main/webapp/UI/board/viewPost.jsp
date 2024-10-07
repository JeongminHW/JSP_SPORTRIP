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

<jsp:include page=".././team/team_header.jsp"/>
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
	<jsp:include page="comments.jsp"/>
	<!-- 목록 -->
    <div class="list-btn"><button type="button" onclick="goList()">목록</button></div>
    <div class="btns">
		<div class="moveTopBtn">↑</div>
		<div class="moveBottomBtn">↓</div>
	</div>
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
		
        const $topBtn = document.querySelector(".moveTopBtn");

	    // 버튼 클릭 시 맨 위로 이동
	    $topBtn.onclick = () => {
	      window.scrollTo({ top: 0, behavior: "smooth" });  
	    }
	
	    const $bottomBtn = document.querySelector(".moveBottomBtn");
	
	    // 버튼 클릭 시 페이지 하단으로 이동
	    $bottomBtn.onclick = () => {
	      window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" });
	    };
	</script>
</body>
</html>