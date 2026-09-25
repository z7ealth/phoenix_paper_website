defmodule PhoenixPaperWebsiteWeb.PaperBird do
  @moduledoc """
  The home page's easter egg: click the hero bird five times and "Paper
  Bird" opens, a small flap-between-the-pipes game starring the
  PhoenixPaper logo.

  Everything around the game is PhoenixPaper: the window is a `pp_dialog`
  (backdrop, Escape, focus trap) and the controls are `pp_button`s. Only
  the playfield is custom, a `<canvas>` driven by a colocated hook -- no
  component can draw a game. It's fully client-side: no LiveView events,
  no server state.

  - `hero_egg/1` wraps the hero mark and counts clicks (reset after
    1.5s idle); the fifth runs `PhoenixPaper.Dialog.show/1`.
  - `game/1` is the dialog. The canvas is `phx-update="ignore"` so
    LiveView never patches it, and reads the `--color-pp-*` tokens when a
    round starts, so the bird and pipes follow the theme picker and dark
    mode. Best score is kept in `localStorage` (`"paper-bird:best"`).
  """
  use Phoenix.Component
  use PhoenixPaper.Components

  alias PhoenixPaper.Dialog

  @dialog_id "paper-bird-dialog"

  attr :id, :string, default: "hero-egg"
  attr :class, :any, default: nil
  slot :inner_block, required: true, doc: "the hero mark"

  @doc "Wraps the hero mark; five quick clicks open the game."
  def hero_egg(assigns) do
    assigns = assign(assigns, :open, Dialog.show(@dialog_id))

    ~H"""
    <div id={@id} phx-hook=".HeroEgg" data-open={@open} class={@class}>
      {render_slot(@inner_block)}
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".HeroEgg">
      const CLICKS = 5
      const IDLE_MS = 1500

      export default {
        mounted() {
          this.count = 0
          this.onClick = () => {
            clearTimeout(this.timer)
            this.count += 1
            // A small squash on every click: the only hint something's there.
            this.el.animate(
              [{ transform: "scale(1)" }, { transform: "scale(0.93)" }, { transform: "scale(1)" }],
              { duration: 180, easing: "ease-out" }
            )
            if (this.count >= CLICKS) {
              this.count = 0
              this.liveSocket.execJS(this.el, this.el.dataset.open)
            } else {
              this.timer = setTimeout(() => (this.count = 0), IDLE_MS)
            }
          }
          this.el.addEventListener("click", this.onClick)
        },
        destroyed() {
          clearTimeout(this.timer)
          this.el.removeEventListener("click", this.onClick)
        }
      }
    </script>
    """
  end

  @doc "The game dialog. Render it once on the page that has `hero_egg/1`."
  def game(assigns) do
    assigns = assign(assigns, :id, @dialog_id)

    ~H"""
    <.pp_dialog id={@id} max_width="2xl">
      <:title>Paper Bird</:title>
      <div id="paper-bird-stage" phx-update="ignore">
        <canvas
          id="paper-bird-canvas"
          phx-hook=".PaperBird"
          tabindex="0"
          aria-label="Paper Bird game. Press Space, Arrow Up, click or tap to flap."
          class="block aspect-[4/3] w-full cursor-pointer rounded-lg"
        ></canvas>
      </div>
      <.pp_typography variant="caption" class="mt-3">
        Space, ↑, click or tap to flap. Don't touch the pipes.
      </.pp_typography>
      <:actions>
        <.pp_button id="paper-bird-close" variant="text" phx-click={Dialog.hide(@id)}>
          Close
        </.pp_button>
      </:actions>
    </.pp_dialog>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".PaperBird">
      // Logical playfield (landscape); the canvas is scaled to its CSS size and the device pixel ratio.
      const W = 640, H = 480
      const GRAVITY = 1500, FLAP = -440, MAX_FALL = 640
      const PIPE_W = 72, GAP = 165, SPACING = 270, SPEED = 190
      const BIRD_X = 150, BIRD_SIZE = 64, HIT_R = 19
      const BEST_KEY = "paper-bird:best"

      // The hero mark's own paths (DocsComponents.hero_mark/1, 64x64 viewBox).
      const BODY = new Path2D("M13 21c1-6 7-10 13-9 6 1 10 6 9 12-1 6-5 10-9 15-3 4-5 9-6 15-4-5-6-11-6-18 0-6 1-11-1-15Z M13 18l-7 4 7 3z M23.8 20a1.8 1.8 0 1 0-3.6 0 1.8 1.8 0 1 0 3.6 0z")
      const FEATHERS = [
        [new Path2D("M34 24c8 0 16-4 22-12"), 4.6],
        [new Path2D("M35 32c9 1 17-3 23-10"), 4.6],
        [new Path2D("M32 41c9 1 16-2 21-9"), 4.2],
        [new Path2D("M22 48c6 2 10 6 12 12"), 4]
      ]

      const readBest = () => { try { return Number(localStorage.getItem(BEST_KEY)) || 0 } catch { return 0 } }
      const saveBest = (n) => { try { localStorage.setItem(BEST_KEY, String(n)) } catch {} }

      export default {
        mounted() {
          this.ctx = this.el.getContext("2d")
          this.best = readBest()
          this.reset()

          this.onPointer = (e) => { e.preventDefault(); this.flap() }
          this.onKey = (e) => {
            if (!this.visible()) return
            if (e.key !== " " && e.key !== "ArrowUp") return
            // Holding the key auto-repeats; one press is one flap.
            if (e.repeat) { e.preventDefault(); return }
            // Let Space still press a focused button (e.g. Close).
            if (e.target.closest && e.target.closest("button, a")) return
            e.preventDefault()
            this.flap()
          }
          this.onVisibility = () => { if (document.hidden && this.state === "playing") this.state = "paused" }
          this.onResize = () => this.resize()

          this.el.addEventListener("pointerdown", this.onPointer)
          window.addEventListener("keydown", this.onKey)
          document.addEventListener("visibilitychange", this.onVisibility)
          window.addEventListener("resize", this.onResize)

          // The dialog starts hidden; draw once it's actually on screen.
          this.observer = new IntersectionObserver((entries) => {
            if (entries.some((e) => e.isIntersecting)) { this.resize(); this.readColors(); this.draw() }
            else if (this.state === "playing") this.state = "paused"
          })
          this.observer.observe(this.el)
        },

        destroyed() {
          cancelAnimationFrame(this.raf)
          this.observer.disconnect()
          this.el.removeEventListener("pointerdown", this.onPointer)
          window.removeEventListener("keydown", this.onKey)
          document.removeEventListener("visibilitychange", this.onVisibility)
          window.removeEventListener("resize", this.onResize)
        },

        visible() { return this.el.offsetParent !== null },

        resize() {
          // clientWidth, not getBoundingClientRect(): the dialog scales in, and a
          // mid-animation (transformed) size would lock in a blurry resolution.
          const w = this.el.clientWidth, h = this.el.clientHeight
          if (!w) return
          const dpr = window.devicePixelRatio || 1
          this.el.width = Math.round(w * dpr)
          this.el.height = Math.round(h * dpr)
          this.scale = this.el.width / W
          this.draw()
        },

        readColors() {
          const css = getComputedStyle(document.documentElement)
          const v = (name, fallback) => css.getPropertyValue(name).trim() || fallback
          this.colors = {
            primary: v("--color-pp-primary", "#7c3aed"),
            secondary: v("--color-pp-secondary", "#3f51b5"),
            accent: v("--color-pp-accent", "#009688"),
            surface: v("--color-pp-surface-variant", "#eeeeee"),
            onSurface: v("--color-pp-on-surface", "#1f1f1f"),
            font: getComputedStyle(document.body).fontFamily
          }
        },

        reset() {
          this.state = "ready"
          this.y = H / 2
          this.vy = 0
          this.score = 0
          this.pipes = []
          this.distance = 0
        },

        flap() {
          if (this.state === "over") {
            // Short grace period so a frantic tap doesn't skip the score screen.
            if (performance.now() - this.overAt < 400) return
            this.reset()
          }
          if (this.state !== "playing") {
            this.readColors()
            this.state = "playing"
            this.last = performance.now()
            cancelAnimationFrame(this.raf)
            this.raf = requestAnimationFrame((t) => this.tick(t))
          }
          this.vy = FLAP
        },

        tick(now) {
          if (this.state !== "playing") { this.draw(); return }
          // The first frame's timestamp can predate the flap: clamp to [0, 1/30s].
          const dt = Math.max(0, Math.min((now - this.last) / 1000, 1 / 30))
          this.last = now
          this.update(dt)
          this.draw()
          this.raf = requestAnimationFrame((t) => this.tick(t))
        },

        update(dt) {
          this.vy = Math.min(this.vy + GRAVITY * dt, MAX_FALL)
          this.y += this.vy * dt
          this.distance += SPEED * dt

          for (const p of this.pipes) p.x -= SPEED * dt
          this.pipes = this.pipes.filter((p) => p.x > -PIPE_W)
          const lastX = this.pipes.length ? this.pipes[this.pipes.length - 1].x : -Infinity
          if (lastX < W - SPACING) {
            const margin = 60
            const gapY = margin + Math.random() * (H - 2 * margin - GAP)
            this.pipes.push({ x: W + 20, gapY, scored: false })
          }

          for (const p of this.pipes) {
            if (!p.scored && p.x + PIPE_W < BIRD_X - HIT_R) { p.scored = true; this.score += 1 }
            const inX = BIRD_X + HIT_R > p.x && BIRD_X - HIT_R < p.x + PIPE_W
            const inGap = this.y - HIT_R > p.gapY && this.y + HIT_R < p.gapY + GAP
            if (inX && !inGap) return this.gameOver()
          }
          if (this.y + HIT_R > H || this.y - HIT_R < 0) this.gameOver()
        },

        gameOver() {
          this.state = "over"
          this.overAt = performance.now()
          if (this.score > this.best) { this.best = this.score; saveBest(this.best) }
        },

        draw() {
          if (!this.scale || !this.colors) return
          const c = this.ctx, k = this.colors
          c.setTransform(this.scale, 0, 0, this.scale, 0, 0)

          c.fillStyle = k.surface
          c.fillRect(0, 0, W, H)

          c.fillStyle = k.accent
          for (const p of this.pipes) {
            this.roundRect(p.x, -10, PIPE_W, p.gapY + 10, 8)
            this.roundRect(p.x, p.gapY + GAP, PIPE_W, H - p.gapY - GAP + 10, 8)
          }

          this.drawBird()

          c.fillStyle = k.onSurface
          c.textAlign = "center"
          c.font = `600 40px ${k.font}`
          if (this.state !== "ready") c.fillText(String(this.score), W / 2, 64)

          c.font = `500 16px ${k.font}`
          if (this.state === "ready") {
            c.fillText("Tap or press Space to flap", W / 2, H / 2 + 70)
          } else if (this.state === "paused") {
            c.fillText("Paused. Tap to keep going", W / 2, H / 2 + 70)
          } else if (this.state === "over") {
            // A translucent card so the text stays readable over the pipes.
            c.save()
            c.globalAlpha = 0.9
            c.fillStyle = k.surface
            this.roundRect(W / 2 - 170, H / 2 - 88, 340, 136, 16)
            c.restore()
            c.fillStyle = k.onSurface
            c.font = `600 28px ${k.font}`
            c.fillText("Game over", W / 2, H / 2 - 40)
            c.font = `500 16px ${k.font}`
            c.fillText(`Score ${this.score}  ·  Best ${this.best}`, W / 2, H / 2 - 10)
            c.fillText("Tap or press Space to try again", W / 2, H / 2 + 20)
          }
        },

        drawBird() {
          const c = this.ctx, k = this.colors
          const y = this.y
          const tilt = this.state === "ready" ? 0 : Math.max(-0.5, Math.min(1.1, this.vy / 600))
          const s = BIRD_SIZE / 64

          c.save()
          c.translate(BIRD_X, y)
          c.rotate(tilt)
          // The logo faces left; mirror it so the bird faces the way it flies.
          c.scale(-s, s)
          c.translate(-32, -34)
          const g = c.createLinearGradient(4, 6, 46, 60)
          g.addColorStop(0, k.primary)
          g.addColorStop(0.55, k.secondary)
          g.addColorStop(1, k.accent)
          c.fillStyle = g
          c.strokeStyle = g
          c.lineCap = "round"
          c.fill(BODY, "evenodd")
          for (const [path, width] of FEATHERS) { c.lineWidth = width; c.stroke(path) }
          c.restore()
        },

        roundRect(x, y, w, h, r) {
          const c = this.ctx
          c.beginPath()
          c.roundRect(x, y, w, h, r)
          c.fill()
        }
      }
    </script>
    """
  end
end
