import type { Metadata } from 'next';
import Link from 'next/link';
import {
  Scissors,
  Search,
  MessageCircle,
  Sparkles,
  Zap,
  Wallet,
  CalendarCheck,
  Users,
  Contact,
  BarChart3,
  Send,
  MapPin,
  ArrowRight,
  Check,
} from 'lucide-react';
import { RedirectIfAuthed } from '@/components/RedirectIfAuthed';

// Copy is intentionally hardcoded English rather than going through next-intl:
// the rest of the app is machine-translated into 25 locales and unproofread, and
// this is the page that makes the first impression. Strings are grouped in the
// arrays below so they can be lifted into messages/*.json once someone can
// review the translations.
export const metadata: Metadata = {
  title: 'Chairful — Keep your chairs full',
  description:
    'Chairful watches your salon booking history and tells you exactly which regulars have stopped coming, so you can win them back with one message on WhatsApp.',
  openGraph: {
    title: 'Chairful — Keep your chairs full',
    description:
      'Know which regulars stopped coming, and win them back in one tap. Salon management built around retention.',
    type: 'website',
  },
};

const STEPS = [
  {
    icon: Search,
    title: 'Spot it',
    body: 'Chairful reads your booking history and flags the regulars who have quietly stopped coming.',
  },
  {
    icon: MessageCircle,
    title: 'Reach out',
    body: 'One tap opens WhatsApp with a friendly message already written for that customer.',
  },
  {
    icon: Sparkles,
    title: 'They come back',
    body: "You fill a chair you didn't even know was empty — from customers you already have.",
  },
];

const FEATURES = [
  {
    icon: Zap,
    title: 'Log a service in one tap',
    body: 'Busy with a customer? Log it after — name, service, done. No slots to juggle.',
  },
  {
    icon: Wallet,
    title: 'Daily, weekly & monthly earnings',
    body: 'See exactly what you made today, this week, this month — automatically.',
  },
  {
    icon: CalendarCheck,
    title: 'Bookings in seconds',
    body: 'Create and manage appointments with the right slots for your working hours.',
  },
  {
    icon: Users,
    title: 'Staff & working hours',
    body: "Add your stylists, set each person's days and timings, see everyone's schedule.",
  },
  {
    icon: Contact,
    title: 'Customer list with smart search',
    body: 'Type a name or number and returning customers fill in instantly — no re-typing.',
  },
  {
    icon: BarChart3,
    title: 'Retention insights',
    body: 'New, returning, at-risk and lost customers, updated automatically.',
  },
  {
    icon: Send,
    title: 'One-tap WhatsApp win-backs',
    body: "Reach a customer who's gone quiet without typing a word.",
  },
  {
    icon: MapPin,
    title: 'Your salon on the map',
    body: 'Pin your exact location with GPS for an accurate address.',
  },
];

const REASONS = [
  {
    title: 'It makes you money, not just charts.',
    body: 'Most salon apps only take bookings. Chairful tells you which customers to win back — that’s revenue you already lost.',
  },
  {
    title: 'Simple enough for the whole team.',
    body: 'Clean, fast, no training needed. If you can use WhatsApp, you can use Chairful.',
  },
  {
    title: 'Built for real salons.',
    body: 'Made for independent salons and small groups — not for big corporate chains.',
  },
  {
    title: 'Your data stays yours.',
    body: "We never sell your customers' details, and we don't show ads.",
  },
];

function Wordmark({ light = false }: { light?: boolean }) {
  return (
    <span className="inline-flex items-center gap-2">
      <span
        className={`grid h-8 w-8 place-items-center rounded-[9px] shadow-sm ${
          light ? 'bg-white/15 ring-1 ring-white/25' : 'bg-gradient-to-br from-primary to-primary-dark'
        }`}
      >
        <Scissors size={15} className="text-white" />
      </span>
      <span
        className={`text-lg font-bold tracking-[-0.02em] ${light ? 'text-white' : 'text-gray-900'}`}
      >
        Chairful
      </span>
    </span>
  );
}

