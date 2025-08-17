import React from 'react'
import { createRoot } from 'react-dom/client'
import Hello from '../components/Hello.jsx'
import TeamBuilder from '../components/team_builder/TeamBuilder.jsx'
import TeamEditor from '../components/team_editor/TeamEditor.jsx'

const components = { Hello, TeamBuilder, TeamEditor }

function mountAll() {
  document.querySelectorAll('[data-react-component]').forEach((el) => {
    const name = el.getAttribute('data-react-component')
    const props = JSON.parse(el.getAttribute('data-props') || '{}')
    if (!name || !components[name]) return
    const root = createRoot(el)
    root.render(React.createElement(components[name], props))
    el._reactRoot = root
  })
}

function unmountAll() {
  document.querySelectorAll('[data-react-component]').forEach((el) => {
    if (el._reactRoot) el._reactRoot.unmount()
  })
}

document.addEventListener('turbo:load', mountAll)
document.addEventListener('turbo:before-cache', unmountAll)
document.addEventListener('DOMContentLoaded', mountAll)


