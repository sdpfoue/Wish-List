module Sync
  include OAuth
  
  def sync_to_douban(user,message)
    auth=user.get_auth('douban')
    @access_token = OAuth::AccessToken.new(
                        OAuth::Consumer.new(
                          "016fbfa638df0c66044f3ef2aa9d2532",  
                          "5675c3dcf1243fab", 
                          {
                            :site=>"http://api.douban.com",
                            :scheme=>:header,
                            :signature_method=>"HMAC-SHA1",
                            :realm=>"http://0.0.0.0:3000"
                          }
                      ),
                            auth['token'],
                            auth['secret']
                          )

    @response=@access_token.post "/miniblog/saying", %q{<?xml version='1.0' encoding='UTF-8'?>
      <entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
        <content>}+message+%q{</content>
      </entry>
    },  {"Content-Type" =>  "application/atom+xml"}
  end
  
  def sync_to_tsina(user,message)
    auth=user.get_auth('tsina')
    consumer=OAuth::Consumer.new("3919887720", "e6b59529eaab69871633f37966419a81", :site => "http://api.t.sina.com.cn")
    access_token = OAuth::AccessToken.new(consumer, auth['token'],auth['secret'])
    url="http://api.t.sina.com.cn/statuses/update.xml"      
    response = access_token.request(:post, url, :status=>message)
   end
  
  #functions for sync to providers
  def sync_to_provider(user,provider,message)
    case provider
    when 'tsina'
      sync_to_tsina(user,message)
    when 'douban'
      sync_to_douban(user,message)
    end
  end
end
