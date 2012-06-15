require 'spec_helper'

describe Admin::AdvertsController do
  context 'crud' do
    it 'shows an advert' do
      get :show, :id => @advert.id
      response.should be_success
      assigns(:advert).id.should == @advert.id
    end
    it 'edits an advert' do
      get :edit, :id => @advert.id
      response.should be_success
      assigns(:advert).id.should == @advert.id
    end
    it 'updates an advert' do
      put :update, :id => @advert.id
      response.should be_redirect
      flash[:notice].should =~ /updated/
    end

    it 'destroys an advert' do
      delete :destroy, :id => @advert.id
      response.should be_redirect
      assigns[:advert].should_not be_persisted
      flash[:notice].should =~ /destroyed/
    end
  end
end
