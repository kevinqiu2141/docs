<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
	<link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
	<link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
	<title>{{.BookName}} - Powered by MinDoc</title>
</head>
<body>
<style>
    #filePicker{float:left;line-height: 1.428571429;vertical-align: middle;margin: 0 6px 0 0;position: relative}
    #filePicker div,#filePicker div input{width: 94px;height: 38px;}
    #filePicker div.webuploader-pick{padding: 8px 15px;}
</style>
<div class="modal fade" id="importModal" tabindex="-1" role="dialog" aria-labelledby="importModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">导入文件</h4>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="name">文档名称</label>
                    <input class="form-control" id="name" name="doc_name" placeholder="balabala">
                </div>
                <div class="form-group">
                    <label for="des">描述</label>
                    <input class="form-control" id="des" placeholder="balabala">
                </div>
                <div id="uploader-demo" style="margin-top:30px;">
                    <div id="fileList" class="uploader-list" style="border:1px solid #ccc;padding:5px;min-height:80px;margin-bottom:20px;"></div>
                    <div id="filePicker">选择文件</div>
                    <button id="ctlBtn" name="uploadname" class="btn btn-default pull-left">开始上传</button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary">提交更改</button>
            </div>
        </div>/.modal-content
    </div>/.modal
</div>

    
<script type="text/javascript">   
// 初始化Web Uploader
var $btn = $('#ctlBtn'),
    state = 'pending',
    uploader;
if(window.uploader === null){
    try{
        var uploader = WebUploader.create({

            // swf文件路径
            swf: '/static/webuploader/Uploader.swf',

            // 文件接收服务端。
            server: "{{urlfor "DocumentController.Import" ":bookname" .BookName}}",

            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            pick: '#filePicker',

            // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
            resize: false
        })
        // 当有文件被添加进队列的时候
        .on( 'fileQueued', function( file ) {
            $('#fileList').append( '<div id="' + file.id + '" class="item">' +
                '<h4 class="info">' + file.name + '</h4>' +
                '<p class="state">等待上传...</p>' +
            '</div>' );
        })
        // 文件上传过程中创建进度条实时显示。
        .on( 'uploadProgress', function( file, percentage ) {
            var $li = $( '#'+file.id ),
                $percent = $li.find('.progress .progress-bar');

            // 避免重复创建
            if ( !$percent.length ) {
                $percent = $('<div class="progress progress-striped active">' +
                  '<div class="progress-bar" role="progressbar" style="width: 0%">' +
                  '</div>' +
                '</div>').appendTo( $li ).find('.progress-bar');
            }

            $li.find('p.state').text('上传中');

            $percent.css( 'width', percentage * 100 + '%' );
        })
        // 文件上传过程中创建进度条实时显示。
        .on( 'uploadProgress', function( file, percentage ) {
            var $li = $( '#'+file.id ),
                $percent = $li.find('.progress span');

            // 避免重复创建
            if ( !$percent.length ) {
                $percent = $('<p class="progress"><span></span></p>')
                        .appendTo( $li )
                        .find('span');
            }

            $percent.css( 'width', percentage * 100 + '%' );
        }).on( 'uploadSuccess', function( file ) {
            $( '#'+file.id ).find('p.state').text('已上传');
        }).on( 'uploadError', function( file ) {
            $( '#'+file.id ).find('p.state').text('上传出错');
        }).on( 'uploadComplete', function( file ) {
            $( '#'+file.id ).find('.progress').fadeOut();
        }).on( 'all', function( type ) {
            if ( type === 'startUpload' ) {
                state = 'uploading';
            } else if ( type === 'stopUpload' ) {
                state = 'paused';
            } else if ( type === 'uploadFinished' ) {
                state = 'done';
            }

            if ( state === 'uploading' ) {
                $btn.text('暂停上传');
            } else {
                $btn.text('开始上传');
            }
        });
        $btn.on( 'click', function() {
            if ( state === 'uploading' ) {
                uploader.stop();
            } else {
                uploader.upload();
            }
        });
    }catch(e){
        console.log(e);
    }
}

</body>
</html>
