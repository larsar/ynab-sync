class CollectionsController < ApplicationController

  def index
    @source = Source.where("id = '%s' AND user_id = '%s'", params[:source_id], current_user.id).first
    @collections = Collection.joins(:source).where(source_id: params[:source_id]).where("sources.user_id = '%s'", current_user.id)
    add_crumb 'Bank sources', sources_path
    add_crumb @source.name, source_path(@source)
    add_crumb 'Bank accounts', source_collections_path(@source)
  end

  def show
    @collection = current_user.collections.where(id: params[:id]).first
    @source = current_user.sources.where(id: params[:source_id]).first
    #@collection = Collection.joins(:source).where("collections.id = '%s' AND source_id = sources.id AND sources.user_id = '%s'", params[:id], current_user.id).first
    add_crumb 'Bank sources', sources_path
    add_crumb @source.name, source_path(@source)
    add_crumb 'Bank accounts', source_collections_path(@source)
    add_crumb @collection.name, source_collection_path(@source, @collection)
  end
end