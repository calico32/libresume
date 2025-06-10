#import "@preview/fontawesome:0.5.0": *
#import "libtailwind.typ": *

#let resume-default-theme = (
  primary: cyan,
  accent: sky,
  neutral: gray,
  font-heading: "DM Sans",
  font-body: "Bitter Pro",
)

#let _theme-state = state("_resume-theme", resume-default-theme)

#let resume-info(..args) = context {
  let theme = _theme-state.get()

  set text(size: 11pt)

  args
    .pos()
    .map(it => {
      if type(it) == content {
        box(it)
      } else if (
        type(it) == array and type(it.at(0)) == function and it.len() >= 2
      ) {
        it.at(0)(fill: theme.primary.s700)
        if it.len() == 3 {
          link(it.at(2), box(it.at(1)))
        } else {
          box(it.at(1))
        }
      } else if type(it) == dictionary {
        box([
          #if "icon" in it and type(it.icon) == function {
            (it.icon)(fill: theme.primary.s700)
          }
          #if "href" in it and type(it.href) == str {
            link(it.href, it.content)
          } else {
            it.content
          }
        ])
      } else {
        panic("Invalid argument for resume-info", repr(it))
      }
    })
    .join(h(0.2in))
}

#let resume-email(email) = resume-info((
  icon: fa-envelope,
  content: email,
  href: "mailto:" + email,
))

#let resume-phone(phone) = resume-info((
  icon: fa-phone,
  content: phone,
  href: "tel:" + phone.replace(regex("[^\d]"), ""),
))

#let resume-linkedin(slug) = resume-info((
  icon: fa-linkedin,
  content: slug,
  href: "https://www.linkedin.com/in/" + slug,
))

#let resume-github(username) = resume-info((
  icon: fa-github,
  content: username,
  href: "https://github.com/" + username,
))

#let resume-website(url) = resume-info((
  icon: fa-globe,
  content: url.replace(regex("^https?://"), ""),
  href: url,
))

#let resume-tagline(content) = {
  text(content, size: 11pt)
}

#let resume-education(inst, degree, dates, location) = context [
  #let theme = _theme-state.get()

  #heading(inst, level: 3)\
  #heading(degree, level: 4)\
  #dates\
  #location
]

#let resume-hr() = context {
  let theme = _theme-state.get()

  line(
    stroke: 2pt + theme.primary.s800,
    length: 100%,
  )
}

#let resume-experience(title, company, dates, location, details) = context {
  let theme = _theme-state.get()

  block(
    width: 100%,
    heading(title, level: 3)
      + place(
        horizon + right,
        text(dates, fill: theme.neutral.s600, size: 10pt),
      ),
  )

  block(
    width: 100%,
    above: 0.7em,
    below: 0.8em,
    heading(company, level: 4)
      + place(
        horizon + right,
        text(location, fill: theme.neutral.s600, size: 10pt),
      ),
  )

  block(
    below: 1.4em,
    list(
      marker: fa-chevron-right(size: 9pt),
      indent: 0.1in,
      ..details,
    ),
  )
}

#let resume-project(name, title, dates, skills, details) = context {
  let theme = _theme-state.get()

  block(
    width: 100%,
    below: 0.7em,
    {
      heading(name, level: 3)
      h(0.2in)
      text(
        title,
        style: "italic",
      )
      place(horizon + right, text(dates, fill: theme.neutral.s600, size: 10pt))
    },
  )

  block(
    below: 0.9em,
    heading(skills, level: 4),
  )

  list(
    marker: fa-chevron-right(size: 9pt),
    indent: 0.1in,
    ..details,
  )
}

#let resume(theme: resume-default-theme, content) = {
  _theme-state.update(theme)

  set page(paper: "us-letter", margin: 0.45in)

  set text(
    size: 10pt,
    fill: theme.neutral.s600,
    font: theme.font-body,
    weight: 500,
  )

  set par(leading: 0.65em)

  show heading: it => if it.level == 1 {
    block(
      below: 0.8em,
      text(
        it,
        font: theme.font-heading,
        weight: "bold",
        size: 28pt,
        fill: theme.primary.s950,
      ),
    )
  } else if it.level == 2 {
    text(
      it,
      font: theme.font-heading,
      weight: "bold",
      size: 16pt,
      fill: theme.primary.s950,
    )
    v(-0.1in)
    resume-hr()
    v(0.07in)
  } else if it.level == 3 {
    text(
      it.body,
      font: theme.font-heading,
      size: 14pt,
      weight: "bold",
      fill: theme.primary.s950,
    )
  } else {
    text(
      it.body,
      font: theme.font-heading,
      weight: "bold",
      fill: theme.accent.s700,
    )
  }


  content
}
