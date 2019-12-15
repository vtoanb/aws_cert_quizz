require 'pry'
require './string_mod'

class Quizz
  attr_accessor :id, :question, :choices, :answer

  def initialize(text)
    _id = text.match(/^ *(\d{1,3})\./)[1]
    return if _id.nil?
    @id = _id
    @choices = []

    text.split("\n").each do |ln|
      next if ln.nil? || ln.empty?
      next if ln.include?('Review Questions') || \
        ln.include?('Subdomain') || \
        ln.include?('Domain') || \
        ln.include?('Solutions Architect Practice')
      next if ln.match?('(■|✓|©)')

      if ln.is_a_question?
        @question = ln.strip
        next
      end

      if question.to_s.size > 10 \
          && !question.match?(/\?$|\)$/) \
          && !ln.is_a_choice?
        question << "\n#{ln}"
        next
      end

      if ln.is_a_choice?
        choices << ln.lstrip.strip
      elsif choices[-1].is_a?(String)
        choices[-1] << ln.lstrip.strip
      end

    end
  end

  def to_a
    [
      question_number,
      question,
      *choices
    ]
  end

  def to_json
    return {
      qnum: question_number,
      question: question.gsub(/^ *\d{1,3}\./, ''),
      choices: choices
    }.to_json unless is_an_answer?

    return {
      qnum: question_number,
      answer: question.gsub(/^ *\d{1,3}\./, '')
    }.to_json
  end

  def is_an_answer?
    question && choices.empty?
  end

  def question_number
    question[/\d{1,3}\./]
  end
end

