<%@page import="java.text.DecimalFormat"%>
<%@page import="basket.BasketMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="basket.BasketBean"%>
<%@page import="team.TeamBean"%>
<%@page import="md.MDBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="basket" scope="session" class="basket.BasketBean" />
<jsp:setProperty property="*" name="basket" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />
<%
	String url = request.getParameter("url");
	int fee = 3500;
	//POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)

	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}
	// 팀 정보와 선수 명단 가져오기

	int sportNum = (int)session.getAttribute("sportNum");
	Vector<BasketBean> basketVList = basketMgr.listBasket(login.getId());
	int basketNum = 0;
	
	//금액 포맷 설정
	DecimalFormat formatter = new DecimalFormat("###,###");
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" href=".././assets/css/cartStyle.css">
</head>
<body>
<header class="header">
    <div style="position: absolute; left: 50%; transform: translateX(-50%);" class="img-box">
        <img style="cursor: pointer; " src=".././assets/images/white_sportrip_logo.png" alt="sportrip" onClick="location.href='.././team/teamPage_store.jsp'">
    </div>
    <!-- 아이콘과 장바구니 이미지를 같은 div에 넣기 -->
    <div class="header-right">
        <!-- 아이콘 이미지 -->
        <img src=".././assets/images/myPage_icon.png" alt="내 아이콘" class="myPage_icon" onClick="location.href='.././user/myPage.jsp'"> 
        <!-- 장바구니 이미지 -->
        <img src=".././assets/images/cart_icon.png" alt="장바구니" class="cart_img" onClick="location.href='shoppingPage_basket.jsp'">
    </div>
</header>

    <section class="cart">
        <p class="title">
            <span class="cart-title">장바구니</span> <span id="cartSize"> (<%=basketVList.size() %>)</span>
        </p>
		<table class="cart__list">
		    <form id="paymnetForm" accept-charset="UTF-8" action="shoppingPage_payment.jsp" method="POST">
		        <thead>
		            <tr>
		                <td><input type="checkbox"></td>
		                <td colspan="2">상품정보</td>
		                <td>수량</td>
		                <td>상품금액</td>
		                <td>배송비</td> <!-- 배송비 컬럼 유지 -->
		            </tr>
		        </thead>
		        <tbody>
		            <!-- 상품 -->
		            <% 
		                int total = 0;
		                ArrayList<BasketBean> selectedItems = new ArrayList<>();
		                
		                for (int i = 0; i < basketVList.size(); i++) {
		                    BasketBean basketbean = basketVList.get(i);
		                    MDBean MDBean = mdMgr.getMD(basketbean.getMD_NUM());
		                    int sum = MDBean.getMD_PRICE() * basketbean.getREPAIR_B();
		                    total += MDBean.getMD_PRICE() * basketbean.getREPAIR_B();
		
		                    TeamBean teamInfo = teamMgr.getTeam(MDBean.getTEAM_NUM());
		                    String teamName = teamInfo.getTEAM_NAME();
		                    basketNum = basketbean.getBASKET_NUM();
		
							
		            %>
		            <tr class="cart__list__detail">
		                <td>
		                    <input type="checkbox" class="item-checkbox"
		                        data-md-num="<%= MDBean.getMD_NUM() %>"
		                        data-md-name="<%= MDBean.getMD_NAME() %>"
		                        data-repair-c="<%= basketbean.getREPAIR_B() %>"
		                        data-price="<%= MDBean.getMD_PRICE() %>"
		                        data-img="<%= MDBean.getMD_IMG() %>"
		                        data-team-name="<%= teamName %>">
		                </td>
		                <td class="img_td"><img src="<%= MDBean.getMD_IMG() %>" alt="<%= MDBean.getMD_NAME() %>"></td>
		                <td style="position: relative;">
		                    <p><%= MDBean.getMD_NAME() %></p>
		                    <span class="price-info"><%= formatter.format(MDBean.getMD_PRICE())  %>원</span>
		                    <button class="cart__list__countbtn" onclick="deleteBasket(<%= basketbean.getBASKET_NUM() %>)">삭제하기</button>
		                </td>
		                <td class="cart__list__count">
		                    <!-- 수량 조절 버튼 -->
		                    <div class="quantity-control">
		                        <button type="button" class="decrease" onclick="decrease(<%= basketbean.getBASKET_NUM() %>)">-</button>
		                        <input type="number" class="quantity-input" onchange="quantity_input(this)" value="<%= basketbean.getREPAIR_B() %>" min="1" data-price="<%= formatter.format(MDBean.getMD_PRICE()) %>">
		                        <button type="button" class="increase" onclick="increase(<%= basketbean.getBASKET_NUM() %>)">+</button>
		                    </div>
		                </td>
		                <td style="width: 200px;"><span class="product-price"><%= formatter.format(sum) %>원</span></td>
		
		                <!-- 배송비는 첫 번째 행에만 rowspan을 적용하여 병합 -->
		                <% if (i == 0) { %>
		                <td rowspan="<%= basketVList.size() %>">
		                    <span class="delivery-fee" id="fee1"><%= fee %>원</span>
		                </td>
		                <% } %>
		            </tr>
		            <form action="/shoppingPage_payment.jsp?<%= login.getId() %>" method="get" class="order_form">
		                <input type="hidden" name="orders[0].MD_NUM" value="<%= MDBean.getMD_NUM() %>">
		                <input type="hidden" name="orders[0].REPAIR_C" value="<%= formatter.format(sum) %>">
		                <input type="hidden" name="teamNum" value="<%= teamNum %>">
		            </form>
		            <% } %>
		        </tbody>
		        <tfoot>
		            <tr>
		                <td colspan="3" style="border-bottom: none;"></td>
		                <td style="border-bottom: none;"></td>
		                <td class="total-price">
		                    <span>상품 합계</span><br>
		                    <span>배송비</span><br>
		                </td>
		                <td style="text-align: right;">
		                    <span class="total-product">0원</span><br>
		                    <span class="delivery-fee" id="fee2"><%= fee %>원</span><br>
		                </td>
		            </tr>
		            <tr>
		                <td colspan="3" style="border-bottom: none;"></td>
		                <td style="border-bottom: none;"></td>
		                <td class="final" style="border-bottom: none; text-align: right;"><span>합계</span>
		                </td>
		                <td style="border-bottom: none; text-align: right; font-weight: bold;">
		                    <span class="final-price">0원</span> <!-- 최종 합계에 배송비 포함 -->
		                </td>
		            </tr>
		        </tfoot>
		    </form>
		</table>

		    </form>
		</table>

        <div class="cart__mainbtns">
            <button class="cart__bigorderbtn left" onClick="location.href='.././team/teamPage_store.jsp'">쇼핑 계속하기</button>
            <button class="cart__bigorderbtn right"  id="orderBtn">주문하기</button>
        </div>
    </section>

