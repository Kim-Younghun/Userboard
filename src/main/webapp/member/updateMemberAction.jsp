<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	//------------------------Controller Layer--------------------------
	// 인코딩 코드
	request.setCharacterEncoding("utf-8");
	
	//로그인이 되어있지 않으면 home으로 리다이렉션
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 요청값 확인코드
	System.out.println(request.getParameter("currentPw") + " <--updateMemberAction param currentPw");
	System.out.println(request.getParameter("newPw") + " <--updateMemberAction param newPw");
	System.out.println(request.getParameter("confirmPw") + " <--updateMemberAction param confirmPw");
	
	// 유효성검증 후 불만족시 비밀번호수정폼으로
	if(request.getParameter("currentPw") == null
		|| request.getParameter("currentPw").equals("")
		|| request.getParameter("newPw") == null
		|| request.getParameter("newPw").equals("")
		|| request.getParameter("confirmPw") == null
		|| request.getParameter("confirmPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp");
		return;
	}
	
	String msg = null;
	//비밀번호 수정 폼에서 입력한 값들을 서버로 전송하여 처리
	String currentPw = request.getParameter("currentPw");
	String newPw = request.getParameter("newPw");
	String confirmPw = request.getParameter("confirmPw");
	
	//---------------------------Model Layer-----------------------------------
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//현재 비밀번호가 맞는지 확인하는 코드
	String memberId = (String) session.getAttribute("loginMemberId");
	String checkPwSql = "SELECT member_pw FROM MEMBER WHERE member_id=? AND member_pw = PASSWORD(?)";
	PreparedStatement checkPwStmt = conn.prepareStatement(checkPwSql);
	checkPwStmt.setString(1, memberId);
	checkPwStmt.setString(2, currentPw);
	ResultSet checkPwRs = checkPwStmt.executeQuery();
	System.out.println(checkPwStmt + " <--updateMemberAction param checkPwStmt");
	
	if (checkPwRs.next()) {
	/*  
	 // 암호화 메소드 사용필요
	 String dbPw = checkPwRs.getString("member_pw");
	 if (!dbPw.equals(currentPw)) {
	     // 현재 비밀번호가 맞지 않는 경우
		msg = URLEncoder.encode("현재 비밀번호가 다릅니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
		return;
	 } else 
	*/ 
	if (!newPw.equals(confirmPw)) {
         // 새 비밀번호와 새 비밀번호 확인 값이 일치하지 않는 경우
		msg = URLEncoder.encode("변경할 비밀번호와 확인값이 서로 다릅니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
		return;
     } else {
        // 새 비밀번호와 새 비밀번호 확인 값이 일치하는 경우
        String updatePwSql = "UPDATE MEMBER SET member_pw = PASSWORD(?) WHERE member_id=?";
        PreparedStatement updatePwStmt = conn.prepareStatement(updatePwSql);
        updatePwStmt.setString(1, newPw);
        updatePwStmt.setString(2, memberId);
        updatePwStmt.executeUpdate();
        System.out.println(updatePwStmt + " <--updateMemberAction param updatePwStmt");
        
  		msg = URLEncoder.encode("비밀번호가 변경되었습니다.", "utf-8");
  		System.out.println("password changed successfully");
  		response.sendRedirect(request.getContextPath()+"/member/myPage.jsp?msg="+msg);
     	}
	}
%>