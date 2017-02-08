require_relative "questions_db"
require_relative "user"
require_relative "question"

class QFollow
  attr_accessor :id, :user_id, :question_id

  def self.find_by_question_id(q_id)
    data = QuestionDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM likes
      WHERE question_id = ?
    SQL
    return nil if data.empty?
    data.map { |like_data| QFollow.new(like_data) }
  end

  def self.followers_for_question_id(question_id)
      data = QuestionDB.instance.execute(<<-SQL, question_id)
        SELECT *
        FROM users
        JOIN questions
        ON (users.id = questions.author_id)
        JOIN questions_follows
        ON (questions_follows.user_id = questions.author_id)
        WHERE questions.id = ?
      SQL
      return nil if data.empty?
      data.map { |user_data| User.new(user_data) }
  end

  def self.followed_questions_for_user_id(user_id)
      data = QuestionDB.instance.execute(<<-SQL, user_id)
        SELECT *
        FROM users
        JOIN questions
        ON (users.id = questions.author_id)
        JOIN questions_follows
        ON (questions_follows.user_id = questions.author_id)
        WHERE users.id = ?
      SQL
      return nil if data.empty?
      data.map { |question_data| Question.new(question_data) }
  end

  def self.most_followed_questions(n)
    data = QuestionDB.instance.execute(<<-SQL, n)
      SELECT *
      FROM questions_follows
      JOIN questions ON (questions.id = questions_follows.question_id)
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
