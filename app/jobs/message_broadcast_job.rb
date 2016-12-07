class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    #  Be executed when you call the perform_later method
    sender = message.user
    recipient = message.conversation.opposed_user(sender)

    broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private

  def broadcast_to_sender(user, message)
  	ActionCable.server.broadcast(
  		"conversations-#{user.id}",
  		message: render_message(message, user),
  		conversation_id: message.conversation_id
  	)
  end

  def broadcast_to_recipient(user, message)
  	ActionCable.server.broadcast(
  		"conversations-#{user.id}",
  		message: render_message(message, user),
  		conversation_id: message.conversation_id
  	)
  end

  def render_message(message, user)
  	# in Rails 5 we can render a HTML code from any partial 
  	# or a view by calling the ApplicationController.render method outside a controller
  	ApplicationController.render(
  		partial: 'messages/message',
  		locals: {
  			message: message,
  			user: user
  		}
  	)
  end
end
