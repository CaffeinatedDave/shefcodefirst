console.info("I see you looking at my source....");

$('.imgbox img').mouseenter(
  function() {$(this).removeClass('grey')}
).mouseleave(
  function() {$(this).addClass('grey')}
)

$('#cookieAccept').on('click', function() {
  console.info('Accepted Cookies...')
  document.cookie = "acceptCookies=Y; expires=31 Dec 9999 12:00:00 UTC; path=/";
  $('#cookieBanner').hide();
});
