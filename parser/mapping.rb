require 'json'
require 'pry'

0.upto(5) do |i|
  q = JSON.parse(File.read("./test.q.#{i}.json"))
  a = JSON.parse(File.read("./test.a.#{i}.json"))

  q.map! { |item| JSON.parse item } rescue binding.pry
  a.map! { |item| JSON.parse item }

  q.map! do |item|
    ai = a.find { |i| i['qnum'] == item['qnum'] }
    if ai
      item['answer'] = ai['answer']
      matches = ai['answer'].match(/([A-H]) *,? *([A-H])? *,? *([A-H])?./)
      item['ans'] = matches.to_a[1..-1].compact
    end

    item
  end

  File.open("./test.q.#{i}.json", 'wb') { |f| f.puts q.to_json }
end
