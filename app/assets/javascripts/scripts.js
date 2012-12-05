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

    var friendCounter = 0;
    $("form#campaign-friends").submit(function(event) {
      event.preventDefault();
      event.stopPropagation();
      var err = "";
      var emailField = $("#campaign_email");
      var friend = validEmail(emailField.val());
      if (!friend) {
        err = "Please enter a valid email";
      }
      var video = void 0,
          videoField;
      if ($("#recorded").attr("checked")) {
        videoField = $("#videos .video input");
        if (videoField.length > 0) { 
          video = videoField.val(); 
        } else {
          if (err != '') {
            err += " and record a video!";
          } else {
            err = "Please record a video!";
          }
        }
      } else {
        videoField = $("#campaign_video_link");
        video = videoField.val();
        if (!validVideo(video)) {
          if (err != '') {
            err += " and check your video url!";
          } else {
            err = "Please make sure your video url is valid";
          }
        }
      }
      if (err !== "") {
        var errBox = $("#campaign-notice");
        if (errBox.length == 0) {
          $("#friends-container").prepend("<span id='campaign-notice' class='alert alert-error'></span>");
          errBox = $("#campaign-notice");
        }
        errBox.html(err);
        return false;
      }
      if ($("ul#friends li").length == 0) {
        $("ul#friends").html("");
      }
      $("<li>" + friend.fname + " " + friend.lname + ": " + friend.email + 
          "<input type='hidden' name='campaign[campaign_friend_attributes][" + friendCounter + "][name]' value='" + (friend.fname + " " + friend.lname) + "' />" + 
          "<input type='hidden' name='campaign[campaign_friend_attributes][" + friendCounter + "][video]' value='" + video + "' />" + 
          "<input type='hidden' name='campaign[campaign_friend_attributes][" + friendCounter + "][email]' value='" + friend.email + "' /></li>").hide().appendTo("ul#friends").slideDown('slow');
      //$("ul#friends").append(toAdd)
      friendCounter += 1;
      videoField.val("");
      emailField.val("");
      return false;
    });

    function validEmail(full_email) {
      var emailRegexp = new RegExp(/\<.+\>/),
          isName = emailRegexp.test(full_email),
          fname = "",
          lname = "",
          email = "";
          
      if (isName) {
        email = emailRegexp.exec(full_email)[0].replace(/[\<\>]/g, "").trim();
        var name = full_email.substring(0, full_email.indexOf('<')).split(" ");
        if (name.length > 0) {
          fname = name[0];
          if (name.length > 1) {
            name[0] = "";
            lname = name.join(" ").trim();
          }
        }
      }
      var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
      if (pattern.test(email)) {
        return { email: email, fname: fname, lname: lname };
      } else { 
        return false; 
      }
    }
    function validVideo(videoUrlOrId) {
      if (!videoUrlOrId) { return false; }
      var video_regexp = [  
        new RegExp(/^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/i), 
        new RegExp(/^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/i),
        new RegExp(/^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/i)
          ];
      for (var i = 0; i < video_regexp.length; i++) {
        if (video_regexp[i].test(videoUrlOrId)) {
          return true;
        }
      }
      return false;
    }
  });
})(jQuery)
