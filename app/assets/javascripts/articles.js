// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//= require ./editormd/codemirror.min
//= require ./editormd/modes.min
//= require ./editormd/addons.min
//= require ./editormd/marked.min
//= require ./editormd/prettify.min
//= require editormd

var editor;

var ready = function() {
    if($('.articles.edit').length != 0 || $('.articles.new').length != 0 || $('.articles.create').length != 0) {
        editor = editormd('editormd',{
            path: 'https://pandao.github.io/editor.md/lib/',
            height: 640,
            syncScrolling: "single"
            // tex             : false,  // 数学公式，默认不解析
            // flowChart       : false,  // 流程图，默认不解析
            // sequenceDiagram : false,  // 序列图，默认不解析
        });
    } else if ($('.articles.show').length != 0) {
        editormd.markdownToHTML("editormd-preview", {
            htmlDecode      : "style,script,iframe",  // you can filter tags decode
            emoji           : true,
            taskList        : true,
            // tex             : false,  // 数学公式，默认不解析
            // flowChart       : false,  // 流程图，默认不解析
            // sequenceDiagram : false,  // 序列图，默认不解析
        });
    }
    /*
    // or
    editor = editormd({
        id      : "test-editormd",
        width   : "90%",
        height  : 640,
        path    : "../lib/"
    });
    */
};

// this two supposed not work at same time
$(document).ready(ready);
//$(document).on('page:load', ready);  //just for turbolink
