# require 'byebug'
class ModelBase

  def self.table
    class_string = nil
    self_class = self.itself.to_s
    if self_class == "Question"
      class_string = 'questions'
    elsif self_class == "Reply"
      class_string = 'replies'
    else
      class_string = 'users'
    end
    class_string
  end

  def self.all
    data = QuestionDB.instance.execute(<<-SQL)
    SELECT *
    FROM #{table}
    SQL
    data.map { |datum| self.new(datum)}
  end

  def self.find_by_id(id)

    data = QuestionDB.instance.execute(<<-SQL, id)
      SELECT *
      FROM #{table}
      WHERE id = ?
    SQL
    return nil if data.empty?
    self.new(data.first)
  end

  def save
    raise "STOP IT! IT ALREADY EXISTS!" if @id
    QuestionDB.instance.execute(<<-SQL, *self.table_vars)
    INSERT INTO #{self.class.table}(#{table_vars_str})
    VALUES (#{question_marks})
    SQL
    @id = QuestionDB.instance.last_insert_row_id
  end

  def self.where(options)
    options_arr = options.to_a
    vals = options.values
    options_arr_str = options_arr.map { |pair| "#{pair[0]} = ?" }.join(",")
    data = QuestionDB.instance.execute(<<-SQL, *vals)
      SELECT *
      FROM #{table}
      WHERE #{options_arr_str}
    SQL
    return nil if data.empty?
    self.new(data.first)
  end

  def table_vars
    (self.instance_variables - [:@id]).map(&:to_s)
  end

  def table_vars_str
    table_vars.map{ |sym| sym.to_s.delete("@")}.join(',')
  end

  def question_marks
    table_vars.map {'?'}.join(',')
  end


end
