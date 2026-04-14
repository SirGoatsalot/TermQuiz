#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'rainbow'

require_relative 'lib/quizgen'

# Terminal Program to create and use a quizlet equivalent
module TermQuiz
  include QuizGen

  def self.run(quizname)
    puts `clear`
    puts Rainbow("==== TermQuiz - #{quizname.capitalize} ====").green

    filename = "#{quizname.downcase}.#{FILE_EXT}"
    filepath = "#{QUIZZES_DIR}/#{filename}"
    puts Rainbow("searching for #{filename}").faint
    if File.exist? filepath
      questions = JSON.parse(File.read(filepath))
      quiz questions
    else
      puts Rainbow("Quiz does not exist in #{QUIZZES_DIR}.").red
      puts Rainbow(`ls #{QUIZZES_DIR}`).red
    end
  end

  def self.quiz(quiz)
    puts ''
    valid = quiz.keys
    q_num = 0

    loop do
      q_num += 1
      break if q_num > quiz.keys.size

      current = valid.sample
      valid -= [current]
      print Rainbow("\nQ%.2d: %s" % [q_num, current]).underline + " "
      response = STDIN.gets.chomp

      if !quiz[current].respond_to? 'each'
        puts 'Answer: '
        if response.downcase == quiz[current].downcase
          puts Rainbow(" ✔ #{quiz[current]}").green
        elsif checkstrings(quiz[current], response)
          puts Rainbow(" ? #{quiz[current]} ~ #{response}").blue
        else
          puts Rainbow(" x #{quiz[current]}").red.italic
        end
      elsif quiz[current].respond_to? 'each'
        puts 'Answers: '
        response = response.split(', ')
        quiz[current].each do |answer|
          if response.include? answer
            puts Rainbow(" ✔ #{answer}").green
          else
            semi_correct = false
            response.each do |item|
              if checkstrings(answer, item)
                puts Rainbow(" ? #{answer} ~ #{item}").blue
                semi_correct = true
                break
              end
            end
            puts Rainbow(" x #{answer}").red.italic unless semi_correct
          end
        end
      end
    end
  end

  def self.checkstrings(str1, str2)
    threshold = 0.5
    matches = 0
    str1 = str1.split('')
    str1.each do |char|
      matches += 1 if str2.include? char
    end

    (matches / str2.size) >= threshold
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0].nil?
    QuizGen.make_quiz
  else
    TermQuiz.run ARGV[0].chomp
  end
end
