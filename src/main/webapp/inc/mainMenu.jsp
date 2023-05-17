<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="./style.css" type="text/css" rel="stylesheet">
 <!-- Core CSS -->
 <link rel="stylesheet" href="./Resources/assets/vendor/css/core.css" class="template-customizer-core-css" />
 <link rel="stylesheet" href="./Resources/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
 <link rel="stylesheet" href="./Resources/assets/css/demo.css" />
<div>
	<ul>
		<!-- css로 변경 or <span>태그 사용해서 세로로 변경 -->
		<li><a href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<li><a href="<%=request.getContextPath()%>/local/localList.jsp">지역리스트</a></li>
		<!-- 
			로그인전 : 회원가입
			로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId)
		-->
		
		<%
			// 로그인전에 나타나는 메뉴
			if(session.getAttribute("loginMemberId") == null) {
		%>
				<li><a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
		<% 
			} else { // 로그인후에 나타나는 메뉴
		%>
				<li><a href="<%=request.getContextPath()%>/member/myPage.jsp">회원정보</a></li>
				<li><a href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
		<% 
			}
		%>
	</ul>
</div>