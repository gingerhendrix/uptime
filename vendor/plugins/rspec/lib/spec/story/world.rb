require 'rubygems'
require 'spec/expectations'
require 'spec/matchers'
require 'spec/dsl/pending'

module Spec
  module Story
=begin
  A World represents the actual instance a scenario will run in.
  
  The runner ensures any instance variables and methods defined anywhere
  in a story block are available to all the scenarios. This includes
  variables that are created or referenced inside Given, When and Then
  blocks.
=end
    module World
      include ::Spec::DSL::Pending
      include ::Spec::Matchers
      # store steps and listeners in the singleton metaclass.
      # This serves both to keep them out of the way of runtime Worlds
      # and to make them available to all instances.
      class << self
        def create(cls = Object, *args)
          cls.new(*args).extend(World)
        end
        
        def listeners
          @listeners ||= []
        end
        
        def add_listener(listener)
          listeners() << listener
        end
        
        def step_mother
          @step_mother ||= StepMother.new
        end
                
        def use(steps)
          step_mother.use(steps)
        end

        def run_given_scenario_with_suspended_listeners(world, type, name, scenario)
          current_listeners = Array.new(listeners)
          begin
            listeners.each { |l| l.found_scenario(type, name) }
            @listeners.clear
            scenario.perform(world, name) unless ::Spec::Story::Runner.dry_run
          ensure
            @listeners.replace(current_listeners)
          end
        end
        
        def store_and_call(world, type, name, *args, &block)
          if block_given?
            step_mother.store(type, Step.new(name, &block))
          end
          step = step_mother.find(type, name)
          begin
            step.perform(world, name, *args) unless ::Spec::Story::Runner.dry_run
            listeners.each { |l| l.step_succeeded(type, name, *args) }
          rescue Exception => e
            case e
            when Spec::DSL::ExamplePendingError
              @listeners.each { |l| l.step_pending(type, name, *args) }
            else
              @listeners.each { |l| l.step_failed(type, name, *args) }
            end
            errors << e
          end
        end
        
        def errors
          @errors ||= []
        end
      end # end of class << self
      
      def start_collecting_errors
        errors.clear
      end
      
      def errors
        World.errors
      end
      
      def GivenScenario(name)
        World.run_given_scenario_with_suspended_listeners(self, :'given scenario', name, GivenScenario.new(name))
        @__previous_step = :given
      end
      
      def Given(name, *args, &block)
        World.store_and_call self, :given, name, *args, &block
        @__previous_step = :given
      end
      
      def When(name, *args, &block)
        World.store_and_call self, :when, name, *args, &block
        @__previous_step = :when
      end
      
      def Then(name, *args, &block)
        World.store_and_call self, :then, name, *args, &block
        @__previous_step = :then
      end
      
      def And(name, *args, &block)
        World.store_and_call self, @__previous_step, name, *args, &block
      end
    end
  end
end
