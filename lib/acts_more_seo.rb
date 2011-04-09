require "string_ext"

module Acts
  module MoreSeo

    def self.included(base)
      base.extend AddActsAsMethod
    end

    module AddActsAsMethod
      def acts_more_seo(seo_column = :name)
        cattr_accessor :seo_column
        self.seo_column = seo_column
        class_eval <<-END
           include Acts::MoreSeo::InstanceMethods
        END
      end
    end

    # Istance methods
    module InstanceMethods

      # Overwrite default to_param - should return nice url
      def to_param
        self.url
      end

      # Lets return nice and smooth url
      def url
        seo = self.send(self.class.seo_column)
        seo ? "#{self.id}-#{seo.to_url}" : self.id
      end

      module ClassMethods
      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::MoreSeo)
