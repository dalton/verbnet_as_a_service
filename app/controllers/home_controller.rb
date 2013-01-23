class HomeController < ApplicationController
  def index
    @classes = VerbnetClass.all.asc(:name)
  end
end
