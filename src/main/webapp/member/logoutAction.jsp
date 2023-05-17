<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 기존 세션을 지우고 갱신
	// response.sendRedirect경우 클라이언트를 측에 요청을 함 -> request.getContextPath()
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>
