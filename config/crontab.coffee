module.exports =
  crontab:
    "0 */1 9-16 * * * 1-5": ->
      sails.services.news.get()
