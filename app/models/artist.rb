# frozen_string_literal: true

# == Schema Information
#
# Table name: artists
#
#  id         :bigint           not null, primary key
#  identifier :string(255)      not null
#  name       :string(255)      not null
#  genres     :json
#  popularity :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_artists_on_identifier  (identifier) UNIQUE
#
class Artist < ApplicationRecord
end
