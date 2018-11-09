<?php
/*  2015-06-29 전제현  */

if ($_GET['search_action_check']) { /* 검색 여부를 체크하여 검색을 했을 시 POST 값을 별개의 변수에 저장함 */

	$rowsOfScreen = 5;	/* 한 화면에 표현 가능한 줄의 갯수 */
	$navOfScreen = 5;	/* 한 화면에 표현 가능한 내비게이터의 갯수 */

	$search_action_check = $_GET['search_action_check'];
	$search_collection = $_GET['search_collection'];
	$search_keyword = $_GET['search_keyword'];
	if ($_GET['prev_search_Keyword']) {
		$prev_search_Keyword = $_GET['prev_search_Keyword'];
	}
	$currentPage = number_format($_GET['currentPage']);
	if ($search_collection == "thsis") {
		$searchField = $searchField_thsis = $_GET['searchField_thsis'];
	} else if ($search_collection == "users") {
		$searchField = $searchField_users = $_GET['searchField_users'];
	}
}

/* 패스트캣 검색엔진용 함수들, 패스트캣 API는 해당 파일에서 별도로 require */
include_once("fastcat/common.php");

if ($search_action_check) {

/* SearchQueryStringer 클래스 초기화 (검색할 컬렉션 설정) */
$query = new SearchQueryStringer($search_collection);
/* SearchQueryStringer 초기화 끝 */

/* FastcatCommunicator 클래스 초기화 (검색엔진 통신정보) */
$fastcat = new FastcatCommunicator("http://cloud.gncloud.io:13802");
/* FastcatCommunicator 초기화 끝 */

//검색엔진과 통신 (검색)
$search_result = searchMaster($search_collection, $fastcat, $query, $search_keyword, $search_keyword, $searchField);
$restime = explode(" ", $search_result["time"]);
$restime = $restime[0]; /* 응답시간을 수치만 변수에 저장 */

/* PageNavigator 클래스 초기화 (페이징 기능 지원) */
$paging_option = new PageNavigator($rowsOfScreen, $navOfScreen);
//총갯수 입력
$paging_option->setTotal($search_result["total_count"]);
/* 초기화 끝 */
}

/* 인기검색어 관련 변수 초기화와 함수 선언 */
// 먼저 로그분석기와의 커넥션을 형성한다.
$logger = new FastcatCommunicator("http://localhost:8051");
sendLog($logger, $search_keyword, $prev_search_Keyword, $searchField, "통합검색", "내림차순", $currentPage, $restime)
?>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Fastcat PHP 검색페이지</title>
<!-- Favicon -->
<link rel="shortcut icon" href="img/fastcat-favicon.ico">
<!-- 부트스트랩 CSS -->
<link href="bootstrap/css/bootstrap.css" rel="stylesheet">
<link href="bootstrap/css/template_style.css" rel="stylesheet">
<!-- IE8 에서 HTML5 요소와 미디어 쿼리를 위한 HTML5 shim 와 Respond.js -->
<!-- WARNING: Respond.js 는 당신이 file:// 을 통해 페이지를 볼 때는 동작하지 않습니다. -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->
<!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요합니다) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.js"></script>
<!-- 모든 컴파일된 플러그인을 포함합니다 (아래), 원하지 않는다면 필요한 각각의 파일을 포함하세요 -->
<script src="bootstrap/js/bootstrap.js"></script>

<script type="text/javascript">
/* 페이지 링크 */
function viewDocument(url) {
	//location.href = url;
	alert("현재 링크기능은 제공하지 않습니다.");
}

