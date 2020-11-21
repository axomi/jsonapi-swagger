require 'forwardable'
module Jsonapi
  module Swagger
    class GraphitiResource
      extend Forwardable

      def initialize(gr)
        @gr = gr
      end

      # TODO: Graphiti::Resource
      def attributes
        attributes_by_flag(:readable)
      end

      def relationships
        {}.tap do |relations|
          @gr.sideloads.values.map do |sl|
            relations[sl.name] = OpenStruct.new(class_name: sl.resource_class.to_s)
          end
        end

      end
      
      def sortable_fields
        attributes_by_flag(:sortable)
      end

      def creatable_fields
        attributes_by_flag(:writable)
      end

      def updatable_fields
        attributes_by_flag(:writable)
      end

      def filters
        @gr.keys
      end

      def mutable?
        @gr.abstract_class?
      end

      private

      def attributes_by_flag(flag)
        @gr.attributes.map {|k, v| k if v[:writable] }.compact
      end
    end
  end
end