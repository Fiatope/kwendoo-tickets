//= require jquery.js
// require jquery.turbolinks
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require jquery.pjax
//= require foundation
//= require bootstrap-sprockets
//= require dropzone
//= require best_in_place
//= require ./lib/underscore.js
//= require ./lib/backbone.js
//= require neighborly/neighborly.js
//= require init.js
//= require custom
//= require_tree ./lib
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-pjax
//= require nprogress-ajax
//= require neighborly-mangopay-creditcard
//= require neighborly-admin
//= require jquery.ui.datepicker
//= require cocoon

var loaded = function(){

	document.addEventListener("turbolinks:load", function() {

		$("#question1").click(function(){
			$("#answer1").toggleClass("bounce");
		});
	
		$("#question2").click(function(){
			$("#answer2").toggleClass("bounce");
		});
	
		$("#question3").click(function(){
			$("#answer3").toggleClass("bounce");
		});
	
		$("#question4").click(function(){
			$("#answer4").toggleClass("bounce");
		});
	
		$("#question5").click(function(){
			$("#answer5").toggleClass("bounce");
		});
	
		$("#question6").click(function(){
			$("#answer6").toggleClass("bounce");
		});
	
		$("#question7").click(function(){
			$("#answer7").toggleClass("bounce");
		});
	
		$("#question8").click(function(){
			$("#answer8").toggleClass("bounce");
		});
	
		$("#question9").click(function(){
			$("#answer9").toggleClass("bounce");
		});
	
		$("#question10").click(function(){
			$("#answer10").toggleClass("bounce");
		});
	
		$("#question11").click(function(){
			$("#answer11").toggleClass("bounce");
		});
	
		$("#question12").click(function(){
			$("#answer12").toggleClass("bounce");
		});
	
		$("#question13").click(function(){
			$("#answer13").toggleClass("bounce");
		});
	
		$("#question14").click(function(){
			$("#answer14").toggleClass("bounce");
		});
	
		$("#question15").click(function(){
			$("#answer15").toggleClass("bounce");
		});

		$("#question16").click(function(){
			$("#answer16").toggleClass("bounce");
		});

		$("#question17").click(function(){
			$("#answer17").toggleClass("bounce");
		});

		$("#question18").click(function(){
			$("#answer18").toggleClass("bounce");
		});

		$("#question19").click(function(){
			$("#answer19").toggleClass("bounce");
		});

		$("#question20").click(function(){
			$("#answer20").toggleClass("bounce");
		});

		$("#question21").click(function(){
			$("#answer21").toggleClass("bounce");
		});

		if ($('#project_about, #project_budget, #project_english, #project_terms').length) {
			$('#project_about, #project_budget, #project_english, #project_terms').markItUp(Neighborly.markdownSettings);
		}

		if ($('#profile_how_it_works, #profile_submit_your_project_text').length) {
			$('#profile_how_it_works, #profile_submit_your_project_text').markItUp(Neighborly.markdownSettings);
		}

		if ($('.contribution-info').length) {
			$('.contribution-info').on('click', function() {
				$('#' + $(this).data('reveal-id')).modal('show');
				return false;
			});
		}

		if ($('.flash').length) {
			$('.flash .dismissible a.close').on('click', function() {
				$('.flash .alert-box.dismissible').fadeOut("slow", "swing");
				return false;
			});

			setTimeout(function() {
				$('.flash .alert-box.dismissible').fadeOut("slow", "swing");
			}, 3000);
		}

		$('#contribution_form_currency').on('change', function(event) {

			if ($('#contribution_form_currency option:selected').text() == "EUR"){
		  
			  $('.label-ammount').text("Veuillez entrer une valeur entre 10 et 300€");
		  
			  $('#contribution_form_value').attr('min', 10);
		  
			  $('#contribution_form_value').attr('max', 300);
		  
			} else {
		  
			  $('.label-ammount').text("Veuillez entrer une valeur entre 3000 et 200000 RWF");
		  
			  $('#contribution_form_value').attr('min', 3000);
		  
			  $('#contribution_form_value').attr('max', 20000);
		  
			}
		  
		});

		if ($('.payment-method[data-path]').length) {
			$('.payment-method[data-path]').on('focusin', function() {
				$(this).find('form.payment').on('change', function() {
					if ($(this).find('input[type=radio]').length) {
						if ($(this).find('input[type=radio]:checked').val() == 'new') {
							$(this).find('.add-new-creditcard-form').removeClass('hide');
						} else {
							$(this).find('.add-new-creditcard-form').addClass('hide');
						}
					}
				});

				$(this).off('focusin');
			});
		}

		if ($('.js-load-more').length) {
			var page = $('.contributions-page');

			var loader = $('.contributions-loading img');
			var loaderDiv = $('.contributions-loading');
			var filter = { page: 2 };
	  
			$('.js-load-more').click(function(){
				loader.show();

				$.ajax({
					url: page.data('path') + '?page=' + filter.page,
					type: 'GET',
					success: function(data) {
						var dataDiv = $(data).filter('div');

						if (dataDiv.length) {
							page.find('.list .custom-tooltip > a').unbind('click');

							page.find('.list').append(dataDiv);

							if (page.find('.list .custom-tooltip > a').length) {
								page.find('.list .custom-tooltip > a').on('click', function() {
									var tooltipContent = $(this).parents('.custom-tooltip').find('.tooltip-content');
									$('.tooltip-content').not('.hide').not(tooltipContent).toggleClass('hide');
									tooltipContent.toggleClass('hide');
									return false;
								});
							}
					
							filter.page += 1;
						}

						loader.hide();
					}
				});
		
				return false;
			});
		}

		if ($('.hidden-description').length) {
			$('.hidden-description').on('click', function() {
				$(this).toggleClass('active');
			});
		}

		var nameCookie = 'cookie-consent';
		var expireDay = 365;

		if (getCookie(nameCookie) === undefined) {
			setTimeout(function () {
				$("#cookieConsent").fadeIn(200);
				$("#cookieConsentModal").modal('show');
			}, 1500);
		}

		$("#closeCookieConsent").click(function() {
			$("#cookieConsent").fadeOut(200);
		});

		$(".cookieConsentOK").click(function() {
			var consentOK = 'yes';

			if ($('#cookie_session').is(":checked")) {
				consentOK += ',cs';
			}

			if ($('#cookie_google_analytics').is(":checked")) {
				consentOK += ',cga';
			}

			setCookie(nameCookie, consentOK, expireDay);

			$("#cookieConsent").fadeOut(200);
			$("#cookieConsentModal").modal('hide');
		});

		$(".cookieConsentKO").click(function() {
			setCookie(nameCookie, 'no', expireDay);

			$("#cookieConsent").fadeOut(200);
			$("#cookieConsentModal").modal('hide');
		});

		$(".openCookieConsentModal").click(function(){
			$("#cookieConsentModal").modal('show');
		
			return false;
		});

		$('#cookieConsentModal .modal-footer button').on('click', function(event) {
			var consentBtn = $(event.target); // The clicked button
		  
			$(this).closest('.modal').one('hidden.bs.modal', function() {
				// Fire if the button element 

				if (consentBtn.data('accepte') == 'yes') {
					var consentOK = 'yes';

					if ($('#cookie_session').is(":checked")) {
						consentOK += ',cs';
					}

					if ($('#cookie_google_analytics').is(":checked")) {
						consentOK += ',cga';
					}
		
					setCookie(nameCookie, consentOK, expireDay);
		
					$("#cookieConsent").fadeOut(200);
				}

				if (consentBtn.data('accepte') == 'no') {
					setCookie(nameCookie, 'no', expireDay);

					$("#cookieConsent").fadeOut(200);
				}
			});
		});

		if ($('.flash').length) {
			setTimeout(function(){
				$('.flash .alert-box.dismissible').slideUp('slow');
			}, 15000);

			$('.flash .dismissible a.close').click(function(){
				$('.flash .alert-box.dismissible').slideUp('slow');
			
				return false;
			});
		}
	});
}

function checkMobileMoneyPaymentSuccess(contribution_id) {
	$.ajax({
	  url: "/contributions/"+contribution_id+"/check_mobile_money_payment_success",
	  type: "GET",
	  success: function(data) {
		if (data.responseText == "confirmed" || data.responseText == "canceled") {
		  window.location = "."
		}
	  },
	  error: function(data) {
		if (data.responseText == "confirmed" || data.responseText == "canceled") {
		  window.location = ".";
		}
	  }
	});
	setTimeout(function() {
	  checkMobileMoneyPaymentSuccess(contribution_id);
	}, 10000);
}

function getCookie(name) {
    var matches = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return matches ? matches[2] : undefined;
}

function setCookie(name, value, days) {
    var d = new Date;
    d.setTime(d.getTime() + 24*60*60*1000*days);
    document.cookie = name + "=" + value + ";path=/;expires=" + d.toGMTString();
}

function deleteCookie(name) { setCookie(name, '', -1); }

$(document).on("page:load ready", loaded);
