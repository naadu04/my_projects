const chatPanel = document.querySelector("#chat-panel");
const toggleButton = document.querySelector("#chat-toggle");
const closeButton = document.querySelector("#close-chat");
const form = document.querySelector("#chat-form");
const input = document.querySelector("#message-input");
const conversation = document.querySelector("#conversation");
const sendButton = document.querySelector("#send-button");
const errorMessage = document.querySelector("#error-message");
const suggestions = document.querySelectorAll(".suggestion");
const scatterCanvas = document.querySelector("#product-scatter");
const scatterTooltip = document.querySelector("#scatter-tooltip");
const scatterDataElement = document.querySelector("#product-scatter-data");

const messages = [];
let scatterPoints = [];
let scatterCoordinates = [];

function setChatOpen(open) {
  chatPanel.hidden = !open;
  toggleButton.setAttribute("aria-expanded", String(open));
  toggleButton.setAttribute(
    "aria-label",
    open ? "Close sales assistant" : "Open sales assistant",
  );
  if (open) input.focus();
}

function addMessage(role, content) {
  const message = document.createElement("article");
  message.className = `message message-${role}`;

  const label = document.createElement("span");
  label.className = "message-label";
  label.textContent = role === "user" ? "You" : "Sales assistant";

  const text = document.createElement("p");
  text.className = "message-text";
  text.textContent = content;

  message.append(label, text);
  conversation.append(message);
  conversation.scrollTop = conversation.scrollHeight;
  return message;
}

function resizeInput() {
  input.style.height = "auto";
  input.style.height = `${Math.min(input.scrollHeight, 120)}px`;
}

function applyBarSizes() {
  document.querySelectorAll(".trend-bar[data-height]").forEach((bar) => {
    bar.style.height = `${bar.dataset.height}%`;
  });

  document.querySelectorAll(".rank-fill[data-width]").forEach((fill) => {
    fill.style.width = `${fill.dataset.width}%`;
  });
}

function drawProductScatter() {
  if (!scatterCanvas || !scatterDataElement) return;
  if (!scatterPoints.length) scatterPoints = JSON.parse(scatterDataElement.textContent);

  const bounds = scatterCanvas.getBoundingClientRect();
  if (!bounds.width) return;

  const pixelRatio = window.devicePixelRatio || 1;
  const width = bounds.width;
  const height = bounds.height;
  scatterCanvas.width = Math.round(width * pixelRatio);
  scatterCanvas.height = Math.round(height * pixelRatio);

  const context = scatterCanvas.getContext("2d");
  context.setTransform(pixelRatio, 0, 0, pixelRatio, 0, 0);
  context.clearRect(0, 0, width, height);

  const plot = { left: 62, right: 18, top: 16, bottom: 46 };
  plot.width = width - plot.left - plot.right;
  plot.height = height - plot.top - plot.bottom;
  const maxValue = scatterPoints.reduce(
    (maximum, point) => Math.max(maximum, point.retail_sales, point.warehouse_sales),
    1,
  );
  const axisMax = Math.max(10, 10 ** Math.ceil(Math.log10(maxValue)));
  const maxLog = Math.log10(axisMax);
  const scale = (value) => Math.log10(Math.max(1, value)) / maxLog;
  const xFor = (value) => plot.left + scale(value) * plot.width;
  const yFor = (value) => plot.top + (1 - scale(value)) * plot.height;

  context.font = "10px Inter, system-ui, sans-serif";
  context.textBaseline = "middle";
  context.textAlign = "right";
  context.strokeStyle = "#eeedf3";
  context.fillStyle = "#9697a7";
  context.lineWidth = 1;

  for (let tick = 1; tick <= axisMax; tick *= 10) {
    const x = xFor(tick);
    const y = yFor(tick);
    context.beginPath();
    context.moveTo(x, plot.top);
    context.lineTo(x, plot.top + plot.height);
    context.moveTo(plot.left, y);
    context.lineTo(plot.left + plot.width, y);
    context.stroke();
    context.fillText(tick.toLocaleString(), x, plot.top + plot.height + 12);
    context.textAlign = "right";
    context.fillText(tick.toLocaleString(), plot.left - 8, y);
  }

  context.save();
  context.setLineDash([5, 4]);
  context.strokeStyle = "#c8c4e7";
  context.beginPath();
  context.moveTo(xFor(1), yFor(1));
  context.lineTo(xFor(axisMax), yFor(axisMax));
  context.stroke();
  context.restore();

  context.fillStyle = "rgba(55, 153, 127, 0.42)";
  context.beginPath();
  scatterCoordinates = scatterPoints.map((point) => {
    const x = xFor(point.retail_sales);
    const y = yFor(point.warehouse_sales);
    context.moveTo(x + 2, y);
    context.arc(x, y, 2, 0, Math.PI * 2);
    return { x, y, point };
  });
  context.fill();

  context.fillStyle = "#77798d";
  context.textAlign = "center";
  context.fillText("Retail sales (units, log scale)", plot.left + plot.width / 2, height - 8);
  context.save();
  context.translate(13, plot.top + plot.height / 2);
  context.rotate(-Math.PI / 2);
  context.fillText("Warehouse sales (units, log scale)", 0, 0);
  context.restore();
}

