<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<html>
<head>
    <meta charset="UTF-8"/>
</head>
<body>
<%
    /*
    * 이 페이지는 EUC-KR로 설정된 서버를 위한 search.jsp 입니다.
    * 톰캣 서버가 EUC-KR 환경일 경우 이곳으로 값을 보낼 때 꼭 POST로 보내주세요!
    * 그렇지 않으면 한글값이 깨져서 제대로 된 값을 불러오지 못합니다.
    * 이곳으로 값을 보내는 form의 속성값으로 method="post" accept-charset="UTF-8" 를 꼭 추가해 주세요.
    * accept-charset="UTF-8"은 form의 가장 마지막에 선언되어야 합니다.
    * */

    String searchEngineAddress = "localhost";
    String searchEnginePort= "9090";

    /*
    * get 방식으로 파라미터를 보낼 경우 setCharacterEncoding으로 인코딩을 하지 못합니다.
    * 이럴 경우 톰캣 서버 설정을 바꾸는 수밖에 없습니다.
    * */
    request.setCharacterEncoding("UTF-8");

    /*
    * 검색쿼리용 파라미터
    * cn : 컬렉션 아이디
    * se : 검색
    * fl : 결과값으로 받을 필드명들
    * sn : 결과값으로 읽기 시작할 값 순서 (1이면 처음부터 읽어온다는 뜻)
    * ln : 출력할 결과값 개수
    * */
    String cn = request.getParameter("cn") == null ?  "ac" : request.getParameter("cn");
    String se = request.getParameter("se") == null ?  "" : request.getParameter("se");
    String fl = request.getParameter("fl") == null ?  "id,term,prefix,_score_" : request.getParameter("fl");
    String sn = request.getParameter("sn") == null ?  "1" : request.getParameter("sn");
    String ln = request.getParameter("ln") == null ?  "10" : request.getParameter("ln");

    /*
    * UTF-8로 값을 받아와도 URLEncoder를 통해 인코딩을 해주지 않으면 검색엔진에서 한글 값을 깨진 상태로 받아 결과값이 제대로 나오지 않습니다.
    * */
    se = URLEncoder.encode(se,"utf8");
    String urlStr = "http://" + searchEngineAddress +":" + searchEnginePort + "/search/json?" + "cn=" + cn + "&se=" + se + "&fl=" + fl + "&sn=" + sn + "&ln=" + ln;

    URL url = new URL(urlStr);
    BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
    String s = "";
    StringBuilder sb = new StringBuilder("");

    /*
    * 한줄씩 읽어오고 맨 마지막에 print 출력
    * */
    while ((s = br.readLine()) != null) {
        sb.append(s + "\n");
    }

    out.print(sb.toString());
%>
</body>
</html>