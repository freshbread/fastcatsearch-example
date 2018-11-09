<!--
 * 날짜 : 2015-07-20
 * 작성자 : 패스트캣 사원 전제현
 * 내용 : 로그분석기 연동 ASP.NET(C#) 예제
-->

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="FastcatSearch_ASP_001.Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Content1" runat="server">
    <div class="panel panel-info">
        <div class="panel-heading">검색 쿼리</div>
        <div class="panel-body">
            <%=getQuery()%>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-heading">검색 결과 (실제 검색 결과가 아닙니다.)</div>
        <div class="panel-body">
            <ul>
                <li><a href="detailpage.aspx?keyword=<%=getKeyword()%>&clickId=1111111111&clickType=search_list">검색결과 1</a></li>
                <li><a href="detailpage.aspx?keyword=<%=getKeyword()%>&clickId=1111111112&clickType=search_list">검색결과 2</a></li>
                <li><a href="detailpage.aspx?keyword=<%=getKeyword()%>&clickId=1111111113&clickType=best_item">검색결과 3</a></li>
                <li><a href="detailpage.aspx?keyword=<%=getKeyword()%>&clickId=1111111114&clickType=best_item">검색결과 4</a></li>
                <li><a href="detailpage.aspx?keyword=<%=getKeyword()%>&clickId=1111111115&clickType=new_item">검색결과 5</a></li>
            </ul>
        </div>
    </div>
</asp:Content>