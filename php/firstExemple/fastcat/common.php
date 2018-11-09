<?php
require_once "fastcat_api.php";

function searchMaster($collection,$fastcat,$query,$keyword,$hkeyword,$stype="ALL",$sfrom="",$otype="",$interval="",$findCategory="",$checkAdult="",$chapterSize="",$startItem="1", $lengthItem="50") {
	if($collection=="thsis") {
		return searchThsis($collection,$fastcat,$query,$stype,$keyword,$hkeyword,$otype,$interval,$findCategory,$checkAdult,$chapterSize,$startItem,$lengthItem);
	} else if($collection=="users") {
		return searchUsers($collection,$fastcat,$query,$stype,$keyword,$hkeyword,$otype,$interval,$findCategory,$checkAdult,$chapterSize,$startItem,$lengthItem);
	}
}

//실질적인 검색기능을 구현해 놓은 함수, 모든 검색 옵션을 여기에서 설정한다.
function searchThsis($collection,$fastcat,$query,$stype,$keyword,$hkeyword,$otype,$interval,$findCategory,$checkAdult,$chapterSize,$startItem,$lengthItem) {        
    $searchField = array();
    // 검색해올 필드를 정한다.
    if($stype=="ALL") {
        // 전체내용에서 검색
        $searchField = array("title","content","tags","filename");
    } else if($stype=="TITLE") {
        // 제목에서 검색
        $searchField = array("title");
    } else if($stype=="CONTENT") {
        // 내용에서 검색
        $searchField = array("content");
    } else if($stype=="TAGS") {
        // 태그에서 검색
        $searchField = array("tags");
    } else if($stype=="FILENAME") {
        // 파일네임에서 검색 
        $searchField = array("filename");
    } else if($stype=="AUTOCOMPLETE") {
		// 자동완성 검색용 필드
		$searchField = array("title", "keyword");
	}

	// 정확도 기준 내림차순 정렬
	$query->addRankingEntry("_score");

    // 정렬방식
	/*
    if($otype=="date") {
        // 날자기준 내림차순 정렬
        $query->addRankingEntry("wdate");
    } else {
        // 정확도 기준 내림차순 정렬
        $query->addRankingEntry("_score");
    }
	*/
    // 날자필터링
	/*
    preg_match_all("/([0-9]+)([a-z]+)/", $interval, $matches);
    if($interval=="all") {
    } else if($matches[2][0]=="d") {
        // 일별 필터링 (1일전, 2일전....)
        $query->addFilterEntry("wdate",SearchQueryStringer::FILTER_SECTION,date("YmdHis",strtotime("-".$matches[1][0]." days")),date("YmdHis"));
    } else if($matches[2][0]=="w") {
        // 주별 필터링 (1주전, 2주전....)
        $query->addFilterEntry("wdate",SearchQueryStringer::FILTER_SECTION,date("YmdHis",strtotime("-".$matches[1][0]." weeks")),date("YmdHis"));
    } else if($matches[2][0]=="m") {
        // 월별 필터링 (1달전, 2달전....)
        $query->addFilterEntry("wdate",SearchQueryStringer::FILTER_SECTION,date("YmdHis",strtotime("-".$matches[1][0]." months")),date("YmdHis"));
    } else if($matches[2][0]=="y") {
        // 년별 필터링 (1년전, 2년전....)
        $query->addFilterEntry("wdate",SearchQueryStringer::FILTER_SECTION,date("YmdHis",strtotime("-".$matches[1][0]." years")),date("YmdHis"));
    } else {
        // 날자 범위로 필터링
        $intervalArray = explode("~",$interval);
        if(count($intervalArray)>1) {
            $query->addFilterEntry("wdate",SearchQueryStringer::FILTER_SECTION,$intervalArray[0],$intervalArray[1]);
        } else if(count($intervalArray)>0) {
            $query->addFilterEntry("wdate",SearchQueryStringer::FILTER_SECTION,$intervalArray[0]);
        }
    }
	*/
    //검색필드를 이용해 검색 식 구성 ( 검색어 매칭 점수 : 10점)
    $query->andSearchEntry($searchField,$hkeyword." ".$keyword,SearchQueryStringer::KEYWORD_AND,10);
    if($stype=="ALL") {
        // 제목 가중치를 높이기 위해 OR 블럭으로 제목 검색어 매칭 점수를 500점을 주어 검색식 구성
        $query->orSearchEntry(array("title"),$hkeyword." ".$keyword,SearchQueryStringer::KEYWORD_AND,500);
    }
    // SearchQueryStringer 를 이용해 검색식 구성
    $query->setCollection($collection)
        ->setFieldList("title:100,content:200,filename,tags")
        ->setUserDataKeyword($keyword)
        ->setLength($startItem,$lengthItem);
    // FastcatCommunicator 를 이용해 검색엔진과 통신
    $jsonStr = $fastcat->communicate("/service/search.json",$query->getQueryString(),"");
    // json_decode 를 이용해 받아온 검색결과 파싱
    return json_decode($jsonStr,true);
}

