require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AdvertsController do
  let(:advert) { double("Advert", :id => 23) }

  context 'crud' do
    before :each do
      @controller.stub!(:authenticate)
      Advert.stub!(:find).with('23').and_return(advert)
    end

    it 'shows an advert' do
      get :show, :id => advert.id
      response.should be_success
      assigns(:advert).should == advert
    end

    it 'edits an advert' do
      get :edit, :id => advert.id
      response.should be_success
      assigns(:advert).should == advert
    end

    it 'updates an advert' do
      advert.should_receive(:update_attributes).with({'a' => 'b'})
      advert.stub!(:valid?).and_return(true)

      put :update, :id => advert.id, :advert => {'a' => 'b'}
      response.should be_redirect
      flash[:notice].should =~ /Updated/
    end

    it 'destroys an advert' do
      advert.should_receive(:destroy)

      delete :destroy, :id => advert.id
      response.should be_redirect
      flash[:notice].should =~ /Destroyed/
    end
  end
end
