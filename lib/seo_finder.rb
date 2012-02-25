module Acts
  module MoreSeo

    # Used to search for apropriate element in seo_urls or history (if included)
    class Finder

      def initialize(klass)
        @klass = klass
      end

      def search(name)
        ret = search_in_table(name)

        if !ret && @klass.seo_history?
          ret = search_in_history(name)
        end

        ret
      end

      def search!(name)
        search_in_table!(name)
      rescue ActiveRecord::RecordNotFound => e
        if @klass.seo_history?
          ret = search_in_history(name)
          return ret if ret
        end
        raise e
      end

      private

      # Try to find element in an instance class table
      def search_in_table(name)
        if @klass.seo_use_id
          @klass.find_by_id(name)
        else
          @klass.find_by_seo_url name, :first
        end
      end

      # Try to find element in an instance class table and raise exception
      # if it failes
      def search_in_table!(name)
        if @klass.seo_use_id
          @klass.find(name)
        else
          @klass.find_by_seo_url! name, :first
        end
      end

      # Try to find element in its seo history
      def search_in_history(name)
        sql = 'seo_url = ? AND seo_historable_type = ?'
        ret = Acts::MoreSeo::SeoHistory.where(sql, name, @klass.to_s).limit(1).first
        ret = ret.seo_historable if ret
        ret
      end

    end

  end
end
