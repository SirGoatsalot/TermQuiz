#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'fileutils'

require_relative 'lib/quizgen'

# Terminal Program to create and use a quizlet equivalent
module TermQuiz
  def run(quizname)
    puts `clear`
    puts "==== TermQuiz - #{quizname} ===="

  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0].nil?
    QuizGen.make_quiz
  else
    run ARGV[0]
  end
end
