<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="commons.jsp" %>
<%
    /* 검색한 키워드 받아서 인코딩 후 변수에 저장 */
    String searchStr_restore = request.getParameter("search_keyword");
    if (!(searchStr_restore.equals(""))) {

    String searchStr = new String(searchStr_restore.getBytes("8859_1"), "UTF-8");

/* 검색을 하고 검색결과를 받는다 */
    JSONObject acSearchResult = searchAutoCompleteData("test_autocomplete", "P_NAME", searchStr, 1, 10);
    JSONArray resultBody = acSearchResult.optJSONArray("result");

%>
<ul id="autoComplete-layer-ul" class="check_autocomplete_result_is_<%=acSearchResult.optInt("total_count")%>">
    <%
        for (int arr_count = 0; arr_count < resultBody.length(); arr_count++) {
            JSONObject autoKeywordStr = resultBody.optJSONObject(arr_count);

            if (autoKeywordStr == null) {
                continue;
            }
    %>
    <li class="autoComplete-keyword" id="keyword-<%=arr_count%>">
        <span><%=autoKeywordStr.optString("P_NAME")%></span>
    </li>
    <%
        }
    %>
</ul>
<script type="text/javascript">
    $(document).ready(function () {
        $(".autoComplete-keyword").on("click", this, function () {
            $("#searchStr").val($(this).text().trim());
            $("#autoComplete-layer").hide();
            $("#product_search").submit();
        });

        $(".autoComplete-keyword").on("mouseover", this, function () {
            $(".selected").removeClass("selected");
            $(this).addClass("selected");
        });

        $(".autoComplete-keyword").on("mouseout", this, function () {
            $(this).removeClass("selected");
        });
    });
</script>

<%
    }
%>