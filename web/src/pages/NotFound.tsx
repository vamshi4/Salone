export function NotFound() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-salone-surface">
      <div className="text-center">
        <h1 className="text-6xl font-extrabold text-salone-accent mb-4">404</h1>
        <p className="text-xl font-bold text-salone-ink mb-2">Page not found</p>
        <p className="text-sm text-salone-ink-muted mb-8">
          The page you're looking for doesn't exist.
        </p>
        <a
          href="/"
          className="px-6 py-3 bg-salone-accent text-white font-bold rounded-full hover:opacity-90 transition-opacity"
        >
          Go Home
        </a>
      </div>
    </div>
  );
}
