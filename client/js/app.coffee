datasets = new Meteor.Collection("datasets");

Template.smallview_page.helpers 
  prepare: (url)->
    Meteor.subscribe "dataset", "#{url}/blocks"

  draw: (canvas_element, url)->
    data = datasets.findOne url: "#{url}/blocks"

    # console.log data

    if (data)
      blocks_horizontal canvas_element, data.dataset

Template.smallview_page.rendered = ()->
  console.log @

  Deps.autorun ()=>
    Template.smallview_page.prepare @data.page.url
#    Template.smallview_page.prepare()
    Template.smallview_page.draw @find("canvas"), @data.page.url


Template.app.pages = ()->
  l = [ "crimea", "ukraine" ]

  r = []

  for i in l
    r.push
      page:
        title: "#{i}"
        url: "en/#{i}"

  r