function showScatterTooltip(event) {
  if (!scatterTooltip || !scatterCoordinates.length) return;
  const bounds = scatterCanvas.getBoundingClientRect();
  const pointerX = event.clientX - bounds.left;
  const pointerY = event.clientY - bounds.top;
  let nearest = null;
  let nearestDistance = 12 ** 2;

  for (const coordinate of scatterCoordinates) {
    const distance = (coordinate.x - pointerX) ** 2 + (coordinate.y - pointerY) ** 2;
    if (distance < nearestDistance) {
      nearest = coordinate;
      nearestDistance = distance;
    }
  }

  if (!nearest) {
    scatterTooltip.hidden = true;
    return;
  }

  const { point } = nearest;
  scatterTooltip.textContent =
    `${point.name} · Retail: ${point.retail_sales.toLocaleString()} · `
    + `Warehouse: ${point.warehouse_sales.toLocaleString()}`;
  scatterTooltip.style.left = `${Math.min(pointerX + 12, bounds.width - 180)}px`;
  scatterTooltip.style.top = `${Math.max(4, pointerY - 36)}px`;
  scatterTooltip.hidden = false;
}

if (scatterCanvas) {
  scatterCanvas.addEventListener("pointermove", showScatterTooltip);
  scatterCanvas.addEventListener("pointerleave", () => {
    if (scatterTooltip) scatterTooltip.hidden = true;
  });
  window.addEventListener("resize", drawProductScatter);
}

toggleButton.addEventListener("click", () => {
  setChatOpen(chatPanel.hidden);
});

closeButton.addEventListener("click", () => setChatOpen(false));
input.addEventListener("input", resizeInput);
document.addEventListener("DOMContentLoaded", () => {
  applyBarSizes();
  drawProductScatter();
});

suggestions.forEach((button) => {
  button.addEventListener("click", () => {
    input.value = button.textContent;
    input.focus();
    resizeInput();
  });
});

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  const content = input.value.trim();
  if (!content || sendButton.disabled) return;

  errorMessage.hidden = true;
  messages.push({ role: "user", content });
  addMessage("user", content);
  input.value = "";
  resizeInput();
  sendButton.disabled = true;

  const pendingMessage = addMessage("assistant", "Checking the sales analysis…");
  pendingMessage.classList.add("message-pending");

  try {
    const response = await fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        messages: messages.slice(-20),
      }),
    });
    let data;
    try {
      data = await response.json();
    } catch {
      if (!response.ok) {
        throw new Error(`The server returned an error (${response.status}). Check the Flask terminal for details.`);
      }
      throw new Error("The dashboard server returned an unreadable response. Check that it is running.");
    }
    if (!response.ok) throw new Error(data.error || "The request could not be completed.");
    if (typeof data.reply !== "string" || !data.reply.trim()) {
      throw new Error("The assistant returned an empty answer. Please try again.");
    }
    pendingMessage.querySelector(".message-text").textContent = data.reply;
    pendingMessage.classList.remove("message-pending");
    messages.push({ role: "assistant", content: data.reply });
  } catch (error) {
    pendingMessage.remove();
    messages.pop();
    errorMessage.textContent = error instanceof TypeError
      ? "Can't reach the dashboard server. Make sure app.py is still running, then refresh this page."
      : error.message || "Could not connect. Please try again.";
    errorMessage.hidden = false;
  } finally {
    sendButton.disabled = false;
    input.focus();
  }
});
