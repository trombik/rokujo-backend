def find_by_testid(id, ...)
  find("[data-testid='#{id}']", ...)
end

def have_testid(id)
  have_css("[data-testid='#{id}']")
end

def find_by_testid_starting_with(id, ...)
  find("[data-testid^='#{id}']", ...)
end

def have_testid_starting_with(id, ...)
  have_css("[data-testid^='#{id}']", ...)
end
