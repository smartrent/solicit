defmodule Solicit.HTTP.StatusCodes do
  @moduledoc false && "For internal use only."

  @type metadata :: %{
          :code => pos_integer(),
          :reason_atom => atom(),
          :reason_phrase => binary(),
          :spec_title => binary(),
          :spec_href => binary(),
          :docs => binary()
        }

  sc =
    %{
      200 => %{
        spec_title: "RFC7231#6.3.1",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.3.1",
        docs: """
        The request has succeeded.

        The payload sent in a 200 response depends on the request method. For the
        methods defined by this specification, the intended meaning of the payload
        can be summarized as:

        * `GET` a representation of the target resource
        * `HEAD` the same representation as `GET`, but without the representation data
        * `POST` a representation of the status of, or results obtained from, the action;
            * `PUT` `DELETE` a representation of the status of the action;
            * `OPTIONS` a representation of the communications options;
            * `TRACE` a representation of the request message as received by the end server.

        Aside from responses to `CONNECT`, a 200 response always has a payload,
        though an origin server MAY generate a payload body of zero length. If
        no payload is desired, an origin server ought to send `204 No Content`
        instead. For `CONNECT`, no payload is allowed because the successful result
        is a tunnel, which begins immediately after the 200 response header section.

        A 200 response is cacheable by default; i.e., unless otherwise indicated by
        the method definition or explicit cache controls.
        """
      },
      201 => %{
        spec_title: "RFC7231#6.3.2",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.3.2",
        docs: """
        The request has been fulfilled and has resulted in one or more new resources
        being created.

        The primary resource created by the request is identified by either a Location
        header field in the response or, if no Location field is received, by the
        effective request URI.

        The 201 response payload typically describes and links to the resource(s)
        created.
        """
      },
      202 => %{
        spec_title: "RFC7231#6.3.3",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.3.3",
        docs: """
        The request has been accepted for processing, but the processing has not been
        completed. The request might or might not eventually be acted upon, as it might
        be disallowed when processing actually takes place.

        There is no facility in HTTP for re-sending a status code from an asynchronous
        operation.

        The 202 response is intentionally noncommittal. Its purpose is to allow a server
        to accept a request for some other process (perhaps a batch-oriented process that
        is only run once per day) without requiring that the user agent's connection to
        the server persist until the process is completed. The representation sent with
        this response ought to describe the request's current status and point to
        (or embed) a status monitor that can provide the user with an estimate of when
        the request will be fulfilled.
        """
      },
      203 => %{
        spec_title: "RFC7231#6.3.4",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.3.4",
        docs: """
        The request was successful but the enclosed payload has been modified
        from that of the origin server's 200 OK response by a transforming proxy.

        This status code allows the proxy to notify recipients when a transformation
        has been applied, since that knowledge might impact later decisions regarding the
        content. For example, future cache validation requests for the content might
        only be applicable along the same request path (through the same proxies).

        The 203 response is similar to the Warning code of 214 Transformation Applied, which has the advantage of being applicable to responses with any status code.

        A 203 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      204 => %{
        spec_title: "RFC7231#6.3.5",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.3.5",
        docs: """
        The server has successfully fulfilled the request and that there is no additional content to send in the response payload body.

        Metadata in the response header fields refer to the target resource and its selected representation after the requested action was applied.

        For example, if a 204 status code is received in response to a PUT request and the response contains an ETag header field, then the PUT was successful and the ETag field-value contains the entity-tag for the new representation of that target resource.

        The 204 response allows a server to indicate that the action has been successfully applied to the target resource, while implying that the user agent does not need to traverse away from its current "document view" (if any). The server assumes that the user agent will provide some indication of the success to its user, in accord with its own interface, and apply any new or updated metadata in the response to its active representation.

        For example, a 204 status code is commonly used with document editing interfaces corresponding to a "save" action, such that the document being saved remains available to the user for editing. It is also frequently used with interfaces that expect automated data transfers to be prevalent, such as within distributed version control systems.

        A 204 response is terminated by the first empty line after the header fields because it cannot contain a message body.

        A 204 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      205 => %{
        spec_title: "RFC7231#6.3.6",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.3.6",
        docs: """
        The server has fulfilled the request and desires that the user agent reset the "document view", which caused the request to be sent, to its original state as received from the origin server.

        This response is intended to support a common data entry use case where the user receives content that supports data entry (a form, notepad, canvas, etc.), enters or manipulates data in that space, causes the entered data to be submitted in a request, and then the data entry mechanism is reset for the next entry so that the user can easily initiate another input action.

        Since the 205 status code implies that no additional content will be provided, a server MUST NOT generate a payload in a 205 response. In other words, a server MUST do one of the following for a 205 response: a) indicate a zero-length body for the response by including a Content-Length header field with a value of 0; b) indicate a zero-length payload for the response by including a Transfer-Encoding header field with a value of chunked and a message body consisting of a single chunk of zero-length; or, c) close the connection immediately after sending the blank line terminating the header section.
        """
      },
      206 => %{
        spec_title: "RFC7233#4.1",
        spec_href: "https://tools.ietf.org/html/rfc7233#section-4.1",
        docs: """
        The server is successfully fulfilling a range request for the target resource by transferring one or more parts of the selected representation that correspond to the satisfiable ranges found in the request's Range header field.
        """
      },
      300 => %{
        spec_title: "RFC7231#6.4.1",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.4.1",
        docs: """
        The target resource has more than one representation, each with its own more specific identifier, and information about the alternatives is being provided so that the user (or user agent) can select a preferred representation by redirecting its request to one or more of those identifiers.

        In other words, the server desires that the user agent engage in reactive negotiation to select the most appropriate representation(s) for its needs.

        If the server has a preferred choice, the server SHOULD generate a Location header field containing a preferred choice's URI reference. The user agent MAY use the Location field value for automatic redirection.
        """
      },
      301 => %{
        spec_title: "RFC7231#6.4.2",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.4.2",
        docs: """
        The target resource has been assigned a new permanent URI and any future references to this resource ought to use one of the enclosed URIs.

        Clients with link-editing capabilities ought to automatically re-link references to the effective request URI to one or more of the new references sent by the server, where possible.

        The server SHOULD generate a Location header field in the response containing a preferred URI reference for the new permanent URI. The user agent MAY use the Location field value for automatic redirection. The server's response payload usually contains a short hypertext note with a hyperlink to the new URI(s).

        Note: For historical reasons, a user agent MAY change the request method from POST to GET for the subsequent request. If this behavior is undesired, the 307 Temporary Redirect status code can be used instead.

        A 301 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      302 => %{
        spec_title: "RFC7231#6.4.3",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.4.3",
        docs: """
        The target resource resides temporarily under a different URI. Since the redirection might be altered on occasion, the client ought to continue to use the effective request URI for future requests.

        The server SHOULD generate a Location header field in the response containing a URI reference for the different URI. The user agent MAY use the Location field value for automatic redirection. The server's response payload usually contains a short hypertext note with a hyperlink to the different URI(s).

        Note: For historical reasons, a user agent MAY change the request method from POST to GET for the subsequent request. If this behavior is undesired, the 307 Temporary Redirect status code can be used instead.
        """
      },
      303 => %{
        spec_title: "RFC7231#6.4.4",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.4.4",
        docs: """
        The server is redirecting the user agent to a different resource, as indicated by a URI in the Location header field, which is intended to provide an indirect response to the original request.

        A user agent can perform a retrieval request targeting that URI (a GET or HEAD request if using HTTP), which might also be redirected, and present the eventual result as an answer to the original request. Note that the new URI in the Location header field is not considered equivalent to the effective request URI.

        This status code is applicable to any HTTP method. It is primarily used to allow the output of a POST action to redirect the user agent to a selected resource, since doing so provides the information corresponding to the POST response in a form that can be separately identified, bookmarked, and cached, independent of the original request.

        A 303 response to a GET request indicates that the origin server does not have a representation of the target resource that can be transferred by the server over HTTP. However, the Location field value refers to a resource that is descriptive of the target resource, such that making a retrieval request on that other resource might result in a representation that is useful to recipients without implying that it represents the original target resource. Note that answers to the questions of what can be represented, what representations are adequate, and what might be a useful description are outside the scope of HTTP.

        Except for responses to a HEAD request, the representation of a 303 response ought to contain a short hypertext note with a hyperlink to the same URI reference provided in the Location header field.
        """
      },
      304 => %{
        spec_title: "RFC7232#4.1",
        spec_href: "https://tools.ietf.org/html/rfc7232#section-4.1",
        docs: """
        A conditional GET or HEAD request has been received and would have resulted in a 200 OK response if it were not for the fact that the condition evaluated to false.

        In other words, there is no need for the server to transfer a representation of the target resource because the request indicates that the client, which made the request conditional, already has a valid representation; the server is therefore redirecting the client to make use of that stored representation as if it were the payload of a 200 OK response.

        The server generating a 304 response MUST generate any of the following header fields that would have been sent in a 200 OK response to the same request: Cache-Control, Content-Location, Date, ETag, Expires, and Vary.

        Since the goal of a 304 response is to minimize information transfer when the recipient already has one or more cached representations, a sender SHOULD NOT generate representation metadata other than the above listed fields unless said metadata exists for the purpose of guiding cache updates (e.g., Last-Modified might be useful if the response does not have an ETag field).

        Requirements on a cache that receives a 304 response are defined in [Section 4.3.4 of RFC7234](https://tools.ietf.org/html/rfc7234#section-4.3.4). If the conditional request originated with an outbound client, such as a user agent with its own cache sending a conditional GET to a shared proxy, then the proxy SHOULD forward the 304 response to that client.

        A 304 response cannot contain a message-body; it is always terminated by the first empty line after the header fields.
        """
      },
      307 => %{
        spec_title: "RFC7231#6.4.7",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.4.7",
        docs: """
        The target resource resides temporarily under a different URI and the user agent MUST NOT change the request method if it performs an automatic redirection to that URI.

        Since the redirection can change over time, the client ought to continue using the original effective request URI for future requests.

        The server SHOULD generate a Location header field in the response containing a URI reference for the different URI. The user agent MAY use the Location field value for automatic redirection. The server's response payload usually contains a short hypertext note with a hyperlink to the different URI(s).

        Note: This status code is similar to 302 Found, except that it does not allow changing the request method from POST to GET. This specification defines no equivalent counterpart for 301 Moved Permanently ([RFC7238](https://tools.ietf.org/html/rfc7238), however, proposes defining the status code 308 Permanent Redirect for this purpose).
        """
      },
      308 => %{
        spec_title: "RFC7538#3",
        spec_href: "http://tools.ietf.org/html/rfc7538#section-3",
        docs: """
        The target resource has been assigned a new permanent URI and any future references to this resource ought to use one of the enclosed URIs.

        Clients with link editing capabilities ought to automatically re-link references to the effective request URI to one or more of the new references sent by the server, where possible.

        The server SHOULD generate a Location header field in the response containing a preferred URI reference for the new permanent URI. The user agent MAY use the Location field value for automatic redirection. The server's response payload usually contains a short hypertext note with a hyperlink to the new URI(s).

        A 308 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.

        Note: This status code is similar to 301 Moved Permanently, except that it does not allow changing the request method from POST to GET.
        """
      },
      400 => %{
        spec_title: "RFC7231#6.5.1",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.1",
        docs: """
        The server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing).
        """
      },
      401 => %{
        spec_title: "RFC7235#6.3.1",
        spec_href: "https://tools.ietf.org/html/rfc7235#section-3.1",
        docs: """
        The request has not been applied because it lacks valid authentication credentials for the target resource.

        The server generating a 401 response MUST send a WWW-Authenticate header field containing at least one challenge applicable to the target resource.

        If the request included authentication credentials, then the 401 response indicates that authorization has been refused for those credentials. The user agent MAY repeat the request with a new or replaced Authorization header field. If the 401 response contains the same challenge as the prior response, and the user agent has already attempted authentication at least once, then the user agent SHOULD present the enclosed representation to the user, since it usually contains relevant diagnostic information.
        """
      },
      402 => %{
        spec_title: "RFC7231#6.5.2",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.2",
        docs: """
        Reserved for future use.
        """
      },
      403 => %{
        spec_title: "RFC7231#6.5.3",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.3",
        docs: """
        The server understood the request but refuses to authorize it.

        A server that wishes to make public why the request has been forbidden can describe that reason in the response payload (if any).

        If authentication credentials were provided in the request, the server considers them insufficient to grant access. The client SHOULD NOT automatically repeat the request with the same credentials. The client MAY repeat the request with new or different credentials. However, a request might be forbidden for reasons unrelated to the credentials.

        An origin server that wishes to "hide" the current existence of a forbidden target resource MAY instead respond with a status code of 404 Not Found.
        """
      },
      404 => %{
        spec_title: "RFC7231#6.5.4",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.4",
        docs: """
        The origin server did not find a current representation for the target resource or is not willing to disclose that one exists.

        A 404 status code does not indicate whether this lack of representation is temporary or permanent; the 410 Gone status code is preferred over 404 if the origin server knows, presumably through some configurable means, that the condition is likely to be permanent.

        A 404 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      405 => %{
        spec_title: "RFC7231#6.5.5",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.5",
        docs: """
        The method received in the request-line is known by the origin server but not supported by the target resource.

        The origin server MUST generate an Allow header field in a 405 response containing a list of the target resource's currently supported methods.

        A 405 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      406 => %{
        spec_title: "RFC7231#6.5.6",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.6",
        docs: """
        The target resource does not have a current representation that would be acceptable to the user agent, according to the proactive negotiation header fields received in the request, and the server is unwilling to supply a default representation.

        The server SHOULD generate a payload containing a list of available representation characteristics and corresponding resource identifiers from which the user or user agent can choose the one most appropriate. A user agent MAY automatically select the most appropriate choice from that list. However, this specification does not define any standard for such automatic selection, as described in [RFC7231 Section 6.4.1](https://tools.ietf.org/html/rfc7231#section-6.4.1 ).
        """
      },
      407 => %{
        spec_title: "RFC7235#3.2",
        spec_href: "https://tools.ietf.org/html/rfc7235#section-3.2",
        docs: """
        Similar to 401 Unauthorized, but it indicates that the client needs to authenticate itself in order to use a proxy.

        The proxy MUST send a Proxy-Authenticate header field containing a challenge applicable to that proxy for the target resource. The client MAY repeat the request with a new or replaced Proxy-Authorization header field.
        """
      },
      408 => %{
        spec_title: "RFC7231#6.5.7",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.7",
        docs: """
        The server did not receive a complete request message within the time that it was prepared to wait.

        A server SHOULD send the "close" connection option in the response, since 408 implies that the server has decided to close the connection rather than continue waiting. If the client has an outstanding request in transit, the client MAY repeat that request on a new connection.
        """
      },
      409 => %{
        spec_title: "RFC7231#6.5.8",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.8",
        docs: """
        The request could not be completed due to a conflict with the current state of the target resource. This code is used in situations where the user might be able to resolve the conflict and resubmit the request.

        The server SHOULD generate a payload that includes enough information for a user to recognize the source of the conflict.

        Conflicts are most likely to occur in response to a PUT request. For example, if versioning were being used and the representation being PUT included changes to a resource that conflict with those made by an earlier (third-party) request, the origin server might use a 409 response to indicate that it can't complete the request. In this case, the response representation would likely contain information useful for merging the differences based on the revision history.
        """
      },
      410 => %{
        spec_title: "RFC7231#6.5.9",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.9",
        docs: """
        The target resource is no longer available at the origin server and that this condition is likely to be permanent.

        If the origin server does not know, or has no facility to determine, whether or not the condition is permanent, the status code 404 Not Found ought to be used instead.

        The 410 response is primarily intended to assist the task of web maintenance by notifying the recipient that the resource is intentionally unavailable and that the server owners desire that remote links to that resource be removed. Such an event is common for limited-time, promotional services and for resources belonging to individuals no longer associated with the origin server's site. It is not necessary to mark all permanently unavailable resources as "gone" or to keep the mark for any length of time -- that is left to the discretion of the server owner.

        A 410 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      411 => %{
        spec_title: "RFC7231#6.5.10",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.10",
        docs: """
        The server refuses to accept the request without a defined Content-Length.

        The client MAY repeat the request if it adds a valid Content-Length header field containing the length of the message body in the request message.
        """
      },
      412 => %{
        spec_title: "RFC7232#4.2",
        spec_href: "https://tools.ietf.org/html/rfc7232#section-4.2",
        docs: """
        One or more conditions given in the request header fields evaluated to false when tested on the server.

        This response code allows the client to place preconditions on the current resource state (its current representations and metadata) and, thus, prevent the request method from being applied if the target resource is in an unexpected state.
        """
      },
      413 => %{
        spec_title: "RFC7231#6.5.11",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.11",
        docs: """
        The server is refusing to process a request because the request payload is larger than the server is willing or able to process.

        The server MAY close the connection to prevent the client from continuing the request.

        If the condition is temporary, the server SHOULD generate a Retry-After header field to indicate that it is temporary and after what time the client MAY try again.
        """
      },
      414 => %{
        spec_title: "RFC7231#6.5.12",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.12",
        docs: ~S"""
        The server is refusing to service the request because the request-target is longer than the server is willing to interpret.

        This rare condition is only likely to occur when a client has improperly converted a POST request to a GET request with long query information, when the client has descended into a "black hole" of redirection (e.g., a redirected URI prefix that points to a suffix of itself) or when the server is under attack by a client attempting to exploit potential security holes.

        A 414 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      415 => %{
        spec_title: "RFC7231#6.5.13",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.13",
        docs: """
        The origin server is refusing to service the request because the payload is in a format not supported by this method on the target resource.

        The format problem might be due to the request's indicated Content-Type or Content-Encoding, or as a result of inspecting the data directly.
        """
      },
      416 => %{
        spec_title: "RFC7233#4.4",
        spec_href: "https://tools.ietf.org/html/rfc7233#section-4.4",
        docs: """

        None of the ranges in the request's Range header field overlap the current extent of the selected resource or that the set of ranges requested has been rejected due to invalid ranges or an excessive request of small or overlapping ranges.

        For byte ranges, failing to overlap the current extent means that the first-byte-pos of all of the byte-range-spec values were greater than the current length of the selected representation. When this status code is generated in response to a byte-range request, the sender SHOULD generate a Content-Range header field specifying the current length of the selected representation.

        For example:

        ```
        HTTP/1.1 416 Range Not Satisfiable
        Date: Fri, 20 Jan 2012 15:41:54 GMT
        Content-Range: bytes */47022
        ```

        Note: Because servers are free to ignore Range, many implementations will simply respond with the entire selected representation in a 200 OK response. That is partly because most clients are prepared to receive a 200 OK to complete the task (albeit less efficiently) and partly because clients might not stop making an invalid partial request until they have received a complete representation. Thus, clients cannot depend on receiving a 416 Range Not Satisfiable response even when it is most appropriate.
        """
      },
      417 => %{
        spec_title: "RFC7231#6.5.14",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.5.14",
        docs: """
        The expectation given in the request's Expect header field could not be met by at least one of the inbound servers.
        """
      },
      418 => %{
        spec_title: "RFC2324#2.3.1",
        spec_href: "https://tools.ietf.org/html/rfc2324#section-2.3.1",
        docs: """
        Any attempt to brew coffee with a teapot should result in the error code "418 I'm a teapot". The resulting entity body MAY be short and stout.
        """
      },
      421 => %{
        spec_title: "RFC7540#9.1.2",
        spec_href: "http://tools.ietf.org/html/rfc7540#section-9.1.2",
        docs: """
        The request was directed at a server that is not able to produce a response. This can be sent by a server that is not configured to produce responses for the combination of scheme and authority that are included in the request URI.

        Clients receiving a 421 Misdirected Request response from a server MAY retry the request -- whether the request method is idempotent or not -- over a different connection. This is possible if a connection is reusedor if an alternative service is selected (see [ALT-SVC](https://tools.ietf.org/html/rfc7540#ref-ALT-SVC)).

        This status code MUST NOT be generated by proxies.

        A 421 response is cacheable by default, i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      422 => %{
        spec_title: "RFC4918#11.2",
        spec_href: "http://tools.ietf.org/html/rfc4918#section-11.2",
        docs: """
        The server understands the content type of the request entity (hence a 415 Unsupported Media Type status code is inappropriate), and the syntax of the request entity is correct (thus a 400 Bad Request status code is inappropriate) but was unable to process the contained instructions.

        For example, this error condition may occur if an XML request body contains well-formed (i.e., syntactically correct), but semantically erroneous, XML instructions.
        """
      },
      429 => %{
        spec_title: "RFC6585#4",
        spec_href: "http://tools.ietf.org/html/rfc6585#section-4",
        docs: """
        The user has sent too many requests in a given amount of time ("rate limiting").

        The response representations SHOULD include details explaining the condition, and MAY include a Retry-After header indicating how long to wait before making a new request.

        For example:

        ```
        HTTP/1.1 429 Too Many Requests
        Content-Type: text/html
        Retry-After: 3600

        <html>
          <head>
            <title>Too Many Requests</title>
          </head>
          <body>
            <h1>Too Many Requests</h1>
            <p>I only allow 50 requests per hour to this Web site per
            logged in user. Try again soon.</p>
          </body>
        </html>
        ```

        Note that this specification does not define how the origin server identifies the user, nor how it counts requests. For example, an origin server that is limiting request rates can do so based upon counts of requests on a per-resource basis, across the entire server, or even among a set of servers. Likewise, it might identify the user by its authentication credentials, or a stateful cookie.

        Responses with the 429 status code MUST NOT be stored by a cache.
        """
      },
      451 => %{
        spec_title: "draft-ietf-httpbis-legally-restricted-status",
        spec_href: "https://tools.ietf.org/html/draft-ietf-httpbis-legally-restricted-status",
        docs: """
        The server is denying access to the resource as a consequence of a legal demand.

        The server in question might not be an origin server. This type of legal demand typically most directly affects the operations of ISPs and search engines.

        Responses using this status code SHOULD include an explanation, in the response body, of the details of the legal demand: the party making it, the applicable legislation or regulation, and what classes of person and resource it applies to. For example:

        ```
        HTTP/1.1 451 Unavailable For Legal Reasons
        Link: <https://spqr.example.org/legislatione>; rel="blocked-by"
        Content-Type: text/html

        <html>
          <head>
            <title>Unavailable For Legal Reasons</title>
          </head>
          <body>
            <h1>Unavailable For Legal Reasons</h1>
            <p>This request may not be serviced in the Roman Province
            of Judea due to the Lex Julia Majestatis, which disallows
            access to resources hosted on servers deemed to be
            operated by the People's Front of Judea.</p>
          </body>
        </html>
        ```

        The use of the 451 status code implies neither the existence nor non- existence of the resource named in the request. That is to say, it is possible that if the legal demands were removed, a request for the resource still might not succeed.

        Note that in many cases clients can still access the denied resource by using technical countermeasures such as a VPN or the Tor network.

        A 451 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls; see [RFC7234](https://tools.ietf.org/html/rfc7234).
        """
      },
      500 => %{
        spec_title: "RFC7231#6.6.1",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.6.1",
        docs: """
        The server encountered an unexpected condition that prevented it from fulfilling the request.
        """
      },
      501 => %{
        spec_title: "RFC7231#6.6.2",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.6.2",
        docs: """
        The server does not support the functionality required to fulfill the request.

        This is the appropriate response when the server does not recognize the request method and is not capable of supporting it for any resource.

        A 501 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.
        """
      },
      502 => %{
        spec_title: "RFC7231#6.6.3",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.6.3",
        docs: """
        The server, while acting as a gateway or proxy, received an invalid response from an inbound server it accessed while attempting to fulfill the request.
        """
      },
      503 => %{
        spec_title: "RFC7231#6.6.4",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.6.4",
        docs: """
        The server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay.

        The server MAY send a Retry-After header field to suggest an appropriate amount of time for the client to wait before retrying the request.

        Note: The existence of the 503 status code does not imply that a server has to use it when becoming overloaded. Some servers might simply refuse the connection.
        """
      },
      504 => %{
        spec_title: "RFC7231#6.6.5",
        spec_href: "https://tools.ietf.org/html/rfc7231#section-6.6.5",
        docs: """
        The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request.
        """
      }
    }
    |> Map.new(fn {code, meta} ->
      {code,
       Map.merge(meta, %{
         code: code,
         reason_phrase: Plug.Conn.Status.reason_phrase(code),
         reason_atom: Plug.Conn.Status.reason_atom(code)
       })}
    end)

  @status_codes sc

  @spec all() :: %{pos_integer() => metadata()}
  def all, do: @status_codes

  @spec metadata(pos_integer()) :: metadata()
  def metadata(code) when is_integer(code), do: Map.get(@status_codes, code)
end
