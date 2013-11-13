class NeedsController < ApplicationController
  def show
    @need = Need.where(nid: params[:id]).first
  end
end