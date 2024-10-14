<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="charge.PaymentBean"%>
<%@page import="java.util.List"%>
<%@page import="basket.BasketMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="basket.BasketBean"%>
<%@page import="team.TeamBean"%>
<%@page import="md.MDBean"%>
<%@page import="team.TeamMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.util.UUID"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />
<%
    request.setCharacterEncoding("UTF-8");

	// POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)
	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	
	if(teamNum == 0 && (session.getAttribute("teamNum") == null || session.getAttribute("teamNum").equals(""))){
		teamNum = 1;
	}else if (teamNum != 0) {
	    session.setAttribute("teamNum", teamNum); // 세션에 teamNum 저장
	} else {
	    teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 teamNum 가져오기
	}

    // 세션에서 sportNum 가져오기
    int sportNum = (int) session.getAttribute("sportNum");

    // 선택한 상품 정보 받아오기
    List<PaymentBean> orders = new ArrayList<>();
    int i = 0;
    int sum = 0;
    while (true) {
        String mdNum = request.getParameter("orders[" + i + "].MD_NUM");
        String mdName = request.getParameter("orders[" + i + "].MD_NAME");
        String repairC = request.getParameter("orders[" + i + "].REPAIR_C");
        String price = request.getParameter("orders[" + i + "].PRICE");
        String img = request.getParameter("orders[" + i + "].MD_IMG");
        String name = request.getParameter("orders[" + i + "].TEAM_NAME");

        // 유효성 검증 및 반복문 탈출
        if (mdNum == null || mdName == null || repairC == null || price == null || img == null || name == null) {
            break;
        }

        // 주문 정보 생성 및 리스트에 추가
        PaymentBean order = new PaymentBean();
        order.setMD_NUM(Integer.parseInt(mdNum));
        order.setMD_NAME(mdName);

        // 가격 계산
        Integer totalPrice = Integer.parseInt(repairC) * Integer.parseInt(price);
        order.setPRICE(totalPrice);
        order.setMD_IMG(img);
        order.setREPAIR_C(Integer.parseInt(repairC));
        order.setTEAM_NAME(name);
        orders.add(order);

        sum += totalPrice;
        i++;
    }

    // 팀별로 주문 정보 그룹핑
    Map<String, List<PaymentBean>> teamOrdersMap = new HashMap<>();
    for (PaymentBean order : orders) {
        String teamName = order.getTEAM_NAME();
        teamOrdersMap.computeIfAbsent(teamName, k -> new ArrayList<>()).add(order);
    }

    // 금액 포맷 설정
    DecimalFormat formatter = new DecimalFormat("###,###");

    // 주문 데이터를 세션에 저장
    session.setAttribute("orders", orders);

    // 배송비 계산
    int fee = (sum >= 100000) ? 0 : 3500;

    // 주문번호 생성: 시간 기반 + 해시 처리
    String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    String orderNumber = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 6) + timeStamp.substring(8);

    // 주문번호를 세션에 저장
    session.setAttribute("orderNumber", orderNumber);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문/결제</title>
