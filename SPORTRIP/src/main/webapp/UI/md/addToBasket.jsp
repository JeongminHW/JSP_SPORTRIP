<%@page import="basket.BasketBean"%>
<%@page import="basket.BasketMgr"%>
<jsp:useBean id="basketMgr" class="basket.BasketMgr" />

<%
    String userId = ((user.UserBean)session.getAttribute("login")).getId();
    int mdNum = Integer.parseInt(request.getParameter("mdNum"));
    int repairB = Integer.parseInt(request.getParameter("repairB"));

    BasketBean basketBean = new BasketBean();
    basketBean.setID(userId);
    basketBean.setMD_NUM(mdNum);
    basketBean.setREPAIR_B(repairB);

   	if(basketMgr.insertBasket(basketBean)){
		response.sendRedirect(".././team/teamPage_store.jsp");
	}
%>
