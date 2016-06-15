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

ActiveRecord::Schema.define(version: 20160615000000) do

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
    t.datetime "created_at",                                                                                                         null: false
    t.datetime "updated_at",                                                                                                         null: false
    t.integer  "modus"
    t.integer  "max_pool_temperatur",                                       default: 30
    t.string   "schalter_typ",                                              default: "Rutenbeck_TPIP1"
    t.string   "schalter_ip",                                               default: "192.168.178.48"
    t.string   "filename_vorlauf_sensor",                                   default: "/sys/bus/w1/devices/28-04146f57a7ff/w1_slave"
    t.string   "filename_ruecklauf_sensor",                                 default: "/sys/bus/w1/devices/28-04146f57bdff/w1_slave"
    t.string   "filename_sonne_sensor",                                     default: "/sys/bus/w1/devices/28-021503c262ff/w1_slave"
    t.string   "filename_schatten_sensor",                                  default: "/sys/bus/w1/devices/28-021503c981ff/w1_slave"
    t.string   "schalter_passwort"
    t.decimal  "min_sonne_ruecklauf_distanz",       precision: 3, scale: 1, default: 0.5
    t.decimal  "min_vorlauf_ruecklauf_distanz",     precision: 3, scale: 1, default: 0.2
  end

  add_index "konfigurations", ["created_at"], name: "index_konfigurations_on_created_at"

  create_table "temperaturs", force: :cascade do |t|
    t.datetime "Zeit"
    t.decimal  "Vorlauf",                          precision: 6, scale: 3
    t.decimal  "Ruecklauf",                        precision: 6, scale: 3
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.decimal  "Schatten",                         precision: 6, scale: 3
    t.decimal  "Sonne",                            precision: 6, scale: 3
    t.decimal  "Pumpenstatus",                     precision: 1
    t.integer  "wegen_temperatur_aktiv"
    t.integer  "wegen_zirkulationszeit_aktiv"
    t.integer  "wegen_zyklischer_reinigung_aktiv"
  end

  add_index "temperaturs", ["created_at"], name: "index_temperaturs_on_created_at"

end
