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

    var extras = 0;
    $(".video label").each(function(index, video) { 
      if ($(video).hasClass("extra")) {
        extras++;
      }
    });
    
    $("#remove").live("click", function(event) {
      var selector = $(this).data("selector");
      if (extras > 1) {
        $(selector + ":last").remove();
        extras--;  
      }
      if (extras <= 1) {
        $(this).attr("disabled", "disabled");
      } 
      return false;
    }); 
    $("#add").live("click", function(event) {
      var selector = $(this).data("selector");
      var index = $(selector).length;
      var toadd = reindexProjectVideo($(selector + ":last").clone(), index);
      toadd.find("input").removeAttr("value");
      $(selector + ":last").after(toadd);
      extras++;
      if ($("#remove").attr("disabled")) {
        $("#remove").removeAttr("disabled");
      }
      return false;
    });
  });
  function reindexProjectVideo(video, index) {
    var id = "project_videos_attributes_" + index + "_video_id";
    video.find("label").attr("for", id);
    video.find("label").html("Video " + (index+1));
    video.find("input").attr("id", id);
    video.find("input").attr("name", "project[videos_attributes][" + index + "][video_id]");
    video.find("input[type=checkbox]").remove();
    video.find("span").remove();
    return video;
  }
})(jQuery)
