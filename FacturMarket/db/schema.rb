# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_11_09_235438) do
  create_table "__EFMigrationsHistory", primary_key: "MigrationId", id: :string, force: :cascade do |t|
    t.string "ProductVersion", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", limit: 19, precision: 19, null: false
    t.integer "blob_id", limit: 19, precision: 19, null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.integer "byte_size", limit: 19, precision: 19, null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", limit: 19, precision: 19, null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", primary_key: "Id", id: { limit: 10, precision: 10, default: 0 }, force: :cascade do |t|
    t.string "Name", null: false
    t.string "Email", null: false
    t.string "Identification", null: false
    t.string "Address", null: false
    t.datetime "CreatedAt", precision: 7, null: false
    t.datetime "UpdatedAt", precision: 7
  end

  create_table "invoices", force: :cascade do |t|
    t.string "series"
    t.integer "number", precision: 38, null: false
    t.string "issuer_nit"
    t.string "issuer_name"
    t.string "receiver_nit"
    t.string "receiver_name"
    t.date "issue_date"
    t.decimal "subtotal", precision: 15, scale: 2, null: false
    t.decimal "total", precision: 15, scale: 2, null: false
    t.decimal "vat", precision: 15, scale: 2, null: false
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "receiver_id", precision: 38
    t.index ["series", "number"], name: "idx_unique_invoice_series_number", unique: true
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "invoice_id", precision: 38, null: false
    t.string "description"
    t.integer "quantity", precision: 38
    t.decimal "price"
    t.decimal "subtotal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "line_items", "invoices"
end
