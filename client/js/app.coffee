datasets = new Meteor.Collection("datasets");
urls= new Meteor.Collection("urls");

api_endpoint = "http://api.localhost"

Template.smallview_page.helpers 
  prepare: (url)->
    Meteor.subscribe "dataset", "#{url}/blocks"

  draw: (canvas_element, data)->
    if (data)
      blocks_horizontal canvas_element, data.data

  draw_timeline: (canvas_element, data)->
    if (data)
      evolution_chart canvas_element, data.data
      # @center_timeline()

  center_timeline: (canvas_container)->
    # console.log canvas_container

    $container = $(canvas_container)
    $canvas = $(canvas_container).children("canvas")

    day = moment().format("X")

    x = parseInt( -$canvas.width() + 40 + 2*(moment().endOf("year").format("X") - day)/(60*60*24) + ($container.width()/2))
    # console.log "center_offset", x
    $canvas.css({ left: "#{x}px"})

Template.smallview_page.created = ()->
#  console.log @

Template.smallview_page.rendered = ()->
#  console.log @data
  lang = @data.page.lang
  page = @data.page.title
  revid = @data.page.revid

  blocks_url = "#{api_endpoint}/page/#{lang}.wikipedia.org/wiki/#{page}/revision/#{revid}/blocks"
  timeline_url = "#{api_endpoint}/page/#{lang}.wikipedia.org/wiki/#{page}/timeline"

  # console.log blocks_url

  HTTP.get timeline_url, (e,d)=>
    Template.smallview_page.draw_timeline(@find(".evolution_chart"), d)
    Template.smallview_page.center_timeline(@find(".evolution_chart-container"), d)

  HTTP.get blocks_url, (e,d)=>
    Template.smallview_page.draw(@find(".smallview"), d)

Template.app.current_t_position = ()->
  return moment(Date.now()).format()

Template.app.rendered = ()->
  Deps.autorun ()=>
    Meteor.subscribe "urls"

    sample = urls.findOne {}

    if (sample)
      console.log sample.set

      set = sample.set

      regexp2 = ///
      http:\/\/
      ([a-z]*
      \.wikipedia.org\/wiki\/
      .*)
      ///

      for url in set
#        console.log url

        matches = regexp2.exec url
        full_url = matches[1]
        query = "#{api_endpoint}/page/#{full_url}"
        # console.log matches

        HTTP.get query,(e,d)=>
          url = full_url
          last_rev = d.data.datasets.latest_rev
          url_blocks = "#{query}/revision/#{last_rev}"

#          console.log url_blocks

          smallview_info = 
            page:
              url: url
              revid: d.data.datasets.latest_rev
              revisions: d.data.datasets.revisions
              lang: d.data.lang
              title: d.data.page

          # console.log smallview_info

          el = @find("#pages")
          UI.insert UI.renderWithData(Template.smallview_page,smallview_info), el