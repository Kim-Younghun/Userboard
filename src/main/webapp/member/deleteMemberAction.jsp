<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>   
<%
	//------------------------Controller Layer--------------------------

	//로그인이 되어있지 않으면 home으로 리다이렉션
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 인코딩 코드
	request.setCharacterEncoding("utf-8");

	// 요청값 확인코드
	System.out.println(request.getParameter("memberPw") + " <--deleteMemberAction param memberPw");
	
	// 유효성검증 후 불만족시 회원탈퇴폼으로
	String memberPw = "";
	if(request.getParameter("memberPw") == null
			|| request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp");
		return;
	}
	
	String msg = null;
	memberPw = request.getParameter("memberPw");
	String memberId = (String)session.getAttribute("loginMemberId");
	
	//---------------------------Model Layer-----------------------------------
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 비밀번호로는 암호화된값을 넣어준다.
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_pw = password(?)";
	PreparedStatement deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1, memberId);
	deleteMemberStmt.setString(2, memberPw);
	int row = deleteMemberStmt.executeUpdate();
	System.out.println(deleteMemberStmt + " <--deleteMemberAction deleteMemberStmt");
	
	if (row == 1){
		msg = URLEncoder.encode("회원탈퇴성공", "utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		session.invalidate();
		return;
	} else {
		msg = URLEncoder.encode("회원탈퇴실패(비밀번호를 다시 입력해주세요.)", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
	}
%>