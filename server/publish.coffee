Meteor.publish "dataset", (id)->
  Datasets.find url: id