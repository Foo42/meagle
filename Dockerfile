FROM trenpixster/elixir:1.0.5
MAINTAINER Julian Haeger @juliansthoughts

ADD . /code
WORKDIR /code


RUN mix deps.get && mix compile

EXPOSE 4000

CMD ["mix","phoenix.server"] 