/* 페이지 내비 번호로 이동 */
function goPage(pageNumber) {
	location.href = "http://localhost/fastcat_search/?search_action_check=<?=$search_action_check?>&currentPage="+pageNumber+"&search_collection=<?=$search_collection?>&search_keyword=<?=$search_keyword?>";
}
</script>
</head>
<body cz-shortcut-listen="true">
<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.php">Fastcat Search</a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<form name="fastcat_search" id ="fastcat_search" class="navbar-form navbar-right" method="get" enctype="multipart/form-data">
				<input type="hidden" name="search_action_check" value="true">
				<?php if ($search_action_check) { ?>
				<input type="hidden" name="prev_search_Keyword" value="<?=$search_keyword?>">
				<?php } ?>
				<input type="hidden" name="currentPage" value="1">
				<div class="form-group">
					<select name="search_collection" id="search_collection" class="form-control main-select">
						<option value="thsis" <?php if ($search_collection == "thsis") { ?>selected<?php } ?>>thsis</option>
						<option value="users" <?php if ($search_collection == "users") { ?>selected<?php } ?>>users</option>
					</select>
					<select name="searchField_thsis" id="searchField_thsis" class="form-control thsis-select" <?php if ($search_collection && $search_collection != "thsis") { ?>style="display:none;"<?php } ?>>
						<option value="ALL">All</option>
						<option value="TITLE"<?php if ($searchField_thsis == "TITLE") { ?> selected<?php } ?>>title</option>
						<option value="CONTENT"<?php if ($searchField_thsis == "USERS") { ?> selected<?php } ?>>content</option>
						<option value="TAGS"<?php if ($searchField_thsis == "TAGS") { ?> selected<?php } ?>>tags</option>
						<option value="FILENAME"<?php if ($searchField_thsis == "FILENAME") { ?> selected<?php } ?>>filename</option>
					</select>
					<select name="searchField_users" id="searchField_users" class="form-control users-select" <?php if (!$search_collection || ($search_collection && $search_collection != "users")) { ?>style="display:none;"<?php } ?>>
						<option value="ALL">All</option>
						<option value="FULLNAME"<?php if ($searchField_users == "FULLNAME") { ?> selected<?php } ?>>fullname</option>
						<option value="LASTNAME"<?php if ($searchField_users == "LASTNAME") { ?> selected<?php } ?>>lastname</option>
						<option value="FIRSTNAME"<?php if ($searchField_users == "FIRSTNAME") { ?> selected<?php } ?>>firstname</option>
					</select>
					<script type="text/javascript">
					$(".main-select").change(function() {
						if ($(".main-select").val() == "thsis") {
							$("#autocomplete-warring").css("display", "none");
							$(".thsis-select").css("display", "inline-block");
							$(".users-select").css("display", "none");
						} else if ($(".main-select").val() == "users") {
							$("#autocomplete-warring").css("display", "none");
							$(".thsis-select").css("display", "none");
							$(".users-select").css("display", "inline-block");
						}
					});

					$(".thsis-select").change(function() {
						var select_field = $(".thsis-select").val();

						if (select_field != "ALL" && select_field != "TITLE") {
							$("#autocomplete-warring").css("display", "inline-block");
						} else {
							$("#autocomplete-warring").css("display", "none");
						}
					});

					$(".users-select").change(function() {
						var select_field = $(".users-select").val();

						if (select_field != "ALL" && select_field != "FULLNAME") {
							$("#autocomplete-warring").css("display", "inline-block");
						} else {
							$("#autocomplete-warring").css("display", "none");
						}
					});
					</script>
					<div id="search-keyword-input-div">
						<input type="text" name="search_keyword" id="search_keyword" placeholder="검색어를 입력해 주세요" class="form-control" size="40" <?php if ($search_keyword) { ?>value="<?=$search_keyword?>"<?php } ?> autocomplete=off>
						<!-- AJAX를 이용하여 자동완성 리스트 불러오기 시작 -->
						<div id="autoComplete-layer"></div>
					</div>
					<script type="text/javascript">

					$(document).ready(function() {

						$("#search_keyword").on({
							
							"keyup" : function() {

								var searchKeyword = $("#search_keyword").val();
								var searchCollection = $("#search_collection").val();
								var searchField = "";
								if (searchCollection == "thsis") {
									searchField = $("#searchField_thsis").val();
								} else if (searchCollection == "users") {
									searchField = $("#searchField_users").val();
								}

								if (!searchKeyword) {
									$("#autoComplete-layer").hide();
								} else if (searchField == "" || searchField == "ALL" || searchField == "TITLE" || searchField == "FULLNAME") {

									if (event.keyCode != '38' && event.keyCode != '40') {

										if (search_keyword!='') {
											$.ajax({	
												url : "fastcat/autoComplete.php",
												type : "post",
												data : {
													search_collection:searchCollection, 
													search_keyword:searchKeyword
												},
												dataType : "text",
												success : function(html) {
													if (html != '') {
														$("#autoComplete-layer").html(html).show();
													}
												},
												error : function(request, status, error) {
													//alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
												}
											});
										}
									} else if (event.keyCode == '38') {
										if ($(".autoComplete-keyword").hasClass("selected") == false) {
											var select_keyword = $(".autoComplete-keyword").last().addClass("selected").text();
											if (select_keyword != '') {
												$("#search_keyword").val(select_keyword);
											}
										} else if ($(".autoComplete-keyword").hasClass("selected")) {
											var select_keyword = $(".selected").removeClass("selected").prev().addClass("selected").text();
											if (select_keyword != '') {
												$("#search_keyword").val(select_keyword);
											}
										}
									} else if (event.keyCode == '40') {
										if ($(".autoComplete-keyword").hasClass("selected") == false) {
											var select_keyword = $("#keyword-0").addClass("selected").text();
											if (select_keyword != '') {
												$("#search_keyword").val(select_keyword);
											}
										} else if ($(".autoComplete-keyword").hasClass("selected")) {
											var select_keyword = $(".selected").removeClass("selected").next().addClass("selected").text();
											if (select_keyword != '') {
												$("#search_keyword").val(select_keyword);
											}
										}
									}
								}
							},

							"focus" : function(){

								var searchKeyword = $("#search_keyword").val();
								var searchCollection = $("#search_collection").val();
								var searchField = "";
								if (searchCollection == "thsis") {
									searchField = $("#searchField_thsis").val();
								} else if (searchCollection == "users") {
									searchField = $("#searchField_users").val();
								}
								if (!searchKeyword) {
										$("#autoComplete-layer").hide();
								} else if (searchField == "" || searchField == "ALL" || searchField == "TITLE" || searchField == "FULLNAME") {
									$.ajax({	
										url : "fastcat/autoComplete.php",
										type : "post",
										data : {
											search_collection:searchCollection, 
											search_keyword:searchKeyword
										},
										dataType : "text",
										success : function(html) {
											if (html != '') {
												$("#autoComplete-layer").html(html).show();
											}
										},
										error : function(request, status, error) {
											//alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
										}
									});
								}
							}
						});
					});
					</script>
					<!-- AJAX를 이용하여 자동완성 리스트 불러오기 끝 -->
				</div>
				<button type="submit" class="btn btn-success">Search</button>
			</form>
		</div>
		<div id="autocomplete-warring">
		! 해당 필드에서는 자동완성 기능을 제공하지 않습니다.
		</div>
	</div>
