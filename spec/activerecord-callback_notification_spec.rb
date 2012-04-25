require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class CreateStuff < ActiveRecord::Migration
  def self.up
    create_table "foos" do |t|
      t.string "name"
    end
    create_table "bars" do |t|
      t.string "x"
    end
  end
end

class Foo < ActiveRecord::Base; end
class Bar < ActiveRecord::Base; end

describe "ActiverecordCallbackNotification" do
  before :all do
    ActiveRecord::Base.notify_callbacks!
    db = 'test.db'
    File.unlink db if File.exists? db
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => db
    )

    CreateStuff.up
  end
  before :all do
    @notifications = []
    ActiveSupport::Notifications.subscribe(/^callback:/) do |*data|
      @notifications << data
      true
    end
  end
  before :each do
    # clear array without messsing with pointer
    @notifications.size.times {@notifications.shift}
  end

  it "allows the model to save" do
    f = Foo.new(:name => "1")
    f.save!
  end

  it "works for create" do
    f = Foo.new(:name => "1")
    f.save!
    ac = @notifications.detect{|e| e[0] == 'callback:after_create'}
    ac.should_not be_nil
    ac.last[:object].should == f
    ac.last[:callback].should == :after_create
  end

  it "works for another model" do
    f = Bar.new(:x => "1")
    f.save!
    ac = @notifications.detect{|e| e[0] == 'callback:after_create'}
    ac.should_not be_nil
    ac.last[:object].should == f
    ac.last[:callback].should == :after_create
  end
end
