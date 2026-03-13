local _acl = {
  roles = {
    -- admin   = { 'address1' = true, 'address2' = true }
    -- [role1] = { 'address3' = true, 'address4' = true }
    -- [role2] = { 'address5' = true, 'address6' = true }
  }
}

function _acl.assertHasOneOfRole(address, roles)
  for _, role in pairs(roles) do
    if
      role == 'owner' and address == Owner or
      role == 'owner' and address == ao.id then
      return true
    elseif _acl.roles[role]
      and _acl.roles[role][address] ~= nil
    then
      return true
    end
  end
  assert(false, 'Permission Denied')
end

function _acl.updateRoles(updateRolesDto, state)
  state = state or _acl

  if updateRolesDto.Grant ~= nil then
    for address, roles in pairs(updateRolesDto.Grant) do
      assert(
        type(address) == 'string',
        'Address must be a string: ' .. tostring(address)
      )
      assert(type(roles) == 'table', 'Granted roles must be a list of strings')
      for _, role in pairs(roles) do
        assert(
          type(role) == 'string',
          'Role must be a string: ' .. tostring(role)
        )
        if state.roles[role] == nil then
          state.roles[role] = {}
        end
        state.roles[role][address] = true
      end
    end
  end

  if updateRolesDto.Revoke ~= nil then
    for address, roles in pairs(updateRolesDto.Revoke) do
      assert(
        type(address) == 'string',
        'Address must be a string: ' .. tostring(address)
      )
      assert(type(roles) == 'table', 'Revoked roles must be a list of strings')
      for _, role in pairs(roles) do
        assert(
          type(role) == 'string',
          'Role must be a string: ' .. tostring(role)
        )
        if state.roles[role] == nil then
          state.roles[role] = {}
        end
        state.roles[role][address] = nil
      end
    end
  end

  return state
end

return _acl
