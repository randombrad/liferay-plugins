AUI().use(
	'get',
	function(A){
		if (A.one('.flexslider')){
			A.Get.script(Liferay.ThemeDisplay.getPathThemeRoot() + 'js/jquery.flexslider-min.js', {
	       		onSuccess: function(){
	           		console.log('Flexslider has been loaded');
	      		}
	 		});
		}
	}
);