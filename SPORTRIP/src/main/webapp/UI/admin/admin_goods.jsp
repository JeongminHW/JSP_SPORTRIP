<%@page import="md.MDBean"%>
<%@page import="team.TeamBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />

<%
	String url = request.getParameter("url");
	//POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	
	int teamNum = MUtil.parseInt(request, "teamNum", 1); // 폼에서 받은 값이 없으면 0
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
%>

<jsp:include page="../header.jsp"/>
<div class="insert-goods">
	<button class="update-btn" id="delete" onclick="deleteGoods()">삭제</button>
	<button class="update-btn" id="edit" onclick="editGoods()">수정</button>
	<button class="update-btn" id="add" onclick="addGoods()"> 등록</button>
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
		<% for (MDBean MDList : vlist) { %>
		<div class="goods-card" data-goods-num="<%=MDList.getMD_NUM()%>">
			<img src="<%=MDList.getMD_IMG()%>" alt="굿즈 사진" class="goods-photo"
				id="<%=MDList.getMD_KINDOF()%>">
			<div class="goods-info">
				<div class="goods-name"><%=MDList.getMD_NAME()%></div>
				<div class="price-and-cart">
					<span class="goods-price">₩<%=MDList.getMD_PRICE()%></span>
				</div>
			</div>
		</div>
		<% } %>
	</div>
</div>
<form id="basketForm" method="POST" action=".././md/addToBasket.jsp">
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

    // 선택한 옵션에 따라 상품을 필터링하는 함수
    const filterGoods = (category) => {
        goodsCards.forEach(card => {
            const cardId = card.querySelector('.goods-photo').id; // 상품의 ID 가져오기
            if (category === '유니폼' && cardId === 'uniform') {
                card.style.display = 'block'; // '유니폼' 카테고리이고 ID가 'uniform'인 경우 표시
            } else if (category === '머플러' && cardId === 'muffler') {
                card.style.display = 'block'; // '머플러' 카테고리이고 ID가 'muffler'인 경우 표시
            } else if (category === '기타' && cardId === 'etc') {
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
        filterGoods(item.textContent); // 필터링 함수 호출
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

 	// 등록하기
    function addGoods(){
    	const goodsFrame = document.getElementById('goods-List');
		document.location.href="admin_addGoods.jsp";
    }
 	
 	// 굿즈 선택 시 번호 저장
    let selectedGoodsNum = null;
 	
 	// 굿즈 클릭 이벤트
    document.querySelectorAll('.goods-card').forEach((item) => {
        item.addEventListener('click', () => {
            // 토글을 통해 카드가 활성화됨을 표시
            item.classList.toggle('active');

            // 선택한 굿즈 번호 가져오기
            selectedGoodsNum = item.getAttribute('data-goods-num');
            
            // 이름 요소를 찾아 스타일 적용
            const goodsName = item.querySelector('.goods-name');
            
            if (item.classList.contains('active')) {
            	goodsName.style.marginLeft = '3px'; // 활성화 시 3px 추가
            	goodsName.style.bottom = '-3px';  // 활성화 시 3px 추가 (아래)
            } else {
            	goodsName.style.marginLeft = ''; // 비활성화 시 원래 상태로 복원
            	goodsName.style.bottom = '';  // 비활성화 시 원래 상태로 복원
            }
        });
    });
 	
 	// 수정하기 함수 업데이트
    function editGoods() {
        const goodsFrame = document.getElementById('goods-List');

        // 굿즈가 선택된 경우
        if (selectedGoodsNum) {
            var form = document.createElement("form");
            form.setAttribute("method", "POST");
            form.setAttribute("action", "admin_updateGoods.jsp");

            var goodsField = document.createElement("input");
            goodsField.setAttribute("type", "hidden");
            goodsField.setAttribute("name", "goodsNum");
            goodsField.setAttribute("value", selectedGoodsNum);
            form.appendChild(goodsField);

            document.body.appendChild(form);
            form.submit();
        } 
        // 굿즈가 선택되지 않은 경우
        else {
            alert("수정할 굿즈를 선택하세요.");
        }
    }
 	
 	// 삭제
	function deleteGoods() {
		const goodsFrame = document.getElementById('goods-List');

	    if (selectedGoodsNum) {
	        const params = new URLSearchParams();
	        params.append('selectedGoodsNum', selectedGoodsNum);

	        fetch('delete_goods.jsp?' + params.toString(), {
	            method: 'GET',
	        })
	        .then(response => response.text())
	        .then(data => {
	            console.log("Response:", data);
	            if (data.includes("success")) {
	                alert('굿즈 삭제가 완료되었습니다.');
	                location.href = "admin_goods.jsp"; // 삭제 후 페이지 이동
	            } else {
	                alert('굿즈 삭제가 되지 않았습니다.');
	            }
	        })
	        .catch(error => console.error('Error:', error));
	    } else {
	        alert('삭제할 굿즈를 선택하세요.');
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
    });
</script>