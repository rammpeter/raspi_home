# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160513000000) do

  create_table "konfigurations", force: :cascade do |t|
    t.string   "UserName"
    t.string   "Passwort"
    t.integer  "Max_Stunde_Aktiv"
    t.integer  "Min_Aktiv_Stunden_je_Tag"
    t.integer  "Tage_Rueckwaerts_Mindestens_Aktiv"
    t.integer  "Min_Aktiv_Minuten_Vor_Vergleich"
    t.integer  "Max_Inaktiv_Minuten_Tagsueber"
    t.integer  "Inaktiv_Betrachtung_Start"
    t.integer  "Inaktiv_Betrachtung_Ende"
    t.integer  "Min_Aktiv_Fuer_Reinigung"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "konfigurations", ["created_at"], name: "index_konfigurations_on_created_at"

  create_table "temperaturs", force: :cascade do |t|
    t.datetime "Zeit"
    t.decimal  "Vorlauf",      precision: 6, scale: 3
    t.decimal  "Ruecklauf",    precision: 6, scale: 3
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.decimal  "Schatten",     precision: 6, scale: 3
    t.decimal  "Sonne",        precision: 6, scale: 3
    t.decimal  "Pumpenstatus", precision: 1
  end

  add_index "temperaturs", ["created_at"], name: "index_temperaturs_on_created_at"

end
