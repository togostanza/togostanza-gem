$(function(){

	var $w = $(window),
		$html = $("html"),
		$body = $("body"),
		screenWidth = $body.width(),
		screenHeight = $body.height(),
		MIDDLE_FONT_SIZE = 20,
		TICK_FONT_SIZE = 8,
		BASE_WIDTH = 12,
		BASE_COLOR = "#249eb3",
		GRAYISH_BASE_COLOR = "#d5e0dc",
		BLACK_COLOR = "#333030",
		GRAY_COLOR = "#bfbeba",
		LIGHT_GRAY_COLOR = "#e5e5e4",
		PH_COLORS = [ "#bf1e2e", "#f13e37", "#fcb040", "#8cc63e", "#24a9e2", "#283890", "#93268f" ],
		SVG_START = "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' id='svg-root' width = '" + screenWidth + "' height='" + screenHeight + "'>";

	{ // font size
		$(".text-size-adjust").each(function(){
			var $this = $(this);
			$this.wrapInner("<span style='white-space: nowrap;'>");
			var $inner = $("span", $this);
			var w1 = $inner.width();
			var w2 = screenWidth - 40;
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
			}
		} catch(e) {
			//window.console.log(e);
		}
	}
	{ // growth temperature
		if ($body.has(".growth-temperature").length > 0) {
			var html = SVG_START;
			html += "\
			<line x1='0' y1='68.5' x2='" + screenWidth + "' y2='68.5' class='stroke-light-gray dash' />\
			<line x1='0' y1='114.5' x2='" + screenWidth + "' y2='114.5' class='stroke-light-gray dash' />\
			<text x='24' y='72' class='font-size-small fill-black text-anchor-middle' >45°</text>\
			<text x='24' y='118' class='font-size-small fill-black text-anchor-middle' >20°</text>\
			<circle cx='43' cy='31' r='6' class='thermophile' />\
			<rect x='37' y='31' width='12' height='38' class='thermophile' />\
			<rect x='37' y='69' width='12' height='46' class='mesophile' />\
			<rect x='37' y='115' width='12' height='25' class='psychrophile' />\
			<circle cx='43' cy='138' r='14' class='psychrophile' />\
			<text x='" + (screenWidth - 25) + "' y='56' class='font-size-middle fill-black bold text-anchor-end' >" + $(".datum[data-temperature='thermophile']").text() + "</text>\
			<text x='" + (screenWidth - 25) + "' y='99' class='font-size-middle fill-black bold text-anchor-end' >" + $(".datum[data-temperature='mesophile']").text() + "</text>\
			<text x='" + (screenWidth - 25) + "' y='142' class='font-size-middle fill-black bold text-anchor-end' >" + $(".datum[data-temperature='psychrophile']").text() + "</text>";
			// close
			html += "</svg>";
			$("#main-view").append(html);
		}
	}
	{ // pie chart
		if ($body.has(".pie-chart").length > 0) {
			var data = [],
				html = SVG_START,
				sum = 0, currentRadian = -Math.PI * .5,
				centerX = screenWidth * .5,
				centerY = screenHeight * .5 + 7,
				$chart = $(".pie-chart"),
				RADIUS = 50;
			$(".datum").each(function(){
				var $datum = $(this);
				data.push({
					value: parseFloat($datum.text()),
					name: $datum.data("name")
				});
				sum += data[data.length - 1].value;
			});
			// chart
			html += "<g fill='none' stroke-width='" + BASE_WIDTH + "'>"
			for (var i = 0; i < data.length; i++) {
				var ratio = data[i].value / sum,
					radian = Math.PI * 2 * ratio,
					color = BASE_COLOR,
					largeArcFlag = ratio > .5;
				// color
				if ($chart.hasClass("gc-content")) {
					if (data[i].name == "at") color = GRAYISH_BASE_COLOR;
				}
				// arc
				html += "<path d='M " + (Math.cos(currentRadian) * RADIUS + centerX) + "," + (Math.sin(currentRadian) * RADIUS + centerY) + " A " + RADIUS + "," + RADIUS + " 0 " + (largeArcFlag ? 1 : 0) + ",1 " + (Math.cos(currentRadian + radian) * RADIUS + centerX) + "," + (Math.sin(currentRadian + radian) * RADIUS + centerY) + "' stroke='" + color + "' />";
				currentRadian += radian;
			}
			html += "</g>";
			// text
			html += "<text x='" + centerX + "' y='" + (centerY + 13) + "' dx='5' class='fill-black text-anchor-middle' ><tspan class='font-size-large bold'>" + $(".datum[data-name='gc']").text() + "</tspan><tspan class='unit'>" + $chart.data("unit") + "</tspan></text>";
			// close
			html += "</svg>";
			$("#main-view").append(html);
		}
	}
	{ // bar chart
		if ($body.has(".bar-chart").length > 0) {
			var data = [],
				html = SVG_START,
				maxValue = 0, maxValueString = "", sum = 0,
				colWidth, barWidth, marginLeft, strokeColor,
				$chart = $(".bar-chart"),
				xGraduationsPar = parseFloat($chart.data("xGraduationsPar"));
				BASE_Y = 114,
				MARGIN_X = 16,
				MAX_HEIGHT = 88,
				BAR_MIN_SPACE = 1,
				FONT_SIZE_SMALL = 12,
				TICKS = {
					"0": [],
					"1": [.5, 1],
					"2": [1, 2],
					"3": [1, 2, 3],
					"4": [2, 4],
					"5": [2, 4],
					"6": [3, 6],
					"7": [3, 6],
					"8": [4, 8],
					"9": [4, 8]
				};
			$(".datum").each(function(){
				var $datum = $(this),
					value = parseFloat($datum.text());
				data.push({
					value: value,
					x: $datum.data("x")
				});
				sum += data[data.length - 1].value;
				maxValue = maxValue < value ? value : maxValue;
			});
			maxValueString = Math.ceil(maxValue) + "";
			marginLeft = TICK_FONT_SIZE * maxValueString.length + TICK_FONT_SIZE;
			// background: x
			html += "<line x1='0' y1='" + (BASE_Y + .5) + "' x2='" + screenWidth + "' y2='" + (BASE_Y + .5) + "' class='stroke-gray' />";
			colWidth = (screenWidth - MARGIN_X * 2 - marginLeft) / data.length;
			barWidth = (colWidth - BAR_MIN_SPACE) < BASE_WIDTH ? colWidth - BAR_MIN_SPACE : BASE_WIDTH;
			for (var i = 0; i <= data.length; i++) {
				var x = (MARGIN_X + marginLeft + colWidth * i), xGraduation;
				if (i < data.length) {
					xGraduation = data[i].x;
				} else {
					xGraduation = data[i - 1].x + (data[i - 1].x - data[i - 2].x);
				}
				if ((i % xGraduationsPar) == 0) {
					html += "\
					<line x1='" + x + "' y1='0' x2='" + x + "' y2='" + screenHeight + "' class='stroke-light-gray dash' />\
					<text x='" + x + "' y='" + (BASE_Y + 14) + "' class='font-size-small fill-black text-anchor-middle' >" + xGraduation + "</text>";
				}
			}
			// background: y
			var ticks = TICKS[maxValueString.charAt(0)];
			for (var i = 0; i < ticks.length; i++) {
				var tick = ticks[i];
				var y = BASE_Y - MAX_HEIGHT * (tick / parseInt(maxValueString.charAt(0)));
				var tick2 = Math.pow(10, maxValueString.length) * tick * .1;
				html += "\
				<line x1='0' y1='" + y + "' x2='" + screenWidth + "' y2='" + y + "' class='stroke-gray dash' />\
				<text x='" + (MARGIN_X + marginLeft - TICK_FONT_SIZE + 4) + "' y='" + (y + FONT_SIZE_SMALL * .5 - 2) + "' class='font-size-small fill-black text-anchor-end' >" + tick2 + "</text>";
			}
			// data
			strokeColor = BASE_COLOR;
			for (var i = 0; i < data.length; i++) {
				switch ($chart.data("xAxisUnit")) {
					case "pH":
					strokeColor = PH_COLORS[i];
					break;
				}
				var x = (MARGIN_X + marginLeft + colWidth * i) + colWidth * .5;
				var barHeight = maxValue == 0 ? 0 : MAX_HEIGHT * (data[i].value / maxValue);
				html += "\
				<line x1='" + x + "' y1='" + BASE_Y + "' x2='" + x + "' y2='" + (BASE_Y - barHeight) + "' stroke='" + strokeColor + "' stroke-width='" + barWidth + "' />";
			}
			// sum
			html += "<text x='" + (screenWidth * .5) + "' y='" + (BASE_Y + 36) + "' class='font-size-middle fill-black bold text-anchor-middle' >" + sum + "</text>"
			// close
			html += "</svg>";
			$("#main-view").append(html);
		}
	}

	{ // vertical-centering
		if ($body.has(".vertical-centering").length > 0) {
			$(".vertical-centering").each(function(){
				$this = $(this);
				window.console.log($this.outerHeight());
				$this.css({
					position: "relative",
					top: (screenHeight - $this.outerHeight()) * .5 + 8
				})
			})
		}
	}

});
