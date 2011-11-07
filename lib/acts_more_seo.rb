require "string_ext"

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

        if columns.is_a?(Array)
          columns.collect!{|a| a.to_sym}
        else
          columns = columns.to_sym
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
        self.to_url
      end

      # Lets return nice and smooth url
      def to_url
        seo_path = seo_text_part
        seo_path = "#{self.id}#{"-#{seo_path}" if seo_path && seo_path.length > 0}"
        seo_path.length > 0 ? seo_path : "#{self.id}"
      end
      # Alias
      def url
        to_url
      end

      def to_seo
        if self.seo_use_id
          to_url
        else
          seo_link = seo_text_part.length > 0 ? seo_text_part : "#{self.id}"
          if !self.class.where("seo_url = ? AND id != ?", seo_link, self.id).limit(1).empty?
            to_url
          else
            seo_link
          end
        end
      end

      def update_seo_url
        if self.class.seo_url_table?
          self.update_column(:seo_url, to_seo)
        end
      end

      def set_seo_url
        if self.class.seo_url_table?
          self.update_column(:seo_url, to_seo)
        end
      end

      module ClassMethods

        def seo_url_table?
          self.column_names.include?("#{:seo_url}")
        end

        def find_by_seo(id)
          if self.seo_use_id
            find(id)
          else
            el = find_by_seo_url id, :first
            raise ActiveRecord::RecordNotFound unless el
            el
          end
        end

      end

      private

      def seo_text_part
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
        seo_path
      end

    end
  end
end

ActiveRecord::Base.send(:include, Acts::MoreSeo)
