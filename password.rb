require "rubygems"
require "gooddata"


username = ARGV[0]
old_password = ARGV[1]
new_password = ARGV[2]
server = ARGV[3]



GoodData.connect(username,old_password) if server.nil?
GoodData.connect(username,old_password,{:server => server}) if !server.nil?
logger = Logger.new(STDOUT)

GoodData.logger = logger
GoodData.logger.level = Logger::DEBUG


begin
  profile = GoodData.get("/gdc/account/profile/current")
rescue => e
  exit 1
end
profile_id = profile["accountSetting"]["links"]["projects"].split("/")[4]

json = {
    "accountSetting" => {
      "firstName" => profile["accountSetting"]["firstName"],
      "lastName" => profile["accountSetting"]["lastName"],
      "old_password" => old_password,
      "password" => new_password,
      "verifyPassword" => new_password
  }
}


begin
  response = GoodData.put("/gdc/account/profile/#{profile_id}",json)
rescue => e
  exit 1
end



