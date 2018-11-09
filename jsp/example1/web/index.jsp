<%--
  Created by IntelliJ IDEA.
  User: JJH
  Date: 2015-07-09
  Time: 오전 10:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="commons.jsp" %>

<%
  /* 검색한 키워드 받아서 인코딩 후 변수에 저장 */
  String searchStr_restore = request.getParameter("searchStr"); //검색데이터
  String prevStr_restore = request.getParameter("prev"); //이전데이터
  if(searchStr_restore==null||searchStr_restore.equals("")){
    searchStr_restore="";
  } //null로 들어오면 ""처리
  if(prevStr_restore==null||prevStr_restore.equals("")){
    prevStr_restore="";
  } //null로 들어오면 ""처리
  String searchStr = new String(searchStr_restore.getBytes("8859_1"), "UTF-8").trim();
  String prevStr = new String(prevStr_restore.getBytes("8859_1"), "UTF-8").trim();
  /* 검색을 하고 검색결과를 받는다 */
  JSONObject searchResult = searchData("test","P_NO,P_NAME,PRICE,THUMB,CATE1,CATE2,CATE3,REFERRER","P_NAME",searchStr,1,80);
  JSONArray resultBody = searchResult.optJSONArray("result");

  /* 검색 정보를 통계서버로 보낸다 */

  //카운트가 1이상일때(결과값이 1개 이상)
  if(!(searchResult.optString("total_count").equals("0"))){
    /* 통계데이터 생성*/
    String siteId="adlib";
    String categoryId=""; //맞는지 확인
    String searchService="totalSearch";
    String keyword=searchStr;
    String prev=prevStr;//이전검색어 저장용 데이터 필요
    String resptime=searchResult.optString("time").substring(0,searchResult.optString("time").length()-3);
    String category=e("의류"); //의류 임의설정
    String pageValue="1";
    String sort="";
    String service=e("통합검색");
    String login=e("비로그인");
    String age;
    if(request.getParameter("age")!=null) { //테스트를 위해 값이 없으면 30대로 설정
      age = request.getParameter("age")+e("대");
    }else{
      age = e("30대");
    }
    String gender;
    if(request.getParameter("gender")!=null) { //테스트를 위해 값이 없으면 남자로 설정
      gender= e(new String(request.getParameter("gender").getBytes("8859_1"), "UTF-8"));
    }else{
      gender = e("남자");
    }

    if(!(searchStr.equals("")))
      sendSearchData(siteId,categoryId,searchService,keyword,prev,resptime,category,pageValue,sort,service,login,age,gender);
  }

  /* 인기검색어 정보를 받는다 */
  JSONObject popularKeywordSource=  getPopularKeyword("adlib", "");
  JSONArray popularKeywordData = popularKeywordSource.optJSONArray("list");

  /* 페이지 네비게이터 정보를 가져온다 */
  int cpage;
  String check_parameter_cpage = request.getParameter("cpage");
  if(check_parameter_cpage==null) {
    cpage = 1; //null로 들어오면 ""처리
  } else {
    cpage = Integer.parseInt(request.getParameter("cpage"));
  }
  PageNavigator pn = new PageNavigator(8,10);
  pn.setTotal(resultBody.length());
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Fastcatsearch JSP 페이지</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="css/template_style.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
  <style type="text/css">
    .bs-example{
      margin: 20px;
    }
  </style>

  <link rel="stylesheet" type="text/css" href="fdw-demo.css" media="all" />
  <link href='http://fonts.googleapis.com/css?family=Open+Sans+Condensed:700' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" type="text/css" href="style.css">

  <script type="text/javascript" src="js/jquery-hover-effect.js"></script>
  <script type="text/javascript">
    //Image Hover
    jQuery(document).ready(function(){
      jQuery(function() {
        jQuery('ul.da-thumbs > li').hoverdir();
      });
    });
  </script>
  <script src="js/jquery.bxslider.js"></script>
  <link href="css/jquery.bxslider.css" rel="stylesheet" />

</head>
<body>


<div style="padding-top:30px;">
  <table style="width:100%;text-align:center;" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td style="width:270px;"><img src="images/left_image.png"></td>
      <td><img src="images/logo.png"></td>
      <td style="width:100px;">로그인</td>
      <td style="width:100px;">회원가입</td>
      <td style="width:100px;"><i class="glyphicon glyphicon-book" style="vertical-align: middle;font-size:10pt;font-weight:bold;"></i> <span style="vertical-align: middle;">쿠폰북</span></td>
      <td style="width:100px;"><i class="glyphicon glyphicon-star" style="vertical-align: middle;font-size:10pt;font-weight:bold;"></i> <span style="vertical-align: middle;">관심쇼핑몰</span></td></td>
      <td style="width:100px;"><i class="glyphicon glyphicon-heart" style="vertical-align: middle;font-size:10pt;font-weight:bold;"></i> <span style="vertical-align: middle;">관심상품</span></td></td>
    </tr>
  </table>
