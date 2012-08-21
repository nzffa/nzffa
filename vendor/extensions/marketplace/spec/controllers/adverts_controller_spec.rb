require 'spec_helper'

describe AdvertsController do

  describe 'updating' do
    let(:advert) { stub(:advert, 
                        :update_attributes => true, 
                        :is_company_listing? => true)}

    it 'saves your company listing' do
      Advert.stub(:find).and_return(advert)
      advert.should_receive(:update_attributes).and_return(true)
      post :update
      repsonse.should redirect_to FFT_MEMBERS_AREA_PATH
    end
  end


  describe 'create' do
    describe 'company listings' do
      describe 'valid listing' do
        it 'updates reader attributes' do
          Advert.stub(:new, stub(:advert, :is_company_listing? => true))
          post :create, :advert => {:reader_attributes => {}}
          reader_stub = stub
          reader_stub.should_receive(:update_attributes).and_return(true)
          controller.stub(:current_reader, reader_stub)
        end
        it 'creates an advert and sets reader'
        it 'redirects to adverts path on success'
        it 'renders edit_company_listing on validation fail'
      end
    end
    describe 'adverts' do
      describe 'valid advert' do
        it 'creates advert and sets reader to current reader'
      end
      describe 'invalid advert' do
        it 'renders new'
      end
    end
  end
end
