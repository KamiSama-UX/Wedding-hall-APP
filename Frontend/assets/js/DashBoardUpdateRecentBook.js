// Configuration for different booking statuses and their corresponding label/colors
const statusConfig = {
  confirmed: {
    label: 'Confirmed',
    colorBg: 'bg-green-100',
    colorText: 'text-green-800'
  },
  pending: {
    label: 'Pending',
    colorBg: 'bg-orange-100',
    colorText: 'text-orange-800'
  },
  cancelled: {
    label: 'Cancelled',
    colorBg: 'bg-red-100',
    colorText: 'text-red-800'
  },
  declined: {
    label: 'Declined',
    colorBg: 'bg-gray-100',
    colorText: 'text-gray-800'
  }
}

// All possible status options for the dropdown
const statusOptions = [
  { value: 'pending', label: 'Pending' },
  { value: 'confirmed', label: 'Confirmed' },
  { value: 'declined', label: 'Declined' }
]

// Format a UTC date string into readable format YYYY-MM-DD HH:mm:ss
function formatDateTime (dateString) {
  if (!dateString) return ''
  const dateObj = new Date(dateString)
  const year = dateObj.getUTCFullYear()
  const month = String(dateObj.getUTCMonth() + 1).padStart(2, '0')
  const day = String(dateObj.getUTCDate()).padStart(2, '0')
  const hours = String(dateObj.getUTCHours()).padStart(2, '0')
  const minutes = String(dateObj.getUTCMinutes()).padStart(2, '0')
  const seconds = String(dateObj.getUTCSeconds()).padStart(2, '0')
  return `${year} - ${month} - ${day} ${hours}: ${minutes}: ${seconds}`
}

// Mapping raw data keys to user-friendly column titles
const columnDisplayNames = {
  id: 'ID',
  customer_name: 'Customer',
  hall_name: 'Hall',
  event_date: 'Date',
  event_time: 'Time',
  created_at: 'Created At',
  status: 'Status'
}

// Convert unknown keys to human-readable format
function prettifyColumnName (key) {
  if (columnDisplayNames[key]) return columnDisplayNames[key]
  return key
    .replace(/([A-Z])/g, ' $1')
    .replace(/_/g, ' ')
    .replace(/\w\S*/g, w => w.charAt(0).toUpperCase() + w.slice(1))
}

// Build table header with desired column order
function buildTableHeader () {
  const thead = document.getElementById('recentBookingsHead')
  thead.innerHTML = '' // Clear previous headers
  const tr = document.createElement('tr')
  tr.classList.add('border-b')

  const orderedColumns = [
    'id',
    'customer_name',
    'hall_name',
    'event_date',
    'event_time',
    'created_at',
    'status'
  ]

  orderedColumns.forEach(col => {
    const th = document.createElement('th')
    th.className = 'text-left p-2'
    th.textContent = prettifyColumnName(col)
    tr.appendChild(th)
  })

  // Always add an "Actions" column at the end
  const actionsTh = document.createElement('th')
  actionsTh.className = 'text-left p-2'
  actionsTh.textContent = 'Actions'
  tr.appendChild(actionsTh)

  thead.appendChild(tr)
}

