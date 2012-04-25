require 'active_record'
require 'active_record/base'
require 'active_record/callbacks'

module ActiveRecord
  module CallbackNotifications
    extend ActiveSupport::Concern

    module ClassMethods
      def notify_callbacks!
        ActiveRecord::Callbacks::CALLBACKS.each do |callback|
          next if callback.to_s =~ /^around_/
          next unless respond_to?(callback)
          callback_meth = :"_instrument_notifications_for_#{callback}"
          next if respond_to?(callback_meth)
          define_method callback_meth do |&block|
            ActiveSupport::Notifications.instrument("callback:#{callback}",
                                                    :object => self,
                                                    :callback => callback
                                                   )
            true
          end
          send(callback, callback_meth)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include,  ActiveRecord::CallbackNotifications)
