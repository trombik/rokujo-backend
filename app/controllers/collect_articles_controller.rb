# Controller to enqueue CollectArticlesJob
class CollectArticlesController < ApplicationController
  def index
    @spiders = Forms::CollectArticlesComponent::REGISTERED_SPIDERS
  end

  def new
    @spider = params[:spider]
    @form_component = Forms::CollectArticlesComponent.for(@spider)
    redirect_to collect_articles_path, alert: t(".invalid") unless @form_component
  end

  def create
    spider = params[:spider]
    component = Forms::CollectArticlesComponent.for(spider)
    return head :not_found unless component

    # filter unsupported options out
    allowed_keys = component.supported_args
    spider_args = params.permit(*allowed_keys).to_h

    CollectArticlesJob.perform_later(spider, spider_args)
    redirect_to collect_articles_path, notice: t(".success")
  end
end
