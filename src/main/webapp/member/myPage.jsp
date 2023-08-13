<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>   
<%
	//------------------------------Controller layer----------------------------------
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");
	
	//session 유효성 검사 -> 비로그인시 홈으로
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String memberId = (String) session.getAttribute("loginMemberId");
	System.out.println(session.getAttribute("loginMemberId"));
	
	//--------------------------------Model layer----------------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	PreparedStatement myPageStmt = null;
	ResultSet myPageRs = null;
	String myPageSql = "";
	/*  
		SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM MEMBER WHERE member_id
	*/
	// 로그인한 Member 정보를 조회(출력)
	myPageSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ?";
	myPageStmt = conn.prepareStatement(myPageSql);
	myPageStmt.setString(1, memberId);
	System.out.println(myPageStmt + "myPage myPageStmt");
	myPageRs = myPageStmt.executeQuery();
	ArrayList<Member> memberList = new ArrayList<Member>();
	Member m = null;
	if(myPageRs.next()) {
		m = new Member();
		m.setMemberId(myPageRs.getString("memberId"));
		m.setMemberPw(myPageRs.getString("memberPw"));
		m.setCreatedate(myPageRs.getString("createdate"));
		m.setUpdatedate(myPageRs.getString("updatedate"));
		memberList.add(m);
	}
	
	// ArrayList에 들어간 값 확인
	System.out.println(memberList.size() + "myPage memberList.size()");
	
	//------------------------------------View layer-------------------------------------
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"/>
<title>Userboard project</title>
<meta name="description" content="" />
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<link href="../style.css" type="text/css" rel="stylesheet">
	<!-- Core CSS -->
    <link rel="stylesheet" href="../Resources/assets/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="../Resources/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="../Resources/assets/css/demo.css" />
</head>
<body>
	<!-- Layout wrapper -->
	<div class="layout-wrapper layout-content-navbar">
	 <div class="layout-container"> 
	 
	   <!-- Menu -->
	   <aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
	   <div>
	         <span class="app-brand-text demo menu-text fw-bolder ms-5">Userboard</span>
	   </div>
	
	     <ul class="menu-inner py-1">
	       <!-- Dashboard -->
	       <li class="menu-item">
	         <a href="<%=request.getContextPath()%>/home.jsp" class="menu-link">
	           <i class="menu-icon tf-icons bx bx-home-circle"></i>
	           <div>홈으로</div>
	         </a>
	       </li>
	       <li class="menu-item">
	         <a href="<%=request.getContextPath()%>/local/localList.jsp" class="menu-link">
	           <i class="menu-icon tf-icons bx bx-home-circle"></i>
	           <div>지역리스트</div>
	         </a>
	       </li>
	       	<%
			// 로그인전에 나타나는 메뉴
			if(session.getAttribute("loginMemberId") == null) {
			%>
					<li class="menu-item">
			           <a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp" class="menu-link">
			           <i class="menu-icon tf-icons bx bx-home-circle"></i>
			           <div>회원가입</div>
			         </a>
			       </li>
			<% 
			} else { // 로그인후에 나타나는 메뉴
			%>
					<li class="menu-item">
			           <a href="<%=request.getContextPath()%>/member/myPage.jsp" class="menu-link">
			             <i class="menu-icon tf-icons bx bx-home-circle"></i>
			             <div>회원정보</div>
			           </a>
			         </li>
					<li class="menu-item">
			          <a href="<%=request.getContextPath()%>/member/logoutAction.jsp" class="menu-link">
			           	<i class="menu-icon tf-icons bx bx-home-circle"></i>
			           	<div>로그아웃</div>
			          </a>
			       </li>
			<% 
			}
			%>
	     </ul>
	   </aside>
	   <!-- / Menu -->
	   <!-- Layout container -->
	   <div class="layout-page">
	     <!-- Content wrapper -->
	     <div class="content-wrapper">
	       <!-- Content -->
	        <div class="container-xxl flex-grow-1 container-p-y">
	         <div class="row">
	         <div class="col-lg-4 mb-4 order-0">
	             <div class="card">
	               <div class="d-flex align-items-end row">
	                 <div class="col-sm-12">
	                   <div class="card-body">
	                   	<!-- [시작] 회원정보확인 -->
						<header>
							<h1 class="center">회원정보확인</h1>
						</header>
						<%
							if(request.getParameter("msg") != null){
						%>
								<%=request.getParameter("msg")%>
						<%
							}
						%>
						<table class="table table-bordered text-center">
							<tr>
								<td>아이디</td>
								<td><%=m.getMemberId()%></td>
							</tr>
							<tr>
								<td>회원가입일</td>
								<td><%=m.getCreatedate()%></td>
							</tr>
							<tr>
								<td>회원가입정보수정일</td>
								<td><%=m.getUpdatedate()%></td>
							</tr>
						</table>
						<!-- [끝] 회원정보확인 -->
						<!-- 비밀번호 변경, 회원탈퇴 -->
						<div class="center">
							<a href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">비밀번호 변경</a>
							<a href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">회원탈퇴</a>
						</div>
	                   </div>
	               	 </div>
	             </div>
	           </div>
	         </div>
	       </div>
	       <!-- / Content -->
			
	       <!-- Footer -->
	       <footer class="content-footer footer bg-footer-theme">
	         <div class="container-xxl d-flex flex-wrap justify-content-between py-2 flex-md-row flex-column">
	          <div class="mb-2 mb-md-0">
	             Copyright &copy; 구디아카데미
	             <br>
	             ©
	             <script>
	               document.write(new Date().getFullYear());
	             </script>
	             , made with by
	             <a href="https://themeselection.com" target="_blank" class="footer-link fw-bolder">ThemeSelection</a>
	           </div>
	         </div>
	       </footer>
	       <!-- / Footer -->
	
	       <div class="content-backdrop fade"></div>
	     </div>
	     <!-- Content wrapper -->
	   </div>
	   <!-- / Layout page -->
	  </div>
	</div>
	<!-- / Layout wrapper -->
	</div>
</body>
</html>