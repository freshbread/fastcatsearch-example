<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="
java.text.*,
java.util.Calendar,
java.util.*,
java.text.SimpleDateFormat,
org.json.JSONObject,
org.json.JSONArray
"%>
<% try { %>
<%@ include file="../../commons.jsp" %>
<%
	String[][] collections = { {"news_kor","샘플"}, {"purple_content","게시판"}, {"purple_attach", "첨부파일"} };
	List cfgList = new ArrayList();
	int searchCollection = -1;

	int count = 0;
	int totalCount = 0;
	int maxShowSize = 5;
	int cpage = 0;

	String keyword = getStr(request, "keyword", "");
	String hkeyword = getStr(request, "hkeyword", "");
	String keyworDisp = keyword;
	String category = getStr(request, "category", "");
	String useRange = "";
	String start = "";
	String end = "";
	String stype = getStr(request,"stype","all");
	String otype = getStr(request,"otype","score");
	String interval = getStr(request,"interval","all");
	String sfrom = getStr(request,"sfrom","all");

	cpage = Integer.parseInt(getStr(request,"cpage","1"));

	for(int colinx=0;colinx<collections.length;colinx++) {
		Map cfg = new HashMap();
		cfg.put("cn",collections[colinx][0]);
		cfgList.add(cfg);
		if(collections[colinx][0].equals(sfrom)) {
			searchCollection = colinx;
		}
		cfg.put("out",out);
	}
	PageNavigator pn = new PageNavigator(10,9);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>검색 샘플 페이지</title>
<script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="js/keywordSuggest.js"></script>
<link rel=stylesheet" type="text/css" href="css/keywordSuggest.css">
<script type="text/javascript">
function goPage(page) {
	var df = $("#navForm")[0];
	df.cpage.value = page;
	df.submit();
}

$(document).ready(function() {
	var form = $("#navForm")[0];
	var sortfnc = function() {
		var type = $(this).attr("id").substr(9);
		form.otype.value = type;
		form.cpage.value = "1";
		form.submit();
	};
	$("#btn_sort_score").click(sortfnc);
	$("#btn_sort_date").click(sortfnc);

	var searchfnc = function() {
		var type = $(this).attr("id").substr(9);
		form.stype.value = type;
		form.cpage.value = "1";
		form.submit();
	};
	$("#btn_type_all").click(searchfnc);
	$("#btn_type_title").click(searchfnc);
	$("#btn_type_body").click(searchfnc);
	$("#btn_type_tags").click(searchfnc);

	var intervalfnc = function() {
		var type = $(this).attr("id").substr(13);
		form.interval.value = type;
		form.cpage.value = "1";
		form.submit();
	};

	$("#btn_interval_all").click(intervalfnc);
	$("#btn_interval_1d").click(intervalfnc);
	$("#btn_interval_1w").click(intervalfnc);
	$("#btn_interval_1m").click(intervalfnc);
	$("#btn_interval_1y").click(intervalfnc);

	var searchfromfnc = function() {
		var type = $(this).attr("id").substr(20);
		form.sfrom.value = type;
		form.cpage.value = "1";
		form.submit();
	}

	$("li.search_menu_category").each(function() {
		if($(this).attr("id").indexOf("btn_select_category_")==0) {
			$(this).click(searchfromfnc);
		}
	});

	$("#search_detail").keydown(function(event) {
		if(event.which == 13) {
			var form = $("#navForm")[0];
			form.hkeyword.value = $("#keyword_backup").html();
			form.keyword.value = $(this).val();
			form.cpage.value = "1";
			form.submit();
		}
	});

	$("#input_date_from").click(function() { makeCalendar($(this)[0]); });
	$("#input_date_to").click(function() { makeCalendar($(this)[0]); });
	$("#btn_date_search").click(function() {
		var form = $("#navForm")[0];
		form.interval.value = $("#input_date_from").val()+"~"+$("#input_date_to").val();
		form.cpage.value = "1";
		form.submit();
	});

	$("#input_date_btn").click(function() {
		var element = $("#input_date_body");
		if(element.css("display")=="none") {
			element.removeClass("hidden");
		} else {
			element.addClass("hidden");
		}
	});

	$(".category_goods").click(function() {
		var cateCode = $(this).attr("id").substr(9);
		var form = $("#navForm")[0];
		form.category.value = cateCode;
		form.cpage.value = "1";
		form.submit();
	});


    var enterPressed = function (value){
        //검색을 수행한다.
        $("form[name=searchForm]")[0].submit();
    };

    $("input.search_button").click(function() {
        $("form[name=searchForm]")[0].submit();
    });

    //자동완성 검색결과를 리턴하면 keywordSuggest 라이브러리에서 items를 알아서 뿌려준다.
    var typingSearch = function (value, callback){
        //알아서 리턴.
        value = $.trim(value);

        $.ajax({type:"post",url:"completion.jsp",data:{
            keyword:encodeURI(value),
            sn:1,ln:20
        },dataType:"json",success:function(data) {
            callback({"items":data["list"]});
        },fail:function(data) {
        }});
    };

    $("input[type=radio][name=redate]").click(function() {
        $("form[name=searchForm]")[0].interval.value=$(this).val();
    });

    var clickKeyword = function (obj){
        console.log("## clickKeyword > ", obj, new Date());
    };

    var selectKeyword = function (obj){
        console.log("## selectKeyword > ", obj);
    };


    $("#searchInput").keywordSuggest({
        toggleButtonOffsetX: 340,
        toggleButtonOffsetY: 8,
        toggleButtonOpenImg: 'images/btn_atcmp_up_on.gif',
        toggleButtonCloseImg: 'images/btn_atcmp_down_on.gif',
        dropdownOffsetX : -1,
        dropdownOffsetY : 7,
        enterPressed : enterPressed,
        typingSearch: typingSearch,
        onClickKeyword: clickKeyword,
        onSelectKeyword: selectKeyword
    });
});



</script>
<style type="text/css">
div {
	font-family:Gulim;
}
span.nav {
	cursor:pointer;
}
li.hit_keyword {
	clear:both;padding:2px 0 2px 0;
}
div.hit_keyword_title {
	text-align:center;
	font-size:15px;
	font-weight:bold;
	padding:0 0 10px 0;
}
div.hit_keyword_no {
	float:left;width:18px;border:1px solid #cccccc;
	margin-right:10px;text-align:center;
	vertical-align:middle;
}
div.hit_keyword_str {
	float:left;width:100px;overflow:hidden;text-align:left;
}
div.hit_keyword_rank {
	float:right;width:25px; text-align:center;
	font-size:12px;
}
div.hit_keyword_arrow {
	float:right;width:10px; text-align:center;
	font-size:12px;
}
div.hit_keyword_body {
	border:1px solid #cccccc;width:200px;padding:10px;font-size:13px;float:right;
	background:#ffffff;position:relative;z-index:10;
}
ul.hit_keyword_body {
	position:relative;margin:0;padding:0;list-style-type:none;
}
div.search_box_body {
	float:left;border:5px solid #7dbc20; width:450px;
}
div.clear {
	clear:both;
}
div.float_left {
	float:left;
}
div.float_right {
	float:right;
}
input.search_box_input {
	border:none;width:350px;height:25px;font-size:15px;padding:3px 0 0 3px;
}
div.search_top {
	padding:10px 0 10px 0;
}
div.search_box_btn {
	float:right;position:relative;margin:8px 8px 0 0;font-size:12px;
	color:#7dbc20;cursor:pointer;
	width:8px;
}
input.search_box_submit {
	width:55px;
	height:36px;
	background:#efefef;
	border:2px solid #cccccc;
	font-size:15px;
	font-weight:bold;
	text-align:center;
	padding-top:3px;
	margin:0 0 0 10px;
}

div.search_menu_body {
	width:200px;font-size:13px;float:left
	background:#ffffff;position:absolute;z-index:10;
	height:300px;
	width:200px;
}

body {
	padding:0;margin:0;
}

form {
	padding:0;margin:0;
}

ul.search_menu_category {
	position:relative;margin:0;padding:0;list-style-type:none;
}

li.search_menu_category {
	clear:both;padding:10px 0 10px 15px;
	background:#7dbc20;
	border-bottom:1px solid #3d9005;
	font-size:13px;
	font-weight:bold;
	color:#ffffff;
	cursor:pointer;
}

div.search_menu_bullet {
	float:right;width:10px;position:relative;
	margin-right:15px;
}

div.search_menu_sub {
	border:1px solid #cccccc;
	margin:10px 0 10px 0;
	padding:10px;
}

div.search_menu_label {
}

div.search_menu_item {
	clear:both;
	width:76px;
	border:1px solid #cccccc;
	text-align:center;
	padding:5px;
	margin:5px 0 5px 0;
	cursor:pointer;
}

li.search_menu_item {
	position:relative;
	float:left;
	width:76px;
	border-bottom:1px solid #cccccc;
	border-right:1px solid #cccccc;
	text-align:center;
	padding:5px;
	cursor:pointer;
}

ul.search_menu_group {
	display:table-cell;
	list-style-type:none;
	padding:0;margin:0;
	position:relative;
	border-top:1px solid #cccccc;
	border-left:1px solid #cccccc;
	width:174px;
}

div.search_menu_selected,
li.search_menu_selected {
	background:#efefef;
}

li.search_category_selected {
	background:#ffffff;color:#3d9005;
	border:1px solid #3d9005;
}

hr {
	clear:both;
	padding:0px;margin:0px;
}

div.search_title {
	border-top:1px solid #899567;
	background:#daf1c3;
	height:25px;
	padding:10px 0 0px 20px;
	font-size:14px;
	font-weight:bold;
}

div.search_summary {
	background:#f3f5f0;
	padding:5px 0 5px 10px;
	font-size:12px;
}

span.search_keyword {
	color:#eb5629;
	font-weight:bold;
}

div.result_item_title {
	background:#eff8d9;
	border:0;
	border-top:1px solid #8c956a;
	border-bottom:1px solid #8c956a;
	font-size:13px;
	font-weight:bold;
	padding:10px 0 10px 10px;
	text-decoration:none;
	color:#666666;
}

div.result_item_contents {
	background:#f4f5ef;
	font-size:13px;
	padding:20px
}

div.category_goods {
	float:left;
	padding:5px;
	font-size:12px;
	cursor:pointer;
}

div.result_item_goods {
	border:0;
	border-top:1px solid #8c956a;
	font-size:13px;
	font-weight:bold;
	padding:10px 0 5px 10px;
	text-decoration:none;
	color:#666666;
}

div.result_item_goods_contents {
	font-size:13px;
	padding:0 20px 5px 20px;
}

span.highlight {
	color:#000000;
	font-weight:bold;
}

div.page_title_body {
	background:#7dbc20;
	height:50px;
}

span.keyword_new { font-size:9px;color:red }
div.hit_keyword_up { color:red; }
div.hit_keyword_down { color:blue; }
div.autocompletion_main {
	position:absolute;z-index:11;
}
div.hidden {
	display:none;
}
div.absolute {
	position:absolute;
}
div.autocompletion_body {
	position:relative;top:-10px;left:5px;background:#ffffff;
	border:1px solid #000000;
	width:420px;
	height:200px;
}

div.autocompletion_text {
	font-size:12px;
	padding:5px 10px 5px 10px;
	cursor:pointer;
}

div.autocompletion_title {
	font-size:14px;
	padding:10px;
}

input#search_detail {
	border:2px solid #999999;
	width:170px;
}
div#input_date_body {
	z-index:12;
}

