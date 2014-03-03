$(function(){

	$w = $(window);
	$html = $("html");
	$body = $("body");

	{ // font size
		$(".text-size-adjust").each(function(){
			var $this = $(this);
			$this.wrapInner("<span style='white-space: nowrap;'>");
			var $inner = $("span", $this);
			var w1 = $inner.width();
			var w2 = $body.width() - 40;
			//window.console.log(w1+" / "+w2);
			if (w1 > w2) {
				var fontSize = parseInt($this.css("font-size"));
				//window.console.log("fontSize: "+fontSize);
				fontSize *= w2 / w1;
				fontSize = fontSize < 10 ? 10 : fontSize;
				$this.css("font-size", fontSize + "px");
			}
		})
	}
	{
		$(".multiline-text-view").each(function(){
			var $this = $(this);
			var height = $this.height();
			$this.css("top", (($body.height() - 16 - height) * .5) + "px");
		});
	}
	{ // extension
		try {
			if (NANO_STANZA && NANO_STANZA.EXTENSION && NANO_STANZA.EXTENSION.length) {
				//window.console.log(NANO_STANZA.EXTENSION);
				var html = "<div id='extension'>";
				for (var i = 0; i < NANO_STANZA.EXTENSION.length; i++) {
					var item = NANO_STANZA.EXTENSION[i];
					html += "<p class='" + item.functionType + "'><a href='" + item.value + "' target='_blank'>" + item.label + "</a></p>";
				}
				html += "</div>";
				$body.append(html);
				var $extension = $("#extension");
				var height = $("p", $extension).height() * NANO_STANZA.EXTENSION.length;
				var exHeight = $extension.height();
				var padding = (exHeight - height) * .5;
				$extension.css("padding-top", padding + "px");
				window.console.log("height: "+height);
			}
		} catch(e) {
			//window.console.log(e);
		}
	}

});
