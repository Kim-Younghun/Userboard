<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>

<%
	//요청값 확인코드
	System.out.println(Integer.parseInt(request.getParameter("boardNo")) + " <--modifyCommentAction param boardNo");
	System.out.println(request.getParameter("commentContent") + " <--modifyCommentAction param commentContent");
	System.out.println(request.getParameter("commentNo") + " <--modifyCommentAction param commentNo");
	System.out.println(request.getParameter("memberId") + " <--modifyCommentAction param memberId");
	
	//------------------------Controller Layer--------------------------
	// 인코딩 코드
	request.setCharacterEncoding("utf-8");

	String msg = null;
	
	// 유효성검증 후 불만족시 입력폼으로
	if(request.getParameter("commentContent") == null
		|| request.getParameter("commentContent").equals("")) {
		msg = URLEncoder.encode("수정할 댓글을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyComment.jsp?msg="+msg);
		return;
	}
	// 유효성검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")
		|| session.getAttribute("loginMemberId") == null
 		|| session.getAttribute("loginMemberId").equals("")
 		|| request.getParameter("commentNo") == null
		|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/modifyComment.jsp");
		return;
	}
	
	// 변수를 받아 sql문에 ?에 사용한다.
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	String memberId = request.getParameter("memberId");
	
	
	//------------------------Model Layer-----------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement modifyCommentStmt = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글 작성자의 아이디를 조회(로그인한 사용자와 같은)
	String checkQuery = "SELECT member_id FROM comment WHERE member_id = ?";
	PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
	checkStmt.setString(1, memberId);
	System.out.println(checkStmt + "modifyCommentAction param checkStmt");
	ResultSet checkRs = checkStmt.executeQuery();
	
	checkRs.next();
	if(checkRs.next()) {
	    // 댓글의 내용을 수정, 선택한 댓글의 내용을 수정
	    String modifyCommentSql = "UPDATE comment SET comment_content = ?, updatedate = now() WHERE comment_no = ?";
	    modifyCommentStmt = conn.prepareStatement(modifyCommentSql);
	    modifyCommentStmt.setString(1, commentContent);
	    modifyCommentStmt.setInt(2, commentNo);
		System.out.println(modifyCommentStmt + "modifyCommentAction param modifyCommentStmt");
	    int row = modifyCommentStmt.executeUpdate();
	    System.out.println(row + "modifyCommentAction row");
	    if (row == 1) {
	    	System.out.println("댓글수정성공");
			response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	    } else {
	    msg = URLEncoder.encode("댓글 수정에 실패하였습니다.", "utf-8");
	    System.out.println("댓글수정실패");
	    response.sendRedirect(request.getContextPath() + "/board/modifyComment.jsp?msg="+msg);
		}
	}	else { // 로그인한 ID가 comment DB상에 존재하지 않는경우
		msg = URLEncoder.encode("일치하는 작성자 ID를 찾을 수 없습니다.", "utf-8");
		System.out.println("지역내용 수정실패(작성자 ID 미일치)");
	    response.sendRedirect(request.getContextPath() + "/board/modifyComment.jsp?msg="+msg);
	}
%>      
