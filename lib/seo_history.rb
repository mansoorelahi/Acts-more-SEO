module Acts
  module MoreSeo

    # Store the history of urls if they where changed
    class SeoHistory < ActiveRecord::Base

      belongs_to :seo_historable, :polymorphic => true

    end

  end
end