div#input_date_form {
	position:relative;
	background:#ffffff;
	border:2px solid #999999;
	padding:10px;
	font-size:12px;
	width:300px;
}

input#input_date_from,
input#input_date_to {
	border:1px solid #999999;
	width:100px;
}

input#btn_date_search {
	border:1px solid #999999;
}

#search_window {
	padding-left: 298px;
}

.keywordSuggest-dropdown {
    width: 360px;
    min-height: 230px;
    z-index:99;
}
.keywordSuggest-comment {
    width: 360px;
    z-index:99;
}
.keywordSuggest-comment .keywordSuggest-footer {
    width: 360px;
    z-index:99;
}
.keywordSuggest-comment p {
    padding: 4px 9px 9px 10px;
    color: #666;
    z-index:99;
}

.keywordSuggest-keywords {
    width: 200px;
    min-height: 230px;
    margin-right: 7px;
    z-index:99;
}

.keywordSuggest-footer {
    width: 200px;
    background-color: #eee;
    height: 25px;
    z-index:99;
}

.keywordSuggest-footer div {
    margin:5px;
    font-size: 11px;
    z-index:99;
}

.keywordSuggest-footer div a {
    text-decoration: none;
    color: #666;
    float:right;
    z-index:99;
}

.keywordSuggest-result {
    width: 140px;
    text-align: center;
    z-index:99;
}

