Meteor.publish "dataset", (id)->
  Datasets.find url: id


Meteor.publish "urls", ()->
  Urls.find {}