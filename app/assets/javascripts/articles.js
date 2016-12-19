// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require editormd

var editor;

$ (function() {
    alert("test")
    editor = editormd('editormd',{
          path: 'https://pandao.github.io/editor.md/lib/',
          height: 640,
          syncScrolling: "single"
          });
    /*
    // or
    editor = editormd({
        id      : "test-editormd",
        width   : "90%",
        height  : 640,
        path    : "../lib/"
    });
    */
});
