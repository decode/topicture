module UsersHelper
  def options_for_association_conditions(association)
    if association.name == :roles
      ['roles.id != ?', Role.find_by_name('admin').id] unless current_user.has_role? 'admin'
    else
      super
    end
  end
end
