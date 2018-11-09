<?php
/* 2015-07-02 전제현 */
include_once("common.php");

if ( !empty($_POST) ) {

	$search_collection = $_POST['search_collection'];
    $search_keyword = $_POST['search_keyword'];
	$search_field = "AUTOCOMPLETE";
	if ($search_collection == "thsis") {
		$show_field = "TITLE";
	} else if ($search_collection == "users") {
		$show_field = "FULLNAME";
	} else if ($search_collection == "AUTOCOMPLETE") {
		$show_field = "KEYWORD";
	}

	/* SearchQueryStringer 클래스 초기화 (검색할 컬렉션 설정) */
	$query = new SearchQueryStringer($search_collection);
	/* SearchQueryStringer 초기화 끝 */

	/* FastcatCommunicator 클래스 초기화 (검색엔진 통신정보) */
	$fastcat = new FastcatCommunicator("http://localhost:8090");
	/* FastcatCommunicator 초기화 끝 */

	//검색엔진과 통신 (검색)
	$search_result = searchMaster($search_collection, $fastcat, $query, $search_keyword, $search_keyword, $search_field);

	if (count($search_result["result"])) {
		// 사용자 화면에 자동완성 리스트 뿌려주기
		echo "<ul id=\"autoComplete-layer-ul\">";
		for ($arr_count=0; $arr_count < count($search_result["result"]); $arr_count++) {
			echo "<li class=\"autoComplete-keyword\" id=\"keyword-".$arr_count."\"><span>".$search_result["result"][$arr_count][$show_field]."</span></li>";
		}
		echo "</ul>";
?>
		<script type="text/javascript">
		$(document).ready(function() {
			$(".autoComplete-keyword").on("click", this, function() {
				$("#search_keyword").val($(this).text());
				$("#autoComplete-layer").hide();
				$("#fastcat_search").submit();
			});

			$(".autoComplete-keyword").on("mouseover", this, function() {
				$(".selected").removeClass("selected")
				$(this).addClass("selected");
			});

			$(".autoComplete-keyword").on("mouseout", this, function() {
				$(this).removeClass("selected");
			});
		});
		</script>

<?php
	}
}
?>