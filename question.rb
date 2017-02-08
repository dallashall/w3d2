require_relative 'questions_db'
require_relative 'model_base'

class Question < ModelBase

attr_accessor :id, :title, :body, :author_id

  # def self.find_by_id(id)
  #   data = QuestionDB.instance.execute(<<-SQL, id)
  #     SELECT *
  #     FROM questions
  #     WHERE id = ?
  #   SQL
  #   return nil if data.empty?
  #   Question.new(data.first)
  # end

  def self.find_by_author_id(author_id)
    data = QuestionDB.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE author_id = ?
    SQL
    return nil if data.empty?
    data.map { |questions_data| Question.new(questions_data) }
  end

  def self.most_followed(n)
    QFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end



  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def save
    raise "STOP IT! IT ALREADY EXISTS!" if @id
    QuestionDB.instance.execute(<<-SQL, @title, @body, @author_id)
    INSERT INTO questions(title, body, author_id)
    VALUES (?, ?, ?)
    SQL
    @id = QuestionDB.instance.last_insert_row_id
  end

  def update
    raise "QUESTION DOES NOT EXIST" unless @id
    QuestionDB.instance.execute(<<-SQL, @title, @body, @author_id, @id)
      UPDATE questions
      SET title = ?, body = ?, author_id = ?
      WHERE id = ?
    SQL
  end

end
