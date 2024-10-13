<%@page import="java.text.DecimalFormat"%>
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
	int sportNum = (int) session.getAttribute("sportNum");
	Vector<MDBean> vlist = mdMgr.listMD(teamNum);
	
	// 금액 포맷 설정
    DecimalFormat formatter = new DecimalFormat("###,###");
%>
<jsp:include page="../header.jsp" />
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
		<% for (MDBean MDList : vlist) { %>
		<div class="goods-card">
			<img src="<%=MDList.getMD_IMG()%>" alt="굿즈 사진" class="goods-photo"
				id="<%=MDList.getMD_KINDOF()%>">
			<div class="original-img">
				<img src="<%=MDList.getMD_IMG()%>" alt="원본 이미지">
			</div>
			<div class="goods-info">
				<div class="goods-name"><%=MDList.getMD_NAME()%></div>
				<div class="price-and-cart">
					<span class="goods-price">₩<%=formatter.format(MDList.getMD_PRICE())%></span>
					<button class="add-to-cart"
						onclick="addToCart('<%=MDList.getMD_NUM()%>')">
						<img src=".././assets/images/cart_icon.png" alt="카트 아이콘">
					</button>
				</div>
			</div>
		</div>
		<% } %>
	</div>
</div>
<form id="basketForm" method="POST" action=".././md/add_basket.jsp">
	<input type="hidden" name="mdNum" id="mdNumInput"> <input
		type="hidden" name="repairB" value="1"> <input type="hidden"
		name="url" value="<%=url%>">
</form>
<script>
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

        if (<%=login.getId() != null ? true : false%>) {
            alert("장바구니에 담았습니다.");
            document.getElementById('basketForm').submit();
        } else {
            var currentUrl = window.location.href;
			console.log(currentUrl);
            alert("로그인을 진행하세요.");
            document.location.href = ".././user/login.jsp?url=" + encodeURIComponent(currentUrl);
        }
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