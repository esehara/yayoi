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
                  mojiiro: 'black',
                  rpass: '',
                  iamge: 'gar',
                  mode: "mobile"}

    @mechanize.post(@config['url'] + 'abibar.cgi',
                   { name: @config['name'].encode('Shift_JIS'),
                     pass: @config['pass'],
                     os: 'Windows3.1',
                     mno: 1,
                     mojiiro: 'black',
                     rpass: '',
                     iamge: 'gar',
                     mode: "mobile"})
    @identity['mode'] = 'mobile2'
    @identity['chat'] = 'こんばんわ〜'.encode('Shift_JIS')
    @mechanize.post(@config['url' + 'abibar.cgi'], @identity)
  end
end

class Yayoi
  def initialize
    @mind = Mind.new
    @mind.login
  end
end

Yayoi.new
