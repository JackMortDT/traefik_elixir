defmodule Traefik.HandlerTest do
  use ExUnit.Case

  alias Traefik.Handler

  test "GET /hello" do
    request = """
    GET /hello HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 14
           Accept: */*

           Hello World!!!
           """
  end

  test "GET /world" do
    request = """
    GET /world HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 29
           Accept: */*

           Hello MakingDevs and all devs
           """
  end

  test "GET /not-found" do
    request = """
    GET /not-found HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 404 Not Found
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 22
           Accept: */*

           No /not-found found!!!
           """
  end

  test "GET /redirectme" do
    request = """
    GET /redirectme HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 404 Not Found
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 16
           Accept: */*

           No /all found!!!
           """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 157
           Accept: */*

           <h1>Hola mundo!</h1>
           <p>
             <blockquote>Hola Mundo developers</blockquote>
             <ul>
               <li>MakingDevs</li>
               <li>Agora</li>
               <li>Legion</li>
             </ul>
           </p>

           """
  end

  test "POST /new" do
    request = """
    POST /new HTTP/1.1
    Accept: */*
    Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
    User-Agent: telnet

    name=Luis&company=MakingDevs
    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 201 Created
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 41
           Accept: */*

           New element created: Luis from MakingDevs
           """
  end

  test "GET /developer" do
    request = """
    GET /developer HTTP/1.1
    Accept: */*
    Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
    User-Agent: telnet

    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 191
           Accept: */*

           <ul>
             
               <li>1 - Jerri Rubertis</li>
             
               <li>2 - Lief Gepson</li>
             
               <li>3 - Viki Van Halle</li>
             
               <li>4 - Maribelle Dubose</li>
             
               <li>5 - Vivian Klarzynski</li>
             
           </ul>

           """
  end

  test "GET /developer/18" do
    request = """
    GET /developer/18 HTTP/1.1
    Accept: */*
    Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
    User-Agent: telnet

    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 69
           Accept: */*

           18 - Tarrance - Veness - tvenessh@printfriendly.com - 254.34.206.118

           """
  end
end
