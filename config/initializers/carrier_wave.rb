CarrierWave.configure do |config|
  config.s3_access_key_id, config.s3_secret_access_key = TheDailyMo::AuthKeys.network_keys_and_secret(:s3)
  config.s3_bucket = TheDailyMo::AuthKeys.bucket(:s3)
end