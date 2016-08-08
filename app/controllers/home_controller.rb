class HomeController < ApplicationController
  def index
    @items = Item.all.order(:pubDate)
    @sites = Site.all
  end
end
