<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>   
<%
	//-------------------------Controller Layer-------------------------
	
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");
	
	//요청값 확인
	System.out.println(Integer.parseInt(request.getParameter("boardNo"))+ "modifyBoardAction param boardNo");
	System.out.println(request.getParameter("memberId")+ "modifyBoardAction param memberId");
	System.out.println(request.getParameter("localName")+ "modifyBoardAction param localName");
	
	String msg = null;

	//요청검사
	 if(request.getParameter("memberId") == null
 		|| request.getParameter("memberId").equals("")
 		|| request.getParameter("localName") == null
 		|| request.getParameter("localName").equals("")
 		|| request.getParameter("boardNo") == null
 		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	// 변수값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	String localName = request.getParameter("localName");
	
	//------------------------Model Layer-------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement deleteBoardStmt = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 댓글 작성자의 아이디를 조회(로그인한 사용자와 같은)
	String checkQuery = "SELECT local_name FROM board WHERE local_name = ?";
	PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
	checkStmt.setString(1, localName);
	System.out.println(checkStmt + "modifyBoardAction param checkStmt");
	ResultSet checkRs = checkStmt.executeQuery();
	
	checkRs.next();
	if(checkRs.next()) {
	
		// 댓글의 내용을 수정, 선택한 댓글의 내용을 수정
	    String deleteBoardSql = "DELETE FROM board WHERE board_no = ?";
	    deleteBoardStmt = conn.prepareStatement(deleteBoardSql);
	    deleteBoardStmt.setInt(1, boardNo);
		System.out.println(deleteBoardStmt + "deleteBoardAction param deleteBoardStmt");
	    int row = deleteBoardStmt.executeUpdate();
	    System.out.println(row + "deleteBoardAction row");
	    if (row == 1) {
	    	System.out.println("지역내용 삭제성공");
			response.sendRedirect(request.getContextPath()+"/home.jsp");
	    } else {
	    msg = URLEncoder.encode("지역내용 삭제에 실패하였습니다.", "utf-8");
	    System.out.println("지역내용 삭제실패");
	    response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		}
	} else {
		msg = URLEncoder.encode("존재하는 지역명을 삭제해주세요.", "utf-8");
		System.out.println("지역내용 삭제실패(없는 지역명)");
	    response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
	}
%>