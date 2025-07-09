//Add Service
// Open modal and set hall ID
function openAddServiceModal (hallId) {
  document.getElementById('hallIdInput').value = hallId
  document.getElementById('addServiceModal').classList.remove('hidden')
}

// Close modal and reset form
function closeAddServiceModal () {
  document.getElementById('addServiceModal').classList.add('hidden')
  document.getElementById('addServiceForm').reset()
}

// Handle form submission
document
  .getElementById('addServiceForm')
  .addEventListener('submit', function (e) {
    e.preventDefault()

    const hallId = document.getElementById('hallIdInput').value
    const name = document.getElementById('serviceName').value
    const price_per_person = parseFloat(
      document.getElementById('pricePerPerson').value
    )
    const pricing_type = document.getElementById('invitationType').value

    const token = localStorage.getItem('token')

    fetch(`${base_url}/api/halls/${hallId}/services`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token
      },
      body: JSON.stringify({
        name,
        price_per_person,
        pricing_type
      })
    })
      .then(async response => {
        // Check if response is not OK (status outside 200-299)
        if (!response.ok) {
          // Try to parse error message from response body
          const errorData = await response.json().catch(() => null)
          const errorMessage = errorData?.message || 'Failed to add service.'
          // Throw error to be caught below
          throw new Error(errorMessage)
        }
        return response.json()
      })
      .then(data => {
        // Show success alert
        Swal.fire({
          icon: 'success',
          title: 'Success',
          text: 'Service added successfully.'
        })
        // Close modal and reset form
        closeAddServiceModal()
      })
      .catch(error => {
        // Show error alert with error message
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: error.message
        })
        console.error('Error:', error)
      })
  })
