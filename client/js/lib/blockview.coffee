@blocks_horizontal = (canvas, dataset)->
  console.log dataset
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