</div>
<div class="bs-example">
  <nav role="navigation" class="navbar navbar-default">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" data-target="#navbarCollapse" data-toggle="collapse" class="navbar-toggle">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>
    <!-- Collection of nav links, forms, and other content for toggling -->
    <div id="navbarCollapse" class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
        <li><a href="#"><span class="glyphicon glyphicon-home" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">홈으로</span></a></li>
        <li class="active"><a href="#"><span class="glyphicon glyphicon-eye-open" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">할인쇼핑</span></a></li>
        <li class="dropdown">
          <a data-toggle="dropdown" class="dropdown-toggle " href="#"><span class="glyphicon glyphicon-tag" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">여성상품</span> <b class="caret"></b></a>
          <ul role="menu" class="dropdown-menu">
            <li><a href="#">여성상품하위1</a></li>
            <li><a href="#">여성상품하위1</a></li>
            <li><a href="#">여성상품하위1</a></li>
          </ul>
        </li>
        <li><a href="#"><span class="glyphicon glyphicon-bookmark" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">여성샵 순위</span></a></li>
        <li><a href="#"><span class="glyphicon glyphicon-tag" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">남성상품</span></a></li>
        <li><a href="#"><span class="glyphicon glyphicon-bookmark" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">남성샵 순위</span></a></li>
        <li><a href="#"><span class="glyphicon glyphicon-bookmark" style="vertical-align: middle;"></span> <span style="vertical-align: middle;">브랜드샵 대형몰 순위</span></a></li>
      </ul>
      <div style="float:right;">
        <form role="search" class="navbar-form navbar-left">
          <table>
            <tr>
              <td><input type="text" ID="searchLayerTrigger" placeholder="검색어를 입력해주세요." class="form-control" onclick="popup()"></td>
              <td><button type="button" class="btn glyphicon glyphicon-search"></button></td>
            </tr>
          </table>
        </form>
      </div>
    </div>
  </nav>
