class SelectionalRestrictionTypesController < ApplicationController

  def index
    @types = SelectionalRestrictionType.all
  end
  def show
    @srt = SelectionalRestrictionType.find(params[:id])
  end
end
