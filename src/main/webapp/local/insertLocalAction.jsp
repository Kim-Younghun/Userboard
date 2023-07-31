<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	//------------------------Controller Layer--------------------------
	// 인코딩 코드
	request.setCharacterEncoding("utf-8");

	//요청값 확인코드
	System.out.println(request.getParameter("localName") + " <--insertLocalAction param localName");
	
	String msg = null;
	
	// 유효성검증 후 불만족시 입력폼으로
	if(request.getParameter("localName") == null
			|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("추가할 지역을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp");
		return;
	}
	
	// 문자열 타입으로 변수를 받기
	String localName = request.getParameter("localName");
	
	//------------------------Model Layer--------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement insertLocalstmt = null;
	ResultSet insertLocalrs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 입력받은 지역명을 추가
	String insertLocalSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, NOW(), NOW())";
	insertLocalstmt = conn.prepareStatement(insertLocalSql);
	insertLocalstmt.setString(1, localName);
	System.out.println(insertLocalstmt + "insertLocalAction param insertLocalstmt");
	
	int row = insertLocalstmt.executeUpdate();
	
	// 지역입력 성공유무에 따른 분기
	if(row == 1) { 
		System.out.println("지역입력성공");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
		
	} else { 
		msg = URLEncoder.encode("지역입력실패.", "utf-8");
		System.out.println("지역입력실패");
		response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp");
	}
%>   
