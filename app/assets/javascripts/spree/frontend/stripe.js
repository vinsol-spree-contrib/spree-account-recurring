// Inspired by https://stripe.com/docs/stripe.js

mapCC = function(ccType){
  if(ccType == 'MasterCard'){
    return 'mastercard';
  } else if(ccType == 'Visa'){
    return 'visa';
  } else if(ccType == 'American Express'){
    return 'amex';
  } else if(ccType == 'Discover'){
    return 'discover';
  } else if(ccType == 'Diners Club'){
    return 'dinersclub';
  } else if(ccType == 'JCB'){
    return 'jcb';
  }
}

$(document).ready(function(){
  // For errors that happen later.
  Spree.stripePaymentMethod.prepend("<div id='stripeError' class='errorExplanation' style='display:none'></div>")

  $(".cardNumber").payment('formatCardNumber');
  $(".cardExpiry").payment('formatCardExpiry');
  $(".cardCode").payment('formatCardCVC');

  $('.continue').on('click', function(){
    $('#stripeError').hide();
    if(Spree.stripePaymentMethod.is(':visible')){
      expiration = $('.cardExpiry:visible').payment('cardExpiryVal')
      params = {
          number: $('.cardNumber:visible').val(),
          cvc: $('.cardCode:visible').val(),
          exp_month: expiration.month || 0,
          exp_year: expiration.year || 0
        };

      Stripe.card.createToken(params, stripeResponseHandler);
      return false;
    }
  });
});

stripeResponseHandler = function(status, response){
  if(response.error){
    $('#stripeError').html(response.error.message);
    $('#stripeError').show();
  } else {
    Spree.stripePaymentMethod.find('#card_number, #card_expiry, #card_code').prop("disabled" , true);
    Spree.stripePaymentMethod.find(".ccType").prop("disabled", false);
    Spree.stripePaymentMethod.find(".ccType").val(mapCC(response.card.type))
    token = response['id'];
    // insert the token into the form so it gets submitted to the server
    Spree.stripePaymentMethod.append("<input type='hidden' class='stripeToken' name='subscription[card_token]' value='" + token + "'/>");
    Spree.stripePaymentMethod.parents("form").get(0).submit();
  }
}