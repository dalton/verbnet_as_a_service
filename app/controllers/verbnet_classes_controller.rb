class VerbnetClassesController < ApplicationController

  def index
    @verbnet_classes = VerbnetClass.search(params[:query])
  end
  def show
    @vc = VerbnetClass.find(params[:id])
  end
end
