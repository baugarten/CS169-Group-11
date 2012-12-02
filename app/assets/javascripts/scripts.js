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
      toolbar:["html", "bold","italic","underline","strikethrough","|","increasefontsize", "decreasefontsize"]});


    $('iframe').css("background-color", "white");

    $('.stripe-button-frame').css("background-color", "rgb(225,255,225)");

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
      var toRender = "<h3>" + farmer + "</h3><p>" + description.slice(0,110) + "...</p></div><h4>$"+current+" donated of $"+target+" goal</h4><div class='progress progress-striped active'><div class='bar' style='width: "+width+"%;'></div></div><a href='/projects/" + img.data("id") + "' class='btn btn-success' id='project_link'>Donate</a>";
      $(".hero-unit.project_sidebar").html(toRender);
      return false;
    });

    $('a[data-popup]').live('click', function(e) { window.open($(this).attr('href')); e.preventDefault(); });
  });
})(jQuery)
