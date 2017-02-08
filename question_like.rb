require_relative "questions_db"
require_relative "user"
require_relative "question"

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def self.find_by_question_id(q_id)
    data = QuestionDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM question_likes
      WHERE question_id = ?
    SQL
    return nil if data.empty?
    data.map { |like_data| QuestionLike.new(like_data) }
  end

  def self.likers_for_question_id(q_id)
    data = QuestionDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM question_likes
      JOIN users
      ON (users.id = question_likes.user_id)
      WHERE question_id = ?
      SQL
      return nil if data.empty?
      data.map { |user_data| User.new(user_data) }
  end

  def self.num_likes_for_question_id(q_id)
    data = QuestionDB.instance.execute(<<-SQL, q_id)
      SELECT COUNT(*) AS LIKES
      FROM question_likes
      JOIN users
      ON (users.id = question_likes.user_id)
      WHERE question_id = ?
      SQL
      return nil if data.empty?
      data.first['LIKES']
  end

  def self.liked_questions_for_user_id(u_id)
    data = QuestionDB.instance.execute(<<-SQL, u_id)
    SELECT questions.id, questions.title, questions.body, questions.author_id
    FROM question_likes
    JOIN questions
    ON (questions.id = question_likes.question_id)
    WHERE
      question_likes.user_id = ?
    SQL
    return nil if data.empty?
    data.map { |question_data| Question.new(question_data) }
  end

  def self.most_liked_questions(n)
    data = QuestionDB.instance.execute(<<-SQL, n)
      SELECT *
      FROM question_likes
      JOIN questions ON (questions.id = question_likes.question_id)
      GROUP BY questions.id
      ORDER BY COUNT(*) DESC
      LIMIT ?
    SQL
    return nil if data.empty?
    data.map { |question_data| Question.new(question_data) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
