(function($) {
  $.fn.nestedmodel = function(options) {
    var settings = $.extend({
      base: 0,
      handle: ".video",
      removeObj: true,
      removeHandle: ".remove",
      addHandle: "#add",
    }, options);

    return this.each(function() {
      
      var orig = parseInt(settings.base);
      var count = orig;

      $(settings.handle).each(function(index, video) {
        count = count + 1;
      });
      if (count == 0) {
        // We have no idea what to do if there isn't already a model
        return;
      } 
      // If there are no remove handles, then die
      if (!settings.removeObj && $(this).find(settings.removeHandle).length == 0) {
        return;
        /*$(this).append("<a id='remove' class='btn'>Remove</a>");
        settings.removeHandle = "#remove";
        if (count <= orig+1) {
          $(settings.removeHandle).attr("disabled", "disabled");
        }*/
      } 
      // If there is no add handle, then die
      if ($(this).find(settings.addHandle).length == 0) {
        return;
      }
      $(settings.addHandle).on("click", add);
      $(settings.removeHandle).on("click", remove);

      function reindex(element, newindex) {
        console.log($(element).html());
        $(element).html($(element).html().replace(/\d+/g, newindex));
        $(element).find("label").html($(element).find("label").html().replace(/\d+/g, newindex+1));
        return element;
      }
      function add(event) {
        var index = $(settings.handle).length;
        var last = $(settings.handle + ':last');
        var toadd = reindex(last.clone(), orig + index);
        toadd.find("input").removeAttr("value");
        last.after(toadd);
        count++;
        if ($(settings.removeHandle).attr("disabled")) {
          $(settings.removeHandle).removeAttr("disabled");
        }
        return false;
      }
      function remove(event) {
        var toremove;
        if (settings.removeObj) {
          toremove = $(event.currentTarget);
          while (!$(toremove).is(settings.handle)) { toremove = toremove.parent(); }
        } else {
          toremove = $(settings.handle + ":last");
        }
        if (count - orig > 1) {
          toremove.remove();
          count--;
        }
        if (count  - orig <= 1) {
          $(settings.removeHandle).attr("disabled", "disabled");
        }
        return false;
      }
    });
  }
})(jQuery);
