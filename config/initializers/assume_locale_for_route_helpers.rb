# this is a one-line modification of NamedRouteCollection from ActionPack 2.3.5
# line 29: it makes it unnecessary to specify a :locale param to named route url helpers (e.g. user_path)

module ActionController
  module Routing
    class RouteSet
      class NamedRouteCollection
          def define_url_helper(route, name, kind, options)
            selector = url_helper_name(name, kind)
            # The segment keys used for positional paramters

            hash_access_method = hash_access_name(name, kind)

            # allow ordered parameters to be associated with corresponding
            # dynamic segments, so you can do
            #
            #   foo_url(bar, baz, bang)
            #
            # instead of
            #
            #   foo_url(:bar => bar, :baz => baz, :bang => bang)
            #
            # Also allow options hash, so you can do
            #
            #   foo_url(bar, baz, bang, :sort_by => 'baz')
            #
            named_helper_module_eval <<-end_eval # We use module_eval to avoid leaks
              def #{selector}(*args)                                                        # def users_url(*args)
                #{'args.unshift I18n.locale' if route.segment_keys.include?(:locale)}
                                                                                            #
                #{generate_optimisation_block(route, kind)}                                 #   #{generate_optimisation_block(route, kind)}
                                                                                            #
                opts = if args.empty? || Hash === args.first                                #   opts = if args.empty? || Hash === args.first
                  args.first || {}                                                          #     args.first || {}
                else                                                                        #   else
                  options = args.extract_options!                                           #     options = args.extract_options!
                  args = args.zip(#{route.segment_keys.inspect}).inject({}) do |h, (v, k)|  #     args = args.zip([]).inject({}) do |h, (v, k)|
                    h[k] = v                                                                #       h[k] = v
                    h                                                                       #       h
                  end                                                                       #     end
                  options.merge(args)                                                       #     options.merge(args)
                end                                                                         #   end
                                                                                            #
                url_for(#{hash_access_method}(opts))                                        #   url_for(hash_for_users_url(opts))
                                                                                            #
              end                                                                           # end
              #Add an alias to support the now deprecated formatted_* URL.                  # #Add an alias to support the now deprecated formatted_* URL.
              def formatted_#{selector}(*args)                                              # def formatted_users_url(*args)
                ActiveSupport::Deprecation.warn(                                            #   ActiveSupport::Deprecation.warn(
                  "formatted_#{selector}() has been deprecated. " +                         #     "formatted_users_url() has been deprecated. " +
                  "Please pass format to the standard " +                                   #     "Please pass format to the standard " +
                  "#{selector} method instead.", caller)                                    #     "users_url method instead.", caller)
                #{selector}(*args)                                                          #   users_url(*args)
              end                                                                           # end
              protected :#{selector}                                                        # protected :users_url
            end_eval
            helpers << selector
          end
      end
    end
  end
end


