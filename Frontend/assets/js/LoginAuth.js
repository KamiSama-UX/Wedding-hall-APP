document
  .getElementById('loginForm')
  .addEventListener('submit', async function (e) {
    e.preventDefault()

    // Show loading state
    document.getElementById('loadingSpinner').classList.remove('hidden')

    // Hide previous errors
    document.getElementById('emailError').classList.add('hidden')
    document.getElementById('passwordError').classList.add('hidden')

    const email = document.getElementById('email').value
    const password = document.getElementById('password').value

    try {
      const response = await fetch(`${base_url}/api/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email, password })
      })
      if (response.status === 429) {
        // Special handling for rate limiting
        const retryAfter = response.headers.get('Retry-After') || 30
        await Swal.fire({
          title: 'Too Many Attempts',
          html: `
                    <div class="text-center">
                        <p>Please wait <strong>${retryAfter}</strong> seconds before trying again.</p>
                        <div class="mt-4 flex justify-center">
                            <div class="w-3/4 bg-gray-200 rounded-full h-2.5">
                                <div class="bg-primary h-2.5 rounded-full" 
                                     style="width: 0%" id="rateLimitProgress">
                                </div>
                            </div>
                        </div>
                    </div>
                `,
          icon: 'error',
          confirmButtonText: 'OK',
          confirmButtonColor: '#D4A373',
          allowOutsideClick: false,
          showConfirmButton: false,
          timer: retryAfter * 1000,
          timerProgressBar: false,
          didOpen: () => {
            const progressBar = document.getElementById('rateLimitProgress')
            let width = 0
            const interval = setInterval(() => {
              width += 100 / retryAfter
              progressBar.style.width = `${width}%`
              if (width >= 100) clearInterval(interval)
            }, 1000)
          },
          willClose: () => {
            document.getElementById('email').focus()
          }
        })
        return
      }
      const data = await response.json()

      if (response.ok) {
        // Store data in localStorage
        localStorage.removeItem('token')
        localStorage.setItem('token', data.token)
        localStorage.setItem('userData', JSON.stringify(data.user))

        // Show success message
        await Swal.fire({
          title: 'Access Granted',
          html: `
            <div class="text-center">
                <p class="mb-2">Welcome <strong>${data.user.name}</strong>!</p>
                <p class="text-sm text-gray-600">${data.user.role} privileges activated</p>
            </div>
        `,
          icon: 'success',
          showConfirmButton: true,
          confirmButtonText: 'Enter Dashboard',
          confirmButtonColor: '#D4A373',
          timer: 3000,
          timerProgressBar: true,
          willClose: () => {
            window.location.href = '/dashboard.html'
          }
        })
      } else {
        // Handle different error types with specific messages
        let errorTitle = 'Login Failed'
        let errorText = 'Please check your credentials and try again.'
        let errorIcon = 'error'

        if (data.errors) {
          const emailError = data.errors.find(err => err.path === 'email')
          if (emailError) {
            errorTitle = 'Invalid Email'
            errorText = `
                <div class="text-left">
                    <p>• ${emailError.msg}</p>
                    <p class="mt-1 text-sm">Example: user@weddinghall.com</p>
                </div>
            `
          }
        } else if (data.error === 'Invalid credentials') {
          errorTitle = 'Access Denied'
          errorText = 'The password you entered is incorrect.'
          errorIcon = 'warning'
        } else if (response.status === 500) {
          errorTitle = 'Server Error'
          errorText =
            'Our system is temporarily unavailable. Please try again later.'
        }

        await Swal.fire({
          title: errorTitle,
          html: errorText,
          icon: errorIcon,
          confirmButtonText: 'Try Again',
          confirmButtonColor: '#D4A373',
          focusConfirm: false,
          allowOutsideClick: false,
          backdrop: `
            rgba(212, 163, 115, 0.1)
            url("/images/forbidden-icon.png")
            center top
            no-repeat
        `
        }).then(() => {
          
          document.getElementById('password').value = ''
          document.getElementById('password').focus()
        })
      }
    } catch (error) {
      console.error('Error:', error)
      Swal.fire({
        title: 'Error!',
        text: 'Server connection failed',
        icon: 'error',
        confirmButtonText: 'OK',
        confirmButtonColor: '#D4A373'
      })
    } finally {
      document.getElementById('loadingSpinner').classList.add('hidden')
    }
  })
