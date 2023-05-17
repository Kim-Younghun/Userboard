<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//-----------------------Controller layer------------------------
	//session 유효성 검사 -> 로그인된 경우 홈으로 리디렉션
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 다른 페이지로부터 출력 메세지를 받아올 변수 선언
	String msg = request.getParameter("msg");
	//--------------------------View layer----------------------------
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
	              <div class="card-header-tabs">
			       <h3 class="card-title center">회원가입</h3>
			      </div>
	               <div class="d-flex align-items-end row">
	                 <div class="col-sm-12">
	                   <div class="card-body">
	                   	<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
							<table>
								<tr>
									<td>아이디</td>
									<td>
										<input type="text" name="memberId">
										<%
											// 중복 아이디가 있을경우 출력될 메시지
											if(msg != null) {
										%>
											<span><%=msg%></span>
										<%
											}
										%>
									</td>
								</tr>
								<tr>
									<td>비밀번호</td>
									<td><input type="password" name="memberPw"></td>
								</tr>
							</table>
								<button type="submit">회원가입</button>
						</form>
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