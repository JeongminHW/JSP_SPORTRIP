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
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />
<%
	request.setCharacterEncoding("UTF-8");
	String url = request.getParameter("url");

	//POST로 전달된 teamNum을 세션에 저장 (세션에 없을 경우에만 저장)

	int teamNum = MUtil.parseInt(request, "teamNum", 0); // 폼에서 받은 값이 없으면 0
	if (teamNum == 0) {
		teamNum = (Integer) session.getAttribute("teamNum"); // 세션에서 팀 번호 가져오기
	} else {
		session.setAttribute("teamNum", teamNum); // 세션에 팀 번호 저장
	}

	int sportNum = (int)session.getAttribute("sportNum");
	
	
	// 선택한 상품 정보 받아오기(굿즈번호, 수량, 가격)
    String[] mdNums = request.getParameterValues("orders[0].MD_NUM");
    String[] mdNames = request.getParameterValues("orders[0].MD_NAME");
    String[] repairCs = request.getParameterValues("orders[0].REPAIR_C");
    String[] prices = request.getParameterValues("orders[0].PRICE");
    String[] imgs = request.getParameterValues("orders[0].MD_IMG");
    String[] names = request.getParameterValues("orders[0].TEAM_NAME");
    
    		
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

        if (mdNum == null || mdName == null || repairC == null || price == null || img == null|| name == null) {
            break; 
        }
        
        PaymentBean order = new PaymentBean();
        order.setMD_NUM(Integer.parseInt(mdNum));
        order.setMD_NAME(mdName);
        
        Integer totalPrice = Integer.parseInt(repairC)*Integer.parseInt(price);
        
        order.setPRICE(totalPrice);
        order.setMD_IMG(img);
        order.setTEAM_NAME(name);
        orders.add(order);
        
        sum += totalPrice;
        		
        i++;
        
    }
    
    Map<String, List<PaymentBean>> teamOrdersMap = new HashMap<>();

    // Populate the map with orders grouped by team name
    for (PaymentBean order : orders) {
        String teamName = order.getTEAM_NAME();
        if (!teamOrdersMap.containsKey(teamName)) {
            teamOrdersMap.put(teamName, new ArrayList<PaymentBean>());
        }
        teamOrdersMap.get(teamName).add(order);
    }
    

    DecimalFormat formatter = new DecimalFormat("###,###");

    // Pass the orders to the session or use directly
    session.setAttribute("orders", orders);
    
   	int fee = 3500;
    if(sum >= 100000){
    	fee = 0;
    }
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문/결제</title>
<link rel="stylesheet" href=".././assets/css/cartStyle.css">
<link rel="stylesheet" href=".././assets/css/orderStyle.css">
<script>
// 팝업 열기 함수
function openPopup() {
    // 팝업을 표시
    document.querySelector('.popup-background').style.display = 'flex';

    // 팝업 내용의 스크롤을 맨 위로 설정
    document.querySelector('.popup-content').scrollTop = 0;
}

// 팝업 닫기 함수
function closePopup() {
	document.querySelector('.popup-background').style.display = 'none';
}
</script>
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
							<strong class="receiver"><span><%=login.getName()%></span></strong>
							<div class="receiver-phone">
								<span class="phone-number"><%=login.getPhone()%></span>
							</div>
							<div class="receiver-address">
								<span><%=login.getAddress()%>(<%=login.getPostcode()%>)</span>
							</div>
						</div>
						<div class="address-chage">
							<button type="button" class="address-change-btn" onclick="openPopup()">변경</button>
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
					        // Iterate over the map entries (team name and associated products)
					        for (Map.Entry<String, List<PaymentBean>> entry : teamOrdersMap.entrySet()) {
					            String teamName = entry.getKey();
					            List<PaymentBean> teamOrders = entry.getValue();
					    %>
					        <!-- Display team name once -->
					        <div class="team-name">
					            <span><%= teamName %></span>
					        </div>
					
					        <!-- Iterate over the products under the current team -->
					        <% for (PaymentBean order : teamOrders) {  %>
					            <li class="product-info">
					                <div class="product-detail">
					                    <div class="img-box">
					                        <img alt="상품 이미지" src="<%= order.getMD_IMG() %>">
					                    </div>
					                    <div class="content">
					                        <p><%= order.getMD_NAME() %> (상품 번호: <%= order.getMD_NUM() %>)</p>
					                        <span class="price"><%=formatter.format(order.getPRICE())  %>원</span>
					                    </div>
					                </div>
					            </li>
					        <% } %>
					    <% } %>
					</ul>
		        </div>
		    </div>
		</div>
			<div class="price-wrap">
				<div class="total-price">
					<dl class="total-price-detail">
						<div class="total-product-price">
							<dt class="product-price"><span class="product-price-text">상품금액</span></dt>
							<dd class="product-price-number"><%=formatter.format(sum) %>원</dd>
						</div>
						<div class="delivery-fee">
							<dt class="delivery-price">
								<span class="delivery-price-text">배송비</span>
							</dt>
							<dd class="delivery-price-number">+<%= formatter.format(fee)%></dd>
						</div>
					</dl>
					<dl class="final-price">
						<dt class="final-price-text">총 주문금액</dt>
						<dd class="final-price-number"><%= formatter.format(fee+sum)%>원</dd>
					</dl>
				</div>
			</div>
		</div>
	</section>
	
	<!-- 팝업 창 -->
	<div class="popup-background">
		<div class="popup">
			<div class="popup-header">회원 정보</div>
			<div class="popup-content">
				<ul class="address-list-area">
					<li class="address-list-content">
						<div class="address-content">
							<div class="address-area">
								<div class="address-info">
									<strong class="receiver"><span><%=login.getName()%></span></strong>
									<div class="receiver-phone">
										<span class="phone-number"><%=login.getPhone()%></span>
									</div>
									<div class="receiver-address">
										<span><%=login.getAddress()%>(<%=login.getPostcode()%>)</span>
									</div>
								</div>
							</div>
						</div>
					</li>
				</ul>
				<button type="button" class="modify-address">수정</button>
				<button class="close-popup" onclick="closePopup()">닫기</button>
			</div>
		</div>
	</div>
	
	<footer class="payment-section">
		<div class="payment-content">
			<div class="agreement-content">
				<div class="agreement">
					<p><span>약관 및 주문 내용을 확인하였으며, 정보 제공 등에 동의합니다.</span></div>
			</div>
			<div class="payment-button">
				<button type="button" class="payment-btn"><span><%= formatter.format(fee+sum)%>원 </span>결제하기</button>
			</div>
		</div>
	</footer>
</body>
</html>