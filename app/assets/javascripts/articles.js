// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require editormd

var editor;

var ready = function() {
    if($('.articles.edit').length != 0) {
        editor = editormd('editormd',{
              path: 'https://pandao.github.io/editor.md/lib/',
              height: 640,
              syncScrolling: "single"
              });
    } else if ($('.articles.show').length != 0) {
        alert("show init")
        editormd.markdownToHTML("editormd-preview", {
            htmlDecode      : "style,script,iframe",  // you can filter tags decode
            emoji           : true,
            taskList        : true,
            tex             : true,  // 默认不解析
            flowChart       : true,  // 默认不解析
            sequenceDiagram : true,  // 默认不解析
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
