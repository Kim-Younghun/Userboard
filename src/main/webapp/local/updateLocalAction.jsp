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
	System.out.println(request.getParameter("localName") + " <--updateLocalAction param localName");
	System.out.println(request.getParameter("dbLocalName") + " <--updateLocalAction param dbLocalName");
	
	String msg = null;
	
	// 유효성검증 후 불만족시 입력폼으로
	if(request.getParameter("localName") == null
		|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("수정할 지역을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp?msg="+msg);
		return;
	}
	// 지역리스트로부터 받아온 dbLocalName에 대한 유효성 검사
	if(request.getParameter("dbLocalName") == null
		|| request.getParameter("dbLocalName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
		return;
	}
	
	// 변수를 받아 sql문에 ?에 사용한다.
	String localName = request.getParameter("localName");
	String dbLocalName = request.getParameter("dbLocalName");
	
	//------------------------Model Layer--------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement updateLocalstmt = null;
	ResultSet updateLocalrs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 카테고리에 데이터가 있는지 확인하는 코드, 지역리스트에서 누른 해당 지역이름의 DB상 전체 행의 수를 출력(조회)한다.
	String checkQuery = "SELECT count(local_name) cnt FROM board WHERE local_name = ?";
	PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
	checkStmt.setString(1, dbLocalName);
	System.out.println(checkStmt + "updateLocalAction param checkStmt");
	ResultSet checkRs = checkStmt.executeQuery();
	
	checkRs.next();
	int count = checkRs.getInt("cnt");
	// 게시물이 몇개인지 확인
	System.out.println(count + "updateLocalAction count");
	
	if (count == 0) {
	    // 카테고리에 데이터가 없는 경우 -> 수정 가능, 지역리스트에서 누른 해당 지역이름이 DB상에 존재한다면 웹 브라우저로부터 입력받은 지역이름으로 수정한다.
	    String updateLocalSql = "UPDATE local SET local_name = ?, updatedate = now() WHERE local_name = ?";
		updateLocalstmt = conn.prepareStatement(updateLocalSql);
		updateLocalstmt.setString(1, localName);
		updateLocalstmt.setString(2, dbLocalName);
		System.out.println(updateLocalstmt + "updateLocalAction param updateLocalstmt");
	    int row = updateLocalstmt.executeUpdate();
	    if (row == 1) {
	        // 카테고리에 데이터가 없고, 수정된 행이 있는경우 -> 수정 성공
	    	System.out.println("지역수정성공");
			response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
	    } 
	} else {
	    // 카테고리에 데이터가 있는 경우 -> 수정 불가능
	    msg = URLEncoder.encode("안에 내용이 있어 삭제가 불가능합니다.", "utf-8");
	    System.out.println("지역수정실패(수정하려는 카테고리안에 내용이 존재합니다.)");
	    response.sendRedirect(request.getContextPath() + "/local/updateLocalForm.jsp?msg="+msg);
	}
%>   
