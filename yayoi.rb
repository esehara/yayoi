require 'yaml'
require 'mechanize'
class Mind
  def initialize
    @config = YAML.load_file('./config.yaml')
    @mechanize = Mechanize.new
  end

  def login
    @identity = { name: @config['name'].encode('Shift_JIS'),
                  pass: @config['pass'],
                  os: 'Windows3.1',
                  mno: 1,
                  mojiiro: '696969',
                  rpass: '',
                  image: 'gar',
                  mode: "mobile"}

    @mechanize.post(@config['url'] + 'abibar.cgi', @identity)
    @identity['mode'] = 'mobile2'
    talk @config['greet'].shuffle.pop
  end

  def talk content
    @identity['chat'] = content.encode('Shift_JIS')
    @mechanize.post(@config['url' + 'abibar.cgi'], @identity)
  end

  def hear
    @mechanize.get(@config['url' + 'abibar.cgi?window=1&mode=checked'], {window: 1, mode: 'checked'}) do |page|
      data = page.search('font').map { |elem| elem.inner_text.encode('UTF-8') }
      @latest_name = data[-3]
      @latest_talk = data[-2]
    end
  end

  def response
    if @latest_talk.match(/#{@config['name']}/)
      talk "はい、何かお呼びでしょうか?"
    end
  end
end

class Yayoi
  def initialize
    @mind = Mind.new
    @mind.login
    while true
      sleep 10
      @mind.hear
    end
  end
end

Yayoi.new
