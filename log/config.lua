local config = {}

config.LEVELS = {
  { index = 1, id = 'TRACE', func = 'trace', color = '\27[34m' , fmt = '[TRACE] ' };
  { index = 2, id = 'DEBUG', func = 'debug', color = '\27[36m' , fmt = '[DEBUG] ' };
  { index = 3, id = 'INFO',  func = 'info',  color = '\27[32m' , fmt = '[INFO]  ' };
  { index = 4, id = 'WARN',  func = 'warn',  color = '\27[33m' , fmt = '[WARN]  ' };
  { index = 5, id = 'ERROR', func = 'error', color = '\27[31m' , fmt = '[ERROR] ' };
  { index = 6, id = 'FATAL', func = 'fatal', color = '\27[35m' , fmt = '[FATAL] ' };
};

config.DEFAULT_LEVEL = 3
config.DEFAULT_FORMAT = '${lvl}${time} | '

return config
