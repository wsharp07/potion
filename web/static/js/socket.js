// Import the socket library
import {Socket} from "phoenix"
// And import jquery for DOM manipulation
import $ from "jquery"

// Grab the user's token from the meta tag
const userToken = $("meta[name='channel_token']").attr("content")
// And make sure we're connecting with the user's token to persist the user id to the session
const socket = new Socket("/socket", {params: {token: userToken}})
// And then connect to our socket
socket.connect()

// Our actions to listen for
const CREATED_COMMENT  = "CREATED_COMMENT"
const APPROVED_COMMENT = "APPROVED_COMMENT"
const DELETED_COMMENT  = "DELETED_COMMENT"

// Grab the current post's id from a hidden input on the page
const postId = $("#post-id").val();
const channel = socket.channel('comments:${postId}', {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

// REQ 2: Based on a payload, return to us an HTML template for a comment
// Consider this a poor version of JSX
const createComment = (payload) => `
  <li class="comment even thread-even depth-1" id="li-comment-${payload.commentId}">
    <div id="comment-${payload.commentId}" class="comment comment-wrap clearfix" data-comment-id="${payload.commentId}">
      <div class="comment-meta">
        <div class="comment-author vcard">
          <span class="comment-avatar clearfix">
            <img alt="" src="http://0.gravatar.com/avatar/ad516503a11cd5ca435acc9bb6523536?s=60" class="avatar avatar-60 photo avatar-default" height="60" width="60">
          </span>
        </div>
      </div>
      <div class="col-xs-4 text-right">
        ${ userToken ? '<button class="btn btn-xs btn-primary approve">Approve</button> <button class="btn btn-xs btn-danger delete">Delete</button>' : '' }
      </div>
      <div class="comment-content clearfix">
        <div>
          <p class="comment-author">${payload.author}</p>
          <span>
            <a href="#" title="Permalink to this comment"> ${payload.insertedAt} </a>
          </span>
        </div>
        <div class="col-xs-12 comment-body">
          <p> ${payload.body} </p>
        </div>
        <a class="comment-reply-link" href="#"><i class="icon-reply"></i></a>
      </div>
      <div class="clear"></div>
    </div>
  </li>
`

// REQ 3: Provide the comment's author from the form
const getCommentAuthor   = () => $("#comment_author").val()
// REQ 4: Provide the comment's body from the form
const getCommentBody     = () => $("#comment_body").val()
// REQ 5: Based on something being clicked, find the parent comment id
const getTargetCommentId = (target) => $(target).parents(".comment").data("comment-id")
// REQ 6: Reset the input fields to blank
const resetFields = () => {
  $("#comment_author").val("")
  $("#comment_body").val("")
}

// REQ 7: Push the CREATED_COMMENT event to the socket with the appropriate author/body
$(".create-comment").on("click", (event) => {
  event.preventDefault();
  const author = getCommentAuthor();
  const commentBody = getCommentBody();
  const payload = { author: author, body: commentBody, postId }
  debugger;
  channel.push(CREATED_COMMENT, payload);
  resetFields();
})


// REQ 8: Push the APPROVED_COMMENT event to the socket with the appropriate author/body/comment id
$(".comments").on("click", ".approve", (event) => {
  event.preventDefault();
  const commentId = getTargetCommentId(event.currentTarget)
  // Pull the approved comment author
  const author = $(`#comment-${commentId} .comment-author`).text().trim()
  // Pull the approved comment body
  const body = $(`#comment-${commentId} .comment-body`).text().trim()
  debugger;
  channel.push(APPROVED_COMMENT, { author, body, commentId, postId })
})

// REQ 9: Push the DELETED_COMMENT event to the socket but only pass the comment id (that's all we need)
$(".comments").on("click", ".delete", (event) => {
  event.preventDefault()
  const commentId = getTargetCommentId(event.currentTarget)
  channel.push(DELETED_COMMENT, { commentId, postId })
})

// REQ 10: Handle receiving the CREATED_COMMENT event
channel.on(CREATED_COMMENT, (payload) => {
  // Don't append the comment if it hasn't been approved
  if (!userToken && !payload.approved) { return; }
  // Add it to the DOM using our handy template function
  var insertedAt = payload.insertedAt;
  var dateObj = moment.utc({
    year: insertedAt.year,
    month: insertedAt.month - 1,
    day: insertedAt.day,
    hour: insertedAt.hour,
    minute: insertedAt.minute
  });

  payload.insertedAt = dateObj.local().format("dddd, MMMM D YYYY @ h:mmA");

  $("#comments-title").after(
    createComment(payload)
  )
})

// REQ 11: Handle receiving the APPROVED_COMMENT event
channel.on(APPROVED_COMMENT, (payload) => {
  // If we don't already have the right comment, then add it to the DOM
  if ($(`#comment-${payload.commentId}`).length === 0) {
    debugger;
    var insertedAt = payload.insertedAt;
    var dateObj = moment.utc({
      year: insertedAt.year,
      month: insertedAt.month - 1,
      day: insertedAt.day,
      hour: insertedAt.hour,
      minute: insertedAt.minute
    });

    payload.insertedAt = dateObj.local().format("dddd, MMMM D YYYY @ h:mmA");
    $("#comments-title").after(
      createComment(payload)
    )
  }
  // And then remove the "Approve" button since we know it has been approved
  $(`#comment-${payload.commentId} .approve`).remove()
})

// REQ 12: Handle receiving the DELETED_COMMENT event
channel.on(DELETED_COMMENT, (payload) => {
  // Just delete the comment from the DOM
  $(`#comment-${payload.commentId}`).remove()
})

export default socket
