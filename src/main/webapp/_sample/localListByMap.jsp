<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// SQL문 적용 - DB에 없는 데이터값을 마리아DB에서 따로 생성해서 넣어줌.
	/* 
		SELECT local_name localName, '대한민국' country, '박성환' worker 
		FROM local LIMIT 0, 1;
	*/
	String sql = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local LIMIT 0, 1";	
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	// 담을 vo타입이 없음. -> HashMap타입을 사용, HashMap은 하나의 행을 담을 수 있다.
	// Object 타입은 모든 참조형의 데이터타입이 들어올 수 있다.
	HashMap<String, Object> map = null;
	
	if(rs.next()) {
		/* 
		디버깅
		System.out.println(rs.getString("localName"));
		System.out.println(rs.getString("country"));
		System.out.println(rs.getString("worker")); 
		*/
		map = new HashMap<String, Object>();
		// map에 키값과 value을 넣는다.
		map.put("localName", rs.getString("localName"));
		map.put("country", rs.getString("country"));
		map.put("worker", rs.getString("worker"));
	}
	// map에 있는 키값을 출력 - 원칙은 Object를 String값으로 형변환
	System.out.println((String)map.get("localName"));
	System.out.println((String)map.get("country"));
	System.out.println((String)map.get("worker"));
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local";	
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();
	// 반복문이 동작하는 동안에 list에 값을 넣어 사용가능하게 한다.
	while(rs2.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs2.getString("localName"));
		m.put("country", rs2.getString("country"));
		m.put("worker", rs2.getString("worker"));
		list2.add(m);
	}
	
	/* 
	SELECT local_name localName, COUNT(local_name) cnt FROM board
	GROUP BY local_name;
	*/
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";	
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	// 반복문이 동작하는 동안에 list에 값을 넣어 사용가능하게 한다.
	while(rs3.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs3.getString("localName"));
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>localListByMap</title>
</head>
<body>
	<table>
		<tr>
			<th>지역이름</th>
			<th>국가</th>
			<th>작업자명</th>
		</tr>
		<h2>rs2 결과셋</h2>
		<%
			for(HashMap<String, Object> m : list2) {
		%>
			<tr>
				<td><%=m.get("localName")%></td>
				<td><%=m.get("country")%></td>
				<td><%=m.get("worker")%></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<hr>
	<h2>rs3 결과셋</h2>
	<ul>
		<li>
			<a href="">전체</a>
		</li>
		<%
			for(HashMap<String, Object> m : list3) {
		%>
			<li>
				<a href="">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
				</a>
			</li>
		<%
			}
		%>
	</ul>
	
	<hr> <!-- 기본 수평선 -->
	<hr size="2" color="red"> <!-- 크기 2, 색상 빨간색인 수평선 -->
</body>
</html>