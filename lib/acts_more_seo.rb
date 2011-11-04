require "string_ext"

module Acts
  module MoreSeo

    class NoSeoUrlTable < StandardError; end

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

        if columns.is_a?(Array)
          columns.collect!{|a| a.to_sym}
        else
          columns = columns.to_sym
        end

        if !use_id && !self.column_names.include?("#{:seo_url}")
          raise NoSeoUrlTable , 'Create seo_url table for your model'
        end

        cattr_accessor :seo_columns
        cattr_accessor :seo_use_id

        before_update :update_seo_url
        after_create  :set_seo_url

        self.seo_columns = columns

        self.seo_use_id  = use_id
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
        self.url
      end

      # Lets return nice and smooth url
      def url
        # If there is more than one SEO column - prepare url "text" part
        if self.class.seo_columns.is_a?(Array)
          seo_parts = self.class.seo_columns.collect do |field|
            el = self.send(field)
            el.to_url if el
          end
          seo_parts.delete_if{|el| el.to_s.length == 0}
          seo_path = seo_parts.join('-')
        else
          el = self.send(self.class.seo_columns)
          seo_path = el ? el.to_url : ''
        end

        if self.class.seo_use_id
          seo_path = "#{self.id}#{"-#{seo_path}" if seo_path && seo_path.length > 0}"
        end

        seo_path.length > 0 ? seo_path : "#{self.id}"
      end

      def update_seo_url
        if self.class.seo_url_table?
          self.update_column(:seo_url, self.to_param)
        end
      end

      def set_seo_url
        if self.class.seo_url_table?
          self.update_column(:seo_url, self.to_param)
        end
      end

      module ClassMethods

        def seo_url_table?
          self.column_names.include?("#{:seo_url}")
        end

        def find(*args)
          super
        rescue ActiveRecord::RecordNotFound
          if !self.seo_use_id && !(el = find_by_seo_url(args.first, :first)).nil?
            el
          else
            raise ActiveRecord::RecordNotFound
          end
        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::MoreSeo)
