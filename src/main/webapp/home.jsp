<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%	
	//----------------------------controller layer-------------------------
	// 인코딩 코드
	request.setCharacterEncoding("utf-8");
	
	// 1) 요청분석(컨트롤러 계층)
	// 1) session JSP 내장(기본)객체 -> 만들지 않아도 나중에 JAVA코드에 합쳐진다. 
	
	// 2) request / response JSP내장(기본)객체
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	int startRow = (currentPage-1)*rowPerPage;
	if(request.getParameter("startRow") != null) {
		startRow = Integer.parseInt(request.getParameter("startRow"));
	}
	
	String localName = "전체";
	if(request.getParameter("localName") != null) {
		localName = request.getParameter("localName");
	}
	
	 // 디버깅
	System.out.println(localName+"<-- home param localName"); 
	
	 // 2) 게시판 목록 결과셋(모델)
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	Connection conn = null;
	
	//---------------------------Model layer----------------------------
	//DB연결 ,모델값을 한곳에 모아서 구한다.
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 서브메뉴 모델셋
	// 집합 연산(UNION ALL)을 사용하여 전체 카테고리와 각 지역별 카테고리를 합쳤다.(local_name의 행수 출력)
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board " 
	+ " UNION ALL SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	
	// subMenuList <-- 모델데이터로 이후 view단에서 사용한다.
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	// 보드 메뉴 모델셋
	String boardSql = "";
	if(localName.equals("전체")) {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate" 
		+ " From board ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, startRow);
		boardStmt.setInt(2, rowPerPage);
	} else {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate" 
		+ " From board WHERE local_name = ? ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);
		boardStmt.setInt(2, startRow);
		boardStmt.setInt(3, rowPerPage);
	}
	// DB쿼리 결과셋 모델
	boardRs = boardStmt.executeQuery(); 
	
	// 어플리케이션에서 사용할 모델(사이즈 O)
	ArrayList<Board> boardList = new ArrayList<Board>(); 
	// boardRs --> boardList
	// Board b = new Board(); // while문 밖에 선언시 동일한 b에 리스트의 내용이 계속 덮어씌워져서 ArrayList로서의 기능을 하지 못하게 된다.
	while(boardRs.next()) {
		Board b = new Board();
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	// ArrayList에 들어간 값 확인
	System.out.println(boardList.size()+"home boardList.size()");
	
	// 마지막 페이지를 구하는 모델셋
	PreparedStatement cntStmt = 
	conn.prepareStatement("SELECT COUNT(*) FROM board  WHERE local_name = ?");
	
	if(localName.equals("전체")) {
		cntStmt = conn.prepareStatement("SELECT COUNT(*) FROM board");
	} else {
		cntStmt.setString(1, localName);
	} 
	
	ResultSet cntRs = cntStmt.executeQuery();
	int totalRow = 0;
	if(cntRs.next()) {
		totalRow = cntRs.getInt("COUNT(*)");
		
		System.out.println(totalRow + "<-- home totalRow"); 
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0 ) {
		lastPage = lastPage+1;
	}
	System.out.println(lastPage + "<-- home lastPage"); 
	
	// 페이지에 10개의 링크가 출력되도록 함 
 	int pageBlock = 10;
 	int startPage = ((currentPage-1)/pageBlock)*pageBlock+1;
 	int endPage = startPage + pageBlock -1;
 	if(endPage > lastPage) {
  		endPage = lastPage;
  	}
 	//--------------------Veiw Layer---------------------------------
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
	<link href="./style.css" type="text/css" rel="stylesheet">
	<!-- Core CSS -->
    <link rel="stylesheet" href="./Resources/assets/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="./Resources/assets/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="./Resources/assets/css/demo.css" />
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
	           <div class="col-lg-8 mb-4 order-0">
	             <div class="card">
	               <div class="d-flex align-items-end row">
	                 <div class="col-sm-12">
	                   <div class="card-body">
	                   	<img src="./home.jpg" alt="travle" class="img-fluid">	
	                   </div>
	                </div>
	             </div>
	           </div>
	         </div>
	         <div class="col-lg-4 mb-4 order-0">
	             <div class="card">
	              <div class="card-header-tabs">
			       <h3 class="card-title center"></h3>
			      </div>
	               <div class="d-flex align-items-end row">
	                 <div class="col-sm-12">
	                   <div class="card-body">
	                   	<!-- home 내용 : 로그인폼(세션에 id가 null일 경우 출력)-->
							<!-- 로그인 폼 -->
							<%
								if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
							%>
									<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
										<table>
											<tr>
												<td>아이디</td>
												<td><input type="text" name="memberId"></td>
											</tr>
											<tr>
												<td>비밀번호</td>
												<td><input type="password" name="memberPw"></td>
											</tr>
										</table>
										<button type="submit">로그인</button>
									</form>
							<%
								} else {
							%>  
									<div class="center">
										<H3><%=session.getAttribute("loginMemberId")%>님이 접속중입니다.</H3>
									</div>
							<%
								}
							%>
	                   </div>
	               	 </div>
	             </div>
	           </div>
	         </div>
	         <div class="row">
	           <!-- Order Statistics -->
	           <div class="col-md-9 col-lg-6 col-xl-6 order-0 mb-4">
	             <div class="card h-100">
	               <div class="card-body">
	               	 <!---------[시작] boardList(각 지역별 게시글 내용 10개 출력) ------------------------->
					<div>
						<table class="table text-center left">
							<tr>
								<th>지역이름</th>
								<th>제목</th>
								<th>생성날짜</th>
							</tr>
							<%
									for(Board b : boardList) {
							%> 
							<!-- 사용시 외부라이브러리(JSTL) 필요 <c:foreach var="b" items="boardList"> -->
									<tr>
										<td><%=b.getLocalName()%></td>
										<td>
											<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
												<%=b.getBoardTitle()%>
											</a>
										</td>
										<td><%=b.getCreatedate().substring(0, 10)%></td>
									</tr>
								<!-- </c:foreach> -->
							<%
									}
							%>
						</table>
						<!-- 페이지 네비게이션 -->	
						<div class="text-center">
							<%
								if(currentPage > 1) {
							%>	
								<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage-1%>&rowPerPage=<%=rowPerPage%>&localName=<%=localName%>">이전</a>
							<%
								}
							%>
							
							<% 
								// 페이지 번호를 출력하고 출력페이지를 강조함
								// startPage, endPage를 이용해서 출력 페이지 번호의 범위를 지정하고 페이지를 for문을 이용하여 출력한다.
								for (int i = startPage; i <= endPage; i++) {
									// 현재 페이지 번호와 같은 페이지 번호일경우 해당 페이지번호를 강조
									if(i == currentPage) {		
							%>
										<strong><%=i%></strong>
							<% 
									// 현재 페이지와 다른 페이지인경우 해당 페이지로 이동할 수 있는 링크를 출력한다.
									} else {
							%>
										<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>&localName=<%=localName%>"><%=i%></a>
							<% 		
										}
								}
							%>
							
							<%
								if(currentPage < lastPage) {
							%>
								<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage+1%>&rowPerPage=<%=rowPerPage%>&localName=<%=localName%>">다음</a>
							<%
								}
							%>
						</div>
					</div>
					<!---------[끝] boardList------------------------------------------------------>
	               </div>
	             </div>
	           </div>
	           <div class="col-md-3 col-lg-2 col-xl-2 order-1 mb-4">
	             <div class="card h-100">
	               <div class="card-body cate-list">
	               	<table>
	               		<%
							/* HashMap은 기본적으로 캡슐화가 내장되어있다.*/
							for(HashMap<String, Object> m : subMenuList) {
						%>
						 <tr>
					        <td><%= (String)m.get("localName") %></td>
					        <td>
					          <a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
					            <%=(Integer)m.get("cnt")%>
					          </a>
					        </td>
					      </tr>
						<%
							}
						%>
					</table>
	               </div>
	             </div>
	           </div>
	           <!--/ Order Statistics -->
	         </div>
	       </div>
	       <!-- / Content -->
			<!-- 프로젝트 이력 -->
		   <div>
				<div>
					게시판 프로젝트
				</div>
				<br>
				<div>
					개발 기간 : 2023.05.02 ~ 2023.05.15
				</div>
				<br>
				<div>
					개발 환경 및 라이브러리
				</div>
				<br>
				<div>
					JDK 17, HTML, CSS, HeidiSQL, Maria DB(10.5), Eclipse(22-12), Bootstrap5, JSP, JDBC
				</div>
				<br>
				<div>
					[구현기능] <br> 1. 페이징(10페이지 단위)  <br> 
					2. 회원가입, 게시글, 카테고리 CRUD기능 구현 <br> 
					3. 로그인/로그아웃 기능 구현(Session 기능) <br> 
					4. 댓글은 1:N 구조로 하나의 게시글에 여러개의 댓글이 달리는 구조 <br>
				</div>
		   </div>
		   <br>
		   <!-- / 프로젝트 이력 -->
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