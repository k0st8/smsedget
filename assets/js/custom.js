$(document).ready(function () {
	$('#filterData .input-daterange').datepicker({
		todayHighlight: true,
		format:	'yyyy-mm-dd',
		endDate: '+0d',
		autoclose: true
	});

	$('form').on('submit', function(e){
		e.preventDefault();
		// console.log($(this).serializeArray());
		if(window.location.pathname === '/statistics/'){
			var url = window.location.origin + window.location.pathname +'getFilteredData';
console.log(url);
		$.get(url, $(this).serializeArray())
			.done(function(data){
				console.log(data);
				if(data.length > 2){
				// 
					var tbody = $('#statResult').empty();
					// table
					$.each(JSON.parse(data),function(i,v){
						// Create tr
						var tr = $('<tr/>')
						.add('<td/>', {text:v.usr_id})
						.add('<td/>', {text:v.cnt_title})
						.add('<td/>', {text:v.log_success})
						.add('<td/>', {text:v.log_fail})
						.add('<td/>', {text:v.log_created});
						tbody.append(tr);
					});	
				}
			});
		}
	})
});
