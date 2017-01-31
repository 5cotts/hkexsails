module.exports =
  crontab:
    "0 */1 * * * * 1-5": ->
      sails.services.news.get()
