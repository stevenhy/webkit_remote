require File.expand_path('../helper.rb', File.dirname(__FILE__))

describe WebkitRemote::Process do
  describe 'on Xvfb' do
    before :each do
      @process = WebkitRemote::Process.new port: 9669, xvfb: true
    end
    after :each do
      @process.stop if @process
    end

    describe '#running' do
      it 'returns false before #start is called' do
        @process.running?.must_equal false
      end
    end

    describe '#start' do
      before :each do
        @browser = @process.start
      end
      after :each do
        @browser.close if @browser
        @process.stop if @process
      end

      it 'makes running? return true' do
        @process.running?.must_equal true
      end

      it 'returns a Browser instance that does not auto-stop the process' do
        @browser.must_be_kind_of WebkitRemote::Browser
        @browser.closed?.must_equal false
        @browser.stop_process?.must_equal false
      end

      describe '#stop' do
        before :each do
          @process.stop
        end

        it 'makes running? return false' do
          @process.running?.must_equal false
        end

        it 'kills the http server that responds to /json' do
          begin
            @browser.tabs
            fail 'browser process not killed'
          rescue EOFError
            pass
          rescue Errno::ECONNRESET
            pass
          end
        end
      end
    end
  end

  describe 'on real X desktop' do
    before :each do
      unless ENV['DISPLAY'] and /\:\d+/ =~ ENV['DISPLAY']
        skip 'No real X desktop configured'
      end
      @process = WebkitRemote::Process.new port: 9669
    end
    after :each do
      @process.stop if @process
    end

    describe '#start' do
      before :each do
        @browser = @process.start
      end
      after :each do
        @browser.close if @browser
        @process.stop if @process
      end

      it 'returns a Browser instance that does not auto-stop the process' do
        @browser.must_be_kind_of WebkitRemote::Browser
        @browser.closed?.must_equal false
        @browser.stop_process?.must_equal false
      end

      describe '#stop' do
        before :each do
          @process.stop
        end

        it 'kills the http server that responds to /json' do
          begin
            @browser.tabs
            fail 'browser process not killed'
          rescue EOFError
            pass
          rescue Errno::ECONNRESET
            pass
          end
        end
      end
    end
  end
end
