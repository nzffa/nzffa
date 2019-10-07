# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
#
require 'reader_mixin'
#require 'reader_validator'
require "radiant-nzffa-extension"

class NzffaExtension < Radiant::Extension
  version     RadiantNzffaExtension::VERSION
  description RadiantNzffaExtension::DESCRIPTION
  url         RadiantNzffaExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  extension_config do |config|
    # config is the Radiant.configuration object
  end

  def activate
    Reader.send :include, ReaderMixin
    Group.send :include, Nzffa::GroupExtension
    AccountsController.send :include, Nzffa::AccountsControllerExtension
    Admin::MessagesController.send :include, Nzffa::MessagesControllerExtension
    tab 'Readers' do
      add_item "Subscriptions", "/admin/subscriptions"
      add_item "Orders", "/admin/orders"
      add_item "Reports", "/admin/reports"
      add_item "Print Subscriptions", "/admin/subscriptions/batches_to_print"
    end

    Page.send :include, Nzffa::MessageSubscriptionTags
    Page.send :include, Nzffa::IfDescendantOrSelfTags
    Page.send :include, Nzffa::BranchTags
    Page.send :include, Nzffa::NewsletterLinkTags
    Page.send :include, Nzffa::ChildWithCorrespondingSlugTag

    admin.reader.index.add :thead, "ids_ths", :before => "title_header"
    admin.reader.index.add :tbody, "ids_tds", :before => "title_cell"
    admin.reader.edit.add :form, 'form_additions', :after => "edit_notes"
    admin.reader.edit.form_bottom.unshift 'form_bottom_additions'
    admin.group.edit.add :form, "group_levy", :after => "edit_group"
    admin.group.show.main.delete 'members'
    admin.group.show.main.delete 'pages'
    admin.group.show.footer.delete 'notes'
    admin.group.show.footer.delete 'javascript'
    admin.group.show.main << 'existing_pages'
    admin.group.show.main << 'members'
    admin.message.edit.add :main, "ck_editor_hooks"
    admin.message.show.delivery.delete 'options'
    admin.message.show.delivery << "delivery_options_override"
  end
end
