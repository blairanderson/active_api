require "active_api/engine"

module ActiveApi
  def self.auth
    return {
      model: "ApiKey",
      user: "user",
      token: "token"
    }.merge(ActiveApi::Engine.config.try(:authorization) || {})
  end
end

module ActiveApiDefinition
  TRUE_VALUES = ["true", true, "1", 1]

  ALLOWED_TYPES = {
    array: [[Array]],
    hash: [[Hash]],
    boolean: [[Object], -> v { TRUE_VALUES.include?(v) }],
    default: [[String, Numeric]],
  }

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      class_attribute :scopes_configuration, instance_writer: false
      self.scopes_configuration = {}
    end
  end

  module ClassMethods

    def has_scope(*scopes, &block)
      options = scopes.extract_options!
      options.symbolize_keys!
      options.assert_valid_keys(:type, :only, :except, :if, :unless, :default, :as, :using, :allow_blank, :in)

      if options.key?(:in)
        options[:as] = options[:in]
        options[:using] = scopes
      end

      if options.key?(:using)
        if options.key?(:type) && options[:type] != :hash
          raise "You cannot use :using with another :type different than :hash"
        else
          options[:type] = :hash
        end

        options[:using] = Array(options[:using])
      end

      options[:only] = Array(options[:only])
      options[:except] = Array(options[:except])

      self.scopes_configuration = scopes_configuration.dup

      scopes.each do |scope|
        scopes_configuration[scope] ||= {:as => scope, :type => :default, :block => block}
        scopes_configuration[scope] = self.scopes_configuration[scope].merge(options)
      end
    end

    def apply_property_names(target, hash)
      if hash[:pluck].present?
        target.pluck(hash[:pluck])
      else
        target
      end
    end

    def apply_scopes(target, hash)
      scopes_configuration.each do |scope, options|
        key = options[:as]
        if hash.key?(key)
          value, call_scope = hash[key], true
        elsif options.key?(:default)
          value, call_scope = options[:default], true
          if value.is_a?(Proc)
            value = value.arity == 0 ? value.call : value.call(self)
          end
        end

        value = parse_value(options[:type], key, value)
        value = normalize_blanks(value)

        if call_scope && (value.present? || options[:allow_blank])
          current_scopes[key] = value
          target = call_scope_by_type(options[:type], scope, target, value, options)
        end
      end

      target
    end


    # Set the real value for the current scope if type check.
    def parse_value(type, key, value) #:nodoc:
      klasses, parser = ALLOWED_TYPES[type]
      if klasses.any? { |klass| value.is_a?(klass) }
        parser ? parser.call(value) : value
      end
    end

    # Screens pseudo-blank params.
    def normalize_blanks(value) #:nodoc:
      case value
        when Array
          value.select { |v| v.present? }
        when Hash
          value.select { |k, v| normalize_blanks(v).present? }.with_indifferent_access
        else
          value
      end
    end

    # Call the scope taking into account its type.
    def call_scope_by_type(type, scope, target, value, options) #:nodoc:
      block = options[:block]

      if type == :boolean && !options[:allow_blank]
        block ? block.call(self, target) : target.send(scope)
      elsif value && options.key?(:using)
        value = value.values_at(*options[:using])
        block ? block.call(self, target, value) : target.send(scope, *value)
      else
        block ? block.call(self, target, value) : target.send(scope, value)
      end
    end

    # Evaluates the scope options :if or :unless. Returns true if the proc
    # method, or string evals to the expected value.
    def applicable?(string_proc_or_symbol, expected) #:nodoc:
      case string_proc_or_symbol
        when String
          eval(string_proc_or_symbol) == expected
        when Proc
          string_proc_or_symbol.call(self) == expected
        when Symbol
          send(string_proc_or_symbol) == expected
        else
          true
      end
    end

    # Returns the scopes used in this action.
    def current_scopes
      @current_scopes ||= {}
    end
  end

end


ActiveSupport.on_load(:active_model_serializers) do
  include ActiveApiDefinition
  extend WillPaginate::PerPage
end



