<%@page import="board.BoardBean"%>
<%@page import="board.BoardMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.List"%>
<%@page import="DB.MUtil"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="boardMgr" class="board.BoardMgr" />
<jsp:useBean id="boardBean" class="board.BoardBean" />

<%
    // 파라미터로 전달된 검색어와 검색 타입을 받음
    String searchType = request.getParameter("type");
    String searchText = request.getParameter("searchText");
    int teamNum = MUtil.parseInt(request, "teamNum", 0); // 팀 번호를 받음

    // 팀에 속한 게시글 가져오기
    Vector<BoardBean> boardInfo = boardMgr.listBoard(teamNum);

    // NullPointerException 방지
    if (boardInfo == null) {
        boardInfo = new Vector<>();
    }

    Vector<BoardBean> searchResults = new Vector<>();

    // 검색어가 있는 경우에만 검색
    if (searchText != null && !searchText.trim().isEmpty()) {
        for (BoardBean board : boardInfo) {
            if ("제목".equals(searchType) && board.getTITLE().contains(searchText)) {
                searchResults.add(board);
            } else if ("작성자".equals(searchType) && board.getID().contains(searchText)) {
                searchResults.add(board);
            } else if ("작성일".equals(searchType) && board.getPOSTDATE().contains(searchText)) {
                searchResults.add(board);
            }
        }
    } else {
        // 검색어가 없을 경우 모든 게시글 출력
        searchResults = boardInfo;
    }
%>

<!-- 검색 결과 리스트 출력 -->
<% if (searchResults != null && !searchResults.isEmpty()) { %>
    <% int index = 1; %>
    <% for (BoardBean board : searchResults) { %>
    <tr>
        <td><%=index++%></td>
        <td><a href="#" onclick="sendBoardNum(<%=board.getBOARD_NUM()%>, '.././board/viewPost')">
            <%=board.getTITLE()%></a></td>
        <td><%=board.getID()%></td>
        <td><%=board.getPOSTDATE()%></td>
        <td><%=board.getVIEWS()%></td>
        <td><%=board.getRECOMMAND()%></td>
    </tr>
    <% } %>
<% } else { %>
    <tr>
        <td colspan="6">검색 결과가 없습니다.</td>
    </tr>
<% } %>
