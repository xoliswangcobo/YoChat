// https://github.com/WebDevSimplified/Realtime-Simple-Chat-App

const io = require('socket.io')(5555)

const users = {}

io.on('connection', socket => {
  socket.on('enrol-user', name => {
    users[socket.id] = name
    socket.broadcast.emit('user-connected', name)
  })
  socket.on('SendChat', message => {
    console.log(message)
    socket.broadcast.emit('RecieveChat', { message })
  })
  socket.on('disconnect', () => {
    socket.broadcast.emit('user-disconnected', users[socket.id])
    delete users[socket.id]
  })
  console.log(socket.id)
//   socket.emit('RecieveChat', "Hello connection!")
})