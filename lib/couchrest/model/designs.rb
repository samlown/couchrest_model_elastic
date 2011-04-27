
#### NOTE Work in progress! Not yet used!

module CouchRest
  module Model

    # A design block in CouchRest Model groups together the functionality of CouchDB's
    # design documents in a simple block definition.
    #
    #   class Person < CouchRest::Model::Base
    #     property :name
    #     timestamps!
    #
    #     design do
    #       view :by_name
    #     end
    #   end
    #
    module Designs
      extend ActiveSupport::Concern

      module ClassMethods

        # Add views and other design document features
        # to the current model.
        def design(*args, &block)
          mapper = DesignMapper.new(self)
          mapper.create_view_method(:all)

          mapper.instance_eval(&block) if block_given?
        end

        # Override the default page pagination value:
        #
        #   class Person < CouchRest::Model::Base
        #     paginates_per 10
        #   end
        #
        def paginates_per(val)
          @_default_per_page = val
        end

        # The models number of documents to return
        # by default when performing pagination.
        # Returns 25 unless explicitly overridden via <tt>paginates_per</tt>
        def default_per_page
          @_default_per_page || 25
        end

      end

      # 
      class DesignMapper

        attr_accessor :model

        def initialize(model)
          self.model = model
        end

        # Define a view and generate a method that will provide a new 
        # View instance when requested.
        def view(name, opts = {})
          View.create(model, name, opts)
          create_view_method(name)
        end

        # Really simple design function that allows a filter
        # to be added. Filters are simple functions used when listening
        # to the _changes feed.
        #
        # No methods are created here, the design is simply updated.
        # See the CouchDB API for more information on how to use this.
        def filter(name, function)
          filters = (self.model.design_doc['filters'] ||= {})
          filters[name.to_s] = function
        end

        # Create a new Elastic search method. Accepts the following options:
        #
        # * :filter_name   - the name of the _changes filter to be created.
        # * :filter_method - the actual method definition to use.
        #
        def elastic(name, opts = {})
          opts[:filter_name] ||= model.to_s.underscore
          opts[:filter_method] ||= "function(doc, req) { return doc['#{model.model_type_key}'] == '#{self.model.to_s}'; }")
          # Create a filter for this model
          filter(opts[:filter_name], opts[:filter_method])
          create_elastic_method(name, opts[:filter_name])
        end

        protected

        def create_view_method(name)
          model.class_eval <<-EOS, __FILE__, __LINE__ + 1
            def self.#{name}(opts = {})
              CouchRest::Model::Designs::View.new(self, opts, '#{name}')
            end
          EOS
        end

        def create_elastic_method(name, filter_name)
          model.class_eval <<-EOS, __FILE__, __LINE__ + 1
            def self.#{name}(opts = {})
              CouchRest::Model::Designs::Elastic.new(self, opts, '#{name}', '#{filter_name}')
            end
          EOS
        end


      end
    end
  end
end
