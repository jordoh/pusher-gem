require 'spec_helper'

describe Hash do
  describe 'to_params' do
    {
      { "foo" => "bar", "baz" => "bat" } => "foo=bar&baz=bat",
      { "foo" => [ "bar", "baz" ] } => "foo[]=bar&foo[]=baz",
      { "foo" => [ {"bar" => "1"}, {"bar" => 2} ] } => "foo[][bar]=1&foo[][bar]=2",
      { "foo" => { "bar" => [ {"baz" => 1}, {"baz" => "2"}  ] } } => "foo[bar][][baz]=1&foo[bar][][baz]=2",
      { "foo" => {"1" => "bar", "2" => "baz"} } => "foo[1]=bar&foo[2]=baz"
    }.each do |hash, params|
       it "should covert hash: #{hash.inspect} to params: #{params.inspect}" do
         hash.to_params.split('&').sort.should == params.split('&').sort
       end
    end

    it 'should not leave a trailing &' do
      {
          :name => 'Bob',
          :address => {
              :street => '111 Ruby Ave.',
              :city => 'Ruby Central',
              :phones => ['111-111-1111', '222-222-2222']
          }
      }.to_params.should_not =~ /&$/
    end

    it 'should URL encode unsafe characters' do
      {:q => "?&\" +"}.to_params.should == "q=%3F%26%22%20%2B"
    end
  end
end
