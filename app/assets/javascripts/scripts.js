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

    $("#project_description").htmlarea({
      toolbar:["html"]});

    $('iframe').css("background-color", "white");

    $("#videos").nestedmodel({
      base: $(".video").not(".extra").length,
      handle: ".video.extra",
      removeObj: false,
      removeHandle: "#remove-video",
      addHandle: "#add-video",
    });
    $("#photos").nestedmodel({
      base: $(".video").not(".extra").length,
      handle: ".photo.extra",
      removeObj: false,
      removeHandle: "#remove-photo",
      addHandle: "#add-photo",
    });

    $(".smallprojectlist .project_details").click(function(event) {
      $(".project-active").removeClass("project-active");
      $(event.currentTarget).addClass("project-active");
      var img = $(event.currentTarget).find("img");
      var farmer = img.data("farmer");
      var description = img.data("description");
      var target = img.data("target");
      var current = img.data("current");
      var width = 100.0 - (target - current) * 100.0 / target;
      var toRender = "<h1>" + farmer + "</h1><p>" + description + "</p><h2>$"+current+" donated of $"+target+" goal</h2><div class='progress progress-striped active'><div class='bar' style='width: "+width+"%;'></div></div><a href='/projects/" + img.data("id") + "' class='btn btn-success' id='project_link'>Donate</a>";

      $(".hero-unit.project_sidebar").html(toRender);
      return false;
    });
  });
})(jQuery)
