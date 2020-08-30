module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to('Edit', url_for([:edit, item]), class: 'btn btn-primary')
    return raw(edit) if !current_user.admin

    del = link_to('Destroy', item, method: :delete,
                                   data: { confirm: 'Are you sure?' },
                                   class: 'btn btn-danger')
    raw("#{edit} #{del}")
  end

  def round_num(number)
    return nil unless number

    number.round(1)
  end
end
