@blocks_horizontal = (canvas, dataset)->
  # console.log dataset
  letter_size = 2
  line_length = 75

  canvas.width = (dataset.blocks.length + 1) * (line_length * letter_size + 5 * letter_size)
  canvas.height = 388

  c = canvas.getContext("2d")

  x0 = 0
  y = 0
  l = 0

  y_max = 0

  draw = (silent)->  
    for section,key in dataset.blocks
      do (section,key)->
        x = x0

        y_max = Math.max y, y_max
        y = 0

        next_is_title = true

        for word in section
          do (word)->
            if(word == 0)
              y += letter_size * 2
              l = 0
              x = x0
            else
              if next_is_title

                c.fillStyle = "#555"
                c.fillRect(x, y,  word * letter_size, letter_size)

                l = 0
                y += letter_size * 2

                next_is_title = false
              else
                if(l+word > line_length)
                  y += letter_size * 2
                  l = 0
                  x = x0

                c.fillStyle = "#aaa"
                c.fillRect(x, y,  word * letter_size, letter_size)
                l += word + 1
                x += word * letter_size + letter_size
      
      x0 += line_length * letter_size + letter_size * 5


  draw()
  canvas.height = y_max

  # We had to draw twice because of the resizing

  x0 = 0
  y = 0
  l = 0
  draw()

#  console.log y_max
  return true

@evolution_chart = (canvas, dataset)->
  # console.log dataset
  c = canvas.getContext("2d")

  size_day = 2

  frame =
    start: moment(dataset[0].timestamp).format("X")
    end: moment(dataset[dataset.length - 1].timestamp).format("X")

  console.log frame

  timeline = _(dataset).reduce (memo,revision)->
    ts = moment(revision.timestamp).format("YYYY-MM-DD")

    if not(Array.isArray(memo[ts]))
      memo[ts] = []

    memo[ts].push revision.revid

    memo
  , {}

  max_length = 0

  _(timeline).each (t)->
    max_length = Math.max max_length, t.length

  console.log "max length", max_length

  # timeline = _(timeline).sortBy (v,k)-> -k

  console.log timeline

  c.font = "8px"

  offset_x = moment(frame.start, "X").format("X") - moment(frame.start, "X").startOf("year").format("X")
  offset_x = parseInt( offset_x * size_day/ ( 60 * 60 * 24 ))

  # console.log moment(frame.start, "X").format("X"), moment(frame.start, "X").startOf("year").format("X")
  # console.log "offset x", offset_x

  canvas.width = parseInt((moment().format("X") - frame.start) * size_day / (60*60*24)) + offset_x + 1
  canvas.height = 30

  # console.log timeline.length

  # draw current day bar
  day = moment().format("X")

  x = 0.5 + offset_x + parseInt( size_day * (moment().format("X") - frame.start) / (60 * 60 * 24 ))
  console.log "x", x
  c.strokeStyle = "#e4b45e"
  c.strokeWeight = 1
  c.beginPath()
  c.moveTo(x, 0)
  c.lineTo(x, 30)
  c.stroke()

  for year in [moment(frame.start, "X").format("YYYY")..moment(frame.end, "X").add('y',1).format("YYYY")]
    y = year - moment(frame.start, "X").format("YYYY")

    # console.log year
    # console.log y

    x = 0.5 + y * 360 * size_day

    c.strokeStyle = "#ddd"

    c.beginPath()
    c.moveTo(x, 0)
    c.lineTo(x, 30)
    c.stroke()

    c.strokeText year, x+3, 8

  c.beginPath()
  c.moveTo(offset_x,30)
  c.fillStyle = "#aaa"
  c.strokeStyle = "#aaa"
  _(timeline).each (t,k)->
    ts = moment(k, "YYYY-MM-DD").format("X")
    # console.log "ts", ts
    x = offset_x + parseInt((ts - frame.start) / ( 60 * 60 * 24 )) * size_day
    # console.log "x", x
    y = 30 - (t.length / max_length) * 30
    # console.log "y", y
    #c.fillRect x,y,2,2
    c.lineTo(x,y)

  c.stroke()