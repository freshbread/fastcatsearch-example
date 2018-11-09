<%@ page pageEncoding="utf8"%>
<%@ page import="
java.text.*,
java.util.Calendar,
java.util.*,
java.text.SimpleDateFormat,
org.json.JSONObject,
org.json.JSONArray
"%>
	<div class="search_title"> <%=collections[colinx][1]%> </div>
	<% if(cntArray[colinx][1] > 0) { %>
		<% pn.setTotal(cntArray[colinx][1]); %>
		<div class="search_summary">
		<% if (cntArray[colinx][1] != cntArray[colinx][0] && !"all".equals(sfrom)) { %>
			"<span class="search_keyword"><%=keyword%></span>" 에 대한 검색 결과 (총 <%=cntArray[colinx][1]%>건 중 <%=cntArray[colinx][0]%> 건)
		<% } else { %>
			"<span class="search_keyword"><%=keyword%></span>" 에 대한 검색 결과 (총 <%=cntArray[colinx][1]%>건)
		<% } %>
		</div>
		<% JSONArray resultBody = doc.optJSONArray("result"); %>
		<% if(resultBody!=null) { %>
			<% for(int inx=0; inx < resultBody.length(); inx++) { %>
				<% JSONObject item = resultBody.optJSONObject(inx); %>
				<div class="result_item_title"> 
				<% String goUrl=""; %>
				<a class="result_item_title" onclick="viewDocument('<%=goUrl%>')"><%=item.optString("CONTENT_TITLE")%></a> 
				</div>
				<div class="result_item_contents">
				<%=item.optString("CONTENT")%>
				<br/>
				작성일:<%=item.optString("CONTENT_CREATE_AT")%>
				</div>
			<% } %>
		<% } %>
	<% } else if(!"".equals(sfrom)) { %>
		<div class="not_found"> <p><b><font color="#EB5629">'<%=keyworDisp %>'</font>에 대한 검색결과가 없습니다.</b></p>
			<ul>
				<li>단어의 철자가 정확한지 확인해 보세요.</li>
				<li>한글을 영어로 혹은 영어를 한글로 입력했는지 확인해 보세요.</li>
				<li>검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해 보세요.</li>
				<li>두 단어 이상의 검색어인 경우, 띄어쓰기를 확인해 보세요.</li>
			</ul>
		</div>
	<% } %>
