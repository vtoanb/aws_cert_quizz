require './quizz'
require 'pdf-reader'
require 'pry'
require 'csv'

fname = './aws_solution_exam.pdf'

reader = PDF::Reader.new(fname)
db = []

reader.pages.each { |pg| db << pg.text.split("\n") }
db = db.flatten

question = []
q = ""

db.each do |ln|
  if ln.is_a_question? && q.empty?
    q = ln
  elsif ln.is_a_question? && !q.empty?
    question << q
    q = ln
    p ln
  elsif !q.empty?
    q << "\n#{ln}"
  else
  end
end

question << q unless q.empty?
wquestion = []
wanswer = []

question.each do |q|
  quizz = Quizz.new(q)

  if quizz.question_number[/\d+/] == '1'
    quizz.is_an_answer? ? wanswer << [quizz.to_json] : wquestion << [quizz.to_json]
  end

  quizz.is_an_answer? ? wanswer[-1] << quizz.to_json : wquestion[-1] << quizz.to_json
end

wquestion.each_with_index do |question, i|
  File.open("test.q.#{i}.json", 'wb') { |f| f.puts question.to_json }
end

wanswer.each_with_index do |answer, i|
  File.open("test.a.#{i}.json", 'wb') { |f| f.puts answer.to_json }
end
