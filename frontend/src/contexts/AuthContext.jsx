import { createContext, useContext, useState, useCallback } from 'react'
import { findUserByEmailAndPassword } from '../data/mockUsers'

const AuthContext = createContext(null)

const STORAGE_KEY = 'english_admin_user'

function getStoredUser() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(getStoredUser)

  const login = useCallback((email, password) => {
    const found = findUserByEmailAndPassword(email, password)
    if (found) {
      const { password: _, ...rest } = found
      const toStore = { ...rest }
      setUser(toStore)
      localStorage.setItem(STORAGE_KEY, JSON.stringify(toStore))
      return { success: true }
    }
    return { success: false, message: 'Email hoặc mật khẩu không đúng.' }
  }, [])

  const logout = useCallback(() => {
    setUser(null)
    localStorage.removeItem(STORAGE_KEY)
  }, [])

  return (
    <AuthContext.Provider value={{ user, login, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
