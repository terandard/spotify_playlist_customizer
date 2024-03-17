# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  identifier    :string(255)      not null
#  access_token  :string(512)      not null
#  refresh_token :string(512)      not null
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_users_on_identifier  (identifier) UNIQUE
#
class User < ApplicationRecord
  has_many :playlists, dependent: :destroy
end
