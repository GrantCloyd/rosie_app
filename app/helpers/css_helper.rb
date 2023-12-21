# frozen_string_literal: true

module CssHelper
  def primary_th
    'border-b font-medium p-4 pt-2 pb-3 text-slate-400 text-left'
  end

  def primary_td
    'border-b border-slate-100 p-4 text-slate-500'
  end

  def primary_button
    'bg-indigo-500 hover:bg-indigo-4000 text-white font-bold py-2 px-4 rounded mt-2'
  end

  def secondary_button
    'bg-slate-700 hover:bg-slate-500  text-white font-bold py-2 px-4 rounded mt-4'
  end

  def primary_header
    'text-3xl font-bold text-slate-200 underline flex justify-center'
  end

  def action_button
    'bg-slate-300 p-1 hover:text-emerald-600'
  end

  def primary_form
    'shadow-md bg-slate-100 rounded-md'
  end

  def nav_breadcrumbs
    'bg-slate-200 bold border-2 border-slate-300 p-1 px-2 max-w-sm mr-1 rounded-full'
  end

  def sticky_top_action_bar
    'border-4 border-slate-400 bg-slate-100 w-42 px-2 pb-2 sticky top-0 left-4 mt-16 rounded-md'
  end
end
