// Loads Halls
async function loadHallsTable () {
  // Define the columns you want to ignore (they will not appear in the table)
  const ignoredColumns = ['is_saved', 'photos', 'cover_photo']

  try {
    const response = await fetch(`${base_url}/api/halls/all`)
    const data = await response.json()

    if (!Array.isArray(data) || data.length === 0) return

    const tableHead = document.getElementById('TableHead')
    const tableBody = document.getElementById('TableBody')

    // Clear old content
    tableHead.innerHTML = ''
    tableBody.innerHTML = ''

    const keys = Object.keys(data[0]).filter(
      key => !ignoredColumns.includes(key)
    )

    // Header
    const headRow = document.createElement('tr')
    keys.forEach(key => {
      const th = document.createElement('th')
      th.textContent =
        key.charAt(0).toUpperCase() + key.slice(1).replace(/_/g, ' ')
      th.className = 'text-left p-2'
      headRow.appendChild(th)
    })

    // Actions header
    const th = document.createElement('th')
    th.textContent = 'Actions'
    th.className = 'text-left p-2'
    headRow.appendChild(th)

    tableHead.appendChild(headRow)

    // Rows
    data.forEach(item => {
      const tr = document.createElement('tr')
      tr.className = 'border-b'

      keys.forEach(key => {
        const td = document.createElement('td')
        td.className = 'p-2'
        td.textContent = Array.isArray(item[key])
          ? item[key].length > 0
            ? `${item[key].length} items`
            : 'None'
          : item[key]
        tr.appendChild(td)
      })

      const actionTd = document.createElement('td')
      actionTd.className = 'p-2 flex gap-2 flex-wrap'

      // 1. Edit button
      const editBtn = document.createElement('button')
      editBtn.className =
        'text-sm bg-yellow-500 hover:bg-yellow-600 text-white px-3 py-1 rounded'
      editBtn.innerHTML = '<i class="fas fa-edit mr-1"></i>Edit'
      editBtn.addEventListener('click', () => openEditModal(item))
      actionTd.appendChild(editBtn)

      // 2. Delete button
      const deleteBtn = document.createElement('button')
      deleteBtn.className =
        'text-sm bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded'
      deleteBtn.innerHTML = '<i class="fas fa-trash-alt mr-1"></i>Delete'
      deleteBtn.addEventListener('click', () => handleDelete(item.id))
      actionTd.appendChild(deleteBtn)

      // 3. View Services button
      const viewServicesBtn = document.createElement('button')
      viewServicesBtn.className =
        'text-sm bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-1 rounded'
      viewServicesBtn.innerHTML =
        '<i class="fas fa-list mr-1"></i>View Services'
      viewServicesBtn.addEventListener('click', () =>
        openHallServicesModal(item)
      )
      actionTd.appendChild(viewServicesBtn)

      // 4. Add Service button
      const addServiceBtn = document.createElement('button')
      addServiceBtn.className =
        'text-sm bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded'
      addServiceBtn.innerHTML = '<i class="fas fa-plus mr-1"></i>Add Service'
      addServiceBtn.addEventListener('click', () =>
        openAddServiceModal(item.id)
      )
      actionTd.appendChild(addServiceBtn)

      // 5. Photos button
      const photosBtn = document.createElement('button')
      photosBtn.className =
        'text-sm bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded'
      photosBtn.innerHTML = '<i class="fas fa-image mr-1"></i>Add a Photo'
      photosBtn.addEventListener('click', () => openAddPhotosModal(item.id))
      actionTd.appendChild(photosBtn)

      // 6. View Photos button
      const viewPhotosBtn = document.createElement('button')
      viewPhotosBtn.className =
        'text-sm bg-purple-600 hover:bg-purple-700 text-white px-3 py-1 rounded'
      viewPhotosBtn.innerHTML = '<i class="fas fa-images mr-1"></i>View Photos'
      viewPhotosBtn.addEventListener('click', () => viewHallPhotos(item.id))
      actionTd.appendChild(viewPhotosBtn)

      tr.appendChild(actionTd)
      tableBody.appendChild(tr)
    })
  } catch (error) {
    console.error('Error fetching halls:', error)
  }
}

// Load table on first page load
document.addEventListener('DOMContentLoaded', () => {
  loadHallsTable()
})
