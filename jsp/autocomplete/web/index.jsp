<%--
  Created by IntelliJ IDEA.
  User: ������
  Date: 2015-08-13
  Time: 7:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=EUC-KR" language="java" %>
<html>
<head>
  <title>�׽�Ʈ�� �˻� ������</title>
  <meta charset="EUC-KR"/>
  <script src="js/jquery-1.11.3.js"></script>
</head>
<body>
<form name="test_search" action="search.jsp" method="post" accept-charset="UTF-8">
  <input type="text" name="se" value="{prefix:��:100:15}" >
  <input type="submit" value="search.jsp �Է�" >
</form>
<br>
<form name="test_json" action="http://localhost:9090/search/json" method="get" accept-charset="UTF-8">
  <input type="text" name="se" value="{prefix:��:100:15}" >
  <input type="hidden" name="cn" value="ac">
  <input type="hidden" name="fl" value="id,term,prefix">
  <input type="hidden" name="sn" value="1">
  <input type="hidden" name="ln" value="10">
  <input type="submit" value="�˻����� json ������ ���̷�Ʈ �Է�" >
</form>
<br>
<span>Ajax �׽�Ʈ: </span>
<form name="test_ajax">
  <input type="text" id="test_ajax_se" name="se" value="{prefix:��:100:15}" >
</form>
<script>
  $('#test_ajax_se').keyup(function(){

    var se = "se=" + $("#test_ajax_se").val();
    $.ajax({
      url:'search.jsp',
      type:"POST",
      data:se,
      success:function(data){
        $('#test_ajax_value').html(data);
      }
    })
  })
</script>
<div id="test_ajax_value">

</div>
</body>
</html>