.green_window {
    display: -moz-inline-block;
    display: -moz-inline-box;
    display: inline-block;
    width: 450px;
    height: 26px;
    margin-right: 5px;
    border: 7px solid #2db400;
    background-color: #fff;
}

.green_window select {
    margin-left:5px;
}

input.search_button {
    width:55px;
    height:36px;
    background:#efefef;
    border:2px solid #cccccc;
    font-size:15px;
    font-weight:bold;
    text-align:center;
}

.clear {
    clear:both;
}

div.result_item_contents table {
    border-collapse:collapse;
    margin:10px;
}

</style>
</head>
<body>
<% JSONObject[] docArray = new JSONObject[cfgList.size()]; %>
<% int[][] cntArray = new int[cfgList.size()][3]; %>
<% for(int colinx=0;colinx<cfgList.size();colinx++) { %>
	<% Map cfg = (Map)cfgList.get(colinx); %>
	<% JSONObject doc = null; %>
	<% int startItem = 1; %>
	<% int lengthItem = 3; %>
	<% if(!"all".equals(sfrom) && searchCollection == colinx) { %>
		<% startItem = (cpage-1) * pn.getRows()+1; %>
		<% lengthItem = pn.getRows(); %>
	<% } %>
<%cfg.put("cn","purple_content");%>
	<% if(colinx==0) { %>
		<% doc = searchSample(cfg,stype,keyword, hkeyword,otype,interval,startItem,lengthItem); %>
	<% } else if(colinx==1) { %>
		<% doc = searchPurple(cfg,stype,keyword, hkeyword,otype,interval,startItem,lengthItem); %>
	<% } else if(colinx==2) { %>
		<% doc = searchAttach(cfg,stype,keyword, hkeyword,otype,interval,startItem,lengthItem); %>
	<% } %>
	<% if ( doc!=null ) { %>
		<% int totalCountLocal = doc.optInt("total_count",0);%>
		<% int countLocal = doc.optInt("count",0);%>
		<% int countTime = doc.optInt("time",0);%>

		<% totalCount += totalCountLocal;  %>
		<% count += countLocal; %>
		<% docArray[colinx]=doc; %>
		<% cntArray[colinx][0] = countLocal; %>
		<% cntArray[colinx][1] = totalCountLocal; %>
		<% cntArray[colinx][2] = countTime; %>
	<% } %>
<% } %>
<div class="page_title_body">&nbsp;</div>
<div id="div_main">
	<form name="searchForm" action="<%=request.getRequestURI()%>" method="post">
		<input type="hidden" name="sfrom" value="<%=sfrom%>"/>
		<input type="hidden" name="cpage" value="1"/>
		<input type="hidden" name="stype" value="<%=stype%>"/>
		<input type="hidden" name="otype" value="<%=otype%>"/>
		<input type="hidden" name="category" value=""/>
		<input type="hidden" name="interval" value="<%=interval%>"/>
		<div class="search_top">
			<span class="green_window">
				<select name="stype">
                    <option <%="all".equals(stype)?"selected":""%> value="all">전체</option>
                    <option <%="subject".equals(stype)?"selected":""%> value="subject">제목</option>
                    <option <%="summary".equals(stype)?"selected":""%> value="summary">작품소개</option>
                    <option <%="content".equals(stype)?"selected":""%> value="content">작품내용</option>
                    <option <%="member".equals(stype)?"selected":""%> value="member">작가</option>
				</select>
				<input id="searchInput" class="keywordSuggest-input" type="text" data-target="#keywordSuggest" name="keyword" value="<%=keyword%>" autocomplete="off"/>
			</span>
			<input type="button" class="search_button" value="검색"/>
            <div id="keywordSuggest" >
                <a href="javascript:void(0)" class="keywordSuggest-toggle" data-toggle="keywordSuggest"><img src="images/btn_atcmp_down_on.gif" style="border:0"></a>
                <div class="keywordSuggest-dropdown">
                    <div class="keywordSuggest-keywords">
                        <ul class="keywordSuggest-list">
                        </ul>   
                        <div class="keywordSuggest-footer">
                            <div>
                                <a href="javascript:void(0)" data-off="keywordSuggest">자동완성끄기</a>
                            </div>
                        </div>
                    </div>
                    <div class="keywordSuggest-result">
                    </div>
                </div>
        
                <div class="keywordSuggest-comment">
                    <p>현재 자동완성 기능을 사용하고 계십니다.</p>
                    <div class="keywordSuggest-footer">
                        <div>
                            <a href="javascript:void(0)" data-off="keywordSuggest">자동완성끄기</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear"></div>
		</div>
	</form>
	<hr/>
	<div class="search_menu_body">
	<ul class="search_menu_category">
		<li class="search_menu_category <%="all".equals(sfrom)?"search_category_selected":""%>" id="btn_select_category_all">
		<div class="search_menu_bullet">&gt;</div> 통합검색 [<%=totalCount%>] 건
		</li>
		<% for(int colinx=0;colinx<collections.length;colinx++) { %>
			<li class="search_menu_category <%=collections[colinx][0].equals(sfrom)?"search_category_selected":""%>" id="btn_select_category_<%=collections[colinx][0]%>">
			<div class="search_menu_bullet">&gt;</div> <%=collections[colinx][1]%> [<%=cntArray[colinx][1]%>] 건
			</li>
		<% } %>
	</ul>
	<div>
		<div class="search_menu_sub">
			<div>결과내 재검색</div>
			<div><input id="search_detail" type="text"/></div>
		</div>

		<div class="search_menu_sub">
			<div>정렬</div>
			<ul class="search_menu_group">
				<li class="search_menu_item <%="score".equals(otype)?"search_menu_selected":""%>" id="btn_sort_score">정확도</li>
				<li class="search_menu_item <%="date".equals(otype)?"search_menu_selected":""%>" id="btn_sort_date">최신순</li>
			</ul>
		</div>

		<div class="search_menu_sub">
			<div>기간</div>
			<ul class="search_menu_group">
				<li class="search_menu_item <%="all".equals(interval)?"search_menu_selected":""%>" id="btn_interval_all">전체</li>
				<li class="search_menu_item <%="1d".equals(interval)?"search_menu_selected":""%>" id="btn_interval_1d">1일</li>
				<li class="search_menu_item <%="1w".equals(interval)?"search_menu_selected":""%>" id="btn_interval_1w">1주</li>
				<li class="search_menu_item <%="1m".equals(interval)?"search_menu_selected":""%>" id="btn_interval_1m">1개월</li>
				<li class="search_menu_item <%="1y".equals(interval)?"search_menu_selected":""%>" id="btn_interval_1y">1년</li>
			</ul>
			<%String[] intervalArray = interval.split("~");%>
			<div class="clear search_menu_item <%=interval.indexOf('~')>0?"search_menu_selected":""%>" id="input_date_btn">직접입력</div>
			<div class="absolute hidden" id="input_date_body">
				<div id="input_date_form">
				<span><input type="text" id="input_date_from" value="<%=interval.indexOf('~')>0?intervalArray[0]:""%>"/></span>~
				<span><input type="text" id="input_date_to" value="<%=intervalArray.length>1?intervalArray[1]:""%>"/></span>
				<input type="button" id="btn_date_search" value="검색"/>
				</div>
			</div>
		</div>

		<div class="search_menu_sub">
			<div>영역</div>
			<ul class="search_menu_group">
				<li class="search_menu_item <%="all".equals(stype)?"search_menu_selected":""%>" id="btn_type_all">전체</li>
				<li class="search_menu_item <%="title".equals(stype)?"search_menu_selected":""%>" id="btn_type_title">제목</li>
				<li class="search_menu_item <%="body".equals(stype)?"search_menu_selected":""%>" id="btn_type_body">본문</li>
			</ul>
		</div>
	</div>

	</div>
	<div class="hit_keyword_body">
		<div class="hit_keyword_title">인기검색어</div>
		<div>
		<ul class="hit_keyword_body">
		</ul>
		</div>
	</div>
