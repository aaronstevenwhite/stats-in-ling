local removed = false

function Header(header)
  if header.level == 1 then
    if not removed then
      removed = true
      return {}
    end

    header.level = 2
    return header
  end
end
