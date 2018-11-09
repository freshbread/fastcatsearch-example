<?php
/* 2015-07-02 ������ */
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

	/* SearchQueryStringer Ŭ���� �ʱ�ȭ (�˻��� �÷��� ����) */
	$query = new SearchQueryStringer($search_collection);
	/* SearchQueryStringer �ʱ�ȭ �� */

	/* FastcatCommunicator Ŭ���� �ʱ�ȭ (�˻����� �������) */
	$fastcat = new FastcatCommunicator("http://localhost:8090");
	/* FastcatCommunicator �ʱ�ȭ �� */

	//�˻������� ��� (�˻�)
	$search_result = searchMaster($search_collection, $fastcat, $query, $search_keyword, $search_keyword, $search_field);

	if (count($search_result["result"])) {
		// ����� ȭ�鿡 �ڵ��ϼ� ����Ʈ �ѷ��ֱ�
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