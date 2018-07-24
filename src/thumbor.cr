require "habitat"
require "./thumbor/*"

module Thumbor
  Habitat.create do
    setting key : String = "unsafe"
  end
end
