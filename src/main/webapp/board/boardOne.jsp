<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
		//-------------------------controller layer-------------------------
		// 1.요청처리
		//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
		request.setCharacterEncoding("utf-8");
		
		if(request.getParameter("boardNo") == null
				|| request.getParameter("boardNo").equals("")) {
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
		}

		int currentPage = 1;
		if(request.getParameter("currentPage") != null
				&& !request.getParameter("currentPage").equals("")) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		int rowPerPage = 10;
		if(request.getParameter("rowPerPage") != null) {
			rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		}
		int startRow = (currentPage-1)*rowPerPage;
		if(request.getParameter("startRow") != null) {
			startRow = Integer.parseInt(request.getParameter("startRow"));
		}
		
		// 변수값확인
		System.out.println(boardNo + "boardOne boardNo");
		System.out.println(currentPage + "boardOne currentPage");
		System.out.println(rowPerPage + "boardOne rowPerPage");
		System.out.println(startRow + "boardOne startRow");

		//---------------------------model layer---------------------------------
		//DB연결
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
		// 2-1) board one 결과셋
		PreparedStatement boardStmt = null;
		ResultSet boardRs = null;
		String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle,"
				+" board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, boardNo);
		System.out.println(boardStmt + "boardOne boardStmt");
		boardRs = boardStmt.executeQuery();	// row -> 1(board 타입)			
		ArrayList<Board> boardList = new ArrayList<Board>();
		Board b = null;
		if(boardRs.next()) {
			b = new Board();
			/* 
				boardNo = boardRs.getInt("boardNo");
				b.setBoardNo(boardNo); 
			*/
			// 위의 내용을 한줄로 압축
			b.setBoardNo(boardRs.getInt("boardNo"));
			b.setLocalName(boardRs.getString("localName"));
			b.setBoardTitle(boardRs.getString("boardTitle"));
			b.setBoardContent(boardRs.getString("boardContent"));
			b.setMemberId(boardRs.getString("memberId"));
			b.setCreatedate(boardRs.getString("createdate"));
			b.setUpdatedate(boardRs.getString("updatedate"));
			boardList.add(b);
		}
		
		// ArrayList에 들어간 값 확인
		System.out.println(boardList.size() + "boardOne boardList.size()");
		
		// 2-1) comment list 결과셋
		PreparedStatement commentListStmt = null;
		ResultSet commentListRs = null;
		String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent,"
				+" member_id memberId, createdate, updatedate FROM COMMENT WHERE board_no = ? LIMIT ?, ?";
		commentListStmt = conn.prepareStatement(commentListSql);
		commentListStmt.setInt(1, boardNo);
		commentListStmt.setInt(2, startRow);
		commentListStmt.setInt(3, rowPerPage);
		System.out.println(commentListStmt + "boardOne commentListStmt");
		// row -> 최대 10개가 필요 -> ArrayList<Comment>
		commentListRs = commentListStmt.executeQuery();	
		ArrayList<Comment> commentList = new ArrayList<Comment>();
		while(commentListRs.next()) {
			Comment c = new Comment();
			c.setCommentNo(commentListRs.getInt("commentNo"));
			c.setBoardNo(commentListRs.getInt("boardNo"));
			c.setCommentContent(commentListRs.getString("commentContent"));
			c.setMemberId(commentListRs.getString("memberId"));
			c.setCreatedate(commentListRs.getString("createdate"));
			c.setUpdatedate(commentListRs.getString("updatedate"));
			commentList.add(c);
		}
		
		// ArrayList에 들어간 값 확인
		System.out.println(commentList.size() + "boardOne commentList.size()");
		
		// 마지막 페이지 구하기
		int totalCnt = 0;
		int lastPage = 0;
		
		String countSql = "SELECT count(*) cnt FROM comment WHERE board_no = ?";
		PreparedStatement countStmt = conn.prepareStatement(countSql);
		countStmt.setInt(1, boardNo);
		System.out.println(countStmt+"<-- boardOne param countStmt");
		ResultSet countRs = countStmt.executeQuery();
		
		if(countRs.next()) {
			totalCnt = countRs.getInt("cnt");
		}
		
		lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage++;
		}
		//---------------------------------view layer-------------------------------
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
	           <div class="col-lg-12 mb-4 order-0">
	             <div class="card">
	             <div class="card-header-tabs">
			       <h3 class="card-title center">상세정보</h3>
			      </div>
	               <div class="d-flex align-items-end row">
	                 <div class="col-sm-12">
	                   <div class="card-body">
	                   	<!-- 3-1) board one 결과셋(게시글 1개의 상세정보를 출력하는 화면) -->
						<div>
							<table class="table text-center left">
								<tr>
									<td>번호</td>
									<td><%=b.getBoardNo()%></td>
								</tr>
								<tr>
									<td>지역</td>
									<td><%=b.getLocalName()%></td>
								</tr>
								<tr>
									<td>제목</td>
									<td><%=b.getBoardTitle()%></td>
								</tr>
								<tr>
									<td>내용</td>
									<td><%=b.getBoardContent()%></td>
								</tr>
								<tr>
									<td>작성자</td>
									<td><%=b.getMemberId()%></td>
								</tr>
								<tr>
									<td>생성일</td>
									<td><%=b.getCreatedate()%></td>
								</tr>
								<tr>
									<td>수정일</td>
									<td><%=b.getUpdatedate()%></td>
								</tr>
							</table>
						</div>
						<%
							// 로그인 유저만 입력가능
							if(session.getAttribute("loginMemberId") != null) {
								// 현재 로그인 사용자의 아이디(형변환 Object -> String)
								String loginMemberId = (String)session.getAttribute("loginMemberId");
						%>
						<div class="center">
						<%
								// 현재 접속한 사람과 지역글 작성자가 같을경우에만 수정/삭제 링크 표시되도록
								if(loginMemberId.equals(b.getMemberId())) {
						%>
									<a href="<%=request.getContextPath()%>/board/modifyBoard.jsp?boardNo=<%=boardNo%>&memberId=<%=loginMemberId%>&localName=<%=b.getLocalName()%>">수정</a>
									<a href="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=boardNo%>&memberId=<%=loginMemberId%>&localName=<%=b.getLocalName()%>">삭제</a>
						<%
								}
						%>
							<a href="<%=request.getContextPath()%>/board/insertBoard.jsp?memberId=<%=loginMemberId%>&localName=<%=b.getLocalName()%>">입력</a>
						</div>
						<% 		
							}
						%>
						<!-- [끝] 게시글 1개의 상세정보를 출력하는 화면 -->	
	                   </div>
	                </div>
	             </div>
	           </div>
	         </div>
	         <div class="row">
	           <!-- Order Statistics -->
	           <div class="col-md-6 col-lg-4 col-xl-4 order-0 mb-4">
	             <div class="card">
	             <div class="card-header-tabs">
			       <h3 class="card-title center">추가할 댓글을 입력해주세요.</h3>
			      </div>
	               <div class="card-body">
	               	 <!-- 3-2) comment 입력 : 세션유무에 따른 분기 -->
					<%
						// 로그인 사용자만 댓글 입력 허용
						if(session.getAttribute("loginMemberId") != null) {
							// 현재 로그인 사용자의 아이디(형변환 Object -> String)
							String loginMemberId = (String)session.getAttribute("loginMemberId");
					%>
						<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
							<!-- boardNo값 사용 -->
							<input type="hidden" name="boardNo" value="<%=b.getBoardNo()%>"> 
							<!-- 로그인한 정보의 id를 세션에 저장한 뒤 memberId의 변수명으로 저장한다. -->
							<input type="hidden" name="memberId" value="<%=loginMemberId%>">
							<table class="table text-center">
								<tr>
									<th>내용</th>
									<td>
										<textarea rows="2" cols="30" name="commentContent"></textarea>
									</td>
								</tr>
							</table>
							<button type="submit">댓글입력</button>
						</form>
					<% 		
						}
					%>
	               </div>
	             </div>
	           </div>
	           <div class="col-md-6 col-lg-8 col-xl-8 order-0 mb-4">
	             <div class="card ">
	               <div class="card-body">
	               	<!-- 3-3) comment list 결과셋 -->
	               	<%
						if(request.getParameter("msg") != null){
					%>
							<%=request.getParameter("msg")%>
					<%
						}
					%>
					<table class="table text-center">
						<tr>
							<th>내용</th>
							<th>작성자</th>
							<th>생성날짜</th>
							<th>수정날짜</th>
							<th>수정</th>
							<th>삭제</th>
						</tr>
						<%
							for(Comment c : commentList) {
						%>
							<tr>
								<td><%=c.getCommentContent()%></td>
								<td><%=c.getMemberId()%></td>
								<td><%=c.getCreatedate()%></td>
								<td><%=c.getUpdatedate()%></td>
						<%
								// 현재 접속한 사람과 댓글 작성자가 같을경우에만 수정/삭제 링크 표시되도록
								String loginMemberId = (String)session.getAttribute("loginMemberId");
								if(loginMemberId.equals(c.getMemberId())) {
						%>
								<td>
									<a href="<%=request.getContextPath()%>/board/modifyComment.jsp?boardNo=<%=boardNo%>&commentNo=<%=c.getCommentNo()%>">수정</a>
								</td>
								<td>
									<a href="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?boardNo=<%=boardNo%>&commentNo=<%=c.getCommentNo()%>&memberId=<%=c.getMemberId()%>">삭제</a>
								</td>
						<%
								}
						%>
							</tr>
						<%
							}
						%>
					</table>
					<!-- 페이지 네비게이션 -->
					<div class="center">
						<%
							if(currentPage > 1) {
						%>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">이전</a>
						<%
							}
						%>
							<%=currentPage%>
						<%
							if(currentPage < lastPage) {
						%>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">다음</a>
						<%
							}
						%>
					</div>
	               </div>
	             </div>
	           </div>
	           <!--/ Order Statistics -->
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