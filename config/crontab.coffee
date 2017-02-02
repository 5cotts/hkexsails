module.exports =
  crontab:
    "0 */1 9-16 * * * 1-5": ->
      sails.services.news.get()
    "30 29 * * * * *": ->
      sails.services.news.get()
    "30 59 * * * * *": ->
      sails.services.news.get()
