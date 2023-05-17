<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	//--------------------------------Controller layer-----------------------------------
	// 1. 세션 유효성 검사 -> 2. 요청값 유효성 검사
	// 로그인된 클라이언트가 들어오지 못하도록
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 요청값 유효성 검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 디버깅
	System.out.println(memberId+ "<-- loginAction memberId");
	System.out.println(memberPw+ "<-- loginAction memberPw");
	// 데이터를 묶는 작업
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	//---------------------------------Model layer--------------------------------
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/*  
		// sql문 미리 검증해보기
		"SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)"
	*/
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	rs = stmt.executeQuery();
	if(rs.next()) { // 로그인 성공
		// 세션에 로그인 정보(memberId) 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
	} else { // 로그인 실패
		System.out.println("로그인 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>    
