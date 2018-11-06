class Cache

  API_RATE_LIMIT_YNAB_TOKEN = 'api-rate-limit-token-ynab'
  API_RATE_LIMIT_YNAB_TOKEN_EXP = "#{API_RATE_LIMIT_YNAB_TOKEN}_exp"
  API_RATE_LIMIT_YNAB = ''

  def self.token(token_id, object_id, expires_in)
    t = Rails.cache.read([token_id, object_id])
    unless t
      t = Cache.pseudo_random_token(5)
      Rails.cache.write(["#{token_id}_exp", object_id, t], Time.zone.now + expires_in, expires_in: expires_in)
      Rails.cache.write([token_id, object_id], t, expires_in: expires_in)
    end
    t
  end

  def self.reset_token(token_id, object_id)
    Rails.cache.delete([token_id, object_id])
  end

  def self.pseudo_random_token(length)
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0..length - 1).map { o[rand(o.length)] }.join
  end

end