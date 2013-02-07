class VerbnetClassesController < ApplicationController

  def index

    respond_to do |format|
      format.html {
        result = VerbnetClass.search(params[:query])
        @verbnet_members = result[:members]
        @verbnet_classes = result[:classes]
      }
      format.json {render json: VerbnetClass.name_search(params[:query])}
    end

  end
  def show
    @vc = VerbnetClass.find(params[:id])
  end

  def check

    vc = VerbnetClass.named(params[:class]).first

    respond_to do |format|
      format.json{render json: vc.response_to_arguments({params[:role] => params[:value]})}
    end
  end
end
