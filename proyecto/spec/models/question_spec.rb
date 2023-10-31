# frozen_string_literal: true

# spec/models/question_spec.rb

require_relative '../../models/init'

describe 'Question' do
  context 'validations' do
    it 'is valid with valid attributes' do
      question = Question.new(
        answer: true,
        question: 'Sample question',
        content_link: '/images/letraE.png',
        module_id: 1
      )
      expect(question).to be_valid
    end

    it 'is invalid without a question content' do
      question = Question.new(
        answer: true,
        content_link: '/images/letraE.png',
        module_id: 1
      )
      expect(question).to_not be_valid
    end

    it 'is invalid without a module_id' do
      question = Question.new(
        answer: true,
        question: 'Sample question',
        content_link: '/images/letraE.png'
      )
      expect(question).to_not be_valid
    end
  end

  context 'columns' do
    it 'has an "answer" column of type boolean' do
      expect(Question.columns_hash['answer'].type).to eq :boolean
    end

    it 'has a "question" column of type string' do
      expect(Question.columns_hash['question'].type).to eq :string
    end

    it 'has a "content_link" column of type string' do
      expect(Question.columns_hash['content_link'].type).to eq :string
    end

    it 'has a "module_id" column of type integer' do
      expect(Question.columns_hash['module_id'].type).to eq :integer
    end
  end

  context 'data integrity' do
    it 'ensures that content_link starts with "/images/"' do
      question = Question.new(
        answer: true,
        question: 'Sample question',
        content_link: 'example.com',
        module_id: 3
      )
      expect(question.valid?).to be false
    end
  end
end
