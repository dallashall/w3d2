require_relative 'questions_db'
require_relative 'model_base'

class Reply < ModelBase

  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  # def self.find_by_id(id)
  #   data = QuestionDB.instance.execute(<<-SQL, id)
  #     SELECT *
  #     FROM replies
  #     WHERE id = ?
  #   SQL
  #   return nil if data.empty?
  #   Reply.new(data.first)
  # end

  def self.find_by_user_id(u_id)
    data = QuestionDB.instance.execute(<<-SQL, u_id)
      SELECT *
      FROM replies
      WHERE user_id = ?
    SQL
    return nil if data.empty?
    data.map { |reply_data| Reply.new(reply_data) }
  end

  def self.find_by_question_id(q_id)
    data = QuestionDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
    SQL
    return nil if data.empty?
    data.map { |reply_data| Reply.new(reply_data) }
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil unless @parent_reply_id
    Reply.find_by_id(@parent_reply_id)
  end

  def child_replies
    data = QuestionDB.instance.execute(<<-SQL, @id)
    SELECT *
    FROM replies
    WHERE parent_reply_id = ?
    SQL
    return nil if data.empty?
    data.map { |reply_data| Reply.new(reply_data) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  # def save
  #   raise "STOP IT! IT ALREADY EXISTS!" if @id
  #   QuestionDB.instance.execute(<<-SQL, @question_id, @parent_reply_id, @user_id, @body)
  #   INSERT INTO replies(question_id, parent_reply_id, user_id, body)
  #   VALUES (?, ?, ?, ?)
  #   SQL
  #   @id = QuestionDB.instance.last_insert_row_id
  # end

  def update
    raise "REPLY DOES NOT EXIST" unless @id
    QuestionDB.instance.execute(<<-SQL, @question_id, @parent_reply_id, @user_id, @body, @id)
      UPDATE replies
      SET question_id = ?, parent_reply_id = ?, user_id = ?, body = ?
      WHERE id = ?
    SQL
  end

end
