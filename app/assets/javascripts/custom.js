var loaded_ticket = function(){
	document.addEventListener("turbolinks:load", function() {
    $("[id^='contribution_form_ticket_categories_orders_attributes_'][id$='_count']").on("change", function() {
      refreshPrice($(this), null);
    });
    $("[id^='contribution_form_ticket_categories_orders_attributes_'][id$='_count']").each(function() {
      refreshPrice($(this), null);
    });
    $("[id^='promotions_']").on("change", function() {
      checkCode($(this), null);
    });
  });
}

function checkCode($el, $prev) {
  var $ele = $el.closest(".user-ticket");

  $ele.find("input[type='hidden'][name^='user_tickets'][name*='code']").prop('disabled', true);
  $ele.find("input[type='hidden'][name^='user_tickets'][name*='promotion_id']").prop('disabled', true);
  var $index = null;

  $ele.find("input[type='hidden'][name^='user_tickets'][name*='code']").each(function(i) {
    if ($el.val().trim().toUpperCase() === $(this).val().trim().toUpperCase()) {
      $(this).prop('disabled', false);
      $index = i;
      return false;
    }
  });

  if ($index !== null) {
    $el.removeClass('alert');
    $ele.find("input[type='hidden'][name^='user_tickets'][name*='promotion_id']").each(function(i) {
      if ($index == i) {
        $(this).prop('disabled', false);
      }
    });
  }else{
    if ($el.val().trim() == '') {
      $el.removeClass('alert');
    }else{
      $el.addClass('alert');
    }
  }
}

function refreshPrice($el, $prev) {
  var price = $el.closest(".nested-fields").find(".ticket_price").html();
  var max_tickets = $el.closest(".nested-fields").find(".reward-container").data("remaining");
  var user_ticket = $el.closest(".user-ticket");
  var n_tickets = parseInt($el.val());
  var tickets = parseInt(user_ticket.data('tickets'));
  var couple = parseInt(user_ticket.data('couple'));
  var total_price = 0.0;

  if ($prev !== null) {
    tickets = $prev;
  }

  if (n_tickets < 0) {
    $el.val(0);
    refreshPrice($el, 0);
    return;
  } else if (n_tickets > max_tickets) {
    $el.val(max_tickets);
    refreshPrice($el, max_tickets);
    return;
  }

  user_ticket.data('tickets', n_tickets);

  if (user_ticket.children(".form-group.ticket").length) {
    user_ticket.children(".form-group.ticket").remove();
  }

  for(var i=0; i<n_tickets*couple; i++){
    var $ele = user_ticket.children(".form-group").eq(0).clone();

    $ele.find("input[type='hidden']").prop('disabled', false);
    $ele.find("input[type='text']").prop('disabled', false);
    $ele.find("input[type='text']").attr('placeholder', $ele.find("input[type='text']").attr('placeholder').replace('#', i+1));
    $ele.find("input[type='email']").prop('disabled', false);
    $ele.find("input[type='email']").attr('placeholder', $ele.find("input[type='email']").attr('placeholder').replace('#', i+1));
    $ele.addClass('ticket');
    $ele.show();

    user_ticket.append($ele);
  }

  price = parseFloat(price);
  
  $el.closest(".nested-fields").find(".price-container").html(n_tickets*price);

  $(".price-container").each(function() {
    if ($(this).html() == "") { return; }
    total_price = total_price + parseFloat($(this).html());
  })
  $("#total_price_container").html(total_price);
}

$(document).on("page:load ready", loaded_ticket);
