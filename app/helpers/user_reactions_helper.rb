# frozen_string_literal: true

module UserReactionsHelper
  def status_to_unicode(status)
    unicode_map = { 'Likes' => "\u{1F44D}",
                    'Loves' => "\u{2665}",
                    'Celebrates' => "\u{1F64C}",
                    'Laughs' => "\u{1F606}" }

    unicode_map[status]
  end
end