</nav>

<div class="container">
	<div class="row">
		<div class="col-sm-9 search-content">
		<?php if ($search_action_check) { /* 검색을 했을 경우 */ ?>
			<?php if ($search_result["total_count"] > 0) { ?>
				<div class="search_summary">
					<span class="search_keyword"><?=$search_keyword?></span>에 대한 검색 결과 (총 <?=number_format($search_result["total_count"])?>건)
				</div>
				<?php $resultArray = $search_result["result"]; ?>
				<?php if($resultArray != null) { ?>
				<ul class="search_list">
					<?php for ($index_num=$paging_option->startRow($currentPage); $index_num < $paging_option->endRow($currentPage); $index_num++) { ?>
						<?php
						$item = $resultArray[$index_num];
						$goUrl = ""; //클릭했을 경우 이동할 url 을 입력.
						?>
						
						<?php if ($search_collection == "thsis") { /* thsis 테이블 검색 시 결과 */ ?>
							<?php if ($item["TITLE"] != "") { ?>
							<li>
								<div class="result_item_title"> 
									<a class="result_item_title" onclick="viewDocument('<?=$goUrl?>')" style="cursor:pointer;"><?=$item["TITLE"]?></a> 
								</div>
								<div class="result_item_contents">
									<?=$item["CONTENT"]?><br/>
									<b>파일명: <a class="result_item_fullname" onclick="viewDocument('<?=$goUrl?>')" style="cursor:pointer;"><?=$item["FILENAME"]?></a></b><br/>
									<b>태그: <a class="result_item_fullname" onclick="viewDocument('<?=$goUrl?>')" style="cursor:pointer;"><?=$item["TAGS"]?></a></b>
								</div>
							</li>
							<?php } ?>
						<?php } else if ($search_collection == "users") { /* users 테이블 검색 시 결과 */ ?>
							<?php if ($item["FULLNAME"] != "") { ?>
							<li>
								<div class="result_item_firsename"> 
									<a class="result_item_fullname" onclick="viewDocument('<?=$goUrl?>')" style="cursor:pointer;"><?=$item["FULLNAME"]?></a> 
								</div>
								<div class="result_item_name_parts">
									<b>성</b>: <?=$item["LASTNAME"]?> / <b>이름</b>: <?=$item["FIRSTNAME"]?>
								<br/>
								</div>
							</li>
							<?php } ?>
						<?php } ?>
					<?php } ?>
				</ul>
				<?php //페이지 네비게이션 출력 ?>
				<div class="page-count">
					<ul class="page-count-list">
					<?php for ($pageInx=$paging_option->startPage($currentPage); $pageInx<$paging_option->endPage($currentPage); $pageInx++) { ?>
						<li>
						<?php if($pageInx==$currentPage) { ?>
							<b><?=$pageInx?></b>
						<?php } else { ?>
							<span onclick="goPage(<?=$pageInx?>)" style="cursor:pointer;">[<?=$pageInx?>]</span>
						<?php } ?>
						</li>
					<?php } ?>
					</ul>
				</div>
				<?php } ?>
			<?php } else if ($search_result["total_count"] == 0) { ?>
				<div class="not_found"> <p><b><font color="#EB5629">'<?=$search_keyword?>'</font>에 대한 검색결과가 없습니다.</b></p>
					<ul>
						<li>단어의 철자가 정확한지 확인해 보세요.</li>
						<li>한글을 영어로 혹은 영어를 한글로 입력했는지 확인해 보세요.</li>
						<li>검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해 보세요.</li>
						<li>두 단어 이상의 검색어인 경우, 띄어쓰기를 확인해 보세요.</li>
					</ul>
				</div>
			<?php } ?>	
		<?php } else if (!$search_action_check) { /* 검색을 하지 않았을 경우 (첫페이지) */ ?>
		검색을 시작하십시오.
		<?php } ?>
		</div>
		<!-- /.search-content -->
		<div class="col-sm-2 col-sm-offset-1 search-slidebar">
			<div class="sidebar-module">
				<h4>인기검색어</h4>
				<ol id="hit_keyword_list">
				<?php
				$kdoc = getPopularKeyword($logger, "");
				$keywords = $kdoc["list"];
				if($keywords) {
				?>
					<?php
					for($inx=0; $inx < count($keywords); $inx++) {
					?>
						<?php
						$entry = $keywords[$inx];
						$word = $entry["word"];
						$rank = $entry["rank"];
						$diffType = $entry["diffType"];
						$diff = $entry["diff"];
						?>
						<li class="hit_keyword">
							<ul class="keyword-information">
								<!-- <li><div class="hit_keyword_no"> <?=$rank?>.</div></li> -->
								<li>
								<?php if($diffType=="EQ") { ?>
									<div class="hit_keyword_rank"></div>
									<div class="hit_keyword_arrow">-</div>
								<?php } else if($diffType=="UP") { ?>
									<div class="hit_keyword_rank"><?=$diff?></div>
									<div class="hit_keyword_arrow hit_keyword_up">↑</div>
								<?php } else if($diffType=="DN") { ?>
									<div class="hit_keyword_rank"><?=$diff?></div>
									<div class="hit_keyword_arrow hit_keyword_down">↓</div>
								<?php } else if($diffType=="NEW") { ?>
									<span class="keyword_new">NEW!!</span>
								<?php } ?>
								</li>
								<li><div class="hit_keyword_str"><?=$word?></div></li>
							</ul>
						</li>
					<?php } ?>
				<?php } ?>
				</ol>
			</div>
		</div> <!-- /.search-slidebar -->
	</div> <!-- /.row -->
</div> <!-- /.container -->
<footer>
    <div class="navbar-mobile btn-group btn-group-justified navbar-fixed-bottom">
		<div class="btn btn-default" onclick="location.href='#'">
			<span class="glyphicon glyphicon-info-sign"></span>
			<span class="text">2015 Fastcat.</span>
		</div>
    </div>
</footer>
</body>
</html>