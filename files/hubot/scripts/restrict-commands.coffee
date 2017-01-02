# https://hubot.github.com/docs/patterns/

POWER_COMMANDS = [
  'jenkins' # String that matches the listener ID
]

POWER_USERS = [
  'tgagor' # String that matches the user ID set by the adapter
]

module.exports = (robot) ->
  robot.listenerMiddleware (context, next, done) ->
    if context.listener.options.id in POWER_COMMANDS
      if context.response.message.user.id in POWER_USERS
        # User is allowed access to this command
        next()
      else
        # Restricted command, but user isn't in whitelist
        context.response.reply "I'm sorry, @#{context.response.message.user.name}, but you don't have access to do that."
        done()
    else
      # This is not a restricted command; allow everyone
      next()
