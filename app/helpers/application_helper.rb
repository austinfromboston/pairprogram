module ApplicationHelper
  def current_user
    controller.current_user
  end

  def search_params
    controller.search_params
  end
end
