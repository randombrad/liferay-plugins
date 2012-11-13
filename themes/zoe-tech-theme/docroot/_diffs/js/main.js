AUI().ready(
	'aui-io',
	'event-move',
	'node-base',
	'node-event-delegate',
	'transition',
	/*
	This function gets loaded when all the HTML, not including the portlets, is
	loaded.
	*/

	function (A) {
		var body = A.one('body');
		var html = A.one('html');
		var navigation = A.one('#navigation')
		var toggle = A.one('#toggle');

		if (html.hasClass('mobile')) {
			navigation.removeClass('sort-pages modify-pages');

			if(toggle) {
				toggle.on(
					'click',
					function (e) {
						body.toggleClass('show-nav');			
					}
				);
			};

			body.all('.desktop-link').on(
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

			body.on(
				"gesturemovestart", 
				function (e) {
					var item = e.currentTarget;
					var MIN_SWIPE = 20;
					var target = e.target;

					item.setData("swipeStart", e.pageX);

					item.once(
						"gesturemoveend",
						function (e) {
							var swipeStart = item.getData("swipeStart");
							var swipeEnd = e.pageX;
							var isSwipeLeft = (swipeStart-swipeEnd) > MIN_SWIPE;
							var isSwipeRight = (swipeEnd-swipeStart) > MIN_SWIPE;
							var navOut = body.hasClass('show-nav');
							var swipeLeft = isSwipeLeft && navOut;
							var swipeRight = isSwipeRight && !navOut;

							if (swipeLeft || swipeRight) {
								body.toggleClass('show-nav');
							}
						}
					)					
				}
			)
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