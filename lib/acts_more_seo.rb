require "babosa"
require "string_ext"
require "seo_formatter"
require "seo_finder"
require "seo_history"

module Acts
  module MoreSeo

    def self.included(base)
      base.extend AddActsAsMethod
    end

    module AddActsAsMethod
      def acts_more_seo(params = {})
        # Backward compatibility
        params = {:column => params}  if params.is_a?(String) || params.is_a?(Symbol)
        params = {:columns => params} if params.is_a?(Array)

        columns = params[:column] || params[:columns] || :name
        use_id  = !params[:use_id].nil? ? params[:use_id] : true
        history = params[:history] || false
        case_sensitive = params[:case_sensitive] || false

        if columns.is_a?(Array)
          columns.collect!{|a| a.to_sym}
        else
          columns = columns.to_sym
        end

        cattr_accessor :seo_columns
        cattr_accessor :seo_use_id
        cattr_accessor :seo_history
        cattr_accessor :case_sensitive

        before_update :update_seo_url
        after_create  :set_seo_url

        self.seo_columns = columns
        self.seo_history = history
        self.seo_use_id  = use_id
        self.case_sensitive = case_sensitive

        if self.seo_history
          has_many :seo_histories,
            :as => :seo_historable,
            :dependent => :destroy,
            :class_name => 'Acts::MoreSeo::SeoHistory'
        end

        class_eval <<-END
           include Acts::MoreSeo::InstanceMethods
        END
      end
    end

    # Istance methods
    module InstanceMethods

      def self.included(aClass)
        aClass.extend ClassMethods
      end

      # Overwrite default to_param - should return nice url
      def to_param
        self.to_url
      end

      # Lets return nice and smooth url
      def to_url
        Acts::MoreSeo::SeoFormatter.new(self).to_url
      end
      # Alias
      def url
        to_url
      end

      def to_seo
        Acts::MoreSeo::SeoFormatter.new(self).to_seo
      end

      def update_seo_url
        if self.class.seo_url_table?

          new_url = to_seo

          # Add old url to history if its different from the new one
          if self.class.seo_history? && (new_url != self.seo_url)
            self.seo_histories.create(:seo_url => self.seo_url)
          end

          self.update_column(:seo_url, new_url)
        end
      end

      def set_seo_url
        if self.class.seo_url_table?
          self.update_column(:seo_url, to_seo)
        end
      end

      module ClassMethods

        def seo_history?
          self.seo_history && !self.seo_use_id
        end

        def seo_url_table?
          self.column_names.include?("#{:seo_url}")
        end

        def find_by_seo!(id)
           Acts::MoreSeo::Finder.new(self).search!(id)
        end

        def find_by_seo(id)
          Acts::MoreSeo::Finder.new(self).search(id)
        end

      end

    end
  end
end

ActiveRecord::Base.send(:include, Acts::MoreSeo)
