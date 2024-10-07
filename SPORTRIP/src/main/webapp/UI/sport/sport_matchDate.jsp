<%@page import="java.util.List"%>
<%@page import="matchdate.MatchdateBean"%>
<%@page import="team.TeamBean"%>
<%@page import="java.util.Vector"%>
<%@page import="DB.MUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="teamMgr" class="team.TeamMgr" />
<jsp:useBean id="matchdateMgr" class="matchdate.MatchdateMgr" />
<jsp:useBean id="stadiumMgr" class="stadium.StadiumMgr" />
<jsp:useBean id="teamBean" class="team.TeamBean" />
<% 
    // 세션에서 sportNum 가져오기
    int sportNum = (int)session.getAttribute("sportNum");

    // 선택된 월 확인 (없으면 0으로 처리)
    String selectedMonthStr = request.getParameter("month");
    int selectedMonth = selectedMonthStr != null ? Integer.parseInt(selectedMonthStr) : 0;

    // 경기 데이터를 가져오기 (월별 혹은 전체)
    Vector<MatchdateBean> matchdateVlist = new Vector<>();
    if (selectedMonth > 0) {
        // 선택된 월이 있으면 해당 월 데이터만 조회
        matchdateVlist = matchdateMgr.monthMachedate(sportNum, selectedMonth);
    } else {
        // 선택된 월이 없으면 전체 데이터를 조회
        matchdateVlist = matchdateMgr.listMachedate(sportNum); // 전체 데이터 가져오기
        System.out.println(selectedMonth);
    }
%>


<jsp:include page="sport_header.jsp"/>

<!-- 월 선택 박스 -->
<div class="select-box">
    <form method="GET" action="">
        <select name="month" class="select month" onchange="this.form.submit()">
            <option value="0">전체</option>
            <% for (int i = 1; i <= 12; i++) { %>
                <option value="<%=i%>" <%= (i == selectedMonth) ? "selected" : "" %>><%=i%></option>
            <% } %>
        </select>
    </form>
</div>

<!-- 경기 일정 테이블 -->
<div class="league-date-table">
    <table>
        <thead>
            <tr>
                <th>날짜</th>
                <th>시간</th>
                <th colspan="5">경기</th>
                <th colspan="2">장소</th>
            </tr>
        </thead>
        <tbody>
            <% if (matchdateVlist != null && !matchdateVlist.isEmpty()) {
                for (MatchdateBean matchDate : matchdateVlist) {
                    String team1[] = teamMgr.getTeamInfo(matchDate.getTEAM_NUM1());
                    String team2[] = teamMgr.getTeamInfo(matchDate.getTEAM_NUM2());
            %>
                <tr>
                    <td><%=matchDate.getMATCH_DATE()%></td>
                    <td><%=matchDate.getMATCH_TIME()%></td>
                    <td colspan="5">
                        <img src="<%=team1[1]%>" alt="" /> <%=team1[0]%>
                        <span style="margin-left:40px;"><%=matchDate.getTEAM1_POINT()%> : <%=matchDate.getTEAM2_POINT()%></span>
                        <img src="<%=team2[1]%>" alt="" /> <%=team2[0]%>
                    </td>
                    <td><%=matchdateMgr.getstadiumName(matchDate.getMATCH_DATE_NUM())%></td>
                </tr>
            <% 
                }
            } else { 
            %>
                <!-- 경기 일정이 없을 경우 -->
                <tr>
                    <td colspan="8">해당 월에 경기가 없습니다.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>
