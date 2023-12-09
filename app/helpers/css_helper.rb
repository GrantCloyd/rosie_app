# frozen_string_literal: true

module CssHelper
  def primary_th
    'border-b font-medium p-4 pt-2 pb-3 text-slate-400 text-left'
  end

  def primary_td
    'border-b border-slate-100 p-4 text-slate-500'
  end

  def primary_button
    'bg-slate-700 hover:bg-slate-500 text-white font-bold py-2 px-4 rounded my-4'
  end

  def secondary_button
    'bg-indigo-500 hover:bg-indigo-400 text-white font-bold py-2 px-4 rounded mt-4'
  end

  def primary_header
    'text-3xl font-bold text-slate-200 underline'
  end

  def action_button
    'bg-slate-300 p-1 hover:text-emerald-600'
  end

  def primary_form
    'mt-10 p-10 shadow-md bg-slate-100 max-w-xl rounded-md'
  end
end
