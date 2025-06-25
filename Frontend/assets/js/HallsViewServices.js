function showAlert (icon, title, text) {
  return Swal.fire({
    icon: icon,
    title: title,
    text: text,
    confirmButtonColor: '#3085d6'
  })
}
// Function to open hall services modal
async function openHallServicesModal (hall) {
  try {
    const token = localStorage.getItem('token')
    if (!token) {
      await showAlert(
        'error',
        'Error',
        'Authentication token not found. Please login again.'
      )
      return
    }

    // Show loading modal
    Swal.fire({
      title: 'Loading...',
      html: 'Fetching hall services',
      allowOutsideClick: false,
      didOpen: () => {
        Swal.showLoading()
      }
    })

    // Fetch hall services
    const response = await fetch(`${base_url}/api/halls/${hall.id}/services`, {
      headers: {
        Authorization: 'Bearer ' + token
      }
    })

    if (!response.ok) {
      throw new Error('Failed to fetch hall services')
    }

    const data = await response.json()
    Swal.close()
    if (!data.services || data.services.length === 0) {
      Swal.fire({
        icon: 'info',
        title: 'No Services Found',
        text: 'This hall has no Services yet.',
        confirmButtonText: 'OK'
      })
      return
    }
    // Create services modal HTML
    const servicesHtml = `
      <div class="text-left">
        <h3 class="text-lg font-bold mb-4">${hall.name} Services</h3>
        <div class="overflow-y-auto max-h-96">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Price</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Pricing Type</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              ${data.services
                .map(
                  service => `
                <tr>
                  <td class="px-6 py-4 whitespace-nowrap">${service.name}</td>
                  <td class="px-6 py-4 whitespace-nowrap">${
                    service.price_per_person
                  }</td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span class="px-2 py-1 text-xs rounded-full 
                      ${
                        service.pricing_type === 'static'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-purple-100 text-purple-800'
                      }">
                      ${service.pricing_type.replace(/_/g, ' ')}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <button onclick="editServiceModal(${service.id}, ${
                    hall.id
                  })"
                      class="text-sm bg-yellow-500 hover:bg-yellow-600 text-white px-3 py-1 rounded">
                      <i class="fas fa-edit mr-1"></i> Edit
                    </button>
                  </td>
                </tr>
              `
                )
                .join('')}
            </tbody>
          </table>
        </div>
      </div>
    `

    // Show services modal
    Swal.fire({
      title: 'Hall Services',
      html: servicesHtml,
      width: '800px',
      confirmButtonText: 'Close',
      confirmButtonColor: '#3085d6'
    })
  } catch (error) {
    Swal.close()
    await showAlert('error', 'Error', error.message)
  }
}

// Function to open edit service modal
async function editServiceModal (serviceId, hallId) {
  try {
    const token = localStorage.getItem('token')
    if (!token) {
      await showAlert(
        'error',
        'Error',
        'Authentication token not found. Please login again.'
      )
      return
    }

    // Fetch all services for the hall
    const response = await fetch(`${base_url}/api/halls/${hallId}/services`, {
      headers: {
        Authorization: 'Bearer ' + token
      }
    })

    if (!response.ok) {
      throw new Error('Failed to fetch service details')
    }

    const data = await response.json()

    // Find the specific service we want to edit
    const service = data.services.find(s => s.id == serviceId)

    if (!service) {
      throw new Error('Service not found')
    }

    // Create edit form HTML
    const formHtml = `
      <div class="text-left space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700">Service Name</label>
          <input type="text" id="editServiceName" value="${service.name}" 
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Price Per Person</label>
          <input type="number" id="editServicePrice" value="${
            service.price_per_person
          }" 
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Pricing Type</label>
          <select id="editServicePricingType"
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
            <option value="static" ${
              service.pricing_type === 'static' ? 'selected' : ''
            }>Static</option>
            <option value="invitation_based" ${
              service.pricing_type === 'invitation_based' ? 'selected' : ''
            }>Invitation Based</option>
          </select>
        </div>
      </div>
    `

    // Show edit modal
    const { isConfirmed } = await Swal.fire({
      title: 'Edit Service',
      html: formHtml,
      width: '600px',
      showCancelButton: true,
      confirmButtonText: 'Save Changes',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      preConfirm: () => {
        return {
          name: document.getElementById('editServiceName').value,
          price_per_person: document.getElementById('editServicePrice').value,
          pricing_type: document.getElementById('editServicePricingType').value
        }
      }
    })

    if (isConfirmed) {
      // Save changes
      const updateResponse = await fetch(
        `${base_url}/api/halls/${serviceId}/services`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: 'Bearer ' + token
          },
          body: JSON.stringify({
            name: document.getElementById('editServiceName').value,
            price_per_person: document.getElementById('editServicePrice').value,
            pricing_type: document.getElementById('editServicePricingType')
              .value
          })
        }
      )

      if (!updateResponse.ok) {
        throw new Error('Failed to update service')
      }

      await showAlert('success', 'Success', 'Service updated successfully!')
    }
  } catch (error) {
    await showAlert('error', 'Error', error.message)
  }
}
