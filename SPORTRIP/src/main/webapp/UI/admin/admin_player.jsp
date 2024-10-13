<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="headcoach.HeadcoachBean"%>
<%@page import="headcoach.HeadcoachMgr"%>
<%@page import="player.PlayerBean"%>
<%@page import="player.PlayerMgr"%>
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
    int teamNum = MUtil.parseInt(request, "teamNum", 1); // 폼에서 받은 값이 없으면 0
    if (teamNum == 0) {
        teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
    } else {
        session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
    }
    
    // 팀 정보와 선수 명단 가져오기
    TeamBean teamInfo = teamMgr.getTeam(teamNum);
    PlayerMgr playerMgr = new PlayerMgr();
    Vector<PlayerBean> playerList = playerMgr.TeamPlayers(teamNum);

    HeadcoachMgr coachMgr = new HeadcoachMgr();
    Vector<HeadcoachBean> coachList = coachMgr.TeamHeadCoach(teamNum); // 수정된 부분

    Set<String> positionList = new HashSet<>();
    for (PlayerBean player : playerList) {
        positionList.add(player.getPOSITION());
    }
%>
	<jsp:include page="../header.jsp" />
<div class="update-player">
	<button class="update-btn" id="delete" onclick="deletePlayer()">삭제</button>
	<button class="update-btn" id="edit" onclick="editPlayer()">수정</button>
	<button class="update-btn" id="add" onclick="addPlayer()"> 등록</button>
</div>
<!-- 감독 / 선수 -->
<div id="sub_wrap">
	<div class="u_top">
		<div class="item" id="coach">
			<a href="#" onclick="showCoaches()" data-value="감독">감독</a>
		</div>
		<div class="item" id="player">
			<a href="#" onclick="showPlayers()" data-value="선수">선수</a>
		</div>
	</div>
	<div id="coach-List">
        <% for (HeadcoachBean coach : coachList) { %>
            <div class="coach-card" data-coach-num="<%=coach.getHEADCOACH_NUM() %>">
                <img src="<%= coach.getHEADCOACH_IMG() %>" alt="<%= coach.getHEADCOACH_NAME() %>" class="coach-photo">
                <div class="coach-name">
                    <span><%= coach.getHEADCOACH_NAME() %></span>
                </div>
            </div>
        <% } %>
    </div>
</div>
<div class="players-section">
	<div id="player-List" style="display: none;">
		<!-- 포지션 버튼 생성 -->
		<div class="p_top">
			<% for (String position : positionList) { %>
			<div class="item" style="background-color: #FBFBFB;">
				<a href="#" onclick="filterByPosition('<%=position%>')"><%=position%></a>
			</div>
			<% } %>
		</div>
		<!-- 선수 리스트 -->
		<% for (PlayerBean player : playerList) { %>
		<div class="player-card" data-player-num="<%=player.getPLAYER_NUM()%>" data-position="<%=player.getPOSITION()%>">
			<!-- 선수 사진 출력 -->
			<img src="<%=player.getPLAYER_IMG()%>"
				alt="<%=player.getPLAYER_NAME()%>" class="player-photo">
			<!-- 선수 이름, 나이 출력 -->
			<div class="player-name">
				<span> <%=player.getUNIFORM_NUM()%>
				</span>
				<%=player.getPLAYER_NAME()%>
			</div>
		</div>
		<% } %>
	</div>
