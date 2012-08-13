require 'spec_helper'

describe AdvertsController do
  let(:advert) { stub(:advert, 
                      :update_attributes => true, 
                      :is_company_listing? => true)}

  it 'saves your company listing' do
    Advert.stub(:find).and_return(advert)
    post :update
    repsonse.should redirect_to FFT_MEMBERS_AREA_PATH
  end
end
