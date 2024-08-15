# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, length: { minimum: 2, maximum: 50 }
  validates :phone, length: { minimum: 10, maximum: 15 }
  validates :email, length: { maximum: 255 }
end
