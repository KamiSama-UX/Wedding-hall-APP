document.addEventListener('DOMContentLoaded', () => {
  // Define the columns you want to ignore (they will not appear in the table)
  const ignoredColumns = []

  // Fetch table data from the API
  const token = localStorage.getItem('token')
  fetch(`${base_url}/api/admin/customers`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'Bearer ' + token
    }
  })
    .then(response => response.json())
    .then(data => {
      // Stop if the response is not an array or is empty
      if (!Array.isArray(data) || data.length === 0) return

      // Get references to the table head and body
      const tableHead = document.getElementById('userTableHead')
      const tableBody = document.getElementById('userTableBody')

      // Extract keys from the first object in the array
      const keys = Object.keys(data[0]).filter(
        key => !ignoredColumns.includes(key)
      )

      // Dynamically create the table header
      const headRow = document.createElement('tr')
      keys.forEach(key => {
        const th = document.createElement('th')
        // Capitalize first letter and replace underscores with spaces
        th.textContent =
          key.charAt(0).toUpperCase() + key.slice(1).replace(/_/g, ' ')
        th.className = 'text-left p-2'
        headRow.appendChild(th)
      })
      tableHead.appendChild(headRow)

      // Create table rows for each item
      data.forEach(item => {
        const tr = document.createElement('tr')
        tr.className = 'border-b'

        keys.forEach(key => {
          const td = document.createElement('td')
          td.className = 'p-2'

          // Handle arrays differently
          if (Array.isArray(item[key])) {
            td.textContent =
              item[key].length > 0 ? `${item[key].length} items` : 'None'
          } else if (
            typeof item[key] === 'string' &&
            item[key].match(/^\d{4}-\d{2}-\d{2}T/)
          ) {
            const dateObj = new Date(item[key])
            const year = dateObj.getUTCFullYear()
            const month = String(dateObj.getUTCMonth() + 1).padStart(2, '0')
            const day = String(dateObj.getUTCDate()).padStart(2, '0')
            const hours = String(dateObj.getUTCHours()).padStart(2, '0')
            const minutes = String(dateObj.getUTCMinutes()).padStart(2, '0')
            const seconds = String(dateObj.getUTCSeconds()).padStart(2, '0')
            td.textContent = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
          } else {
            td.textContent = item[key]
          }

          tr.appendChild(td)
        })

        tableBody.appendChild(tr)
      })
    })
    .catch(error => {
      console.error('Error fetching data:', error)
    })
})