</div>
<script src=".././assets/js/main.js">
/* 	 	// 팀 번호 전달
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
	 	
		// 선수 출력
		function showPlayers() {
			document.getElementById('player-List').style.display = 'block';
			document.getElementById('coach-List').style.display = 'none';
			document.getElementById('player').getElementsByTagName('a')[0].style.color = '#FFFFFF'; // 폰트색 흰색으로 변경
			document.getElementById('player').style.backgroundColor = '#000000';
			document.getElementById('coach').getElementsByTagName('a')[0].style.color = '#000000'; // 폰트색 검정으로 변경
			document.getElementById('coach').style.backgroundColor = '#FBFBFB';
			var playerCards = document.querySelectorAll('.player-card');
			playerCards.forEach(function(card) {
				card.style.display = 'inline-block';
			});
			// 모든 포지션 버튼의 스타일 초기화
		    var positionItems = document.querySelectorAll('.p_top .item');
		    positionItems.forEach(function(item) {
		        item.classList.remove('selected-item');  // 선택된 클래스 제거
		        item.getElementsByTagName('a')[0].style.color = '#000000';  // 폰트색 검정으로 변경
		        item.style.backgroundColor = '#FBFBFB';  // 배경색 흰색으로 변경
		    });
		}

		// 감독 출력
		function showCoaches() {
			document.getElementById('player-List').style.display = 'none';
			document.getElementById('coach-List').style.display = 'block';
		    document.getElementById('player').style.backgroundColor = '#FBFBFB';
		    document.getElementById('player').getElementsByTagName('a')[0].style.color = '#000000'; // 폰트색 검정으로 변경
		    document.getElementById('coach').style.backgroundColor = '#000000';
		    document.getElementById('coach').getElementsByTagName('a')[0].style.color = '#FFFFFF'; // 폰트색 흰색으로 변경
		}

	  	
    	// 포지션에 따라 선수 필터링
        function filterByPosition(position) {
            var playerCards = document.querySelectorAll('.player-card');
            var positionItems  = document.querySelectorAll('.p_top .item');  // 포지션 버튼 선택
            
            // 선수 카드 필터링
            playerCards.forEach(function(card) {
                if (card.getAttribute('data-position') === position) {
                    card.style.display = 'inline-block';
                } else {
                    card.style.display = 'none';
                }
            });
         	// 이전 선택된 버튼에서 'selected-item' 클래스 제거
            positionItems.forEach(function(item) {
            	item.classList.remove('selected-item');
            	item.getElementsByTagName('a')[0].style.color = '#000000';  // 폰트 색을 검정으로
            });
            // 현재 클릭한 버튼에 'selected-item' 클래스 추가
            var currentItem = event.target.parentElement;   // 현재 클릭한 버튼
            currentItem.classList.add('selected-item');
            currentItem.getElementsByTagName('a')[0].style.color = '#FFFFFF';  // 폰트 색을 흰색으로
        }

        // 모든 선수 보여주기 (초기 상태)
        function showAllPlayers() {
            var playerCards = document.querySelectorAll('.player-card');
            playerCards.forEach(function(card) {
                card.style.display = 'block';
            });
        }
        
        // 등록하기
        function addPlayer(){
        	const playerFrame = document.getElementById('player-List');
        	const coachFrame = document.getElementById('coach-List');
        	if(coachFrame.style.display == 'block' || playerFrame.style.display == 'none'){
        		document.location.href="admin_addCoach.jsp";
        	}
        	else{
        		document.location.href="admin_addPlayer.jsp";
        	}
        }
        
     // 선수 클릭 시 번호 저장
        let selectedPlayerNum = null;

        document.querySelectorAll('.player-card').forEach((item) => {
            item.addEventListener('click', () => {
                // 토글을 통해 카드가 활성화됨을 표시
                item.classList.toggle('active');
                
                // 선택한 선수의 번호 가져오기
                selectedPlayerNum = item.getAttribute('data-player-num');
                
                // 이름 요소를 찾아 스타일 적용
                const playerName = item.querySelector('.player-name');
                
                if (item.classList.contains('active')) {
                    playerName.style.marginLeft = '3px'; // 활성화 시 3px 추가
                    playerName.style.bottom = '-3px';  // 활성화 시 3px 추가 (아래)
                } else {
                    playerName.style.marginLeft = ''; // 비활성화 시 원래 상태로 복원
                    playerName.style.bottom = '';  // 비활성화 시 원래 상태로 복원
                }
            });
        });

     // 감독 클릭 시 번호 저장
        let selectedCoachNum = null;

        document.querySelectorAll('.coach-card').forEach((item) => {
            item.addEventListener('click', () => {
                // 토글을 통해 카드가 활성화됨을 표시
                item.classList.toggle('active');

                // 선택한 감독의 번호 가져오기
                selectedCoachNum = item.getAttribute('data-coach-num');

                // 이름 요소를 찾아 스타일 적용
                const coachName = item.querySelector('.coach-name');

                if (item.classList.contains('active')) {
                    coachName.style.marginLeft = '3px'; // 활성화 시 3px 추가
                    coachName.style.bottom = '-3px';  // 활성화 시 3px 추가 (아래)
                } else {
                    coachName.style.marginLeft = ''; // 비활성화 시 원래 상태로 복원
                    coachName.style.bottom = '';  // 비활성화 시 원래 상태로 복원
                }
            });
        });

     // 수정하기 함수 업데이트
        function editPlayer() {
            const playerFrame = document.getElementById('player-List');
            const coachFrame = document.getElementById('coach-List');

            // 선수가 선택된 경우
            if (selectedPlayerNum) {
                var form = document.createElement("form");
                form.setAttribute("method", "POST");
                form.setAttribute("action", "admin_updatePlayer.jsp");

                var playerField = document.createElement("input");
                playerField.setAttribute("type", "hidden");
                playerField.setAttribute("name", "playerNum");
                playerField.setAttribute("value", selectedPlayerNum);
                form.appendChild(playerField);

                document.body.appendChild(form);
                form.submit();
            } 
            // 감독이 선택된 경우
            else if (selectedCoachNum) {
                var form = document.createElement("form");
                form.setAttribute("method", "POST");
                form.setAttribute("action", "admin_updateCoach.jsp");

                var coachField = document.createElement("input");
                coachField.setAttribute("type", "hidden");
                coachField.setAttribute("name", "coachNum");
                coachField.setAttribute("value", selectedCoachNum);
                form.appendChild(coachField);

                document.body.appendChild(form);
                form.submit();
            } 
            // 선수나 감독이 선택되지 않은 경우
            else {
                alert("수정할 선수를 또는 감독을 선택하세요.");
            }
        });

    // 감독 클릭 시 번호 저장
    let selectedCoachNum = null;

    document.querySelectorAll('.coach-card').forEach((item) => {
        item.addEventListener('click', () => {
            // 토글을 통해 카드가 활성화됨을 표시
            item.classList.toggle('active');

            // 선택한 감독의 번호 가져오기
            selectedCoachNum = item.getAttribute('data-coach-num');

            // 이름 요소를 찾아 스타일 적용
            const coachName = item.querySelector('.coach-name');

            if (item.classList.contains('active')) {
                coachName.style.marginLeft = '3px'; // 활성화 시 3px 추가
                coachName.style.bottom = '-3px';  // 활성화 시 3px 추가 (아래)
            } else {
                coachName.style.marginLeft = ''; // 비활성화 시 원래 상태로 복원
                coachName.style.bottom = '';  // 비활성화 시 원래 상태로 복원
            }
        });
    });

    // 수정하기 함수 업데이트
    function editPlayer() {
        const playerFrame = document.getElementById('player-List');
        const coachFrame = document.getElementById('coach-List');
		console.log(selectedPlayerNum);
        // 선수가 선택된 경우
        if (selectedPlayerNum) {
            var form = document.createElement("form");
            form.setAttribute("method", "POST");
            form.setAttribute("action", "admin_updatePlayer.jsp");

            var playerField = document.createElement("input");
            playerField.setAttribute("type", "hidden");
            playerField.setAttribute("name", "playerNum");
            playerField.setAttribute("value", selectedPlayerNum);
            form.appendChild(playerField);

            document.body.appendChild(form);
            form.submit();
        } 
        // 감독이 선택된 경우
        else if (selectedCoachNum) {
            var form = document.createElement("form");
            form.setAttribute("method", "POST");
            form.setAttribute("action", "admin_updateCoach.jsp");

            var coachField = document.createElement("input");
            coachField.setAttribute("type", "hidden");
            coachField.setAttribute("name", "coachNum");
            coachField.setAttribute("value", selectedCoachNum);
            form.appendChild(coachField);

            document.body.appendChild(form);
            form.submit();
        } 
        // 선수나 감독이 선택되지 않은 경우
        else {
            alert("수정할 선수 또는 감독을 선택하세요.");
        }
    }

    // 삭제
	function deletePlayer() {
	    const playerFrame = document.getElementById('player-List');
	    const coachFrame = document.getElementById('coach-List');

	    if (coachFrame.style.display == 'block' && selectedCoachNum) {
	        // 감독 삭제일 경우
	        const params = new URLSearchParams();
	        params.append('selectedCoachNum', selectedCoachNum);

	        fetch('delete_coach.jsp?' + params.toString(), {
	            method: 'GET',
	        })
	        .then(response => response.text())
	        .then(data => {
	            console.log("Response:", data);
	            if (data.includes("success")) {
	                alert('감독 삭제가 완료되었습니다.');
	                location.href = "admin_player.jsp"; // 감독 삭제 후 페이지 이동
	            } else {
	                alert('감독 삭제가 되지 않았습니다.');
	            }
	        })
	        .catch(error => console.error('Error:', error));
	    } else if (playerFrame.style.display == 'block' && selectedPlayerNum) {
	        // 선수 삭제일 경우
	        const params = new URLSearchParams();
	        params.append('selectedPlayerNum', selectedPlayerNum);

	        fetch('delete_player.jsp?' + params.toString(), {
	            method: 'GET',
	        })
	        .then(response => response.text())
	        .then(data => {
	            console.log("Response:", data);
	            if (data.includes("success")) {
	                alert('선수 삭제가 완료되었습니다.');
	                location.href = "admin_player.jsp"; // 선수 삭제 후 페이지 이동
	            } else {
	                alert('선수 삭제가 되지 않았습니다.');
	            }
	        })
	        .catch(error => console.error('Error:', error));
	    } else {
	        alert('삭제할 감독이나 선수를 선택하세요.');
	    }
	} */
</script>