<script>
	//상품정보 체크박스 선택 시 실행되는 함수
	document.addEventListener("DOMContentLoaded", function() {
	    const mainCheckbox = document.querySelector("thead input[type='checkbox']");
	    const itemCheckboxes = document.querySelectorAll("tbody input[type='checkbox']");
	
	    // 상품정보 체크박스 클릭 시
	    mainCheckbox.addEventListener("change", function() {
	        // 상품정보 체크박스 상태에 따라 모든 상품 체크박스 상태 변경
	        itemCheckboxes.forEach(function(checkbox) {
	            checkbox.checked = mainCheckbox.checked;
	        });
	        // 모든 체크박스 상태가 변경된 후 가격 업데이트
	        updateTotalPrice();
	    });
	});
	
    // 상품 금액 업데이트 함수
    function updateProductPrice(quantityInput) {
        const row = quantityInput.closest('tr');
        const unitPrice = parseInt(quantityInput.dataset.price); // 개별 상품 가격
        const quantity = parseInt(quantityInput.value); // 입력된 수량
        const productPriceEl = row.querySelector('.product-price');
        const newProductPrice = unitPrice * quantity;
        productPriceEl.textContent = newProductPrice.toLocaleString() + "원";
        updateTotalPrice();
    }

    // 체크된 상품들의 총 금액 계산
	function updateTotalPrice() {
	    let totalPrice = 0;
	    const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
	    checkboxes.forEach((checkbox) => {
	        if (checkbox.checked) {
	            const row = checkbox.closest('tr');
	            const productPriceEl = row.querySelector('.product-price');
	            const productPrice = parseInt(productPriceEl.textContent.replace(/[^0-9]/g, ''));
	            totalPrice += productPrice;
	        }
	    });
	
	    const totalProductEl = document.querySelector('.total-product');
	    totalProductEl.textContent = totalPrice.toLocaleString() + "원";
	
	    // 배송비 계산
	    var deliveryFee = 3500; // 기본 배송비
	    if (totalPrice >= 100000) {
	        deliveryFee = 0; // 10만원 이상 무료 배송
	    }
	
	    const fee1 = document.querySelector('#fee1');
	    fee1.textContent = deliveryFee.toLocaleString() + "원";
	    
	    const fee2 = document.querySelector('#fee2');
	    fee2.textContent = deliveryFee.toLocaleString() + "원";
	
	    const finalPrice = totalPrice + deliveryFee;
	
	    // 최종 합계
	    const finalPriceEl = document.querySelector('.final-price');
	    finalPriceEl.textContent = finalPrice.toLocaleString() + "원";
	}

	// 상품 체크박스 변경 시 가격 업데이트
	document.querySelectorAll('tbody input[type="checkbox"]').forEach(checkbox => {
	    checkbox.addEventListener('change', () => {
	        updateTotalPrice();
	    });
	});
	
	// 페이지 로드 시 초기 계산
	document.addEventListener("DOMContentLoaded", function() {
	    updateTotalPrice();
	});

	// 체크박스 선택 시 data-fee에 span 태그 값을 삽입

    function updateBasketQuantity(basketNum, quantity) {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'shoppingPage_updateBasket.jsp', true); // Assuming you're posting to 'updateBasket.jsp'
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        console.log(quantity + "" + basketNum);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                console.log('Basket updated successfully');
            }
        };

        const params = "basketNum=" + encodeURIComponent(basketNum) + "&quantity=" + encodeURIComponent(quantity);
        
        xhr.send(params);
    }


    // 수량 증가
    function increase(basketNum) {
        const button = event.target;
        const quantityInput = button.previousElementSibling;
        quantityInput.value = parseInt(quantityInput.value) + 1; 
        updateProductPrice(quantityInput); 
        updateBasketQuantity(basketNum, quantityInput.value); 
    }

    // 수량 감소
    function decrease(basketNum) {
        const button = event.target;
        const quantityInput = button.nextElementSibling;
        if (parseInt(quantityInput.value) > 1) { 
            quantityInput.value = parseInt(quantityInput.value) - 1;
            updateProductPrice(quantityInput); 
            updateBasketQuantity(basketNum, quantityInput.value); 
        }
    }

    // 수량 직접 입력 이벤트
	function quantity_input(input) {
	    if (input.value < 1) input.value = 1; // 최소 수량 1로 제한
	    const basketNum = input.closest('tr').querySelector('.decrease').getAttribute('onclick').match(/\d+/)[0]; // Basket number extraction from button's onclick
	    updateBasketQuantity(basketNum, input.value); 
	    updateProductPrice(input); 
	}
    
    function deleteBasket(basketNum) {
    	console.log(basketNum);
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'shoppingPage_deleteBasket.jsp', true); 
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
            	location.href = "shoppingPage_basket.jsp";
            }
        };

        const params = "basketNum=" + encodeURIComponent(basketNum);
        
        xhr.send(params);
        alert("삭제 되었습니다.");
        
    }
    

    // 체크박스 이벤트
    document.querySelectorAll('tbody input[type="checkbox"]').forEach(checkbox => {
        checkbox.addEventListener('change', () => {
            updateTotalPrice();
        });
    });

    
    document.getElementById('orderBtn').addEventListener('click', function() {
        const selectedItems = [];
        document.querySelectorAll('.item-checkbox:checked').forEach((checkbox) => {
            selectedItems.push({
                MD_NUM: checkbox.getAttribute('data-md-num'),
                MD_NAME: checkbox.getAttribute('data-md-name'),
                REPAIR_C: checkbox.getAttribute('data-repair-c'),
                PRICE: checkbox.getAttribute('data-price'),
                MD_IMG: checkbox.getAttribute('data-img'),
                TEAM_NAME: checkbox.getAttribute('data-team-name')
            });
        });

        if (selectedItems.length > 0) {
            const paymentForm = document.createElement('form');
            paymentForm.method = 'POST';
            paymentForm.action = 'shoppingPage_payment.jsp'; 

            selectedItems.forEach((item, index) => {
            	// 팀, 굿즈 번호, 굿즈 이미지, 가격, 굿즈명
                const mdNumInput = document.createElement('input');
                mdNumInput.type = 'hidden';
                mdNumInput.name = `orders[${ "${index}" }].MD_NUM`;
                mdNumInput.value = item.MD_NUM;
                
                const mdNameInput = document.createElement('input');
                mdNameInput.type = 'hidden';
                mdNameInput.name = `orders[${ "${index}" }].MD_NAME`;
                mdNameInput.value = item.MD_NAME;

                const repairCInput = document.createElement('input');
                repairCInput.type = 'hidden';
                repairCInput.name = `orders[${ "${index}" }].REPAIR_C`;
                repairCInput.value = item.REPAIR_C;
                
                const priceInput = document.createElement('input');
                priceInput.type = 'hidden';
                priceInput.name = `orders[${ "${index}" }].PRICE`;
                priceInput.value = item.PRICE;
                
                const imgInput = document.createElement('input');
                imgInput.type = 'hidden';
                imgInput.name = `orders[${ "${index}" }].MD_IMG`;
                imgInput.value = item.MD_IMG;
                
                const teamNameInput = document.createElement('input');
                teamNameInput.type = 'hidden';
                teamNameInput.name = `orders[${ "${index}" }].TEAM_NAME`;
                teamNameInput.value = item.TEAM_NAME;

                paymentForm.appendChild(mdNumInput);
                paymentForm.appendChild(mdNameInput);
                paymentForm.appendChild(repairCInput);
                paymentForm.appendChild(priceInput);
                paymentForm.appendChild(imgInput);
                paymentForm.appendChild(teamNameInput);
            });

            document.body.appendChild(paymentForm);
            paymentForm.submit();
        } else {
            alert("상품을 선택해 주세요.");
        }
    });


	
    // 페이지 로드 시 초기 계산
    updateTotalPrice();
</script>


</body>
</html>