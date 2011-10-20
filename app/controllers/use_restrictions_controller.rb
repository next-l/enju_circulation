class UseRestrictionsController < InheritedResources::Base
  respond_to :html, :xml
  load_and_authorize_resource

  def update
    @use_restriction = UseRestriction.find(params[:id])
    if params[:position]
      @use_restriction.insert_at(params[:position])
      redirect_to use_restrictions_url
      return
    end
    update!
  end
end
