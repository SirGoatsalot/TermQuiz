# frozen_string_literal: true

# Module to generate quiz files for TermQuiz utility.
module QuizGen
  QUIZZES_DIR = "#{Dir.home}/.config/TermQuiz"
  FILE_EXT = 'tquiz'
  PROMPTS = {
    title: '==== TermQuiz Generator ====',
    pick_name: 'What would you like to name your quiz? ',
    overwrite: "\nQuiz with that name already exists. Overwrite it? (y/n) ",
    writing: 'Writing questions to '
  }.freeze

  def self.make_quiz
    puts `clear`
    puts PROMPTS[:title]

    filename = nil

    loop do
      print PROMPTS[:pick_name]
      filename = "#{gets.chomp.downcase}.#{FILE_EXT}"
      break unless File.exist? "#{QUIZZES_DIR}/#{filename}"

      print PROMPTS[:overwrite]
      break if gets.chomp.upcase == 'Y'
    end

    quiz = generate_questions

    puts "#{PROMPTS[:writing]}#{filename}"
    FileUtils.mkdir_p QUIZZES_DIR unless File.exist? QUIZZES_DIR
    File.write("#{QUIZZES_DIR}/#{filename}", quiz.to_json)
  end

  def self.generate_questions
    quiz = {}
    q_num = 0

    loop do
      q_num += 1
      print "Question #{q_num} (q to quit) "
      question = gets.chomp
      break if question.upcase == 'Q'

      print "Answer   #{q_num} (q to quit) "
      answer = gets.chomp
      break if answer.upcase == 'Q'

      answer = answer.split ', ' if answer.include? ', '

      quiz[question] = answer
    end

    quiz
  end
end


