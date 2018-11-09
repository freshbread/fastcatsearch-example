<!--
 * 날짜 : 2015-07-20
 * 작성자 : 패스트캣 사원 전제현
 * 내용 : 로그분석기 연동 ASP.NET(C#) 예제
-->

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="list.aspx.cs" Inherits="FastcatSearch_ASP_001.list" %>
<asp:Content ID="list" ContentPlaceHolderID="Content1" runat="server">
    <div class="jumbotron">
        <h1>ASP 로그분석기 연동 예제</h1>
        <p>예제 참고바랍니다.</p>
        <p><a class="btn btn-primary btn-lg" href="index.aspx" role="button">검색페이지 보기</a></p>
    </div>
    <div class="row">
        <div class="col-md-3 well custom-div-right">
            <h3>실시간 인기검색어</h3>
            <!-- 실시간 인기검색어 출력! -->
            <% 
                foreach (Newtonsoft.Json.Linq.JObject itemObj in realtimePopularList)
                {
                    Response.Write(itemObj["rank"].ToString()+"  ");
                    Response.Write(itemObj["word"].ToString() + "  ");
                    Response.Write(itemObj["diffType"].ToString() + "  ");
                    Response.Write(itemObj["diff"].ToString() + "  ");
                    Response.Write(itemObj["count"].ToString() + "  ");

                    Response.Write("<br>");    
                }  
            %>
            <!-- 출력 끝 -->
        </div>
        <div class="col-md-3 well custom-div-left">
            <h3>어제의 인기검색어</h3>
            <!-- 어제의 인기검색어 출력! -->
            <%
                foreach (Newtonsoft.Json.Linq.JObject itemObj in yesterdayPopularList)
                {
                    Response.Write(itemObj["rank"].ToString()+"  ");
                    Response.Write(itemObj["word"].ToString() + "  ");
                    Response.Write(itemObj["diffType"].ToString() + "  ");
                    Response.Write(itemObj["diff"].ToString() + "  ");
                    Response.Write(itemObj["count"].ToString() + "  ");

                    Response.Write("<br>");    
                }  
            %>
            <!-- 출력 끝 -->
        </div>
        <div class="col-md-3 well custom-div-right">
            <h3>지난 주의 인기검색어</h3>
            <!-- 지난 주의 인기검색어 출력! -->
            <%
                foreach (Newtonsoft.Json.Linq.JObject itemObj in lastweekPopularList)
                {
                    Response.Write(itemObj["rank"].ToString() + "  ");
                    Response.Write(itemObj["word"].ToString() + "  ");
                    Response.Write(itemObj["diffType"].ToString() + "  ");
                    Response.Write(itemObj["diff"].ToString() + "  ");
                    Response.Write(itemObj["count"].ToString() + "  ");

                    Response.Write("<br>");    
                }  
            %>
            <!-- 출력 끝 -->
        </div>
        <div class="col-md-3 well custom-div-left">
            <h3>연관검색어</h3>
            <!-- 연관검색어 출력! -->
            <%
                foreach (String item in relateList)
                {
                    Response.Write(item + "  ");

                    Response.Write("<br>");
                }  
            %>
            <!-- 출력 끝 -->
        </div>
    </div>
</asp:Content>
