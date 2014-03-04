jQuery(function($) {
  var RE = /^data-stanza-(.+)/

  $('[data-stanza]').each(function(index) {
    var $this  = $(this),
        data   = $this.data(),
        params = {},
        counter = 1;

    $.each(this.attributes, function(i, attr) {
      var key = (RE.exec(attr.name) || [])[1]

      if (key) {
        params[key.replace('-', '_')] = attr.value;
      }
    });

    var $iframe = $("<iframe class='unload'></iframe>").attr({frameborder: 0}),
        src = data.stanza + '?' + $.param(params),
        width = (this.className == 'nanostanza-container') ? '' : (data.stanzaWidth || '100%')

    setTimeout(function(){
      $iframe
        .attr({src: src})
        .attr({id: 'stanza-frame-' + index})
        .attr({name: 'stanza-frame-' + index})
        .width(width)
        .height(data.stanzaHeight)
        .appendTo($this)
        .load(function(){
          $(this).removeClass("unload");
        });
      }, (++counter) * 500);
  });

  window.onmessage = function(e) {
    var message = JSON.parse(e.data),
        iframe  = $('#' + message.id);

    if (iframe.attr('style').search(/height/) === -1) {
      iframe.height(message.height);
    }
  };
});
