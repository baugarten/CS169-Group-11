(function($) {
  $(document).ready(function() {
    $(".datepicker").datepicker();

    $(".warn_blur").find(".warning_toggle").live("change", function(evt) {
      $(".warn_blur").addClass("warning");
      $(".warn_blur").find(".help-inline").show();
    });

    $(".admin-form textarea").htmlarea({
      toolbar: [
       "html", "bold","italic","underline","strikethrough","|", "subscript", "forecolor","increasefontsize", "decreasefontsize", "orderedlist", "unorderedlist", "indent", "outdent", "justifyleft", "justifycenter", "justifyright", "link", "unlink", "image", "horizontalrule", "h1","h2","h3","h4","h5","h6"]});
  });
})(jQuery)
