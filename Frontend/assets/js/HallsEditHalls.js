// Edit Hall Modal Elements
const editHallModal = document.getElementById('editHallModal')
const closeEditModal = document.getElementById('closeEditModal')
const editHallForm = document.getElementById('editHallForm')
const subAdminSelect = editHallForm.querySelector('select[name="sub_admin_id"]')

/**
 * Fetches sub-admins list from API
 * @param {string} token - Authentication token
 * @returns {Promise<Array>} - Array of sub-admins
 */
async function fetchSubAdmins (token) {
  try {
    const response = await fetch(`${base_url}/api/admin/sub-admins`, {
      headers: {
        Authorization: 'Bearer ' + token
      }
    })
    if (!response.ok) throw new Error('Failed to fetch sub-admins')
    return await response.json()
  } catch (error) {
    console.error('Fetch sub-admins error:', error)
    throw error
  }
}

/**
 * Updates sub-admin dropdown with current selection
 * @param {number} hallId - ID of the hall being edited
 * @param {string} token - Authentication token
 */
async function updateSubAdminDropdown (hallId, token) {
  try {
    // Fetch current hall data to get assigned sub-admin
    const hallResponse = await fetch(`${base_url}/api/halls/${hallId}`, {
      headers: {
        Authorization: 'Bearer ' + token
      }
    })

    if (!hallResponse.ok) throw new Error('Failed to load hall data')
    const hallData = await hallResponse.json()
    const currentSubAdminId = hallData.sub_admin_id

    // Fetch all available sub-admins
    const subAdmins = await fetchSubAdmins(token)

    // Clear and rebuild dropdown
    subAdminSelect.innerHTML = ''

    // Add default option
    const defaultOption = document.createElement('option')
    defaultOption.value = ''
    defaultOption.textContent = 'Select Sub Admin'
    defaultOption.disabled = true
    subAdminSelect.appendChild(defaultOption)

    // Add sub-admin options
    subAdmins.forEach(subAdmin => {
      const option = document.createElement('option')
      option.value = subAdmin.id
      option.textContent = subAdmin.name

      // Auto-select current sub-admin
      if (subAdmin.id === currentSubAdminId) {
        option.selected = true
      }

      subAdminSelect.appendChild(option)
    })
  } catch (error) {
    console.error('Dropdown update error:', error)
    subAdminSelect.innerHTML = `
        <option value="" disabled selected>
          Error loading sub-admins
        </option>
      `
  }
}

/**
 * Opens edit modal and populates form fields
 * @param {Object} hall - Hall data object
 */
async function openEditModal (hall) {
  // Show modal
  editHallModal.classList.remove('hidden')

  // Fill basic fields
  editHallForm.name.value = hall.name
  editHallForm.location.value = hall.location
  editHallForm.capacity.value = hall.capacity
  editHallForm.description.value = hall.description
  editHallForm.id.value = hall.id

  // Load and update sub-admins dropdown
  const token = localStorage.getItem('token')
  await updateSubAdminDropdown(hall.id, token)
}

// Close modal handler
closeEditModal.addEventListener('click', () => {
  editHallModal.classList.add('hidden')
})

/**
 * Handles form submission
 * @param {Event} e - Form submit event
 */
editHallForm.addEventListener('submit', async function (e) {
  e.preventDefault()

  const id = editHallForm.id.value
  const token = localStorage.getItem('token')

  try {
    // 1. First update hall basic info (excluding sub_admin_id)
    const hallData = {
      name: editHallForm.name.value,
      location: editHallForm.location.value,
      capacity: parseInt(editHallForm.capacity.value),
      description: editHallForm.description.value
      // Note: sub_admin_id is intentionally excluded here
    }

    const hallResponse = await fetch(`${base_url}/api/halls/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token
      },
      body: JSON.stringify(hallData)
    })

    if (!hallResponse.ok) {
      const error = await hallResponse.json()
      throw new Error(error.message || 'Failed to update hall information')
    }

    // 2. Then handle sub-admin change separately if needed
    const newSubAdminId = parseInt(subAdminSelect.value)
    const currentSubAdminId = parseInt(editHallForm.dataset.currentSubAdmin) // Store this when loading form

    if (newSubAdminId !== currentSubAdminId) {
      try {
        const subAdminResponse = await fetch(
          `${base_url}/api/halls/${id}/reassign`,
          {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              Authorization: 'Bearer ' + token
            },
            body: JSON.stringify({ sub_admin_id: newSubAdminId })
          }
        )

        if (!subAdminResponse.ok) {
          const error = await subAdminResponse.json()
          // Ignore only the specific "logAction is not defined" error
          if (error.error !== 'logAction is not defined') {
            throw new Error(
              error.message || 'Failed to update sub-admin assignment'
            )
          }
          // If it is the logAction error, continue with success flow
          console.warn(
            'Sub-admin reassignment succeeded despite logging error:',
            error.error
          )
        }
      } catch (err) {
        // Only throw if it's not the expected logging error
        if (err.message !== 'logAction is not defined') {
          throw err
        }
        console.warn(
          'Sub-admin reassignment succeeded despite logging error:',
          err.message
        )
      }
    }

    // 3. Show success and refresh
    await Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: 'Hall updated successfully',
      confirmButtonText: 'OK'
    })

    editHallModal.classList.add('hidden')
    await loadHallsTable()
  } catch (err) {
    console.error('Update error:', err)
    Swal.fire({
      icon: 'error',
      title: 'Update Failed',
      text: err.message || 'An unexpected error occurred',
      confirmButtonText: 'OK'
    })
  }
})
