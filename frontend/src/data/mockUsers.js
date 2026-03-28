
export const mockUsers = [
  { id: '1', fullName: 'Admin User', email: 'admin@gmail.com', password: '123456' },
  { id: '2', fullName: 'Nguyễn Văn A', email: 'user@example.com', password: 'password' },
  { id: '3', fullName: 'Test User', email: 'test@test.com', password: '123456' },
]

export function findUserByEmailAndPassword(email, password) {
  return mockUsers.find(
    (u) => u.email.toLowerCase() === email.trim().toLowerCase() && u.password === password
  )
}

export function findUserByEmail(email) {
  return mockUsers.find((u) => u.email.toLowerCase() === email.trim().toLowerCase())
}