</div>
<div class="bs-example">
  <!-- Modal HTML -->
  <div id="myModal" class="modal fade" style="padding-top:180px;">
    <div class="modal-dialog" style="width:950px;">
      <div class="modal-content" style="width:950px;">
        <div class="modal-header" style="height:45px;">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        </div>
        <div class="modal-body">
          <table style="width:100%;" border="0">
            <tr>
              <td colspan="2" style="text-align:center;">
                <form name="product_search" id="product_search" role="search2" class="navbar-form navbar-left" style="width:100%;" method="get">
                  <table border="0" style="text-align:center;margin:auto;">
                    <tr>
                      <td>

                        <%if(searchResult.optString("total_count").equals("0")){ //검색어의 데이터가 0개인 경우 이전 검색어로 포함시키지 않음
                          searchStr="";
                        }%>
                        <input type="hidden" name="prev" value="<%=searchStr%>">
                        <input type="text" name="searchStr" id="searchStr" placeholder="상품명을 입력해 주세요" class="form-control" style="width:500px;" value="<%=searchStr%>" autocomplete=off>
                        <div id="autoComplete-layer"></div>
                        <script type="text/javascript">

                          $(document).ready(function() {

                            $("#searchStr").on({

                              "keyup" : function() {

                                var searchKeyword = $("#searchStr").val();

                                if (!searchKeyword) {
                                  $("#autoComplete-layer").hide();
                                } else {

                                  if (event.keyCode != '38' && event.keyCode != '40') {

                                    if (searchKeyword!='') {

                                      $.ajax({
                                        url : "autoComplete.jsp",
                                        type : "get",
                                        data : {
                                          search_keyword:searchKeyword
                                        },
                                        dataType : "text",
                                        success : function(html) {
                                          if (html != null) {
                                            $("#autoComplete-layer").html(html).show();
                                            $(".check_autocomplete_result_is_0").parent().hide();
                                          }
                                        },
                                        error : function(request, status, error) {
                                        }
                                      });
                                    }
                                  } else if (event.keyCode == '38') {
                                    if ($(".autoComplete-keyword").hasClass("selected") == false) {
                                      var select_keyword = $(".autoComplete-keyword").last().addClass("selected").text().trim();
                                      if (select_keyword != '') {
                                        $("#searchStr").val(select_keyword);
                                      }
                                    } else if ($(".autoComplete-keyword").hasClass("selected")) {
                                      var select_keyword = $(".selected").removeClass("selected").prev().addClass("selected").text().trim();
                                      if (select_keyword != '') {
                                        $("#searchStr").val(select_keyword);
                                      }
                                    }
                                  } else if (event.keyCode == '40') {
                                    if ($(".autoComplete-keyword").hasClass("selected") == false) {
                                      var select_keyword = $("#keyword-0").addClass("selected").text().trim();
                                      if (select_keyword != '') {
                                        $("#searchStr").val(select_keyword);
                                      }
                                    } else if ($(".autoComplete-keyword").hasClass("selected")) {
                                      var select_keyword = $(".selected").removeClass("selected").next().addClass("selected").text().trim();
                                      if (select_keyword != '') {
                                        $("#searchStr").val(select_keyword);
                                      }
                                    }
                                  }
                                }
                              },

                              "focus" : function(){

                                var searchKeyword = $("#searchStr").val();

                                if (!searchKeyword) {
                                  $("#autoComplete-layer").hide();
                                } else {
                                  $.ajax({
                                    url : "autoComplete.jsp",
                                    type : "get",
                                    data : {
                                      search_keyword:searchKeyword
                                    },
                                    dataType : "text",
                                    success : function(html) {
                                      if (html != null) {
                                        $("#autoComplete-layer").html(html).show();
                                        $(".check_autocomplete_result_is_0").parent().hide();
                                      }
                                    },
                                    error : function(request, status, error) {
                                    }
                                  });
                                }
                              },

                              "focusout" : function() {
                                if ($(".autoComplete-keyword").hasClass("selected") == false) {
                                  $("#autoComplete-layer").hide();
                                }
                              }
                            });
                          });
                        </script>
                        <!-- AJAX를 이용하여 자동완성 리스트 불러오기 끝 -->
                      </td>
                      <td>
                        <button type="button" class="btn btn-primary">
                          <i class="glyphicon glyphicon-search" style="vertical-align: middle;"></i>
                          <span style="vertical-align: middle;">검색</span>
                        </button>
                      </td>
                    </tr>
                  </table>
                </form>
                <script type="text/javascript">
                  $(document).ready(function()
                  {
                    $(".btn").click(function()
                    {
                      $("#product_search").submit();
                    });
                  });
                </script>
              </td>
            </tr>
            <tr>
              <td style="width:780px;font-size:10pt;font-weight:bold;padding-top:30px;vertical-align:bottom;">추천상품</td>
              <td style="width:170px;font-size:10pt;font-weight:bold;vertical-align:bottom;">실시간 인기상품</td>
            </tr>
            <tr>
              <td rowspan="2" style="text-align:center;">
                <div id="container">
                  <div class="freshdesignweb">
                    <%if(!(searchResult.optString("total_count").equals("0"))){%>
                    <ul class="bxslider">
                      <!-- 한 개 시작 -->
                      <% for (int list_count = 0; list_count < resultBody.length(); list_count++) { %>
                      <% JSONObject item = resultBody.optJSONObject(list_count);%>
                      <% if (list_count%8 == 0) { %> <!-- 한페이지 시작 --> <li><div class="image_grid portfolio_4col"><% } %>
                      <% if (list_count%4 == 0) { %> <!-- 한 줄 시작 --> <ul style="height: 140px;" id="list" class="portfolio_list da-thumbs"><% } %>
                        <li>
                          <%
                            String testString="";
                            if(!(item.optString("THUMB").equals(""))) {
                              testString = item.optString("THUMB").substring(item.optString("THUMB").length() - 3, item.optString("THUMB").length());
                            }
                            if(testString!=null)
                              if((testString.equals("jpg")||testString.equals("png"))){
                                testString=item.optString("THUMB");
                              }else{
                                testString="images/noimage.jpg";
                              }%>
                          <img src="<%=testString%>" alt="img" width="175px;" title="<%=item.optString("P_NAME")%>">
                          <article class="da-animate da-slideFromRight" style="display: block;">
                            <h3 style="color:red;"><%=item.optString("P_NAME")%></h3>
                            <em><%=item.optString("CATE1")%><% if (item.optString("CATE2") != null) { %> / <%=item.optString("CATE2")%><% } if (item.optString("CATE3") != null) { %> / <%=item.optString("CATE3")%><% } %></em>
                            <em><span style="font-size:10pt;"><%=item.optString("PRICE")%>원</span>&nbsp; <span style="text-decoration:line-through;font-size:8pt;"><%=(int)(Integer.parseInt(item.optString("PRICE"))*1.1)%>원</span></em>
                            <span class="link_post" onclick="makeUrl('adlib','<%=item.optString("P_NAME")%>','<%=item.optString("P_NO")%>','clothes')"> <a href="http://www.cocoblack.kr/shop/shopdetail.html?branduid=<%=item.optString("P_NO")%>"></a></span>
                            <span class="zoom"><a href="<%=testString%>"></a></span>
                          </article>
                        </li>
                        <% if (list_count%4 == 3) { %></ul><% } %>
                      <% if (list_count%8 == 7) { %></div></li><% } %>
                      <% if (list_count+1 == resultBody.length()) { %>
                    </ul></div></li>
                  <% } %>
                  <% } %>
                  </ul>
                </div>
                <div id="bx-pager">
                  <% for (int pageInx = pn.startPage(cpage); pageInx <= pn.endPage(cpage); pageInx++) { %>
                  <% if (pageInx == cpage) { %>
                                    <span id="page<%=pageInx-1%>" class="selected-page" style="display:inline-block;cursor:pointer;cursor:hand"><a class="bx-pager-link" data-slide-index="<%=pageInx-1%>" ><%=pageInx%>
                                    </a></span>
                  <% } else { %>
                                    <span id="page<%=pageInx-1%>" style="display:inline-block;cursor:pointer;cursor:hand"><a class="bx-pager-link" data-slide-index="<%=pageInx-1%>"><%=pageInx%>
                                    </a></span>
                  <% } %>
                  <% }}else if (searchStr.equals("")){ %>
                  검색어를 입력해주세요.
                  <%
                  }else{ %>
                  <b>'<%=searchStr%>'</b>에 대한 검색결과가 없습니다. <br>검색어가 올바른지 확인하시거나 다른 검색어로 재검색 해주세요.
                  <%
                    } %>
                </div>
        </div>
        </td>
        <td style="width:170px;height:218px;vertical-align:top;padding-top:10px;">
          <table cellpadding="0" cellspacing="0" border="0" style="text-align:center;">
            <% for (int poplist_count = 0; poplist_count < popularKeywordData.length(); poplist_count++) { %>
            <tr>
              <td style="width:20px;"><img src="images/num/<%=poplist_count+1%>.png"></td>
              <td style="width:150px;text-align:left;padding-left:5px;font-size:10pt;"><a href="javascript:;" onclick="getPopularKeyword('<%=popularKeywordData.getJSONObject(poplist_count).getString("word")%>')"><%=popularKeywordData.getJSONObject(poplist_count).getString("word")%></a></td>
            </tr>
            <% } %>
          </table>
        </td>
        </tr>
        <tr>
          <td style="vertical-algin:top;height:230px;"><img src="images/2.png" style="width:170px;height:228px;"></td>
        </tr>
        <tr>
          <td colspan="2" style="height:50px;"></td>
        </tr>
        </table>
      </div>
    </div>
  </div>
