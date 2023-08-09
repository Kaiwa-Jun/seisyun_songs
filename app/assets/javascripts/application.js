console.log("JavaScript is loaded.");
//= require font-awesome

import "@hotwired/turbo-rails";
import "controllers";

import { Turbo } from "@hotwired/turbo-rails";
console.log(Turbo);

document.addEventListener("turbo:click", () => {
  console.log("Turbo click detected");
});

document.addEventListener("turbo:submit-start", () => {
  console.log("Turbo form submission started");
});

document.addEventListener("turbo:submit-end", () => {
  console.log("Turbo form submission ended");
});

document.addEventListener("turbo:load", () => {
  console.log("Turbo page loaded");
});

document.addEventListener("turbo:stream-start", (event) => {
  console.log("Turbo stream started:", event);
});

document.addEventListener("turbo:stream-end", (event) => {
  console.log("Turbo stream ended:", event);
});

document.addEventListener("turbo:frame-load", () => {
  console.log("Turbo frame loaded");
});

document.addEventListener("turbo:frame-fetch-response", () => {
  console.log("Turbo frame fetch response received");
});

document.addEventListener("turbo:frame-fetch-fail", () => {
  console.log("Turbo frame fetch failed");
});

document.addEventListener("DOMContentLoaded", () => {
  console.log("Document is fully loaded and parsed");
});
