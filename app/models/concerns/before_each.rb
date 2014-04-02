module BeforeEach
  extend ActiveSupport::Concern

  module ClassMethods
    def method_added(method)
      method = method.to_s.gsub(/_with(out)?_before$/, '')
      with_method, without_method = "#{method}_with_before", "#{method}_without_before"

      return if method == 'before_each' or method_defined?(with_method)

      define_method(with_method) do |*args, &block|
        before_each
        send(without_method, *args, &block)
      end
      alias_method_chain(method, :before)
    end
  end

  def before_each
  end
end