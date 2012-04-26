# activerecord-callback_notification

This gem extends ActiveRecord to send an
ActiveSupport::Notification for each normal ActiveRecord callback.

## Usage

    require 'activerecord-callback_notifications'
    ActiveRecord::Base.notify_callbacks!

will setup notifications on all ActiveRecord models. You can also use
this in a single-model context, like:

    class Foo < ActiveRecord::Base
      notify_callbacks!
    end

Elsewhere you can subscribe to callbacks via

    ActiveSupport::Notifications.subscribe(/^callback:/) do |*data|
      # data is an array like
      # [ callback name, start timestamp, end timestamp, some id, information hash ]
      interesting_bit = data.last
      interesting_bit[:object] == your_active_record_object
      interesting_bit[:callback] == :the_callback # like :after_save or whatever
    end

This is primarily useful in a lazy/omniscient "observer-ish" context. You probably don't
want to use this system to monitor specific models.

## Contributing to activerecord-callback_notification
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Optoro, Inc. See LICENSE.txt for
further details.