function searchUsers($collection,$fastcat,$query,$stype,$keyword,$hkeyword,$otype,$interval,$findCategory,$checkAdult,$chapterSize,$startItem,$lengthItem) {

	$searchField = array();
	if($stype=="ALL") {
		$searchField = array("fullname","lastname","firstname");
	} else if($stype=="FULLNAME") {
		$searchField = array("fullname");
	} else if($stype=="LASTNAME") {
		$searchField = array("lastname");
	} else if($stype=="FIRSTNAME") {
		$searchField = array("firstname");
    } else if($stype=="AUTOCOMPLETE") {
		// 자동완성 검색용 필드 (자동완성용 컬럼과 데이터가 마련되지 않아 일단 모든 컬럼으로 설정함)
		$searchField = array("fullname","lastname","firstname", "keyword");
	}

	// 정확도 기준 내림차순 정렬
	$query->addRankingEntry("_score");

	$query->andSearchEntry($searchField,$hkeyword." ".$keyword,SearchQueryStringer::KEYWORD_AND,10);
	if($stype=="all") {
		$query->orSearchEntry(array("fullname"),$hkeyword." ".$keyword,SearchQueryStringer::KEYWORD_AND,500);
	}

	$query->setCollection($collection)
		->setFieldList("fullname,lastname,firstname")
		->setUserDataKeyword($keyword)
		->setLength($startItem,$lengthItem);
	$jsonStr = $fastcat->communicate("/service/search.json",$query->getQueryString(),"");
	return json_decode($jsonStr,true);
}

function dateAdd($time,$type,$value) {
	if($type=="Y") {
		$time += ($value*60*60*24*365);
	} else if($type=="m") {
		$time += ($value*60*60*24*30);
	} else if($type=="w") {
		$time += ($value*60*60*24*7);
	} else if($type=="d") {
		$time += ($value*60*60*24);
	} else if($type=="H") {
		$time += ($value*60*60);
	} else if($type=="i") {
		$time += ($value * 60);
	} else if($type=="s") {
		$time += $value;
	}
}

function parseTimeMillis($timeStr) {
	$value = 0;
	if(endsWith($timeStr,"ms")) {
		$value = trim(substr($timeStr, 0, strlen($timeStr) - 2)) * 1;
	} else if(endsWith($timeStr,"s")) {
		$value = trim(substr($timeStr, 0, strlen($timeStr) - 2)) * 1000;
	} else if(endsWith($timeStr,"m")) {
		$value = trim(substr($timeStr, 0, strlen($timeStr) - 2)) * 1000 * 60;
	} else if(endsWith($timeStr,"h")) {
		$value = trim(substr($timeStr, 0, strlen($timeStr) - 2)) * 1000 * 60 * 60;
	}
	return $value;
}

function startsWith($haystack, $needle) {
	return $needle === "" || strpos($haystack, $needle) === 0;
}

function endsWith($haystack, $needle) {
	return $needle === "" || substr($haystack, -strlen($needle)) === $needle;
}

function sendLog($logger, $keyword, $prevKeyword, $sfrom, $service, $sort, $cpage, $resptime) {

	$siteId = "www"; /* 사이트 ID를 입력하세요. */

	$prevKeyword = urlencode($prevKeyword);
	$prmService = urlencode($service);
	$prmPage = $cpage;
	$resptime = $resptime;
	$prmSort = urlencode($sort);
	$prmCategory = "";

	$prmLogin = "로그인";
	$prmAge = "30대";
	$prmGender = "남성";

	$prmLogin = urlencode($prmLogin);
	$prmAge = urlencode($prmAge);
	$prmGender = urlencode($prmGender);

	$keyword = urlencode($keyword);
	$paramStr = "type=search&siteId=".$siteId."&categoryId=".$sfrom."&keyword=".$keyword."&prev=".$prevKeyword;
	$paramStr .= "&resptime=".$resptime."&page=".$prmPage."&sort=".$prmSort."&service=".$prmService;
	$paramStr .= "&age=".$prmAge."&login=".$prmLogin."&gender=".$prmGender."&category=".$prmCategory;
	
	$logger->communicate("/service/keyword/hit/post.json",$paramStr);
}

function getDailyRankKeyword($logger,$sfrom,$interval) {
	$siteId = "www"; /* 사이트 ID를 입력하세요. */
	$jsonStr = $logger->communicate("/service/keyword/popular.json", "siteId=".$siteId."&categoryId=".$sfrom."&timeType=D&interval=".$interval);
	return json_decode($jsonStr,true);
}

// 통신모듈로 인기검색어 목록을 가져온다.
function getPopularKeyword($logger, $sfrom) {
	$siteId = "www"; /* 사이트 ID를 입력하세요. */
	$jsonStr = $logger->communicate("/service/keyword/popular/rt.json","type=search&siteId=".$siteId."&categoryId=".$sfrom);
	return json_decode($jsonStr,true);
}

function getRelateKeyword($logger,$sfrom, $keyword) {
	$keyword = urlencode($keyword);
	$siteId = "www"; /* 사이트 ID를 입력하세요. */
	$jsonStr = $logger->communicate("/service/keyword/relate.json","siteId=".$siteId."&category=".$sfrom."&keyword=".$keyword."");
	return json_decode($jsonStr,true);
}