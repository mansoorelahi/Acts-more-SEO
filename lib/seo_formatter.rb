module Acts
  module MoreSeo

    class SeoFormatter

      def initialize(instance)
        @instance = instance
        @klass    = instance.class
      end

      def to_url
        seo_path = text_part
        seo_path = "#{@instance.id}#{"-#{seo_path}" if seo_path && seo_path.length > 0}"
        seo_path.length > 0 ? seo_path : "#{@instance.id}"
      end

      def to_seo
        return @to_seo if @to_seo

        if @instance.seo_use_id
          @to_seo = to_url
        else
          seo_link = text_part.length > 0 ? text_part : "#{@instance.id}"
          if !@klass.where("seo_url = ? AND id != ?", seo_link, @instance.id).limit(1).empty?
            @to_seo = to_url
          else
            @to_seo = seo_link
          end
        end
        @to_seo
      end

      private

      # Prepare text part of a seo url (the one without an id)
      def text_part
        return @seo_path if @seo_path
        # If there is more than one SEO column - prepare url "text" part
        if @klass.seo_columns.is_a?(Array)
          seo_parts = @klass.seo_columns.collect do |field|
            el = @instance.send(field)
            el.to_s.to_url if el
          end
          seo_parts.delete_if{|el| el.to_s.length == 0}
          @seo_path = seo_parts.join('-')
        else
          el = @instance.send(@klass.seo_columns)
          @seo_path = el ? el.to_s.to_url : ''
        end
        @seo_path
      end

    end

  end
end
