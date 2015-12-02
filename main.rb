require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pry-byebug'
require 'pg'

get '/tasks' do
  sql = "SELECT * FROM tasks"
  @tasks = run_sql(sql)
  erb :index
end

get '/tasks/new' do
#Get a new form
  erb :new
end

post '/tasks' do
#Create a new task
name = params[:name]
details = params[:details]

sql = "INSERT INTO tasks (name, details) VALUES ('#{name}', '#{details}')"
run_sql(sql)
redirect to ('/tasks')


end

get '/tasks/:id' do

sql = "SELECT * FROM tasks WHERE tasks.id = #{params[:id]}"

@task = run_sql(sql)

erb :show
end

get '/tasks/:id/edit' do
  sql = "SELECT * FROM tasks WHERE tasks.id = #{params[:id]}"

  @task = run_sql(sql)

  erb :edit
end

post '/tasks/:id' do
  # Update the task id = :id
  @name = params[:name]
  @details = params[:details]
  sql = "UPDATE tasks SET name = '#{@name}', details = '#{@details}' WHERE id = #{params[:id]}"


  run_sql(sql)
  redirect to ('/tasks')


end

post '/tasks/:id/delete' do
  #Delete tasks
  @name = params[:name]
  @details = params[:details]
  sql = "DELETE from tasks WHERE id = #{params[:id]}"


  run_sql(sql)
  redirect to ('/tasks')
end

def run_sql(sql)
  conn = PG.connect(dbname: 'todo', host: 'localhost')

  result = conn.exec(sql)
  conn.close
  result
end
