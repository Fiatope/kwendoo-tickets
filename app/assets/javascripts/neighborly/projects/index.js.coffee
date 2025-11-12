Neighborly.Projects = {} if Neighborly.Projects is undefined

Neighborly.Projects.Index =
  init: Backbone.View.extend
    initialize: ->
      $('.hero .expand-section').on 'click', (event)->
        event.preventDefault()
        $target = $(event.currentTarget)

        current_text = $target.text()
        $target.text($target.attr('data-alternative-text'))
        $target.attr('data-alternative-text', current_text)

        $('.hero .expand-section-content').slideToggle
          progress: ->
            $('.hero').backstretch('resize')
          start: ->
            if $(window).width() >= 1000
              if $('.invest-box').css('margin-top') == '20px'
                $('.invest-box').animate({'margin-top': '-9.375em'})
              else
                $('.invest-box').animate({'margin-top': '20px'})

      $('.sign-up-with-facebook').click (event)->
        event.preventDefault()
        value = $('.investment-prospect-value').val()
        $target = $(event.currentTarget)

        location.href = "#{$target.attr('href')}&investment_prospect_value=#{value}"

slideIndex = 0

carousel = ->
  x = document.getElementsByClassName('mySlides')
  i = 0
  if x.length > 0
    while i < 3
      x[i].style.display = 'none'
      i++
    slideIndex++
    if slideIndex > 3
      slideIndex = 1
    # Exploit of jQuery lib for fadeIn effect
    $(x[slideIndex - 1]).fadeIn('slow')
    setTimeout carousel, 6000
  return

carousel()