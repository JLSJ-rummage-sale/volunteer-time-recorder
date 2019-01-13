module ApplicationHelper
  def render_add_record_button(btn_name, path, icon=nil)
    render(:partial => 'layouts/buttons/add_record_button',
      :locals => {btn_name: btn_name,
                  path: path,
                  icon: icon})
  end
end