</div>

<div style="margin:0 230px 0 205px;">
<% for(int colinx=0;colinx<docArray.length;colinx++) { %>
	<% JSONObject doc = (JSONObject)docArray[colinx]; %>
	<% if(keyword!=null && !"".equals(keyword)) { %>
		<% if(colinx==0) { %>
			<% if(searchCollection ==-1 || searchCollection==colinx) { %>
			<%@include file="search_item_sample.jsp"%>
			<% } %>
		<% } else if(colinx==1) { %>
			<% if(searchCollection ==-1 || searchCollection==colinx) { %>
			<%@include file="search_item_purple.jsp"%>
			<% } %>
		<% } else if(colinx==2) { %>
			<% if(searchCollection ==-1 || searchCollection==colinx) { %>
			<%@include file="search_item_attach.jsp"%>
			<% } %>
		<% } %>
		<% if (!"all".equals(sfrom) && colinx==searchCollection) { %>
			<div align="center" style="border:1px solid #999999;padding:10px;">
			<% if (cpage > 5) { %>
				<span class="nav" onclick="goPage(<%=pn.prevPage(cpage,4)%>)">◀</span>
			<% } %>
			<% if (cpage > 1) { %>
				<span class="nav" onclick="goPage(<%=pn.prevPage(cpage,0)%>)">&lt;</span>
			<% } %>
			<% for (int pageInx=pn.startPage(cpage);pageInx <=pn.endPage(cpage); pageInx++) { %>
				<%if(pageInx==cpage) { %>
					<b><%=pageInx%></b>
				<% } else { %>
					<span class="nav" onclick="goPage(<%=pageInx%>)">[<%=pageInx%>]</span>
				<% } %>
			<% } %>
			<% if (cpage < pn.endPage(cpage)) { %>
				<span class="nav" onclick="goPage(<%=pn.nextPage(cpage,0)%>)">&gt;</span>
			<% } %>
			<% if (pn.getTotalPage() > 5 && cpage < (pn.endPage(cpage)-3)) { %>
				<span class="nav" onclick="goPage(<%=pn.nextPage(cpage,4)%>)">▶</span>
			<% } %>
			</div>
		<% } %>
	<% } %>
<% } %>
</div>
<form id="navForm" action="<%=request.getRequestURI()%>" method="post">
<input type="hidden" name="sfrom" value="<%=sfrom%>"/>
<input type="hidden" name="stype" value="<%=stype%>"/>
<input type="hidden" name="otype" value="<%=otype%>"/>
<input type="hidden" name="category" value="<%=category%>"/>
<input type="hidden" name="interval" value="<%=interval%>"/>
<input type="hidden" name="keyword" value="<%=keyword%>"/>
<input type="hidden" name="hkeyword" value="<%=hkeyword%>"/>
<input type="hidden" name="cpage" value="<%=cpage%>"/>
<div id="keyword_backup" class="hidden"><%=keyword%> <%=hkeyword%></div>
</form>
</body>
</html>
<% } catch (Exception e) { %>
	<% StackTraceElement[] ste = e.getStackTrace(); %>
	<%=e.getMessage()%><br/>
	<% for(StackTraceElement el : ste) { %>
		<%=el%><br/>
	<% } %>
<% } %>
