<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.*"%>
<%
	//--------------------------Controller layer---------------------------------
	// 인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");

	// session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//유효성 검사 후 입력값이 맞지 않으면 회원가입 페이지로 리디렉션
	if(request.getParameter("memberId") == null
		|| request.getParameter("memberPw") == null
		|| request.getParameter("memberId").equals("")
		|| request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		return;
	}
	
	// 문자열 타입으로 변수를 받기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 디버깅
	System.out.println(memberId + "insertMemberAction memberId");
	System.out.println(memberPw + "insertMemberAction memberPw");
	
	// 데이터를 묶어서 받기(Member 클래스)
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	//----------------------------Model layer---------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// SQL문 적용 1) 중복 id검사 sql문
	/* 
		"SELECT member_id FROM member WHERE member_id = ?";
	*/
	String idSql = "SELECT member_id FROM member WHERE member_id = ?";	
	stmt = conn.prepareStatement(idSql);
	stmt.setString(1, memberId);
	rs = stmt.executeQuery();
	if(rs.next()) {	// ID가 중복될 경우
		System.out.println("아이디가 중복됨");
		String msg = URLEncoder.encode("중복 ID", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		
		return;
	} 
	
	// ?값 확인
	System.out.println(stmt + "insertMemberAction stmt1");

	// SQL문 적용 2) 회원가입 sql문 (겹치지 않는 id를 mariaDB에 행의 형태로 넣는다.)
	
	/* 
		"INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())"; 
	*/
	// 비밀번호는 PASSWORD 함수 사용하기
	String joinSql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())"; 
	stmt2 = conn.prepareStatement(joinSql);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	
	// ?값 확인
	System.out.println(stmt2 + "insertMemberAction stmt2");
	
	int row = stmt2.executeUpdate();
	
	// 회원가입 조건에 따른 콘솔출력문구 및 페이지 요청
	if(row == 1) { // 회원가입 성공
		System.out.println("회원가입 성공");
	} else { // 회원가입 실패시 회원가입 페이지로
		System.out.println("회원가입 실패");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
	}
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>