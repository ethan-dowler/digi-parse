# for the source html
def parse_source
  puts "parsing source..."

  File.open("./source.html") do |source_file|
    contents = source_file.read

    contents.gsub!(",", "")
    contents.gsub!("\n", "")
    contents.gsub!(/<table +style=/, "\n<table style=\"margin: 0")
    contents.gsub!("</tbody></table>", "</tbody></table>\n")

    contents.split("\n").each.with_index do |line, index|
      next if index.zero?

      File.open("./rows/row_#{index - 1}.txt", "w+") do |new_file|
        new_file.write(line)
      end
    end
  end

  puts "done parsing source!"
end

# for an individual card
def parse_rows
  puts "parsing rows..."

  Dir.glob("./rows/*.txt") do |path|
    # puts path
    File.open(path) do |file|
      contents = file.read

      # contents.gsub!(/"[^>]*\/>/, "")
      # remove all html tags and everything in them
      # (<, >, and everything in between)
      contents.gsub!(/<[^>]*>/, ",")
      # create one line for every meaningful piece of data
      # replace one or more commas (with or without spaces in between) with a new line
      contents.gsub!(/,[, ]*/, "\n")

      File.open("./card_data/card_data_#{path.slice(/\d+/)}.txt", "w+") do |new_file|
        new_file.write(contents)
      end
    end
  end

  puts "done parsing rows!"
end

def parse_option_card(lines)
  [
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    lines[4],
    nil,
  ]
end

def parse_digimon_card(lines)
  effect_regex = /[1a-zA-Z]+[a-zA-Z -]+/ # distinguish effect text from damage values
  wierd_x_effect = lines[20].slice(effect_regex).nil? # some A3 Eff. are on a new line, some are not
  x_effect = wierd_x_effect ? lines[21] : lines[20].slice(effect_regex)
  supp_effect = wierd_x_effect ? lines[23] : lines[22]
  [
    # Level, Type
    lines[4],
    lines[5],

    # HP, attack data (A1, A2, A3, A3 Eff., A3 Spd.)
    lines[9],
    lines[16].slice(/\d+/), # the values are surrounded by ( ), so we need to pull them out
    lines[18].slice(/\d+/),
    lines[20].slice(/\d+/),
    x_effect,
    nil, # A3 Spd. is unknown for all cards

    # DP, +P
    lines[10],
    lines[11],

    # Sup. Eff., Sup. Spd.
    supp_effect,
    nil # Sup. Eff. Spd. is unknown for all cards
  ]
end

CSV_HEADERS = %i(
  number
  name
  level
  type
  hp
  atk1
  atk2
  atk3
  atk3_effect
  atk3_effect_speed
  dp
  plus_p
  support_effect
  support_effect_speed
).freeze

# convert the card data to a csv row
def parse_card_data
  puts "parsing card data..."

  require "csv"
  CSV.open("./dist/cards.csv", "w+") do |csv|
    csv.add_row(CSV_HEADERS)

    cards = []
    Dir.glob("./card_data/*.txt") do |path|
      File.open(path) do |file|
        lines = file.read.split("\n")
        lines.map!(&:strip) # remove prefix/postfix whitespace

        row = [
          lines[1].slice(0..2),
          lines[1].slice(5..-1)
        ]

        row +=
          if row[0].to_i >= 191
            parse_option_card(lines)
          else
            parse_digimon_card(lines)
          end

        cards.push(row)
      end
    end

    cards.sort.each { |card| csv << card }
  end

  puts "done parsing card data!"
end

parse_source
parse_rows
parse_card_data
