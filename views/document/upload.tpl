<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
	<link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
	<link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
	<title>{{.BookName}} - Powered by MinDoc</title>
</head>

<body>
    <form enctype="multipart/form-data" method="post" action="{{urlfor "UploaderController.Upload" ":bookname" .BookName}}">
		<br />
		<h4>请选择要上传的文件</h4>
		<input type="file" name="uploadname" vaule="选择文件"/>
		<br />
		<button type="submit" class="btn btn-success">上传文件</button>
   </form>
	<script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}"></script>
	<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}"></script>
</body>

</html>