<link rel="stylesheet" href=".././assets/css/cartStyle.css">
<link rel="stylesheet" href=".././assets/css/orderStyle.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
</head>
<body>
    <header class="order-header">
        <div>
            <span>주문 및 결제</span>
        </div>
    </header>

    <section class="order-section">
        <div class="order-address">
            <span>배송지</span>
            <div class="address-wrap">
                <div class="address-info-section">
                    <div class="address-content">
                        <div class="address-info">
                            <strong class="receiver"><span><%= login.getName() %></span></strong>
                            <div class="receiver-phone">
                                <span class="phone-number"><%= login.getPhone() %></span>
                            </div>
                            <div class="receiver-address">
                                <span><%= login.getAddress() %> (<%= login.getPostcode() %>)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="order-product">
            <span>주문상품</span>
            <div class="product-wrap">
                <div class="product-info-section">
                    <ul class="product-list">
                        <% 
                            for (Map.Entry<String, List<PaymentBean>> entry : teamOrdersMap.entrySet()) {
                                String teamName = entry.getKey();
                                List<PaymentBean> teamOrders = entry.getValue();
                        %>
                        <div class="team-name">
                            <span><%= teamName %></span>
                        </div>
                        <% for (PaymentBean order : teamOrders) { %>
                        <li class="product-info">
                            <div class="product-detail">
                                <div class="img-box">
                                    <img alt="상품 이미지" src="<%= order.getMD_IMG() %>">
                                </div>
                                <div class="content">
                                    <p><%= order.getMD_NAME() %> (상품 번호: <%= order.getMD_NUM() %>)</p>
                                    <span class="price"><%= formatter.format(order.getPRICE()) %>원</span>
                                </div>
                            </div>
                        </li>
                        <% } } %>
                    </ul>
                </div>
            </div>
        </div>

        <div class="price-wrap">
            <div class="total-price">
                <dl class="total-price-detail">
                    <div class="total-product-price">
                        <dt class="product-price">
                            <span class="product-price-text">상품금액</span>
                        </dt>
                        <dd class="product-price-number"><%= formatter.format(sum) %>원</dd>
                    </div>
                    <div class="delivery-fee">
                        <dt class="delivery-price">
                            <span class="delivery-price-text">배송비</span>
                        </dt>
                        <dd class="delivery-price-number">+<%= formatter.format(fee) %>원</dd>
                    </div>
                </dl>
                <dl class="final-price">
                    <dt class="final-price-text">총 주문금액</dt>
                    <dd class="final-price-number"><%= formatter.format(fee + sum) %>원</dd>
                </dl>
            </div>
        </div>
    </section>
    
    <form id="paymentForm" action="save_charge.jsp" method="post">
       
    </form>

    <footer class="payment-section">
		<div class="payment-content">
			<div class="agreement-content">
				<div class="agreement">
					<p><span>약관 및 주문 내용을 확인하였으며, 정보 제공 등에 동의합니다.</span></div>
			</div>
			<div class="payment-button">
			    <button type="button" class="payment-btn" onclick="submitCharge()">
			        <span><%= formatter.format(fee + sum) %>원</span> 결제하기
			    </button>
			</div>
		</div>
	</footer>

	<script type="text/javascript">
	   const orders = [
	        <% 
	        for (int j = 0; j < orders.size(); j++) {
	            PaymentBean order = orders.get(j);
	            %>{
	                MD_NUM: "<%= order.getMD_NUM() %>",
	                MD_NAME: "<%= order.getMD_NAME() %>",
	                REPAIR_C: "<%= order.getREPAIR_C() %>",
	                PRICE: "<%= order.getPRICE() %>",
	                MD_IMG: "<%= order.getMD_IMG() %>",
	                TEAM_NAME: "<%= order.getTEAM_NAME() %>"
	            }<%= (j < orders.size() - 1) ? "," : "" %>
	        <% } %>
	    ];
	   
	   function submitCharge() {
		    const form = document.getElementById('paymentForm');
		    var repairSum = 0;

		    while (form.lastElementChild) {
		        form.removeChild(form.lastElementChild);
		    }

		    orders.forEach((order, index) => {
		        const mdNumInput = document.createElement('input');
		        mdNumInput.type = 'hidden';
		        mdNumInput.name = `orders${"[${index}]"}.MD_NUM`;
		        mdNumInput.value = order.MD_NUM;
		        form.appendChild(mdNumInput);

		        const mdNameInput = document.createElement('input');
		        mdNameInput.type = 'hidden';
		        mdNameInput.name = `orders${"[${index}]"}.MD_NAME`;
		        mdNameInput.value = order.MD_NAME;
		        form.appendChild(mdNameInput);

		        const repairCInput = document.createElement('input');
		        repairCInput.type = 'hidden';
		        repairCInput.name = `orders${"[${index}]"}.REPAIR_C`;
		        repairCInput.value = order.REPAIR_C;
		        form.appendChild(repairCInput);

		        const priceInput = document.createElement('input');
		        priceInput.type = 'hidden';
		        priceInput.name = `orders${"[${index}]"}.PRICE`;
		        priceInput.value = order.PRICE;
		        form.appendChild(priceInput);

		        const feeInput = document.createElement('input');
		        feeInput.type = 'hidden';
		        feeInput.name = `orders${"[${index}]"}.FEE`;
		        feeInput.value = <%=fee%>;
		        form.appendChild(feeInput);

		        const imgInput = document.createElement('input');
		        imgInput.type = 'hidden';
		        imgInput.name = `orders${"[${index}]"}.MD_IMG`;
		        imgInput.value = order.MD_IMG;
		        form.appendChild(imgInput);

		        repairSum += parseInt(order.REPAIR_C, 10);
		    });

		    console.log(form); 

		    const paymentData = {
		        name: orders[0].MD_NAME,
		        repair: repairSum,
		        price: <%= fee + sum %>
		    };

		    requestPayment(paymentData);
		}



	   function requestPayment(paymentData) {
		    const IMP = window.IMP; // PG사 초기화
		    const userName = "<%= login.getName() %>"; // 사용자 이름 가져오기
		    var msg = paymentData.name  + " " + paymentData.repair + "개";
		    
		    if (paymentData.repair > 1) {
		        msg = paymentData.name + " 외 " + (paymentData.repair - 1) + "개";
		    }
		    
		    // Initialize the payment gateway
		    IMP.init('imp13042654'); // 가맹점 식별코드

		    IMP.request_pay({
		        pg: "kakaopay.TC0ONETIME", // 결제 방식 (여기서는 카카오페이)
		        pay_method: "card", // 결제 수단
		        merchant_uid: "order_" + new Date().getTime(), // 주문 번호
		        name: msg, // 결제할 때 보여줄 항목 이름
		        amount: paymentData.price, // 총 결제 금액
		        buyer_name: userName, // 구매자 이름
		        buyer_email: "user@example.com", // 구매자 이메일
		    }, function (response) {
		        if (response.success) {
		            alert("결제가 완료되었습니다.");
		            document.getElementById('paymentForm').submit();
		        } else {
		            alert("결제에 실패하였습니다. 에러 메시지: " + response.error_msg);
		        }
		    });
		}

	</script>
</body>
</html>
