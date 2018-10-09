Rails.application.config.session_store :redis_store,
                                       servers: Rails.application.config.redis_session_url,
                                       expires_in: 1.hour