// Create a row based on booking data and predefined column order
function createBookingRow (booking) {
  const tr = document.createElement('tr')
  tr.classList.add('border-b')

  const orderedColumns = [
    'id',
    'customer_name',
    'hall_name',
    'event_date',
    'event_time',
    'created_at',
    'status'
  ]

  orderedColumns.forEach(col => {
    const td = document.createElement('td')
    td.className = 'p-2'

    if (col === 'created_at' || col === 'event_date') {
      td.textContent = formatDateTime(booking[col])
    } else if (col === 'event_time') {
      td.textContent = booking[col] || ''
    } else if (col === 'status') {
      const status = booking[col]
      const statusSpan = document.createElement('span')
      const cfg = statusConfig[status] || {
        label: status,
        colorBg: 'bg-gray-100',
        colorText: 'text-gray-700'
      }
      statusSpan.className = `${cfg.colorBg} ${cfg.colorText} px - 2 py - 1 rounded - full font - semibold`
      statusSpan.textContent = cfg.label
      td.appendChild(statusSpan)
    } else {
      td.textContent = booking[col] ?? ''
    }

    tr.appendChild(td)
  })

  // Create "Actions" cell with dropdown and update button
  const actionsTd = document.createElement('td')
  actionsTd.className = 'p-2 flex gap-2 items-center'

  // Create dropdown select
  const select = document.createElement('select')
  select.className = 'border rounded p-1 bg-white'
  select.id = `status - select - ${booking.id}`

  // Add options to dropdown
  statusOptions.forEach(option => {
    const optElement = document.createElement('option')
    optElement.value = option.value
    optElement.textContent = option.label
    if (option.value === booking.status) {
      optElement.selected = true
    }
    select.appendChild(optElement)
  })

  actionsTd.appendChild(select)

  // Create update button
  const updateBtn = document.createElement('button')
  updateBtn.textContent = 'Update'
  updateBtn.className =
    'bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded'
  updateBtn.addEventListener('click', () => {
    const newStatus = document.getElementById(
      `status - select - ${booking.id}`
    ).value
    handleAction(booking.id, newStatus)
  })

  actionsTd.appendChild(updateBtn)

  tr.appendChild(actionsTd)

  return tr
}

// Send booking status update request
function handleAction (bookingId, newStatus) {
  const token = localStorage.getItem('token')
  if (!token) {
    Swal.fire('Error', 'Authentication token not found.', 'error')
    return
  }

  // API endpoint for updating booking status
  const endpoint = `${base_url}/api/admin/bookings/${bookingId}/status`

  // Send PATCH request with updated status and booking ID
  fetch(endpoint, {
    method: 'PATCH',
    headers: {
      Authorization: 'Bearer ' + token,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      status: newStatus,
      booking_id: bookingId
    })
  })
    .then(async response => {
      if (!response.ok) {
        const errorData = await response.json().catch(() => null)
        throw new Error(errorData?.message || 'Action failed.')
      }
      return response.json()
    })
    .then(() => {
      Swal.fire(
        'Success',
        `Booking status updated to ${newStatus} successfully.`,
        'success'
      )
      loadRecentBookings() // Reload the table after update
    })
    .catch(error => {
      Swal.fire('Error', error.message, 'error')
      console.error('Action error:', error)
    })
}

// Fetch recent bookings and render table
function loadRecentBookings () {
  const token = localStorage.getItem('token')
  const tbody = document.getElementById('recentBookingsBody')

  if (!token) {
    tbody.innerHTML =
      '<tr><td colspan="100%" class="p-2 text-center text-red-600">Authentication token not found.</td></tr>'
    return
  }

  fetch(`${base_url}/api/admin/bookings/recent?limit=10`, {
    headers: {
      Authorization: 'Bearer ' + token
    }
  })
    .then(async response => {
      if (!response.ok) {
        const errorData = await response.json().catch(() => null)
        throw new Error(errorData?.message || 'Failed to fetch bookings.')
      }
      return response.json()
    })
    .then(bookings => {
      tbody.innerHTML = '' // Clear previous rows

      if (!bookings.length) {
        tbody.innerHTML =
          '<tr><td colspan="100%" class="p-2 text-center">No recent bookings found.</td></tr>'
        return
      }

      // Build header once
      buildTableHeader()

      // Build rows
      bookings.forEach(booking => {
        const row = createBookingRow(booking)
        tbody.appendChild(row)
      })
    })
    .catch(error => {
      tbody.innerHTML = `< tr > <td colspan="100%" class="p-2 text-center text-red-600">${error.message}</td></tr >`
      console.error('Fetch error:', error)
    })
}

// Load data on page load
loadRecentBookings()
