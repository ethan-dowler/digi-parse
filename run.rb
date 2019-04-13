# for the source html
def parse_source
  File.open("./source.html") do |source_file|
    contents = source_file.read

    contents.gsub!(",", "")
    contents.gsub!("\n", "")
    contents.gsub!(/<table +style=/, "\n<table style=\"margin: 0")
    contents.gsub!("</tbody></table>", "</tbody></table>\n")

    contents.split("\n").each.with_index do |line, index|
      next if index.zero?

      File.open("./rows/row_#{index}.txt", "w+") do |new_file|
        new_file.write(line)
      end
    end
  end
end

# for an individual card
def parse_rows
  Dir.glob("./rows/*.txt") do |path|
    # puts path
    File.open(path) do |file|
      contents = file.read

      contents.gsub!(/"[^>]*\/>/, "")
      contents.gsub!(/<[^>]*>/, ",")
      contents.gsub!(/,[, ]*/, "\n")

      File.open("./card_data/card_data_#{path.slice(/\d+/)}.txt", "w+") do |new_file|
        new_file.write(contents)
      end
    end
  end
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
  require "csv"

  CSV.open("./dist/cards.csv", "w+") do |csv|
    csv.add_row(CSV_HEADERS)

    cards = []
    Dir.glob("./card_data/*.txt") do |path|
      File.open(path) do |file|
        lines = file.read.split("\n")
        row = [
          lines[1].slice(0..2),
          lines[1].slice(5..-1)
        ]
        if row[0].to_i > 292
          # digi option card
        elsif row[0].to_i > 190
          # support option card
        else
          # monster card
        end
        cards.push(row)
      end
    end

    cards.sort.each { |card| csv.add_row(card) }
  end
end

# parse_source
# parse_rows
parse_card_data
