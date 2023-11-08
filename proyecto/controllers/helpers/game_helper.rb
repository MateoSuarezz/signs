module GameHelper
  def load_points
      @user = User.find_by(id: session[:user_id])
      @modules = Modules.all
      @points = []

      @modules.each do |mod|
        questions = Question.where(module_id: mod.id)
        p = 0

        questions.each do |q|
          r = Response.find_or_create_by(users_id: session[:user_id], questions_id: q.id)
          p += 10 if r.correct_answer
        end

        @points.push(p)
      end
  end

  def reset_responses(module_id)
      questions = Question.where(module_id: module_id)

      questions.each do |q|
        r = Response.find_or_create_by(users_id: session[:user_id], questions_id: q.id)
        r.update(correct_answer: false)
      end
  end
end
