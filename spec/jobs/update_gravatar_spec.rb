require 'spec_helper'

describe Jobs::UpdateGravatar do

  it "picks gravatar if system avatar is picked and gravatar was just downloaded" do
    user = User.create!(username: "bob", name: "bob", email: "a@a.com")
    user.uploaded_avatar_id.should == nil
    user.user_avatar.gravatar_upload_id.should == nil

    png = Base64.decode64("R0lGODlhAQABALMAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwICAgP8AAAD/AP//AAAA//8A/wD//wBiZCH5BAEAAA8ALAAAAAABAAEAAAQC8EUAOw==")
    FakeWeb.register_uri(:get, "http://www.gravatar.com/avatar/d10ca8d11301c2f4993ac2279ce4b930.png?s=500&d=404", body: png)

    SiteSetting.automatically_download_gravatars = true

    user.refresh_avatar
    user.reload

    user.uploaded_avatar_id.should == user.user_avatar.gravatar_upload_id
  end

end
