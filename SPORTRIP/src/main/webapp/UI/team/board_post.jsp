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
	// 팀 정보와 선수 명단 가져오기
	TeamBean teamInfo = teamMgr.getTeam(teamNum);
	
	String teamName = teamInfo.getTEAM_NAME();
	int sportNum = (int)session.getAttribute("sportNum");
%>

<jsp:include page="team_header.jsp"/>

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
                    <td><input type="text" name="writer" readonly></td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td style="text-align: left;"><textarea name="postediter" id="summernote"></textarea></td>
                </tr>
            </table>
        </form>
    </div>

    <div class="post-btn-box">
        <button type="button" class="post-btn" onclick="post()">등록</button>
        <button type="button" class="post-btn" onclick="goList()">목록</button>
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