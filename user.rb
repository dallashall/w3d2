require_relative "questions_db"
require_relative "question"
require_relative "question_follow"
require_relative 'model_base'

class User < ModelBase
  attr_accessor :fname, :lname, :id

  # def self.find_by_id(id)
  #   data = QuestionDB.instance.execute(<<-SQL, id)
  #   SELECT *
  #   FROM users
  #   WHERE id = ?
  #   SQL
  #   return nil if data.empty?
  #   User.new(data.first)
  # end

  def self.find_by_name(fname, lname)
    data = QuestionDB.instance.execute(<<-SQL, fname, lname)
    SELECT *
    FROM users
    WHERE fname = ? AND lname = ?
    SQL
    return nil if data.empty?
    User.new(data.first)
  end

  def author_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionDB.instance.execute(<<-SQL, @id)
    SELECT AVG(likes) as karma
    FROM
      (SELECT COUNT(*) AS likes, questions.author_id
      FROM questions
      JOIN question_likes ON (questions.id = question_likes.question_id)
      WHERE questions.author_id = ?
      GROUP BY question_likes.question_id
    )

    SQL
    data.first["karma"]
  end

  def initialize(options)
    @fname = options["fname"]
    @lname = options["lname"]
    @id = options["id"]
  end

  def save
    raise "STOP IT! IT ALREADY EXISTS!" if @id
    QuestionDB.instance.execute(<<-SQL, @fname, @lname)
    INSERT INTO users(fname, lname)
    VALUES (?, ?)
    SQL
    @id = QuestionDB.instance.last_insert_row_id
  end

  def update
    raise "USER DOES NOT EXIST" unless @id
    QuestionDB.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE users
      SET fname = ?, lname = ?
      WHERE id = ?
    SQL
  end

end
