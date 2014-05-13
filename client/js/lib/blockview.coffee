@blocks_horizontal = (canvas, dataset)->
  letter_size = 3
  line_length = 50

  canvas.width = (dataset.length + 1) * (line_length * letter_size + 5 * letter_size)

  c = canvas.getContext("2d")

  x0 = 0
  y = 0
  l = 0

  y_max = 0

  for section in dataset
    do (section)->
      x = x0
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