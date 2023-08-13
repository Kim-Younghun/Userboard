<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%    
	
	//-----------------------------Controller layer----------------------------
	//요청검사
	
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");
	
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")
		|| request.getParameter("commentNo") == null
		|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	System.out.println(Integer.parseInt(request.getParameter("boardNo")) + " <--modifyComment param boardNo");
	System.out.println(Integer.parseInt(request.getParameter("commentNo")) + " <--modifyComment param commentNo");
	//------------------------------View layer-----------------------------------
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
			       <h3 class="card-title center">댓글수정</h3>
			      </div>
	               <div class="d-flex align-items-end row">
	                 <div class="col-sm-12">
	                   <div class="card-body">
						<!-- Action페이지에서 이벤트 발생시 메세지 표시 -->
						<div>
							<%
								if(request.getParameter("msg") != null){
							%>
									<%=request.getParameter("msg")%>
							<%
								}
							%>
							<%
								// 로그인 사용자만 댓글 수정 허용
								if(session.getAttribute("loginMemberId") != null) {
									// 현재 로그인 사용자의 아이디(형변환 Object -> String)
									String loginMemberId = (String)session.getAttribute("loginMemberId");
							%>
							<!-- 지역리스트(localList)로부터 받은 지역명을 보내서 updateLocalAction의 update sql문에 사용한다. -->
							<form action="<%=request.getContextPath()%>/board/modifyCommentAction.jsp?boardNo=<%=boardNo%>" method="post">
							<!-- 로그인한 정보의 id를 세션에 저장한 뒤 memberId의 변수명으로 저장한다. -->
							<input type="hidden" name="memberId" value="<%=loginMemberId%>">
							<!-- 댓글 번호를 넘긴다. -->
							<input type="hidden" name="commentNo" value="<%=commentNo%>">
								<table>
									<tr>
										<td>댓글수정</td>
										<td>
											<textarea rows="2" cols="30" name="commentContent"></textarea>
										</td>
									</tr>
								</table>
									<button type="submit">댓글수정</button>
							</form>
							<% 		
								}
							%>
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
	</div>
</body>
</html>