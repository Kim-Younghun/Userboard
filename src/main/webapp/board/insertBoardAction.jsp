<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>   
<%
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("UTF-8");

	// 넘겨받은 변수확인
	System.out.println(request.getParameter("memberId"));
	System.out.println(request.getParameter("boardTitle"));
	System.out.println(request.getParameter("boardContent"));
	System.out.println(request.getParameter("localName"));
	
	//---------------------------Controller layer-------------------------------
	String msg = null;

	//요청검사(loginMemberId, boardNo, currentPage, rowPerPage..)
	// 로그인 사용자만 댓글 입력 허용 -> 로그인되지 않은 경우 다른 페이지로 보내기
	 if(session.getAttribute("loginMemberId") == null
	 		|| session.getAttribute("loginMemberId").equals("")
	 		|| request.getParameter("memberId") == null
	 		|| request.getParameter("memberId").equals("")
	 		|| request.getParameter("localName") == null
	 		|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	 if(request.getParameter("boardTitle") == null
		|| request.getParameter("boardTitle").equals("")) {
		msg = URLEncoder.encode("제목을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
		return;
	}
	 
	 if(request.getParameter("boardContent") == null
		|| request.getParameter("boardContent").equals("")) {
		msg = URLEncoder.encode("내용을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
		return;
	}
	 
	// 변수값 받기
	String memberId = request.getParameter("memberId");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String localName = request.getParameter("localName");
	
	//-------------------------Model layer------------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	PreparedStatement insertBoardStmt = null;
	ResultSet insertBoardRs = null;
	String insertBoardSql = "";
	
	insertBoardSql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate)"
	+ " VALUES(?, ?, ?, ?, NOW(), NOW())";
	insertBoardStmt = conn.prepareStatement(insertBoardSql);
	insertBoardStmt.setString(1, localName);
	insertBoardStmt.setString(2, boardTitle);
	insertBoardStmt.setString(3, boardContent);
	insertBoardStmt.setString(4, memberId);
	// ? 값 확인
	System.out.println(insertBoardStmt + "<-- insertBoardAction param insertBoardStmt");
	int row = insertBoardStmt.executeUpdate();
	
	if(row == 1) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("지역정보 입력 성공");
	} else {
		msg = URLEncoder.encode("지역정보 입력실패.", "utf-8");
		System.out.println("지역정보 입력 실패");
		response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp");
	}
%>