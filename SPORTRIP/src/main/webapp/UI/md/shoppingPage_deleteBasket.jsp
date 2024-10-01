<%@page import="basket.BasketMgr"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="DB.MUtil"%>
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />
<%
    int basketNum = MUtil.parseInt(request, "basketNum", 0);

    if (basketNum > 0) {
        basketMgr.deleteBasket(basketNum);
        response.getWriter().print("success");
    } else {
        response.getWriter().print("error");
    }
%>
