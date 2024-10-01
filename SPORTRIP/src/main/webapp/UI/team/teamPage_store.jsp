<%@page import="basket.BasketBean"%>
<%@page import="team.TeamBean"%>
<%@page import="md.MDBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />
<%
	String url = request.getParameter("url");

	//POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)

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
  
    Vector<MDBean> vlist = mdMgr.listMD(teamNum);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=teamInfo.getTEAM_NAME()%></title>
    <link rel="stylesheet" href=".././assets/css/style.css">
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
		<a href=".././md/shoppingPage_basket.jsp">	<%-- md --%>
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
        <div class="item" style="background-color: #083660;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_store')">굿즈샵</a>
        </div>
        <div class="item" style="background-color: #236FB5;">
            <a href="#" onclick="sendTeamNum(<%=session.getAttribute("teamNum")%>, 'teamPage_board')">게시판</a>
		</div>
	</div>

	<div class="goods-section">
		<div class="selectBox2">
			<button class="label">카테고리를 선택하세요</button>
			<ul class="optionList">
				<li class="optionItem">유니폼</li>
				<li class="optionItem">머플러</li>
				<li class="optionItem">기타</li>
			</ul>
		</div>

		<!-- goods-list를 selectBox2 아래로 이동 -->
		<div class="goods-list">

			<%
				for (MDBean MDList : vlist){
			%>
					<div class="goods-card"> 
					
					    <img src="<%= MDList.getMD_IMG() %>" alt="굿즈 사진" class="goods-photo" id="<%= MDList.getMD_KINDOF() %>">
					    <div class="goods-info">
					        <div class="goods-name"><%= MDList.getMD_NAME() %></div>
					        <div class="price-and-cart">
					            <span class="goods-price">₩<%=MDList.getMD_PRICE() %></span>
					            <button class="add-to-cart" onclick="addToCart('<%=MDList.getMD_NUM()%>')">
					                <img src=".././assets/images/cart_icon.png" alt="카트 아이콘">
					            </button>
					        </div>
					    </div>
					</div>
				
			<% } %>

		</div>
	</div>
	<form id="basketForm" method="POST" action=".././md/addToBasket.jsp">
	    <input type="hidden" name="mdNum" id="mdNumInput">
	    <input type="hidden" name="repairB" value="1">
	    <input type="hidden" name="url" value="<%=url%>">
	</form>
<script>

	function goMain() {
		document.location.href = "mainPage.jsp";
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
	
    const label = document.querySelector('.label');
    const options = document.querySelectorAll('.optionItem');
    const goodsCards = document.querySelectorAll('.goods-card');

    const filterGoods = (category) => {
        goodsCards.forEach(card => {
            const cardId = card.querySelector('.goods-photo').id; // 상품의 ID 가져오기
            if (category === '유니폼' && cardId === '유니폼') {
                card.style.display = 'block'; // '유니폼' 카테고리이고 ID가 'uniform'인 경우 표시
            } else if (category === '머플러' && cardId === '머플러') {
                card.style.display = 'block'; // '머플러' 카테고리이고 ID가 'muffler'인 경우 표시
            } else if (category === '기타' && cardId === '기타') {
                card.style.display = 'block'; // '기타' 카테고리이고 ID가 'etc'인 경우 표시
            } else {
                card.style.display = 'none'; // 해당하지 않는 경우 숨김
            }
        });
    }

 	// 클릭한 옵션의 텍스트를 라벨 안에 넣고 필터링 실행
    const handleSelect = (item) => {
        label.parentNode.classList.remove('active');
        label.innerHTML = item.textContent;
        filterGoods(item.textContent);// 필터링 함수 호출
    }

 	// 옵션 클릭 시 클릭한 옵션을 넘김
    options.forEach(option => {
        option.addEventListener('click', () => handleSelect(option))
    });

 	// 라벨을 클릭 시 옵션 목록이 열림/닫힘
	label.addEventListener('click', () => {
	    if(label.parentNode.classList.contains('active')) {
	        label.parentNode.classList.remove('active');
	    } else {
	        label.parentNode.classList.add('active');
	    }
	});

    function addToCart(mdNum) {
        document.getElementById('mdNumInput').value = mdNum;

        if (<%=login.getId() != null ? true : false %>) {
            alert("장바구니에 담았습니다.");
            document.getElementById('basketForm').submit();
        } else {
            var currentUrl = window.location.href;
			console.log(currentUrl);
            alert("로그인을 진행하세요.");
            document.location.href = ".././user/login.jsp?url=" + encodeURIComponent(currentUrl);
        }
    }

</script>
</body>
</html>

