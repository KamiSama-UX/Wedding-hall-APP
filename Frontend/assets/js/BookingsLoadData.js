document.addEventListener('DOMContentLoaded', () => {
  // Define the columns you want to ignore (they will not appear in the table)
  const ignoredColumns = ['actions']
  let allBookingsData = []

  // Status configuration
  const statusConfig = {
    pending: {
      label: 'Pending',
      colorBg: 'bg-orange-100',
      colorText: 'text-orange-800'
    },
    confirmed: {
      label: 'Confirmed',
      colorBg: 'bg-green-100',
      colorText: 'text-green-800'
    },
    declined: {
      label: 'Declined',
      colorBg: 'bg-gray-100',
      colorText: 'text-gray-800'
    }
  }

  // Status options for dropdown
  const statusOptions = [
    { value: 'pending', label: 'Pending' },
    { value: 'confirmed', label: 'Confirmed' },
    { value: 'declined', label: 'Declined' }
  ]

  // Status filter buttons
  const filterButtons = document.querySelectorAll('.status-filter button')
  let currentFilterStatus = 'all'

  // Add click event listeners to filter buttons
  filterButtons.forEach(button => {
    button.addEventListener('click', () => {
      filterButtons.forEach(btn => btn.classList.remove('active'))
      button.classList.add('active')
      currentFilterStatus = button.dataset.status
      filterTableByStatus(currentFilterStatus)
    })
  })

  // Function to show SweetAlert notification
  async function showAlert (icon, title, text) {
    return Swal.fire({
      icon: icon,
      title: title,
      text: text,
      confirmButtonColor: '#3085d6'
    })
  }

  // Function to completely refresh table data from API
  async function refreshTableData () {
    try {
      const token = localStorage.getItem('token')
      await checkTokenAndRedirect()
      // if (!token) {
      //   await showAlert(
      //     'error',
      //     'Error',
      //     'Authentication token not found. Please login again.'
      //   )
      //   return
      // }

      const response = await fetch(`${base_url}/api/admin/bookings`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + token
        }
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()

      if (!Array.isArray(data)) {
        throw new Error('Invalid data format')
      }

      // Completely replace old data with new data
      allBookingsData = data

      // Clear and rebuild the table
      rebuildTable()

      // Reapply current filter
      filterTableByStatus(currentFilterStatus)
    } catch (error) {
      console.error('Error refreshing data:', error)
      await showAlert(
        'error',
        'Error',
        'Error refreshing data: ' + error.message
      )
    }
  }

  // Function to completely rebuild table from scratch
  function rebuildTable () {
    const tableHead = document.getElementById('TableHead')
    const tableBody = document.getElementById('TableBody')

    // Clear existing table
    tableHead.innerHTML = ''
    tableBody.innerHTML = ''

    if (allBookingsData.length === 0) {
      tableBody.innerHTML =
        '<tr><td colspan="100%" class="p-4 text-center">No bookings found</td></tr>'
      return
    }

    // Build headers
    const keys = Object.keys(allBookingsData[0]).filter(
      key => !ignoredColumns.includes(key)
    )
    keys.push('actions')

    const headRow = document.createElement('tr')
    keys.forEach(key => {
      const th = document.createElement('th')
      th.textContent =
        key.charAt(0).toUpperCase() + key.slice(1).replace(/_/g, ' ')
      th.className = 'text-left p-2'
      headRow.appendChild(th)
    })
    tableHead.appendChild(headRow)

    // Build rows with current data
    createTableRows(allBookingsData)
  }

  // Function to filter table by status
  function filterTableByStatus (status) {
    const tableBody = document.getElementById('TableBody')
    tableBody.innerHTML = ''

    if (status === 'all') {
      createTableRows(allBookingsData)
      return
    }

    const filteredData = allBookingsData.filter(
      booking => booking.status.toLowerCase() === status.toLowerCase()
    )

    if (filteredData.length === 0) {
      tableBody.innerHTML =
        '<tr><td colspan="100%" class="p-4 text-center">No bookings match this filter</td></tr>'
      return
    }

    createTableRows(filteredData)
  }

  // Function to create table rows
  function createTableRows (data) {
    const tableBody = document.getElementById('TableBody')

    data.forEach(item => {
      const tr = document.createElement('tr')
      tr.className = 'border-b'
      tr.dataset.bookingId = item.id

      const keys = Object.keys(item).filter(
        key => !ignoredColumns.includes(key)
      )

      keys.forEach(key => {
        const td = document.createElement('td')
        td.className = 'p-2'

        if (key === 'status') {
          const cfg = statusConfig[item[key]] || {
            label: item[key],
            colorBg: 'bg-gray-100',
            colorText: 'text-gray-800'
          }
          const statusSpan = document.createElement('span')
          statusSpan.className = `${cfg.colorBg} ${cfg.colorText} px-2 py-1 rounded-full text-xs font-semibold`
          statusSpan.textContent = cfg.label
          td.appendChild(statusSpan)
        } else if (Array.isArray(item[key])) {
          td.textContent =
            item[key].length > 0 ? `${item[key].length} items` : 'None'
        } else if (
          typeof item[key] === 'string' &&
          item[key].match(/^\d{4}-\d{2}-\d{2}T/)
        ) {
          const dateObj = new Date(item[key])
          td.textContent = dateObj.toLocaleString()
        } else {
          td.textContent = item[key] || '---'
        }

        tr.appendChild(td)
      })

      // Add actions cell
      const actionsTd = document.createElement('td')
      actionsTd.className = 'p-2 flex gap-2 items-center'

      const select = document.createElement('select')
      select.className = 'border rounded p-1 text-sm'
      select.dataset.bookingId = item.id

      statusOptions.forEach(option => {
        const opt = document.createElement('option')
        opt.value = option.value
        opt.textContent = option.label
        opt.selected = option.value === item.status
        select.appendChild(opt)
      })

      const updateBtn = document.createElement('button')
      updateBtn.className =
        'bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm'
      updateBtn.textContent = 'Update'
      updateBtn.addEventListener('click', () => updateBookingStatus(item.id))

      actionsTd.appendChild(select)
      actionsTd.appendChild(updateBtn)
      tr.appendChild(actionsTd)

      tableBody.appendChild(tr)
    })
  }

  // Function to update booking status
  async function updateBookingStatus (bookingId) {
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

      const selectElement = document.querySelector(
        `select[data-booking-id="${bookingId}"]`
      )
      const newStatus = selectElement.value

      const { isConfirmed } = await Swal.fire({
        title: 'Confirm Update',
        text: `Are you sure you want to change status to "${newStatus}"?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, update it!',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33'
      })

      if (!isConfirmed) {
        return
      }

      const response = await fetch(
        `${base_url}/api/admin/bookings/${bookingId}/status`,
        {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            Authorization: 'Bearer ' + token
          },
          body: JSON.stringify({
            status: newStatus,
            booking_id: bookingId
          })
        }
      )

      if (!response.ok) {
        const error = await response.json()
        throw new Error(error.message || 'Failed to update status')
      }

      await showAlert('success', 'Success!', 'Status updated successfully!')

      // Completely refresh data from API
      await refreshTableData()
    } catch (error) {
      console.error('Error updating status:', error)
      await showAlert('error', 'Error', 'Error: ' + error.message)
    }
  }

  // Initial data load
  refreshTableData()
})
