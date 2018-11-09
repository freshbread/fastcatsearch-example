<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="detailPage.aspx.cs" Inherits="FastcatSearch_ASP_001.detailPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Content1" runat="server">
    <div class="panel panel-info">
        <div class="panel-heading">클릭통계데이터 쿼리</div>
        <div class="panel-body">
            <%=getClickDataQuery()%>
        </div>
    </div>
</asp:Content>