</div>
</div>
<!--나중에 검색결과없을 시 로딩하지 않도록-->
<script type="text/javascript">
  $(document).ready(function(){
    $('.bxslider').bxSlider({
      pager: true,
      //captions:true
      pagerCustom: '#bx-pager'
    });
  });
  $("#myModal").modal('show');
</script>
<script>
  function popup(){
    $("#myModal").modal('show');
    $("#searchStr").focus();
  }

  function makeUrl(siteId,keyword,clickId,clickType){
    makeRequest("http://10.0.1.202:8050/service/ctr/click/post?"+"siteId="+siteId+"&keyword="+encodeURI(keyword)+"&clickId="+clickId+"&clickType="+clickType)
  }
  function makeRequest(url) {
    if (window.XMLHttpRequest) { // Mozilla, Safari, ...
      httpRequest = new XMLHttpRequest();
    } else if (window.ActiveXObject) { // IE
      try {
        httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
      }
      catch (e) {
        try {
          httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (e) {}
      }
    }

    if (!httpRequest) {
      return false;
    }
    httpRequest.onreadystatechange = alertContents;
    httpRequest.open('GET', url);
    httpRequest.send();
  }

  function alertContents() {
    if (httpRequest.readyState === 4) {
      if (httpRequest.status === 200) {
      } else {
      }
    }
  }

  function getPopularKeyword(keyword) {
    $('#searchStr').val(keyword.trim());
    $('#product_search').submit();
  }
</script>
</body>
</html>