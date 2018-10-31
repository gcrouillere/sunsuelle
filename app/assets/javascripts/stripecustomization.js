$(document).ready(function() {
  if ($('.stripe-button.active')) {
    if ($('.stripe-button.active').attr("data-locale") == "fr") {
      $('.stripe-button-el span').text("Payer par carte");
    }
  }
});
