# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 4) do

  create_table "pings", :force => true do |t|
    t.column "created_at",    :datetime
    t.column "site_id",       :integer
    t.column "response_time", :integer
    t.column "response_code", :integer
    t.column "response_text", :string
  end

  create_table "sites", :force => true do |t|
    t.column "url",     :string
    t.column "user_id", :integer
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string
    t.column "email",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
  end

end
