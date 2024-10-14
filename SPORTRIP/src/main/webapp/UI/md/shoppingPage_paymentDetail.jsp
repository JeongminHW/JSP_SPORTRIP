<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="charge.ChargeBean"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="md.MDBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />
<jsp:useBean id="mdMgr" class="md.MDMgr" />
<jsp:useBean id="chargeMgr" class="charge.ChargeMgr" />
    
 <%
    request.setCharacterEncoding("UTF-8");

    // 금액 포맷 설정
    DecimalFormat formatter = new DecimalFormat("###,###");

    String orderNumber = request.getParameter("orderNumber");

    Vector<ChargeBean> chargeVlist = chargeMgr.findGetCharge(orderNumber);
    int total = 0;
    int price = 0;
    int refair = 0;
    int fee = 0;
    String mdName = null;
   
    
    ChargeBean chargeBean = new ChargeBean();
    MDBean mdbean = new MDBean();
    
    for(ChargeBean charge : chargeVlist){
    	chargeBean.setCHARGE_DATE(charge.getCHARGE_DATE());
    	chargeBean.setORDER_NUM(charge.getORDER_NUM());
    	chargeBean.setORDER_NUM(charge.getORDER_NUM());
    	refair += charge.getREPAIR_C();
    	mdbean = mdMgr.getMD(charge.getMD_NUM());
    	total += (mdbean.getMD_PRICE() * charge.getREPAIR_C());
    	price += charge.getPRICE();
    }
    
    if(refair > 1){
    	mdName = (refair - 1)+ "개";
    }else{
    	mdName = (refair)+ "개";
    }
    
    fee = total - price;
    // 배송비 계산(합산액의 차액 계산)
    if(fee < 0){
    	fee = 0;
    }
    
    
    // 현재 날짜와 주문 날짜 비교
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date chargeDate = sdf.parse(chargeBean.getCHARGE_DATE()); // 주문 날짜
    Date currentDate = new Date(); // 현재 날짜

    // 주문일자와 현재 날짜의 차이를 계산
    long diffInMillis = currentDate.getTime() - chargeDate.getTime();
    long diffInDays = TimeUnit.MILLISECONDS.toDays(diffInMillis);

    // 2일 이내면 버튼을 활성화, 아니면 비활성화
    boolean isCancelable = (diffInDays <= 2);
    
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문/결제내역</title>
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet"/>
<link href=".././assets/css/payment_detailStyle.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="payment-detail">
		<div class="payment-info-section">
			<header class="payment-info-header">
				<span>주문/결제내역</span>
			</header>
			<div class="payment-info-content">
				<div class="purchase-info">
					<span class="order-number">주문번호: <%= orderNumber%></span>
					<span class="order-date"><%= chargeBean.getCHARGE_DATE()%></span>
					<span class="order-name"><%=mdbean.getMD_NAME() %> 외 <%=mdName%></span>
				</div>
				<div class="payment-price"> 
					<span><%=formatter.format(total) %>원</span>
					<span class="payment-method">카카오페이</span>
				</div>
				<div class="payment-status">
					<div>
						<span class="payment-complete">결제완료</span>
						<button type="button" class="payment-cancel" onclick="deletePayment()" <%= !isCancelable ? "disabled" : "" %>>결제취소</button>
					</div> 
					<span>주문 2일 이내 취소 가능</span>
				</div>
			</div>
		</div>
		<div class="payment-detail-section">
			<table>
				<tr>
					<th>주문번호</th>
					<td colspan="3"><%= chargeBean.getORDER_NUM()%></td>
				</tr>
				<tr>
					<th>현재구매상태</th>
					<td colspan="3">결제완료</td>
				</tr>
				<tr>
					<th>결제방식</th>
					<td colspan="3">카카오페이</td>
				</tr>
				<tr>
					<th>결제일</th>
					<td colspan="3"><%=chargeBean.getCHARGE_DATE() %></td>
				</tr>
				<tr class="item-row">
					<th rowspan="3">상품</th>
				<%
					for(ChargeBean charge : chargeVlist){
						
				    	chargeBean.setCHARGE_DATE(charge.getCHARGE_DATE());
				    	chargeBean.setORDER_NUM(charge.getORDER_NUM());
				    	chargeBean.setORDER_NUM(charge.getORDER_NUM());
				    	refair += charge.getREPAIR_C();
				    	mdbean = mdMgr.getMD(charge.getMD_NUM());
				    
				%>
						<tr>
						    <td><%= mdbean.getMD_NAME() %> <%=charge.getREPAIR_C() %>개</td> <!-- 상품명 (Product Name) -->
						    <td class="product-info"><%= formatter.format(mdbean.getMD_PRICE() * charge.getREPAIR_C()) %>원</td> <!-- 가격 (Price) -->
						</tr>
				<%} %>
				<tr>
					<th>배송비</th>
					<td colspan="3"><%=formatter.format(fee) %></td>
				</tr>
			</table>
			<div class="payment-total-price">
				<span class="text">총 금액 </span>
				<span><%=formatter.format(total) %></span>
			</div>

		</div>
	</div>
</body>
	<style>
	    /* 버튼 스타일 */
	    .payment-cancel {
	        color: #333;  /* 텍스트 색 */
	        cursor: pointer;  /* 커서 모양 */
	        transition: background-color 0.3s ease;  /* 호버 효과 */
	    }
	
	    /* 호버 효과 (버튼 위에 마우스를 올렸을 때) */
	    .payment-cancel:hover {
	        background-color: #dcdcdc;  /* 호버 시 배경색 변경 */
	    }
	
	    /* 비활성화된 상태에서 스타일 */
	    .payment-cancel:disabled {
	    	border: none;  /* 테두리 제거 */
	        background-color: #ccc;  /* 비활성화된 버튼 배경색 */
	        color: #999;  /* 비활성화된 텍스트 색 */
	        cursor: not-allowed;  /* 비활성화된 상태에서 커서 변경 */
	    }
	</style>


	<script>
	function deletePayment() {
	    const params = new URLSearchParams();
	    params.append('orderNumber', "<%=orderNumber%>");

	    fetch('delete_payment.jsp?' + params.toString(), {
	        method: 'GET', 
	    })
	    .then(response => response.text())
	    .then(data => {
	        console.log("Response:", data); 
	        if (data.includes("success")) { 
	            alert('결제 취소가 완료되었습니다.');
	            location.href = ".././user/myPage.jsp"; 
	        } else {
	            alert('결제 취소가 되지 않았습니다.');
	        }
	    })
	    .catch(error => console.error('Error:', error));
	} 
	</script>
</html>