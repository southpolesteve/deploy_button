# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $('input').on 'keyup',()->
    owner = $('input#owner').val()
    name = $('input#name').val()

    markdown = "[![Deploy to Heroku](https://deploy-button.herokuapp.com/deploy.png)](https://deploy-button.herokuapp.com/deploy/#{owner}/#{name})"
    html = "<a href='https://deploy-button.herokuapp.com/deploy/#{owner}/#{name}'><img alt='Deploy to Heroku' src='https://deploy-button.herokuapp.com/deploy.png'></a>"

    $('#markdown pre').text(markdown)
    $('#html pre').text(html)