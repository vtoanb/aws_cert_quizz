class String
  def is_start_of_a_new_chapter?
    match?(/Chapter \d+ /)
  end

  def chapter
    num = match(/Chapter (?<chapter_num>\d+)/)[:chapter_num]
    "chapter #{num}"
  rescue
    nil
  end

  def is_a_question?
    match?(/^ *\d{1,3}\. /)
  end

  def is_a_choice?
    match?(/^ *[A-H]\./)
  end
end

