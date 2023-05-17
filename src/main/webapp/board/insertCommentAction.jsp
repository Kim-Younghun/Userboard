<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	System.out.println(Integer.parseInt(request.getParameter("boardNo")));
	System.out.println(request.getParameter("memberId"));
	System.out.println(request.getParameter("commentContent"));
	
	//--------------------Controller layer-----------------------------------
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");

	//요청검사(loginMemberId, boardNo, currentPage, rowPerPage..)
	// 로그인 사용자만 댓글 입력 허용 -> 로그인되지 않은 경우 다른 페이지로 보내기
	 if(session.getAttribute("loginMemberId") == null
	 		|| session.getAttribute("loginMemberId").equals("")
	 		|| request.getParameter("boardNo") == null
	 		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); 
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String commentContent = request.getParameter("commentContent");

	//-------------------------Model layer------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	PreparedStatement commentInsertStmt = null;
	ResultSet commentInsertRs = null;
	String commentInsertSql = "";
	/* 
		INSERT INTO comment(board_no boardNo comment_content commentContent, member_id memberId, createdate, updatedate) 
		VALUES(?, ?, ?, NOW(), NOW())
	*/
	commentInsertSql = "INSERT INTO comment(board_no, comment_content, member_id, createdate, updatedate)"
	+ " VALUES(?, ?, ?, NOW(), NOW())";
	commentInsertStmt = conn.prepareStatement(commentInsertSql);
	commentInsertStmt.setInt(1, boardNo);
	commentInsertStmt.setString(2, commentContent);
	commentInsertStmt.setString(3, loginMemberId);
	// ? 값 확인
	System.out.println(commentInsertStmt + "insertCommentAction param commentInsertStmt");
	int row = commentInsertStmt.executeUpdate();
	
	// 댓글 입력 성공유무에 따른 분기
	if(row == 1) {
		System.out.println("댓글 입력 성공");
	} else {
		System.out.println("댓글 입력 실패");
	}
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>
