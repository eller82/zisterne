module ApplicationHelper

  #def active_class(link_path)
  # current_page?(link_path) ? "active" : ""
  #end
  
  def active_class(link_path)
    "active" if params[:dauer].to_s == link_path.to_s or params[:dauer].blank? && link_path == 1
  end

end
