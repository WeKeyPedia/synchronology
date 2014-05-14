datasets = new Meteor.Collection("datasets");

Template.smallview_page.prepare = ()->
  # HTTP.get "http://api.localhost/page/test/raw",()->
  #   console.log "plop"
  Meteor.subscribe "dataset", "en/crimea/blocks"

Template.smallview_page.draw = (canvas_element)->
  data = datasets.findOne url: "en/crimea/blocks"

  console.log data

  if (data)
    blocks_horizontal canvas_element, data.dataset

Template.smallview_page.rendered = ()->
  Deps.autorun ()=>
    Template.smallview_page.prepare "dataset", "en/crimea/blocks"
#    Template.smallview_page.prepare()
    Template.smallview_page.draw @find "canvas"