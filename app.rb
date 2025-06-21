# app.rb
require "unloosen"

content_script site: "www.google.com/maps/*" do
    puts "Hello Google Maps! by puts."
    console.log("Hello Google Maps! by console.log.")
end