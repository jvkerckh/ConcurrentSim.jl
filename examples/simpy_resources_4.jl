using SimJulia

function user(env::Environment, name::ASCIIString, res::Resource, wait::Float64, prio::Int, preempt::Bool)
  println("$name Requesting at $(now(env))")
  yield(Request(res, prio, preempt))
  println("$name got resource at $(now(env))")
  try
    yield(Timeout(env, 3.0))
  catch exc
    println("$name got preempted at $(now(env))")
  end
  yield(Release(res))
end

env = Environment()
res = Resource(env, 1)
A = Process(env, user, "A", res, 0.0, 0, true)
run(env, 1.0)
B = Process(env, user, "B", res, 1.0, -2, false)
C = Process(env, user, "C", res, 2.0, -1, true)
run(env)