$(document).ready(function() {

  function changeNavContent() {
    if($(document).scrollTop() > 50) {
      $('.navbar-logo').css({display: 'none'});
      $('.nav-bar-list').css({
        position: 'relative',
        top: '-22px'
      });
      $('.navbar-laptop-lighttheme').css({height: '70px'});
      $('.content-lighttheme').css("padding-top", '110px');
      if ($('.alert.alert-dismissible')) {$('.alert.alert-dismissible').css("top", '70px');}
    } else {
      $('.navbar-logo').css({display: 'flex'});
      $('.nav-bar-list').css({
        position: 'relative',
        top: '0px'
      });
      $('.navbar-laptop-lighttheme').css({height: '195px'});
      $('.content-lighttheme').css("padding-top", '187px');
      if ($('.alert.alert-dismissible')) {$('.alert.alert-dismissible').css("top", '190px');}
    }
  }

  $(document).scroll(function() {
    changeNavContent();
  });
})
