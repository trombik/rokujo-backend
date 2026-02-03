# frozen_string_literal: true

require "guard/shell"

interactor :off

def rebuild_css
  `tailwindcss -i app/assets/tailwind/application.css -o app/assets/builds/tailwind.css `
end

guard :shell do
  watch(%r{^app/assets/.+\.(css|js|mjs)$}) do
    rebuild_css
  end

  watch(%r{^app/(components|views)/.+\.(rb|erb)$}) do
    rebuild_css
  end

  watch(%r{^spec/components/.+\.rb$}) do
    rebuild_css
  end
end
