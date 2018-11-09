<!--
 * 날짜 : 2015-07-20
 * 작성자 : 패스트캣 사원 전제현
 * 내용 : 로그분석기 연동 ASP.NET(C#) 예제
-->

<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="FastcatSearch_ASP_001.index" %>

<asp:Content ID="index" ContentPlaceHolderID="Content1" runat="server">
    <div class="jumbotron">
        <h1>ASP 로그분석기 연동 예제</h1>
        <p>예제 참고바랍니다.</p>
        <p><a class="btn btn-primary btn-lg" href="list.aspx" role="button">인기검색어 등 순위리스트 보기</a></p>
    </div>
    <div class="form-group">
        <form action="Search.aspx" method="get">
        <div class="panel panel-info">
            <div class="panel-heading">검색어 입력</div>
            <div class="panel-body">
                <input type="text" name="searchKeyword" id="searchKeyword" class="form-control" placeholder="검색어를 입력해 주세요" value="" />
                <input type="text" name="prevKeyword" id="prevKeyword" class="form-control" placeholder="이전 키워드" value="" />
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">옵션설정</div>
            <div class="panel-body">
                <ul>
                    <li>
                        <label for="category">카테고리</label>
                        <select name="category" id="category">
                            <option value="뷰티">뷰티</option>
                            <option value="잡화">잡화</option>
                            <option value="시계/악세사리">시계/악세사리</option>
                            <option value="패션">패션</option>
                            <option value="전자제품/식품">전자제품/식품</option>
                            <option value="한국상품관">한국상품관</option>
                        </select>
                    </li>
                    <li>
                        <label for="page">페이지 구분</label><input type="text" name="page" id="page" class="form-control-input-number" value="1" />
                    </li>
                    <li>
                        <label for="sort">정렬구분</label>
                        <select name="sort" id="sort">
                            <option value="베스트순">베스트순</option>
                            <option value="신상품순">신상품순</option>
                            <option value="높은가격순">높은가격순</option>
                            <option value="낮은가격순">낮은가격순</option>
                        </select>
                    </li>
                    <li>
                        <label for="service">서비스 구분</label>
                        <select name="service" id="service">
                            <option value="전체검색">전체검색</option>
                            <option value="상세검색">상세검색</option>
                        </select>
                    </li>
                    <li>
                        <label for="age">연령대</label>
                        <select name="age" id="연령대">
                            <% 
                                for (int age_value = 1; age_value <= 8; age_value++) {
                                    if (age_value == 8) {
                            %>
                                <option value="70대 이상">70대 이상</option>
                            <%
                                    } else {
                            %>
                                <option value="<%=age_value%>0대"><%=age_value%>0대</option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </li>
                    <li>
                        <label for="gender">성별</label>
                        <label for="gender_male"><input type="radio" name="gender" id="gender_male" value="남성" checked="checked" />남성</label>
                        <label for="gender_female"><input type="radio" name="gender" id="gender_female" value="여성" />여성</label>
                    </li>
                </ul>
            </div>
        </div>
        <input type="submit" name="submit" id="btn-submit" class="btn btn-lg btn-primary" value="검색" />
        </form>
    </div>
</asp:Content>