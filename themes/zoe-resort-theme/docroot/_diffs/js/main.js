AUI().ready(
	'aui-io',
	'node-scroll-info',

	/*
	This function gets loaded when all the HTML, not including the portlets, is
	loaded.
	*/

	function(A) {
		var body = A.one('body');
		var banner	= A.one('#banner');
		var navigation = A.one('#navigation');
		var li = navigation.all('li').get('clientWidth');
		var ul = navigation.one('ul');
		var width  = 0;

		if (body.hasClass('mobile')) {
			for (x in li) {
				width = width + li[x];
			}

			ul.setStyle('width', width);

			body.one('#desktop-link').on(
				'click',
				function (e) {
					body.toggleClass('mobile-enabled')
					
					A.io.request(
						themeDisplay.getPathMain() + '/portal/session_click',
						{
							data: {
								'mobile-enabled': body.hasClass('mobile-enabled')
							}
						}
					);
					window.location.reload(true);		
				}
			);

			A.on(
				'scroll', 
				function (e) { 
					var scrollHeight = window.scrollY > 240;
					var scrollHeightUnder = window.scrollY <= 240;

					if (scrollHeight) {
						banner.addClass('fixed-nav');
					}else if (banner.hasClass('fixed-nav') && scrollHeightUnder) {
						banner.removeClass('fixed-nav');
					}
				}
			);
			navigation.plug(A.Plugin.ScrollInfo);

			if (navigation.get('clientWidth') < (width)) {
				banner.addClass('rightArrow');
				
				navigation.on(
					'scroll',
					function (e) {
						var navScrollInfo = navigation.scrollInfo.getScrollInfo();

						if (!navScrollInfo.atLeft) {
							banner.addClass('leftArrow');
						}
						else if (navScrollInfo.atLeft) {
							banner.removeClass('leftArrow');
						}

						if (!navScrollInfo.atRight) {
							banner.addClass('rightArrow');
						}
						else if (navScrollInfo.atRight) {
							banner.removeClass('rightArrow');
						}
					}
				);
			}
			
			var scroll = function (node, dist) {
				node.on(
					'click',
					function (e) {
						var scrollLeft = navigation.get('scrollLeft');
						navigation.set('scrollLeft', scrollLeft + dist);
					}
				);
			};

			scroll (banner.one('#scroll-left'), -50);
			scroll (banner.one('#scroll-right'), 50);
		}
	}
);


Liferay.Portlet.ready(

	/*
	This function gets loaded after each and every portlet on the page.

	portletId: the current portlet's id
	node: the Alloy Node object of the current portlet
	*/

	function(portletId, node) {
	}
);

Liferay.on(
	'allPortletsReady',

	/*
	This function gets loaded when everything, including the portlets, is on
	the page.
	*/

	function() {
	}
);