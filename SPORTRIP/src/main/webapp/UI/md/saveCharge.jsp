<%@page import="charge.PaymentBean"%>
<%@page import="charge.ChargeBean"%>
<%@page import="charge.ChargeMgr"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="login" scope="session" class="user.UserBean" />

<%
    String id = login.getId();
	
    if (id == null) {
        out.println("<script>alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');</script>");
        response.sendRedirect(".././user/login.jsp");
        return;
    }

    String orderNumber = (String) session.getAttribute("orderNumber");
    int fee = Integer.parseInt(request.getParameter("orders[0].FEE"));
    if (orderNumber == null) {
        out.println("<script>alert('주문 정보가 없습니다. 다시 시도해주세요.');</script>");
        response.sendRedirect("shoppingPage_payment.jsp");
        return;
    }

    ChargeMgr chargeMgr = new ChargeMgr();
    boolean paymentSuccess = true;

    int i = 0;
    while (true) {
        String mdNum = request.getParameter("orders[" + i + "].MD_NUM");
        String repairC = request.getParameter("orders[" + i + "].REPAIR_C");
        String price = request.getParameter("orders[" + i + "].PRICE");

        if (mdNum == null || repairC == null || price == null) {
            break;
        }

        ChargeBean chargeBean = new ChargeBean();
        chargeBean.setID(id);
        chargeBean.setORDER_NUM(orderNumber);
        chargeBean.setMD_NUM(Integer.parseInt(mdNum));
        chargeBean.setREPAIR_C(Integer.parseInt(repairC));
        chargeBean.setPRICE(Integer.parseInt(price)+fee);

        if (!chargeMgr.payMD(chargeBean)) {
            paymentSuccess = false;
            break;
        }
        i++;
    }
%>
