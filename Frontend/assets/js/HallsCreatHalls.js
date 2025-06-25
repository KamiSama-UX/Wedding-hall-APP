// create a hall
// Show/Hide Modal
const addHallBtn = document.getElementById('addHallBtn')
const addHallModal = document.getElementById('addHallModal')
const closeModal = document.getElementById('closeModal')

addHallBtn.addEventListener('click', () => {
  addHallModal.classList.remove('hidden')
})

closeModal.addEventListener('click', () => {
  addHallModal.classList.add('hidden')
})
// Fetch sub-admins and populate dropdown
document.addEventListener('DOMContentLoaded', function () {
  const token = localStorage.getItem('token')
  const selectElement = document.querySelector('select[name="sub_admin_id"]')

  fetch(`${base_url}/api/admin/sub-admins`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'Bearer ' + token
    }
  })
    .then(response => {
      if (!response.ok) throw new Error('Failed to fetch sub-admins')
      return response.json()
    })
    .then(data => {
      // Clear any existing options except the first one
      while (selectElement.options.length > 1) {
        selectElement.remove(1)
      }

      // Add new options
      data.forEach(subAdmin => {
        const option = document.createElement('option')
        option.value = subAdmin.id
        option.textContent = subAdmin.name
        selectElement.appendChild(option)
      })
    })
    .catch(error => {
      console.error('Error fetching sub-admins:', error)
      // Add a disabled option to show error
      const option = document.createElement('option')
      option.value = ''
      option.textContent = 'Failed to load sub-admins'
      option.disabled = true
      selectElement.appendChild(option)
    })
})
// Handle form submission
document
  .getElementById('hallForm')
  .addEventListener('submit', async function (e) {
    e.preventDefault()

    const formData = new FormData(this)
    const data = {
      name: formData.get('name'),
      location: formData.get('location'),
      capacity: parseInt(formData.get('capacity')),
      description: formData.get('description'),
      sub_admin_id: parseInt(formData.get('sub_admin_id'))
    }

    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`${base_url}/api/halls/create`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + token
        },
        body: JSON.stringify(data)
      })

      if (!response.ok) {
        const errorText = await response.text()
        throw new Error(errorText || 'Failed to add hall')
      }

      Swal.fire({
        icon: 'success',
        title: 'Hall added!',
        text: 'The hall was added successfully.',
        timer: 2000,
        showConfirmButton: false
      })

      addHallModal.classList.add('hidden')
      this.reset()
      loadHallsTable()
      // Optionally: reload the hall table or fetch updated data
    } catch (error) {
      console.error(error)
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: error.message || 'An error occurred while adding the hall.'
      })
    }
  })
