module Whenever::Test
  class DSLInterpreter
    def initialize(schedule_world)
      @_world = schedule_world
    end

    def job_type(job, command)
      @_world.jobs[job] = []
      define_singleton_method(job) do |task, *args|
        job_instance = StrictHash[task: task, every: @_current_every, command: command]
        job_instance.merge!(args[0]) if args[0].is_a? Hash
        @_world.jobs[job] << job_instance
      end
    end

    def every(*args, &block)
      @_current_every = args
      yield
    end

    def set(name, value)
      instance_variable_set("@#{name}".to_sym, value)
      self.class.send(:attr_reader, name.to_sym)

      @_world.sets[name] = value
    end

    def env(name, value)
      @_world.envs[name] = value
    end
  end
end
