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
	
	String teamName = teamInfo.getTEAM_NAME();
	int sportNum = (int)session.getAttribute("sportNum");
%>
<jsp:include page=".././team/team_header.jsp"/>
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
	    
	    $(document).ready(function() {
	        $('#summernote').summernote({
	            height: 550, // 에디터 높이
	            lang: "ko-KR", // 한글 설정
	            placeholder: "내용을 입력하세요.", // placeholder 설정
	            toolbar: [
	                ['fontname', ['fontname']],
	                ['fontsize', ['fontsize']],
	                ['color', ['color']],
	                ['style', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
	                ['para', ['ul', 'ol', 'paragraph']],
	                ['height', ['height']],
	                ['insert', ['picture']]
	            ]
	        });
	    });

	    function postboard() {
	        var content = $('#summernote').val();
	        var title = $('input[name="title"]').val();

	        var formData = $('form[name="postForm"]').serialize(); 
	        formData += '&postediter=' + encodeURIComponent(content); 
	        formData += '&title=' + title;  

	        $.ajax({
	            url: ".././board/board_post_in.jsp",
	            type: "POST",
	            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	            data: formData,
	            success: function(response) {
	                if (response.includes('success')) {
	                    alert("글이 성공적으로 등록되었습니다.");
	                    location.href = ".././team/teamPage_board.jsp"; 
	                } else {
	                    alert("글 등록에 실패했습니다.");
	                }
	            },
	            error: function() {
	                alert("오류가 발생했습니다.");
	            }
	        });
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
</body>
</html>