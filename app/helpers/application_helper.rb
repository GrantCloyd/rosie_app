# frozen_string_literal: true

module ApplicationHelper
  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_group
    User.find_by(id: session[:group_id])
  end

  def select_option_generator(model:, enum:, exception_array: [])
    plural_enum = enum.to_s.pluralize.to_sym

    model.send(plural_enum).except(*exception_array).keys.map { |enum_type| [enum_type.titleize, enum_type] }
  end
end
