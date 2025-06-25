// ملف tokenValidator.js
document.addEventListener('DOMContentLoaded', async function () {
  if (window.location.pathname.includes('login.html')) {
    await checkTokenAndRedirect()
    return
  }

  await checkTokenAndRedirect()
  setInterval(checkTokenAndRedirect, 30 * 60 * 1000)
})

async function checkTokenAndRedirect () {
  const token = localStorage.getItem('token')

  if (!token) {
    if (!window.location.pathname.includes('login.html')) {
      await showTokenAlert('No token found', 'Please login to continue')
    }
    return false
  }

  try {
    const response = await fetch(`${base_url}/api/auth/token-login`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })
    if (!response.ok) {
      throw new Error('Invalid token')
    }

    const data = await response.json()

    if (window.location.pathname.includes('login.html')) {
      window.location.href = 'dashboard.html'
      return true
    }

    // console.log('Token is valid', data.user)
    return true
  } catch (error) {
    localStorage.removeItem('token')
    localStorage.removeItem('userData')
    if (!window.location.pathname.includes('login.html')) {
      await showTokenAlert('Session Expired', 'Your session has expired')
    }
    return false
  }
}

async function showTokenAlert (title, text) {
  let timerInterval
  await Swal.fire({
    title: title,
    html: `${text}. Redirecting in <b></b> seconds...`,
    icon: 'error',
    timer: 5000,
    timerProgressBar: true,
    showConfirmButton: false,
    allowOutsideClick: false,
    willOpen: () => {
      Swal.showLoading()
      timerInterval = setInterval(() => {
        const content = Swal.getHtmlContainer()
        if (content) {
          const b = content.querySelector('b')
          if (b) {
            b.textContent = (Swal.getTimerLeft() / 1000).toFixed(0)
          }
        }
      }, 100)
    },
    willClose: () => {
      clearInterval(timerInterval)
      if (!window.location.pathname.includes('login.html')) {
        window.location.href = 'login.html'
      }
    }
  })
}
