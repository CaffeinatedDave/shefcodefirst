console.info("I see you looking at my source....");

$('.imgbox img').mouseenter(
  function() {$(this).removeClass('grey')}
).mouseleave(
  function() {$(this).addClass('grey')}
)
