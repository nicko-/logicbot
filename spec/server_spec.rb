# Copyright 2014 nick (nick@nicko.ml). This file is part of Logicbot.
#
#    Logicbot is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Logicbot is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Logicbot.  If not, see <http://www.gnu.org/licenses/>.
#

require 'minitest/spec'
require 'minitest/autorun'

require 'stringio'

require_relative '../lib/logicbot'

describe Logicbot::Server do
  it 'can correctly handle a server chat message broadcast' do
    server = Logicbot::Server.new '', '', '', 0
    io = StringIO.new "T,abc,def\n"
    server.instance_variable_set :@tcp, io
    server.get_event.must_equal({:type => :chat_broadcast, :message => 'abc,def'})
  end
  
  it 'can correctly handle a player chat message' do
    server = Logicbot::Server.new '', '', '', 0
    io = StringIO.new "T,player> test,test123\n"
    server.instance_variable_set :@tcp, io
    server.get_event.must_equal({:type => :chat_message, :sender => 'player', :message => 'test,test123'})
  end
  
  it 'can correctly handle a block change' do
    server = Logicbot::Server.new '', '', '', 0
    io = StringIO.new "B,0,0,1,1,1,5\n"
    server.instance_variable_set :@tcp, io
    server.get_event.must_equal({:type => :block_change, :pos => [1, 1, 1], :id => 5})
  end
  
  it 'can correctly handle a block change double-notify' do
    server = Logicbot::Server.new '', '', '', 0
    io = StringIO.new "B,1,1,1,1,1,5\n"
    server.instance_variable_set :@tcp, io
    server.get_event.must_equal nil
  end
  
  it 'can correctly handle a sign update' do
    server = Logicbot::Server.new '', '', '', 0
    io = StringIO.new "S,0,0,1,1,1,4,test,test\n"
    server.instance_variable_set :@tcp, io
    server.get_event.must_equal({:type => :sign_update, :pos => [1, 1, 1], :facing => 4, :text => 'test,test'})
  end
end
