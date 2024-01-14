# frozen_string_literal: true

class UnpinService
  # might need to make this into a background service if it adds too much time
  # current usage does not envision having a ton of pinned posts so it should be negligible for the moment

  def initialize(pinnable:, belongs_to_assoc:)
    @pinnable = pinnable
    @belongs_to_assoc = belongs_to_assoc
    @current_pin_index = pinnable.pin_index
  end

  def call
    remove_pinnable_pin_index
    reindex_belongs_to_assoc_pin_indices
  end

  private

  def remove_pinnable_pin_index
    @pinnable.update(pin_index: nil)
  end

  def reindex_belongs_to_assoc_pin_indices
    # all pinned items higher than current
    pluralized_association = @pinnable.class.name.downcase.pluralize.to_sym
    pinnables = @belongs_to_assoc.send(pluralized_association).where(pin_index: @current_pin_index..).order(:pin_index)

    pinnables.to_a.each.with_index(@current_pin_index) do |pinnable, indx|
      pinnable.update(pin_index: indx)
    end
  end
end
