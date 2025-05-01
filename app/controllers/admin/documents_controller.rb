# This documents controller should be under admin, at least for now
#
class Admin::DocumentsController < ApplicationController
  before_action :set_admin_category, only: %i[ show edit update destroy ]
end
