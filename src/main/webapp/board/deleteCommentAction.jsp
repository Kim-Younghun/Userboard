<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>   

<%
	//------------------------Controller Layer--------------------------

	// 인코딩 코드
	request.setCharacterEncoding("utf-8");

	//요청값 확인코드
	System.out.println(Integer.parseInt(request.getParameter("boardNo")) + " <--modifyCommentAction param boardNo");
	System.out.println(request.getParameter("commentNo") + " <--modifyCommentAction param commentNo");
	System.out.println(request.getParameter("memberId") + " <--modifyCommentAction param memberId");
	
	String msg = null;
	
	// 유효성검증 후 불만족시 입력폼으로
	// 상세페이지부터 받아온 변수에 대한 유효성 검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")
		|| request.getParameter("memberId") == null
 		|| request.getParameter("memberId").equals("")
 		|| request.getParameter("commentNo") == null
		|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"home.jsp");
		return;
	}
	
	// 변수를 받아 sql문에 ?에 사용한다.
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String memberId = request.getParameter("memberId");
	
	
	//------------------------Model Layer--------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement deleteCommentstmt = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글 작성자의 아이디를 조회
	String checkQuery = "SELECT member_id FROM comment WHERE member_id = ?";
	PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
	checkStmt.setString(1, memberId);
	System.out.println(checkStmt + "deleteCommentAction param checkStmt");
	ResultSet checkRs = checkStmt.executeQuery();
	
	checkRs.next();
	if(checkRs.next()) {
	    // 댓글의 내용을 수정, 선택한 댓글의 내용을 수정
	    String deleteCommentSql = "DELETE FROM comment WHERE comment_no = ?";
	    deleteCommentstmt = conn.prepareStatement(deleteCommentSql);
	    deleteCommentstmt.setInt(1, commentNo);
		System.out.println(deleteCommentstmt + "deleteCommentAction param deleteCommentstmt");
	    int row = deleteCommentstmt.executeUpdate();
	    System.out.println(row + "deleteCommentAction row");
	    if (row == 1) {
	    	System.out.println("댓글삭제성공");
			response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	    } else {
	    msg = URLEncoder.encode("댓글 삭제에 실패하였습니다.", "utf-8");
	    System.out.println("댓글삭제실패");
	    response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo+"msg="+msg);
		}
	}
%>      
