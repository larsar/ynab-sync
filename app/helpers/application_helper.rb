module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then "alert alert-info"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-danger"
    when 'alert' then "alert alert-warning"
    end
  end

  def ynab_rate_limit
    default = '0/200'
    return '' unless current_user
    token = Rails.cache.read([Cache::API_RATE_LIMIT_YNAB_TOKEN, current_user.id])
    return default if token.blank?
    limit = Rails.cache.read([Cache::API_RATE_LIMIT_YNAB, current_user.id, token])
    return "#{limit || default} (#{ynab_rate_limit_until})"
  end

  def ynab_rate_limit_until
    default = '60 min'
    return default unless current_user
    token = Rails.cache.read([Cache::API_RATE_LIMIT_YNAB_TOKEN, current_user.id])
    return default if token.blank?
    exp = Rails.cache.read([Cache::API_RATE_LIMIT_YNAB_TOKEN_EXP, current_user.id, token])
    if exp
      return "#{((exp - Time.zone.now) / 60).to_i} min"
    end
    return default
  end


end
