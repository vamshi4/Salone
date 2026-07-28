import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Salone Admin',
  description: 'Salon management dashboard',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