export default function HomePage() {
  return (
    <main className="min-h-screen bg-white">
      <RedirectIfAuthed />

      {/* ---------------- Hero ---------------- */}
      <div className="relative overflow-hidden bg-primary-deep">
        {/* Soft radial glows — pure CSS so the hero costs no image bytes. */}
        <div
          aria-hidden
          className="pointer-events-none absolute inset-0 opacity-70"
          style={{
            backgroundImage:
              'radial-gradient(60rem 30rem at 15% -10%, rgba(27,138,138,0.55), transparent 60%), radial-gradient(45rem 25rem at 95% 15%, rgba(13,92,92,0.6), transparent 65%)',
          }}
        />

        <header className="relative mx-auto flex max-w-6xl items-center justify-between px-5 py-5 sm:px-8">
          <Wordmark light />
          <nav className="flex items-center gap-2 sm:gap-3">
            <Link
              href="/login"
              className="rounded-lg px-3 py-2 text-xs font-medium text-white/80 transition-colors hover:text-white"
            >
              Sign in
            </Link>
            <Link
              href="/signup"
              className="rounded-lg bg-white px-3.5 py-2 text-xs font-semibold text-primary-dark shadow-sm transition-all hover:-translate-y-px hover:shadow-md"
            >
              Start free
            </Link>
          </nav>
        </header>

        <section className="relative mx-auto max-w-6xl px-5 pb-20 pt-12 sm:px-8 sm:pb-28 sm:pt-16">
          <span className="inline-block rounded-full bg-white/10 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.09em] text-primary-200 ring-1 ring-inset ring-white/15">
            For salon owners
          </span>

          <h1 className="mt-5 max-w-3xl text-[2rem] font-bold leading-[1.14] tracking-[-0.03em] text-white sm:text-[2.75rem] lg:text-[3.25rem]">
            Your best customers don&rsquo;t quit loudly.{' '}
            <span className="text-primary-200">They just stop coming.</span>
          </h1>

          <p className="mt-5 max-w-xl text-sm leading-relaxed text-white/70 sm:text-base">
            A regular who came every month suddenly hasn&rsquo;t been in for ten weeks — and you only
            notice when the chair sits empty. Chairful watches your booking history and tells you
            exactly who has slipped away, so you can bring them back with one message on WhatsApp.
          </p>

          <div className="mt-8 flex flex-wrap items-center gap-3">
            <Link
              href="/signup"
              className="inline-flex items-center gap-2 rounded-lg bg-white px-5 py-3 text-sm font-semibold text-primary-dark shadow-hero transition-all hover:-translate-y-px hover:shadow-xl"
            >
              Start free <ArrowRight size={16} />
            </Link>
            <Link
              href="/login"
              className="inline-flex items-center rounded-lg px-5 py-3 text-sm font-medium text-white/85 ring-1 ring-inset ring-white/25 transition-colors hover:bg-white/10 hover:text-white"
            >
              I already have an account
            </Link>
          </div>

          <p className="mt-5 flex flex-wrap items-center gap-x-5 gap-y-2 text-xs text-white/55">
            <span className="inline-flex items-center gap-1.5">
              <Check size={13} className="text-primary-200" /> Free for your first 6 months
            </span>
            <span className="inline-flex items-center gap-1.5">
              <Check size={13} className="text-primary-200" /> No card required
            </span>
            <span className="inline-flex items-center gap-1.5">
              <Check size={13} className="text-primary-200" /> Set up in minutes
            </span>
          </p>
        </section>
      </div>

      {/* ---------------- How it works ---------------- */}
      <section className="mx-auto max-w-6xl px-5 py-16 sm:px-8 sm:py-20">
        <h2 className="text-center text-2xl font-bold tracking-[-0.02em] text-gray-900">
          How it works
        </h2>
        <p className="mx-auto mt-2 max-w-md text-center text-sm text-gray-500">
          Three steps, using customers you already have.
        </p>

        <ol className="mt-10 grid gap-4 sm:grid-cols-3 sm:gap-5">
          {STEPS.map(({ icon: Icon, title, body }, i) => (
            <li key={title} className="card relative p-5">
              <span className="grid h-9 w-9 place-items-center rounded-lg bg-primary-50 text-primary">
                <Icon size={17} />
              </span>
              <span className="absolute right-5 top-5 text-2xl font-bold tabular-nums text-gray-100">
                {i + 1}
              </span>
              <h3 className="mt-3.5 text-sm font-semibold text-gray-900">{title}</h3>
              <p className="mt-1.5 text-xs leading-relaxed text-gray-500">{body}</p>
            </li>
          ))}
        </ol>
      </section>

      {/* ---------------- Features ---------------- */}
      <section className="border-y border-gray-200/70 bg-[#F4F6F8]">
        <div className="mx-auto max-w-6xl px-5 py-16 sm:px-8 sm:py-20">
          <h2 className="text-center text-2xl font-bold tracking-[-0.02em] text-gray-900">
            Everything you need to run the salon
          </h2>
          <p className="mx-auto mt-2 max-w-md text-center text-sm text-gray-500">
            Bookings, staff, earnings and retention — in one place.
          </p>

          <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {FEATURES.map(({ icon: Icon, title, body }) => (
              <div
                key={title}
                className="card p-5 transition-all hover:-translate-y-0.5 hover:shadow-md"
              >
                <span className="grid h-9 w-9 place-items-center rounded-lg bg-primary-50 text-primary">
                  <Icon size={17} />
                </span>
                <h3 className="mt-3.5 text-sm font-semibold text-gray-900">{title}</h3>
                <p className="mt-1.5 text-xs leading-relaxed text-gray-500">{body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ---------------- Why owners choose Chairful ---------------- */}
      <section className="mx-auto max-w-5xl px-5 py-16 sm:px-8 sm:py-20">
        <h2 className="text-center text-2xl font-bold tracking-[-0.02em] text-gray-900">
          Why owners choose Chairful
        </h2>

        <div className="mt-10 grid gap-x-10 gap-y-6 sm:grid-cols-2">
          {REASONS.map(({ title, body }) => (
            <div key={title} className="flex gap-3">
              <span className="mt-0.5 grid h-5 w-5 flex-none place-items-center rounded-full bg-primary-50 text-primary">
                <Check size={12} strokeWidth={3} />
              </span>
              <div>
                <h3 className="text-sm font-semibold text-gray-900">{title}</h3>
                <p className="mt-1 text-xs leading-relaxed text-gray-500">{body}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* ---------------- Closing CTA ---------------- */}
      <section className="px-5 pb-16 sm:px-8 sm:pb-20">
        <div className="relative mx-auto max-w-5xl overflow-hidden rounded-2xl bg-primary-dark px-6 py-10 sm:px-12 sm:py-12">
          <div
            aria-hidden
            className="pointer-events-none absolute inset-0 opacity-80"
            style={{
              backgroundImage:
                'radial-gradient(35rem 18rem at 85% 0%, rgba(27,138,138,0.65), transparent 65%)',
            }}
          />
          <div className="relative flex flex-col items-start gap-6 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 className="text-xl font-bold tracking-[-0.02em] text-white sm:text-2xl">
                Free for your first 6 months
              </h2>
              <p className="mt-2 max-w-md text-sm text-white/70">
                Get set up in minutes. See which customers to bring back today.
              </p>
            </div>
            <Link
              href="/signup"
              className="inline-flex flex-none items-center gap-2 rounded-lg bg-white px-5 py-3 text-sm font-semibold text-primary-dark shadow-lg transition-all hover:-translate-y-px hover:shadow-xl"
            >
              Start free <ArrowRight size={16} />
            </Link>
          </div>
        </div>
      </section>

      {/* ---------------- Footer ---------------- */}
      <footer className="border-t border-gray-200/70">
        <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 px-5 py-8 sm:flex-row sm:px-8">
          <div>
            <Wordmark />
            <p className="mt-1.5 text-xs text-gray-400">Keep your chairs full.</p>
          </div>
          <div className="flex items-center gap-5 text-xs text-gray-500">
            <Link href="/login" className="transition-colors hover:text-primary-dark">
              Sign in
            </Link>
            <Link href="/signup" className="transition-colors hover:text-primary-dark">
              Create account
            </Link>
            <a
              href="mailto:vamshikittu114@gmail.com"
              className="transition-colors hover:text-primary-dark"
            >
              Contact
            </a>
          </div>
        </div>
      </footer>
    </main>
  );
}
