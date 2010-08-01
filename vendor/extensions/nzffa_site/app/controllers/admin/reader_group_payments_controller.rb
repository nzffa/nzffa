class Admin::ReaderGroupPaymentsController < ApplicationController
  inherit_resources
  respond_to :html, :js
  actions :index, :show, :new, :create, :edit, :update, :destroy
  
end