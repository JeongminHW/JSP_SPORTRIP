<%@page import="basket.BasketMgr"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="DB.MUtil"%>
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />
<%
    int basketNum = MUtil.parseInt(request, "basketNum", 0);
    int quantity = MUtil.parseInt(request, "quantity", 0);

    if (basketNum > 0 && quantity > 0) {
        basketMgr.updateBasket(basketNum, quantity); 
        response.getWriter().print("success");
    } else {
        response.getWriter().print("error");
    }
%>
