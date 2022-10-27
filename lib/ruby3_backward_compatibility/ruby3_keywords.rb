module Ruby3BackwardCompatibility
  module Ruby3Keywords
    def self.extended(by)
      # prepend the anonymous module now, so the user has a chance to control where exactly we will end 
      # up in the prepend chain...
      by.send(:_ruby3_keywords_module)
    end

    def ruby3_keywords(*method_names)
      method_names.each do |method_name|
        method_is_private = private_instance_methods.include?(method_name)
        method_is_protected = protected_instance_methods.include?(method_name)

        required_param_count = instance_method(method_name).parameters.sum { |(kind, _name)| kind == :req ? 1 : 0 }
        _ruby3_keywords_module.define_method(method_name) do |*args|
          if args.last.respond_to?(:to_hash) && args.size > required_param_count
            keyword_args = args.pop
            super(*args, **keyword_args)
          else
            super(*args)
          end
        end

        if method_is_private
          _ruby3_keywords_module.send(:private, method_name)
        elsif method_is_protected
          _ruby3_keywords_module.send(:protected, method_name)
        end
      end
    end

    private

    def _ruby3_keywords_module
      @_ruby3_keywords_module ||= begin
        mod = Module.new
        prepend mod
        mod
      end
    end
  end
end
