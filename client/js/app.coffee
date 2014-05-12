Template.smallview_page.draw = (canvas_element)->
  c = canvas_element.getContext("2d")

  c.fillStyle = "#FF0000"
  c.fillRect(0,0,150,75)

Template.smallview_page.rendered = ()->
  Template.smallview_page.draw @find "canvas"