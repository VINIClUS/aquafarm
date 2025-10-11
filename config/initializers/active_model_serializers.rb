# config/initializers/active_model_serializers.rb
ActiveModelSerializers.config.adapter = :attributes
# Se quiser JSON:API padronizado, troque para :json_api
# ActiveModelSerializers.config.key_transform = :unaltered  # ou :camel_lower, :underscore, etc.
#ActiveModelSerializers.config.adapter = :json_api
#ActiveModelSerializers.config.jsonapi_include_toplevel_object = true