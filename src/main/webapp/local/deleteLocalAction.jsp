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
	System.out.println(request.getParameter("localName") + " <--deleteLocalAction param localName");
	
	String msg = null;
	
	// 유효성검증 후 불만족시 
	if(request.getParameter("localName") == null
		|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
		return;
	}
	
	// 변수를 받아 sql문에 ?에 사용한다.
	String localName = request.getParameter("localName");
	/* String dbLocalName = request.getParameter("dbLocalName"); */
	
	//------------------------Model Layer--------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement deleteLocalstmt = null;
	ResultSet deleteLocalrs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 카테고리에 데이터가 있는지 확인하는 코드, 클릭한 지역명의 DB상 전체 행의 수를 출력(조회)한다.
	String checkQuery = "SELECT count(local_name) cnt FROM board WHERE local_name = ?";
	PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
	checkStmt.setString(1, localName);
	System.out.println(checkStmt + "deleteLocalAction param checkStmt");
	ResultSet checkRs = checkStmt.executeQuery();
	
	checkRs.next();
	int count = checkRs.getInt("cnt");
	// 게시물이 몇개인지 확인
	System.out.println(count + "deleteLocalAction count");

	if (count == 0) {
	    // 카테고리에 데이터가 없는 경우 -> 삭제 가능
	    String deleteLocalSql = "DELETE FROM local WHERE local_name = ?";
	    deleteLocalstmt = conn.prepareStatement(deleteLocalSql);
	    deleteLocalstmt.setString(1, localName);
		System.out.println(deleteLocalstmt + "deleteLocalAction param deleteLocalstmt");
	    int row = deleteLocalstmt.executeUpdate();
	    if (row == 1) {
	        // 카테고리에 데이터가 없고, 삭제된 행이 있는경우 -> 삭제 성공
	    	System.out.println("지역삭제성공");
	    } 
	} else {
	    // 카테고리에 데이터가 있는 경우 -> 삭제 불가능
	    msg = URLEncoder.encode("안에 내용이 있어 삭제가 불가능합니다.", "utf-8");
	    System.out.println("지역삭제실패(삭제하려는 카테고리안에 내용이 존재합니다.)");
	}
	response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
%>   
