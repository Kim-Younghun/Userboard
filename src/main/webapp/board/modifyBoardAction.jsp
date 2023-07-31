<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 확인
	System.out.println(Integer.parseInt(request.getParameter("boardNo"))+ "modifyBoardAction param boardNo");
	System.out.println(request.getParameter("memberId")+ "modifyBoardAction param memberId");
	System.out.println(request.getParameter("dbLocalName")+ "modifyBoardAction param dbLocalName");
	System.out.println(request.getParameter("newLocalName")+ "modifyBoardAction param newLocalName");
	System.out.println(request.getParameter("boardTitle")+ "modifyBoardAction param boardTitle");
	System.out.println(request.getParameter("boardContent")+ "modifyBoardAction param boardContent");
	
	//----------------------------------Controller layer--------------------------------------
	//인코딩을 맞춰서 영어를 제외한 언어가 깨짐을 방지함.
	request.setCharacterEncoding("utf-8");
	
	String msg = null;

	//요청검사
	 if(request.getParameter("memberId") == null
	 		|| request.getParameter("memberId").equals("")
	 		|| request.getParameter("dbLocalName") == null
	 		|| request.getParameter("dbLocalName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	 if(request.getParameter("boardTitle") == null
			|| request.getParameter("boardTitle").equals("")) {
			msg = URLEncoder.encode("수정할 제목을 입력해주세요.", "utf-8");
			response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp?msg="+msg);
			return;
	}
		 
	 if(request.getParameter("boardContent") == null
		|| request.getParameter("boardContent").equals("")) {
		msg = URLEncoder.encode("수정할 내용을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp?msg="+msg);
		return;
	}
	 
	 if(request.getParameter("newLocalName") == null
		|| request.getParameter("newLocalName").equals("")) {
		msg = URLEncoder.encode("수정할 지역명을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp?msg="+msg);
		return;
	}
	 
	// 변수값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String dbLocalName = request.getParameter("dbLocalName"); 
	String newLocalName = request.getParameter("newLocalName"); 
	
	//---------------------------------Model Layer------------------------------------
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.78.47.161:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement modifyBoardStmt = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// board의 지역명을 조회(입력받은 지역명과 일치하는)
	String checkQuery = "SELECT local_name FROM board WHERE local_name = ?";
	PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
	checkStmt.setString(1, newLocalName);
	System.out.println(checkStmt + "modifyBoardAction param checkStmt");
	ResultSet checkRs = checkStmt.executeQuery();
	
	checkRs.next();
	// board에 존재하는 지역명이 입력받은 지역명과 일치할경우
	if(checkRs.next()) {
		// 지역상세 내용을 수정, 선택한 게시글의 내용을 수정
	    String modifyBoardSql = "UPDATE board SET board_title = ?, board_content = ?, member_id = ?, local_name = ?, updatedate = now() WHERE board_no = ?";
	    modifyBoardStmt = conn.prepareStatement(modifyBoardSql);
	    modifyBoardStmt.setString(1, boardTitle);
	    modifyBoardStmt.setString(2, boardContent);
	    modifyBoardStmt.setString(3, memberId);
	    modifyBoardStmt.setString(4, newLocalName);
	    modifyBoardStmt.setInt(5, boardNo);
		System.out.println(modifyBoardStmt + "modifyBoardAction param modifyBoardStmt");
	    int row = modifyBoardStmt.executeUpdate();
	    System.out.println(row + "modifyBoardAction row");
	    if (row == 1) {
	    	System.out.println("지역내용 수정성공");
			response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	    } else {
	    msg = URLEncoder.encode("지역내용 수정에 실패하였습니다.", "utf-8");
	    System.out.println("지역내용 수정실패");
	    response.sendRedirect(request.getContextPath() + "/board/modifyBoard.jsp?msg="+msg);
		}
	} else { // 입력받은 지역명이 board DB상에 존재하지 않는경우
		msg = URLEncoder.encode("존재하는 지역명을 입력해주세요.", "utf-8");
		System.out.println("지역내용 수정실패(없는 지역명)");
	    response.sendRedirect(request.getContextPath() + "/board/modifyBoard.jsp?msg="+msg);
	}
%>