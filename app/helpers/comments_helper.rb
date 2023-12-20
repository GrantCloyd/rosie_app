# frozen_string_literal: true

module CommentsHelper
  def commented_time_ago(comment)
    time_amount = DateTime.now.utc - comment.created_at

    "#{time_size(time_amount)} ago"
  end

  private

  def time_size(time_amount)
    time_size, date_type = if (time_amount / 1.months) > 1
                             [(time_amount / 1.months), 'month']
                           elsif (time_amount / 1.weeks) > 1
                             [(time_amount / 1.weeks), 'week']
                           elsif (time_amount / 1.days) > 1
                             [(time_amount / 1.days), 'day']
                           elsif (time_amount / 1.hours) > 1
                             [(time_amount / 1.hours), 'hour']
                           else
                             [(time_amount / 1.minutes), 'minute']
                           end

    pluralize(time_size.to_i, date_type)
  end
end
