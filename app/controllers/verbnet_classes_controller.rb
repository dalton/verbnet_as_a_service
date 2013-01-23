class VerbnetClassesController < ApplicationController
  def show
    @vc = VerbnetClass.find(params[:id])
  end
end
